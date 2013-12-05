Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab3LEURt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:17:49 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:40767 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3LEURs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:17:48 -0500
Message-ID: <52A0DF6A.1010402@linaro.org>
Date: Thu, 05 Dec 2013 15:17:46 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Rabin Vincent <rabin@rab.in>,
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

Masami/Tixy,

As I just noted in a previous email the kprobes.h thing has come back to 
haunt me.  Something more is needed in my last patchset.  Tixy's 
suggestion regarding the arch_specific_insn structure:

> However, I also wonder if we should instead leave arch_specific_insn as
> a kprobes specific structure and on ARM define it in terms of a new more
> generic 'struct probe_insn'? The drawback with that is that we'd
> probably end up with a struct just containing a single member which
> seems a bit redundant:
>
> struct arch_specific_insn {
> 	struct probe_insn pinsn;
> };
>
> Thought's anyone?

...got me thinking.  When I do as he suggests and create a new 
arch-specific structure for sharing between kprobes and uprobes then it 
turns out simply #define'ing the arch_specific_insn structure tag to the 
new structure tag in arch/arm/include/kprobes.h makes everything happy. 
  When KPROBES is not configured that include file is (still) not 
included and the generic kprobes.h include file still continues to make 
a dummy structure for it.  My question is:  Is it too hacky to use a 
#define for a structure tag this way?

-dl

