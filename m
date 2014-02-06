Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaBFOwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:52:50 -0500
Received: from numascale.com ([213.162.240.84]:55869 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaBFOwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:52:49 -0500
Message-ID: <52F3A1B4.2010602@numascale.com>
Date: Thu, 06 Feb 2014 22:52:36 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Waiman Long <waiman.long@hp.com>
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to  spin_on_owner
 if need_resched() triggered while queued
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 6 February 2014 22:10:01 UTC+8, Peter Zijlstra  wrote:
 > On Wed, Feb 05, 2014 at 04:44:34PM -0500, Waiman Long wrote:
 > > I have an alternative way of breaking out of the MCS lock waiting 
queue when
 > > need_resched() is set. I overload the locked flag to indicate a 
skipped node
 > > if negative.
 >
 > I'm not quite seeing how it works (then again, I've not really read the
 > patch carefully).
 >
 > Suppose you break out; at that point you get queued and go to sleep.
 > Suppose you got woken up while you MCS entry is still 'pending' and
 > magically win the race and acquire the lock.
 >
 > At that point your MCS entry can be re-used while its still part of the
 > list.
 >
 > Its a fantastically small race window, but I don't see anything that
 > makes it impossible.
 >
 > > I run the patch through the AIM7 high-systime workload on a
 > > 4-socket server and it seemed to run fine.
 >
 > How do people run this AIM7 piece of shit? I let it run for over an hour
 > and it generated exactly 0 numbers, it just sits there eating cpu-time
 > and creating a racket from my pantry.

Without any better advice, I was building the OSDL AIM7 [1], tweaking 
DISKDIR in data/reaim.config and running (eg on a 384-core setup):
$ src/reaim -c data/reaim.config -f data/workfile.compute -i 16 -e 384

Thanks,
   Daniel

[1] http://sourceforge.net/projects/re-aim-7/
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
