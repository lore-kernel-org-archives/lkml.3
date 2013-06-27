Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3F0JIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:08:40 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:52162 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3F0JIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:08:34 -0400
Message-ID: <51CC010D.70503@numascale-asia.com>
Date: Thu, 27 Jun 2013 17:08:29 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Steffen Persvold <sp@numascale.com>
Subject: Re: 13GB dcache+inode cache hash tables
References: <51C95B3A.10809@numascale-asia.com> <1372153697.3301.98.camel@edumazet-glaptop>
In-Reply-To: <1372153697.3301.98.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/2013 17:48, Eric Dumazet wrote:
> On Tue, 2013-06-25 at 16:56 +0800, Daniel J Blueman wrote:
>> As memory capacity increases, we see the dentry and inode cache hash
>> tables grow to wild sizes [1], eg 13GB is consumed on a 4.5TB system.
>>
>> Perhaps a better approach adds a linear component to an exponent to give
>> tuned scaling, given that spatial locality is an advantage in hash table
>> and careful use of resources.
>>
>> The same approach would fit to other hash tables (mount-cache, TCP
>> established, TCP bind, UDP, UDP-Lite, Dquot-cache) with different
>> coefficients, so perhaps we could generalise.
>>
>
> TCP hash table is limited to 512K slots, unless overridden.
> TCP bind limited to 64K slots.
> UDP limited to 64K slots.
>
>> If so what are reasonable reference points and assumptions?
>
> I do not know what you have in mind, please show us a patch ;)
[...]

Alright, I'll see what I can get together in the next week or so when I 
can fit it in.

Dan
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
