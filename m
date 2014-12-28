Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaL1JSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 04:18:22 -0500
Received: from 1wt.eu ([62.212.114.60]:25616 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbaL1JSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 04:18:18 -0500
Date: Sun, 28 Dec 2014 10:18:18 +0100
From: Willy Tarreau <w@1wt.eu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20141228091818.GA8029@1wt.eu>
References: <20141224163823.GA17035@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141224163823.GA17035@amd>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Wed, Dec 24, 2014 at 05:38:23PM +0100, Pavel Machek wrote:
> Hi!
> 
> It seems that it is easy to induce DRAM bit errors by doing repeated
> reads from adjacent memory cells on common hw. Details are at
> 
> https://www.ece.cmu.edu/~safari/pubs/kim-isca14.pdf

Extremely interesting stuff. I've always wondered if such modules
were *that* reliable given how picky they are about all timings.

> . Older memory modules seem to work better, and ECC should detect
> this. Paper has inner loop that should trigger this.
> 
> Workarounds seem to be at hardware level, and tricky, too.
> 
> Does anyone have implementation of detector? Any ideas how to work
> around it in software?

Maybe reserve some memory "canary" that is periodically scanned and
observe changes there. That will not tell you for sure that something
has not been done, but it will tell you for sure that bits were flipped.

Also I'm wondering whether perf counters on certain CPUs could be used
to detect the abnormal number of clflushes or even the memory access
pattern (will not work in multi-socket environments if a user has one
dedicated CPU though).

Thanks for sharing the link!
Willy

