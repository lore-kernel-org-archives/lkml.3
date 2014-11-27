Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaK0HAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:00:47 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:54916 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaK0HAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:00:46 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fat: Fix oops on corrupted vfat fs
References: <873896x9kf.fsf@devron.myhome.or.jp>
	<20141126142805.396bda184367db070f6321d5@linux-foundation.org>
Date: Thu, 27 Nov 2014 16:00:41 +0900
In-Reply-To: <20141126142805.396bda184367db070f6321d5@linux-foundation.org>
	(Andrew Morton's message of "Wed, 26 Nov 2014 14:28:05 -0800")
Message-ID: <87r3wpw2jq.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 27 Nov 2014 00:31:28 +0900 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
>
>> a) don't bother with ->d_time for positives - we only check it for negatives
>> anyway.
>> b) make sure to set it at unlink and rmdir time - at *that* point soon-to-be
>> negative dentry matches then-current directory contents
>> c) don't go into renaming of old alias in vfat_lookup() unless it has
>> the same parent (which it will, unless we are seeing corrupted image)
>> 
>> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: <stable@vger.kernel.org> # 3.17.x
>> [Make change minimum, don't call d_move() for dir]
>> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
> It's unclear who did the "[Make change minimum.." alteration.
>
> I do it this way:
> [hirofumi@mail.parknet.co.jp: make change minimum, don't call d_move() for dir]

I see. OK, I will also use your format next time.

> Also, who was the primary author of this patch?  It *looks* like it was
> Al, unsure.  If it was indeed Al then this can be communicated by
> putting his From: line at the very top of the changelog body.

Ah, sorry. The patch is written by Al, and I was forgetting to add "From:".
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
