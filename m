Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757Ab3CMQZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:25:32 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:51069 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643Ab3CMQZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:25:30 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 13 Mar 2013 17:25:29 +0100
Message-ID: <CA+icZUVhn_rRhNxmd5wXUhwdbE+n3Das__6u=6XHRQ-zz2rvVw@mail.gmail.com>
Subject: [squashfs] $VERSION and $VERSION_DATE?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: squashfs-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was wondering why OverlayFS gives no success message on loading the module

Snippet from Linux-Next (next-20130313):

[ fs/squashfs/super.c ]
...
static int __init init_squashfs_fs(void)
{
        int err = init_inodecache();

        if (err)
                return err;

        err = register_filesystem(&squashfs_fs_type);
        if (err) {
                destroy_inodecache();
                return err;
        }

        printk(KERN_INFO "squashfs: version 4.0 (2009/01/31) "
                "Phillip Lougher\n");

        return 0;
}
...

And why do you hardcode that $VERSION and $VERSION_DATE here?
Is $VERSION_DATE still correct?

Regards,
- Sedat -
