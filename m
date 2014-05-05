Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaEERcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:32:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbaEERcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:32:41 -0400
Message-ID: <5367CB30.2070604@redhat.com>
Date: Mon, 05 May 2014 19:32:32 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] uprobes: fix scratch register selection for rip-relative
 fixups
References: <1399043040-28366-1-git-send-email-dvlasenk@redhat.com> <20140505154559.GA27072@redhat.com>
In-Reply-To: <20140505154559.GA27072@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 05:45 PM, Oleg Nesterov wrote:
> On 05/02, Denys Vlasenko wrote:
>>  static inline unsigned long *
>>  scratch_reg(struct arch_uprobe *auprobe, struct pt_regs *regs)
>>  {
>> -	return (auprobe->def.fixups & UPROBE_FIX_RIP_AX) ? &regs->ax : &regs->cx;
>> +	/* Order is important - more than one bit can be set! */
> 
> Really?
> 
> Should I remove this comment or I misread the change in riprel_analyze?

Yes, it is not true: latest code sets only one bit.
