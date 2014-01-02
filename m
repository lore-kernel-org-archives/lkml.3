Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750787AbaABKCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:02:48 -0500
Received: from ni.piap.pl ([195.187.100.4]:51151 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaABKCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:02:46 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Willy Tarreau <w@1wt.eu>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>
References: <m3mwjhux0e.fsf@t19.piap.pl> <20131231104511.GA9688@1wt.eu>
Date: Thu, 02 Jan 2014 11:02:44 +0100
In-Reply-To: <20131231104511.GA9688@1wt.eu> (Willy Tarreau's message of "Tue,
	31 Dec 2013 11:45:11 +0100")
MIME-Version: 1.0
Message-ID: <m3txdmu2ez.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: v3.13-rc6+ regression (ARM board)
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140102 #7222383, check: 20140102 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> There seems to be a regression in v3.13-rc6+ (up to current tip =
>> 71ce176ee6ed1735b9a1160a5704a915d13849b1).
>>
>> Board is Gateworks Cambria, CPU Intel IXP435 ARM big endian, gcc 4.7.3.
>> The board boots correctly and works (shell mostly, and SSHD) for about
>> 50 seconds. After 52-54 seconds, it frozes dead without any console
>> (UART) output.
>>
>> Bisecting shows 5e30025a319910695f5010dc0fb53a23299da14d as the first
>> bad commit. Interestingly it's a merge:

Reverting 1ca7d67cf5d5a2aef26a8d9afd789006fa098347 on top of current tip
(9a0bb2966efbf30a71c128c3af63307d8b5f5fc0) fixes my issue.

What now?

1ca7d67cf5d5a2aef26a8d9afd789006fa098347:
    seqcount: Add lockdep functionality to seqcount/seqlock structures

    Currently seqlocks and seqcounts don't support lockdep.

    After running across a seqcount related deadlock in the timekeeping
    code, I used a less-refined and more focused variant of this patch
    to narrow down the cause of the issue.

    This is a first-pass attempt to properly enable lockdep functionality
    on seqlocks and seqcounts.

    Since seqcounts are used in the vdso gettimeofday code, I've provided
    non-lockdep accessors for those needs.

    I've also handled one case where there were nested seqlock writers
    and there may be more edge cases.

    Comments and feedback would be appreciated!
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
