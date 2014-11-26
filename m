Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaKZW2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:28:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaKZW2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:28:07 -0500
Date: Wed, 26 Nov 2014 14:28:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fat: Fix oops on corrupted vfat fs
Message-Id: <20141126142805.396bda184367db070f6321d5@linux-foundation.org>
In-Reply-To: <873896x9kf.fsf@devron.myhome.or.jp>
References: <873896x9kf.fsf@devron.myhome.or.jp>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 00:31:28 +0900 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> a) don't bother with ->d_time for positives - we only check it for negatives
> anyway.
> b) make sure to set it at unlink and rmdir time - at *that* point soon-to-be
> negative dentry matches then-current directory contents
> c) don't go into renaming of old alias in vfat_lookup() unless it has
> the same parent (which it will, unless we are seeing corrupted image)
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Cc: <stable@vger.kernel.org> # 3.17.x
> [Make change minimum, don't call d_move() for dir]
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

It's unclear who did the "[Make change minimum.." alteration.

I do it this way:
[hirofumi@mail.parknet.co.jp: make change minimum, don't call d_move() for dir]

Also, who was the primary author of this patch?  It *looks* like it was
Al, unsure.  If it was indeed Al then this can be communicated by
putting his From: line at the very top of the changelog body.
