Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3LETsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:48:23 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:54772 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3LETsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:48:19 -0500
Message-ID: <52A0D87A.9060802@linaro.org>
Date: Thu, 05 Dec 2013 14:48:10 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Linaro Networking <linaro-networking@linaro.org>
Subject: Re: [PATCH v3 00/15] uprobes: Add uprobes support for ARM
References: <1385520814-10663-1-git-send-email-dave.long@linaro.org> <529F6B88.2050005@linaro.org>
In-Reply-To: <529F6B88.2050005@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/13 12:51, Taras Kondratiuk wrote:
> On 11/27/2013 04:53 AM, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> This patch series adds basic uprobes support to ARM. It is based on patches
>> developed earlier by Rabin Vincent. That approach of adding hooks into
>> the kprobes instruction parsing code was not well received. This approach
>> separates the ARM instruction parsing code in kprobes out into a separate set
>> of functions which can be used by both kprobes and uprobes. Both kprobes and
>> uprobes then provide their own semantic action tables to process the results of
>> the parsing.
>>
>> The following are noteworthy changes made for v3:
>>
>> 1) The ARM uprobes functionality no longer depends on kprobes. As
>> a side effect of this there are no longer any changes to the common
>> kprobes include file (or any other common kprobes files).
>> 2) A couple large patches have been broken down into more smaller
>> patches.
>> 3) A problem with uretprobes has been fixed.
>> 4) The kprobes-test module has been made more useable for thumb tests.
>> 5) The argument list to the "action" functions has been shrunk.
>> 6) Alignment with a few recent patches that were made to common
>> uprobes code specifically to support this patchset.
>>
>> This patchset is based on v3.13-rc1
>
> Hi Dave
>
> I've tested this series in big-endian mode.
> There is an issue within __create_xol_area() function.
> It writes UPROBE_SWBP_INSN directly to memory, but UPROBE_SWBP_INSN
> stores canonical opcode, which leads to a wrong instruction endianness
> if CPU runs in BE.
>
> I think the easies way to fix it without touching generic uprobes code
> is to store opcode in native endianness in UPROBE_SWBP_INSN, and use
> another macro for canonical form in ARM specific code.
> Please check a diff below. With this diff plus addressed comment for
> patch 14/15 plus fixed Ben's BE kprobes series I have uprobes working
> on LE and BE.
>

Thanks Taras.  I am preparing a v4 addressing these issues and also 
addressing the issue that, after duplicating your earlier observations, 
  my claim in "1)" above has proven to be incorrect.

-dl


