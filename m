Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3IJD6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 23:58:00 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:25924 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3IJD56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 23:57:58 -0400
Message-ID: <522E98B4.1050906@hp.com>
Date: Mon, 09 Sep 2013 23:57:40 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk, aswin@hp.com,
        john@stoffel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, scott.norton@hp.com
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
References: <20130910004020.29299.qmail@science.horizon.com>
In-Reply-To: <20130910004020.29299.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 08:40 PM, George Spelvin wrote:
> I'm really wondering about only trying once before taking the write lock.
> Yes, using the lsbit is a cute hack, but are we using it for its cuteness
> rather than its effectiveness?
>
> Renames happen occasionally.  If that causes all the current pathname
> translations to fall back to the write lock, that is fairly heavy.
> Worse, all of those translations will (unnecessarily) bump the write
> seqcount, triggering *other* translations to fail back to the write-lock
> path.
>
> One patch to fix this would be to have the fallback read algorithm take
> sl->lock but *not* touch sl->seqcount, so it wouldn't break concurrent
> readers.

Actually, a follow-up patch that I am planning to do is to introduce a 
read_seqlock() primitive in seqlock.h that does exactly that. Then the 
write_seqlock() in this patch will be modified to read_seqlock().

-Longman
