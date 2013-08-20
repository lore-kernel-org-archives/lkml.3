Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab3HTUrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:47:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63326 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3HTUrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:47:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: linux-next: build failure after merge of the final tree
Date: Tue, 20 Aug 2013 22:46:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ben Myers <bpm@sgi.com>,
        David Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Gao feng <gaofeng@cn.fujitsu.com>,
        Jeremy Kerr <jk@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        cbe-oss-dev@lists.ozlabs.org
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au> <20130820120702.000b044e@oracle.com>
In-Reply-To: <20130820120702.000b044e@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308202246.30869.arnd@arndb.de>
X-Provags-ID: V02:K0:TjvASDqEI7BlnCpnxb3K7zLiuCnv3LM2OWSNih9TJQm
 o5eXEjwqBfohwFP5O+cm3WeiAWzcJil24vbe79LpsqrpIIOf3Z
 8SvfrZ3cD35M8ye5ZMFguKhZnV3xtfgaZ1gfjmo6cWk8L9/hT+
 3NX3wXTw9mV/2CaAwJJasH7pToCwQV3phOagz+ilJWZ3Ax9apK
 64EN9dR2IPUO1S5wdRq4CcgCOpYArykEJr1C0Hh12t3VKotGp6
 l/YghHwAR5nGCwXB+EXqEG6EfB7KkBFvbMpthl7B+Z/OuPwFfX
 RuDESCBEjOO7yg6LzcyiWEbBbpzjbJLsVYe6GtRcu+TlW95r5U
 +9oJ3o0YJIJNde6HZZBU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 August 2013, Dwight Engen wrote:
> diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
> index f390042..90fb308 100644
> --- a/arch/powerpc/platforms/cell/spufs/inode.c
> +++ b/arch/powerpc/platforms/cell/spufs/inode.c
> @@ -620,12 +620,12 @@ spufs_parse_options(struct super_block *sb, char *options, struct inode *root)
>                 case Opt_uid:
>                         if (match_int(&args[0], &option))
>                                 return 0;
> -                       root->i_uid = option;
> +                       root->i_uid = make_kuid(&init_user_ns, option);
>                         break;
>                 case Opt_gid:
>                         if (match_int(&args[0], &option))
>                                 return 0;
> -                       root->i_gid = option;
> +                       root->i_gid = make_kgid(&init_user_ns, option);
>                         break;
>                 case Opt_mode:
>                         if (match_octal(&args[0], &option))

Doesn't this mean the uid/gid is taken from the initial namespace rather than
from the namespace of the 'mount' process calling this? I think the logical
choice would be to have the UID be the one that gets passed here in the caller's
namespace.

	Arnd
