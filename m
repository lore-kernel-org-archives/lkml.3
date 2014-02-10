Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaBJVIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:08:14 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:51357 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaBJVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:08:12 -0500
Message-ID: <52F93FBB.1090108@tilera.com>
Date: Mon, 10 Feb 2014 16:08:11 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
References: <20140206134825.305510953@infradead.org> <52F93B7C.2090304@tilera.com> <20140210205719.GY5002@laptop.programming.kicks-ass.net>
In-Reply-To: <20140210205719.GY5002@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(+LKML again)

On 2/10/2014 3:57 PM, Peter Zijlstra wrote:
> On Mon, Feb 10, 2014 at 03:50:04PM -0500, Chris Metcalf wrote:
>> On 2/6/2014 8:52 AM, Peter Zijlstra wrote:
>>> Its been compiled on everything I have a compiler for, however frv and
>>> tile are missing because they're special and I was tired.
>> So what's the specialness on tile?
> Its not doing the atomic work in ASM but uses magic builtins or such.
>
> I got the list of magic funcs for tilegx, but didn't look into the 32bit
> chips.

Oh, I see.  The <asm/atomic.h> files on tile are already reasonably well-factored.

It's possible you could do better, but I think not by too much, other than possibly
by using <asm-generic/atomic.h> for some of the common idioms like "subtraction
is addition with a negative second argument", etc., which hasn't been done elsewhere.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

