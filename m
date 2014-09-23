Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaIWKqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:46:19 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:13539 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbaIWKqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:46:18 -0400
Message-ID: <54214F76.6070808@imgtec.com>
Date: Tue, 23 Sep 2014 11:46:14 +0100
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, David Daney <ddaney.cavm@gmail.com>
CC: <linux-mips@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] MIPS: ftrace.h: Fix the MCOUNT_INSN_SIZE definition
References: <1411392779-9554-1-git-send-email-markos.chandras@imgtec.com>	<1411392779-9554-2-git-send-email-markos.chandras@imgtec.com>	<5420546D.6050102@gmail.com> <20140922142534.4087a0a9@gandalf.local.home>
In-Reply-To: <20140922142534.4087a0a9@gandalf.local.home>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 07:25 PM, Steven Rostedt wrote:
> On Mon, 22 Sep 2014 09:55:09 -0700
> David Daney <ddaney.cavm@gmail.com> wrote:
> 
>> On 09/22/2014 06:32 AM, Markos Chandras wrote:
>>> The MCOUNT_INSN_SIZE is meant to be used to denote the overall
>>> size of the mcount() call. Since a jal instruction is used to
>>> call mcount() the delay slot should be taken into consideration
>>> as well.
>>> This also replaces the MCOUNT_INSN_SIZE usage with the real size
>>> of a single MIPS instruction since, as described above, the
>>> MCOUNT_INSN_SIZE is used to denote the total overhead of the
>>> mcount() call.
>>
>> Are you seeing errors with the existing code?  If so please state what 
>> they are.
>>
>> By changing this, we can no longer atomically replace the instruction. 
>> So I think shouldn't be changing this stuff unless there is a real bug 
>> we are fixing.
> 
> Actually, it looks like the code still works the same, as it uses the
> old size of 4 (FTRACE_MIPS_INSN_SIZE) to do the update.

Indeed I haven't seen any functional change when it comes to replacing
the instruction.

> [...]
> 
> It may also fix the stack tracer, as it searches for the ip saved in
> the return address to find where the true stack is (skipping the stack
> part that calls the strack tracer itself). If the link register holds
> the location after the delay slot, then this would require
> MCOUNT_INSN_SIZE to include the delay slot as well.

Yes, this is the only case I spotted as well. Perhaps I should put that
in the changelog.

Or I could add
> another macro called MCOUNT_DELAY_SLOT_SIZE that can be defined by an
> arch (and keep it zero for all other archs). That wouldn't be too much
> of an issue to implement.

If you want to fix that in the generic code then I am fine with it.

-- 
markos
