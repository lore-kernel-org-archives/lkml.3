Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaIWKrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:47:48 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:4206 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbaIWKrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:47:45 -0400
Message-ID: <54214FCE.6070501@imgtec.com>
Date: Tue, 23 Sep 2014 11:47:42 +0100
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] MIPS: mcount: Fix selfpc address for static trace
References: <1411392779-9554-1-git-send-email-markos.chandras@imgtec.com>	<1411392779-9554-3-git-send-email-markos.chandras@imgtec.com> <20140922142642.7f70fb0f@gandalf.local.home>
In-Reply-To: <20140922142642.7f70fb0f@gandalf.local.home>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 07:26 PM, Steven Rostedt wrote:
> On Mon, 22 Sep 2014 14:32:59 +0100
> Markos Chandras <markos.chandras@imgtec.com> wrote:
> 
>> According to Documentation/trace/ftrace-design.txt, the selfpc
>> should be the return address minus the mcount overhead (8 bytes).
>> This brings static trace in line with the dynamic trace regarding
>> the selfpc argument to the tracing function.
>>
>> This also removes the magic number '8' with the proper
>> MCOUNT_INSN_SIZE.
> 
> I could also update the generic code to handle delay slots.
> 
> -- Steve

As I said to the other patch, if you want to fix the delay slots in the
generic code that may be preferred indeed. On the other hand, the static
tracer still needs fixing so the correct selfpc is used. I will update
this patch based on the way you choose to handle delay slots in the
generic code. Thanks

-- 
markos
