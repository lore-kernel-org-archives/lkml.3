Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3KNPRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:17:43 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:51043 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3KNPRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:17:38 -0500
Message-ID: <5284E98F.5040707@linaro.org>
Date: Thu, 14 Nov 2013 10:17:35 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/13] ARM: use a function table for determining instruction
 interpreter actions
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>  <1381871068-27660-9-git-send-email-dave.long@linaro.org> <1384362668.3392.41.camel@linaro1.home>
In-Reply-To: <1384362668.3392.41.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/13 12:11, Jon Medhurst (Tixy) wrote:
> On Tue, 2013-10-15 at 17:04 -0400, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> When interpreting instructions use a client-supplied array of functions
>> to take action.  This array can then be provided by krpobes, uprobes, or
>
> 'to take action' sounds a bit weird to me, how about 'to specify
> actions'?

I've changed it to:

ARM: use a function table for determining instruction interpreter actions

Make the instruction interpreter call back to semantic action functions
through a function pointer array provided by the invoker.  The interpreter
decodes the instructions into groups and uses the group number to index
into the supplied array.  kprobes and uprobes code will each supply their
own array of functions.


>> possibly some other client subsystem.  The interpreter assigns a group
>> number to each recognized instruction and invokes the corresponding action
>> function.
>>
>> Signed-off-by: David A. Long <dave.long@linaro.org>
>> ---
>>   arch/arm/kernel/Makefile         |    2 +-
>>   arch/arm/kernel/kprobes-arm.c    |   41 ++
>>   arch/arm/kernel/kprobes-common.c |    3 +-
>>   arch/arm/kernel/kprobes-thumb.c  | 1016 ++++----------------------------------
>>   arch/arm/kernel/kprobes.c        |   10 +-
>>   arch/arm/kernel/kprobes.h        |   14 +-
>>   arch/arm/kernel/probes-arm.c     |  114 ++---
>>   arch/arm/kernel/probes-arm.h     |   37 ++
>>   arch/arm/kernel/probes-thumb.c   |  875 ++++++++++++++++++++++++++++++++
>>   arch/arm/kernel/probes-thumb.h   |  136 +++++
>>   arch/arm/kernel/probes.c         |    9 +-
>>   arch/arm/kernel/probes.h         |   15 +-
>>   12 files changed, 1288 insertions(+), 984 deletions(-)
>>   create mode 100644 arch/arm/kernel/probes-thumb.c
>>   create mode 100644 arch/arm/kernel/probes-thumb.h
>
> As I mentioned in comments to patch 7, this patch seems to accidentally
> include the thumb code reorg of moving code from kprobes-thumb.c to
> probes-thumb.c

Fixed for next version (as described in previous email).

-dl

