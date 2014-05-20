Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaETSaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:30:16 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:34919 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaETSaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:30:14 -0400
Message-ID: <537B9F2D.6060606@colorfullife.com>
Date: Tue, 20 May 2014 20:30:05 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de
Subject: Re: [PATCH 6/6] ipc/sem.c: make semctl(,,{GETNCNT,GETZCNT}) standard
 compliant
References: <1400399917-17583-1-git-send-email-manfred@colorfullife.com> <1400399917-17583-2-git-send-email-manfred@colorfullife.com> <1400399917-17583-3-git-send-email-manfred@colorfullife.com> <1400399917-17583-4-git-send-email-manfred@colorfullife.com> <1400399917-17583-5-git-send-email-manfred@colorfullife.com> <1400399917-17583-6-git-send-email-manfred@colorfullife.com> <1400399917-17583-7-git-send-email-manfred@colorfullife.com> <20140519154639.5570a30f8b47872a323dcdfd@linux-foundation.org>
In-Reply-To: <20140519154639.5570a30f8b47872a323dcdfd@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 05/20/2014 12:46 AM, Andrew Morton wrote:
> On Sun, 18 May 2014 09:58:37 +0200 Manfred Spraul <manfred@colorfullife.com> wrote:
>
>> SUSv4 clearly defines how semncnt and semzcnt must be calculated:
>> A task waits on exactly one semaphore:
>> The semaphore from the first operation in the sop array that cannot proceed.
>>
>> The Linux implementation never followed the standard, it tried to count all
>> semaphores that might be the reason why a task sleeps.
>>
>> This patch fixes that.
> What are the back-compatibility implications of this change?
A really good question:
- there is no application in Fedora that uses GETNCNT or GETZCNT.
- application that use only single-sop semop() are also safe, the 
difference only affects complex apps.
- portable application are also safe, the new behavior is standard 
compliant.

But that's it. The old behavior existed in Linux from 0.99.something 
until now.

What about adding a WARN_ON_ONCE() if the case where the behavior 
differs happens?
Should I write a patch?

--
     Manfred
