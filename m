Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbaIDWCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 18:02:14 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:45992 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbaIDWCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 18:02:13 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] Now that sync_filesystem() must be called from ->remount_fs() it needs to be EXPORT_SYMBOL() for kernel modules.
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <Pine.LNX.4.64.1408211047230.11319@hermes-1.csi.cam.ac.uk>
Date: Thu, 4 Sep 2014 23:01:43 +0100
Cc: "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C5C2C5C4-25F9-4D1A-967E-7396270A3B24@cam.ac.uk>
References: <Pine.LNX.4.64.1408211047230.11319@hermes-1.csi.cam.ac.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

No-one has objected to the below patch I sent you over two weeks ago.

Would you please apply it?

If you would like it to go through for example Al or Andrew please let me know...

Thanks a lot in advance!

Best regards,

	Anton

On 21 Aug 2014, at 11:09, Anton Altaparmakov <aia21@cam.ac.uk> wrote:

> This patch changes sync_filesystem() to be EXPORT_SYMBOL().
> 
> The reason this is needed is that starting with 3.15 kernel, due to 
> Theodore Ts'o's commit 02b9984d640873b7b3809e63f81a0d7e13496886, "fs: push 
> sync_filesystem() down to the file system's remount_fs()", all file 
> systems that have dirty data to be written out need to call 
> sync_filesystem() from their ->remount_fs() method when remounting 
> read-only.
> 
> As this is now a generically required function rather than an internal 
> only function it should be EXPORT_SYMBOL() so that all file systems can
> call it.
> 
> Signed-off-by: Anton Altaparmakov <aia21@cantab.net>
> ---
> 
> Hi Linus,
> 
> Can you please apply this patch for inclusion into 3.17?  Explanation is 
> above.
> 
> Thanks a lot in advance!
> 
> PS. I hope Pine does not mess up the whitespace of the patch!
> 
> Best regards,
> 
> 	Anton
> -- 
> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
> University of Cambridge Information Services, Roger Needham Building
> 7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK
> 
> --- linux/fs/sync.c	2014-08-21 10:30:26.000000000 +0100
> +++ linux/fs/sync.c	2014-08-21 10:30:47.000000000 +0100
> @@ -65,7 +65,7 @@ int sync_filesystem(struct super_block *
> 		return ret;
> 	return __sync_filesystem(sb, 1);
> }
> -EXPORT_SYMBOL_GPL(sync_filesystem);
> +EXPORT_SYMBOL(sync_filesystem);
> 
> static void sync_inodes_one_sb(struct super_block *sb, void *arg)
> {

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

