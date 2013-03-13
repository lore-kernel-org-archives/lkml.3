Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934025Ab3CMSM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:12:56 -0400
Received: from relay3.sgi.com ([192.48.152.1]:37067 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932346Ab3CMSMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:12:54 -0400
Date: Wed, 13 Mar 2013 13:12:51 -0500
From: Robin Holt <holt@sgi.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        dhowells@redhat.com, sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp,
        mszeredi@suse.cz
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
Message-ID: <20130313181251.GA6023@sgi.com>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <CA+icZUVLsqXNEc4UTQp0dDG21sQb0xtFMDF9Lyq5Jy7Px0pPBQ@mail.gmail.com>
 <CA+icZUVn=3qcEDchYqUf2JqDBfPsN6Zxh+cJCDbUaOrkjg7uJg@mail.gmail.com>
 <CAJfpegu40UMTfofY0L20T69sqmPrvpCP53N-xzumgX5MrAZuJw@mail.gmail.com>
 <CA+icZUV=XoN=uUn7npU9Djnkr5DEuA0D42=HV_1n6WN4v2rQMA@mail.gmail.com>
 <CA+icZUXXrarmm3hYSxt7T2_sw+pmZycdmop5z4QCJ6=vMny9EQ@mail.gmail.com>
 <CA+icZUXzYGRU7deUyzgNBEfSkZf+-w6VLOewd+7R=RmZ21mTUg@mail.gmail.com>
 <CAJfpegu3cHatcoWYyYeA-w0+mtQUgiAVkqUOjLGrq9oxk7CcrQ@mail.gmail.com>
 <CA+icZUWqd4OfjxBKeOjqaPiVXOvBk9kLu1u1X_hiG9sbz1Eneg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUWqd4OfjxBKeOjqaPiVXOvBk9kLu1u1X_hiG9sbz1Eneg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 05:51:33PM +0100, Sedat Dilek wrote:
> On Wed, Mar 13, 2013 at 5:21 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Wed, Mar 13, 2013 at 5:10 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> >> Anyway, with CONFIG_OVERLAYFS_FS=m I do not see any related messages
> >> when the kernel-module is loaded.
> >> So, is this intended?
> >> SquashFS prints into the logs, so what is it doing differently?
> >
> > Some modules do, some don't.  It's not compulsory and not very useful.
> >
> 
> What about...
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 482c26f..92b9ad5 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -675,11 +675,13 @@ MODULE_ALIAS_FS("overlayfs");
>  static int __init ovl_init(void)
>  {
>         return register_filesystem(&ovl_fs_type);
> +       printk(KERN_INFO "overlayfs: loaded\n");

How about pr_debug().  That makes things quite for most of us but gives
you info when looking for things like boot problems.

>  }
> 
>  static void __exit ovl_exit(void)
>  {
>         unregister_filesystem(&ovl_fs_type);
> +       printk(KERN_INFO "overlayfs: unloaded\n");
>  }
> 
>  module_init(ovl_init);
> 
> Maybe "loaded" is enough.
> 
> - Sedat -
> 
> > Thanks,
> > Miklos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
