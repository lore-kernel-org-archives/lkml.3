Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaEBNrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:47:32 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:56286 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636AbaEBNrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:47:31 -0400
To: Mj Embd <mj.embd@gmail.com>
Subject: Re: Linux Interrupt Context maps to ARM CPSR.mode  =?UTF-8?Q?=3D=20IRQ?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 02 May 2014 14:47:28 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: kernelnewbies <kernelnewbies@kernelnewbies.org>,
        <linux-kernel@vger.kernel.org>
Organization: ARM Ltd
In-Reply-To: <CAPUj1OML_Rag3gxxBzswS6yaqFciuq2hKrV9BthL2OwU+wNj3A@mail.gmail.com>
References: <CAPUj1OMJ8cE1cNTe8CjgBP2GTCXzi__Yg0+OoomME6=TShgqJg@mail.gmail.com>
 <CAPUj1OML_Rag3gxxBzswS6yaqFciuq2hKrV9BthL2OwU+wNj3A@mail.gmail.com>
Message-ID: <14abe1165b144fe3d1139ad3b631eddd@www.loen.fr>
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: mj.embd@gmail.com, kernelnewbies@kernelnewbies.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-02 13:34, Mj Embd wrote:
> Adding Marc to comment
> Marc Please clarify the doubt
>
>
>
> On Fri, May 2, 2014 at 5:15 PM, Mj Embd <mj.embd@gmail.com> wrote:
>> Hi,
>>
>> As per a lot of linux documentation some components work in process
>> context and some work in interrupt context.
>>
>> If we try to map these contexts to ARM processor modes then is it
>> safely to assume that
>> Process Context : CPSR.mode = SVC
>> Interrupt Context : CPSR.mode = IRQ
>>
>> If not how to define interrupt context properly. Confusing at times.

Well, none of this is completely true.

Process context exists both in USR (process in user mode) and SVC 
(process in kernel mode, executing a syscall for example).

As for interrupts, the processor indeed starts executing the interrupt 
in IRQ mode, but this is a useless complication as far as Linux is 
concerned, and we quickly switch to SVC (see the definition of the 
vector_stub macro in arch/arm/kernel/entry-armv.S).

Hope this helps.

         M.
-- 
Fast, cheap, reliable. Pick two.
