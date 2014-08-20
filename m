Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaHTMfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:35:42 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:64173 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaHTMfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:35:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140818153327.GA12278@ulmo>
References: <CACmBeS1kB4+=CZAtkDkM7F48m3SDgutGWGDHgPWVYDRmsDXBJw@mail.gmail.com>
	<20140818153327.GA12278@ulmo>
Date: Wed, 20 Aug 2014 14:35:39 +0200
Message-ID: <CACmBeS3fMc371PsjbxcW67b=zp1uip3uD1qqB7AAVdNWKjLxMQ@mail.gmail.com>
Subject: Re: fs: panic in mnt_set_mountpoint
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sfr@canb.auug.org.au
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/fs/namespace.c b/fs/namespace.c
> index 4246696dc678..a6815027f225 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -736,6 +736,7 @@ static struct mountpoint *new_mountpoint(struct dentry *dentry)
>                 return ERR_PTR(ret);
>         }
>
> +       INIT_HLIST_HEAD(&mp->m_list);
>         mp->m_dentry = dentry;
>         mp->m_count = 1;
>         hlist_add_head(&mp->m_hash, chain);

I can confirm this has been fixed in next-20140820, my boards boot
without panic after rebase (commit: "Merge remote-tracking branch
'vfs/for-next'" - 002561f4e9e40e5444a8776daeaa4e5a718c376c).

Thanks!


   Jonas
