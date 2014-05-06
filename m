Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaEFRBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:01:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaEFRBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:01:43 -0400
Message-ID: <5369156C.4000602@redhat.com>
Date: Tue, 06 May 2014 19:01:32 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] uprobes: add comment with insn opcodes, mnemonics
 and why we dont support them
References: <1399314247-7368-1-git-send-email-dvlasenk@redhat.com> <20140505194100.GA26916@redhat.com>
In-Reply-To: <20140505194100.GA26916@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 09:41 PM, Oleg Nesterov wrote:
> On 05/05, Denys Vlasenko wrote:
>>
>> + * Opcodes we'll probably never support:
>> + * 6c-6f - ins,outs. SEGVs if used in userspace
>> + * e4-e7 - in,out imm. SEGVs if used in userspace
>> + * ec-ef - in,out acc. SEGVs if used in userspace
> 
> Well. I have no idea why they are nacked, but this is not the reason.
> 
> SEGVs are fine. Plus we have ioperm().

Noted.

Oleg, can you clear for me the following -

If the probed instruction triggers an "illegal insn" or "privileged insn"
CPU exception - are we completely fine?

Or there are some problems? how bad are they?
Slightly wrong signal stack? Wrong EFLAGs on stack?
Wrong address of failing insn?
