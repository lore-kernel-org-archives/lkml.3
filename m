Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935521Ab3IEBz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 21:55:59 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:44436 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092Ab3IEBz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 21:55:57 -0400
Message-ID: <5227E49F.1090809@hp.com>
Date: Wed, 04 Sep 2013 21:55:43 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking
 rename_lock
References: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com> <20130904191104.GK13318@ZenIV.linux.org.uk> <52278AEC.2020307@hp.com> <20130904194341.GL13318@ZenIV.linux.org.uk>
In-Reply-To: <20130904194341.GL13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 03:43 PM, Al Viro wrote:
> On Wed, Sep 04, 2013 at 03:33:00PM -0400, Waiman Long wrote:
>
>> I have thought about that. But if a d_move() is going on, the string
>> in the buffer will be discarded as the sequence number will change.
>> So whether or not it have embedded null byte shouldn't matter. That
>> is why I didn't add code to do byte-by-byte copy at this first
>> patch. I can add code to do that if you think it is safer to do so.
> Sigh...  Junk in the output is not an issue; reading from invalid address
> is, since you might not survive to the sequence number check.  Again,
> if p is an address returned by kmalloc(size, ...), dereferencing p + offset
> is not safe unless offset is less than size.

Yeah, I understand that. As said in my reply to Linus, I will use 
memchr() to see if there is null byte within the specified length. If 
one is found, I will assume the string is not valid and return error to 
the caller.

Longman
