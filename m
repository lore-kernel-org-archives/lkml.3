Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965151Ab3DHVot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:44:49 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40203 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935961Ab3DHVor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:44:47 -0400
Message-ID: <51633A4B.1040908@gmail.com>
Date: Mon, 08 Apr 2013 23:44:43 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcache: Take data offset from the bdev superblock.
References: <51629766.6030805@gmail.com> <1365415866-16344-1-git-send-email-g2p.code+bcache@gmail.com> <20130408204956.GH15749@google.com> <5163356F.50406@gmail.com>
In-Reply-To: <5163356F.50406@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> As for BCACHE_SB_VERSION_CDEV_WITH_UUID, can you explain why you added
>> that? I suspect it's needed but I can't remember why I didn't add it
>> when I added the new UUID format (or perhaps I just forgot)
>
> I took the name from a comment in the kernel-side bcache.h.
> BCACHE_SB_VERSION_CDEV is the version make-bcache writes, and
> BCACHE_SB_VERSION_CDEV_WITH_UUID is what the kernel updates it too; I
> just changed the version names so that user-side and kernel-side were
> more consistent, internally and with each other.
> The kernel doesn't discriminate these two versions when opening, so it
> should be possible to define only the latter and deprecate the other.

To be more clear, I've replaced the kernel's BCACHE_SB_VERSION by 
BCACHE_SB_VERSION_CDEV_WITH_UUID or BCACHE_SB_MAX_VERSION depending on 
the intent.
