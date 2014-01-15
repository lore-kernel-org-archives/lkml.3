Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaAOQoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:44:18 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:42927 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaAOQoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:44:15 -0500
Message-ID: <52D6BADC.2040607@linaro.org>
Date: Wed, 15 Jan 2014 11:44:12 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/16] ARM: Remove use of struct kprobe from generic
 probes code
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>  <1387166930-13182-8-git-send-email-dave.long@linaro.org> <1387547729.3404.50.camel@linaro1.home>
In-Reply-To: <1387547729.3404.50.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/13 08:55, Jon Medhurst (Tixy) wrote:
> On Sun, 2013-12-15 at 23:08 -0500, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> Change the generic ARM probes code to pass in the opcode and architecture-specific
>> structure separately instead of using struct kprobe, so we do not pollute
>> code being used only for uprobes or other non-kprobes instruction
>> interpretation.
>>
>> Signed-off-by: David A. Long <dave.long@linaro.org>
>> ---
>>   arch/arm/include/asm/probes.h    |   9 +-
>>   arch/arm/kernel/kprobes-arm.c    |  77 ++++++-------
>>   arch/arm/kernel/kprobes-common.c |  42 ++++---
>>   arch/arm/kernel/kprobes-thumb.c  | 239 +++++++++++++++++++--------------------
>>   arch/arm/kernel/kprobes.c        |   2 +-
>>   arch/arm/kernel/kprobes.h        |   2 +-
>>   arch/arm/kernel/probes-arm.c     |  33 +++---
>>   arch/arm/kernel/probes-arm.h     |  29 ++---
>>   arch/arm/kernel/probes-thumb.c   |  18 ++-
>>   arch/arm/kernel/probes-thumb.h   |  51 ---------
>>   arch/arm/kernel/probes.c         |  14 ++-
>>   arch/arm/kernel/probes.h         |   8 +-
>>   12 files changed, 246 insertions(+), 278 deletions(-)
>
> Looks OK to me, though it looks like this patch includes some header
> file cleanups that should have been part of the previous patch? I.e. all
> the changes to probes-thumb.h and probes-arm.h. And also the
> re-application of 'static' to functions in kprobes-thumb.c and
> kprobes-arm.c.
>
> I'm not sure it's worth the hassle of trying to unpick those changes
> though, it doesn't impact the end result or bisect-bility.
>

I moved the changes around as suggested.

-dl

