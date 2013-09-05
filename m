Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3IERGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:06:50 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:39021 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab3IERGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:06:48 -0400
Message-ID: <5228BA1B.5030501@hp.com>
Date: Thu, 05 Sep 2013 13:06:35 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking
 rename_lock
References: <20130905043033.20292.qmail@science.horizon.com>
In-Reply-To: <20130905043033.20292.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 12:30 AM, George Spelvin wrote:
> As long as you're removing locks from prepend_name and complicating its
> innards, I notice that each and every call site follows it by prepending
> "/".  How about moving that into prepend_name as well?
>
> Also, if you happen to feel like it, you can delete the slash flag
> and replace it with "bptr != *buffer".
>
> Another small tweak would be to the global_root part of the code.
> You could move the is_mounted(vfsmnt) test up, and combine the tail of
> that code path with the regular exit.  All you have to do is change
> the !slash test to:
>
> 	if (error>= 0&&  bptr == *buffer) {	/* Root directory */
> 		if (--blen<  0)
> 			error = -ENAMETOOLONG;
> 		else
> 			*--bptr = '/';
> 	}
>
> This modified form is no more code than an inlined copy of prepend(),
> so we haven't actually slowed the fast path, but it avoids corrupting
> the return value of 0/1/2 if possible.

Thank for the suggestions. I will implement them in my v2 patch.

-Longman
