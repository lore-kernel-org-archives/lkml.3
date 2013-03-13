Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab3CMQvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:51:36 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:38910 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab3CMQvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:51:35 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAJfpegu3cHatcoWYyYeA-w0+mtQUgiAVkqUOjLGrq9oxk7CcrQ@mail.gmail.com>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<CA+icZUVLsqXNEc4UTQp0dDG21sQb0xtFMDF9Lyq5Jy7Px0pPBQ@mail.gmail.com>
	<CA+icZUVn=3qcEDchYqUf2JqDBfPsN6Zxh+cJCDbUaOrkjg7uJg@mail.gmail.com>
	<CAJfpegu40UMTfofY0L20T69sqmPrvpCP53N-xzumgX5MrAZuJw@mail.gmail.com>
	<CA+icZUV=XoN=uUn7npU9Djnkr5DEuA0D42=HV_1n6WN4v2rQMA@mail.gmail.com>
	<CA+icZUXXrarmm3hYSxt7T2_sw+pmZycdmop5z4QCJ6=vMny9EQ@mail.gmail.com>
	<CA+icZUXzYGRU7deUyzgNBEfSkZf+-w6VLOewd+7R=RmZ21mTUg@mail.gmail.com>
	<CAJfpegu3cHatcoWYyYeA-w0+mtQUgiAVkqUOjLGrq9oxk7CcrQ@mail.gmail.com>
Date: Wed, 13 Mar 2013 17:51:33 +0100
Message-ID: <CA+icZUWqd4OfjxBKeOjqaPiVXOvBk9kLu1u1X_hiG9sbz1Eneg@mail.gmail.com>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 5:21 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Mar 13, 2013 at 5:10 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
>> Anyway, with CONFIG_OVERLAYFS_FS=m I do not see any related messages
>> when the kernel-module is loaded.
>> So, is this intended?
>> SquashFS prints into the logs, so what is it doing differently?
>
> Some modules do, some don't.  It's not compulsory and not very useful.
>

What about...

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 482c26f..92b9ad5 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -675,11 +675,13 @@ MODULE_ALIAS_FS("overlayfs");
 static int __init ovl_init(void)
 {
        return register_filesystem(&ovl_fs_type);
+       printk(KERN_INFO "overlayfs: loaded\n");
 }

 static void __exit ovl_exit(void)
 {
        unregister_filesystem(&ovl_fs_type);
+       printk(KERN_INFO "overlayfs: unloaded\n");
 }

 module_init(ovl_init);

Maybe "loaded" is enough.

- Sedat -

> Thanks,
> Miklos
