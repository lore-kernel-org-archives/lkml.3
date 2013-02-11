Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3BKLW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:22:59 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:50083 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab3BKLW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:22:57 -0500
Message-ID: <5118D478.3010205@synopsys.com>
Date: Mon, 11 Feb 2013 16:52:32 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: Jonas Bonn <jonas.bonn@gmail.com>
CC: James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: pt_regs leak into userspace (was Re: [PATCH v3 20/71] ARC: Signal
 handling)
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com> <1359024639-21915-9-git-send-email-vgupta@synopsys.com> <51189D2F.4030000@synopsys.com> <CACM3HyGNZxfOXpw01POBVT-YcVKQsnPkO6Kgg+epfZS-x-BRCg@mail.gmail.com> <5118C458.2070205@synopsys.com> <5118C7B6.6040807@imgtec.com> <CACM3HyG+4Pzx02iL9atxG+FOLiCcTeXR+ivzRO78bqDHNp5rGQ@mail.gmail.com>
In-Reply-To: <CACM3HyG+4Pzx02iL9atxG+FOLiCcTeXR+ivzRO78bqDHNp5rGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2013 04:23 PM, Jonas Bonn wrote:
> On 11 February 2013 11:28, James Hogan <james.hogan@imgtec.com> wrote:
>> On 11/02/13 10:13, Vineet Gupta wrote:
>>> On Monday 11 February 2013 03:06 PM, Jonas Bonn wrote:
>>>> On 11 February 2013 08:26, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>>>>
>>>>> The only downside of this patch is that userspace signal stack grows in size,
>>>>> since signal frame only cares about scratch regs (pt_regs), but has to accommodate
>>>>> unused placeholder for callee regs too by virtue of using user_regs_struct.
>>>> Is this really true?  Don't setcontext and friends require that _all_
>>>> the registers be part of sigcontext?
>>>
>>> But for an ABI - callee saved regs will anyhow be saved/restored even in
>>> setcontext case ! So collecting it for that purpose seems useless, or am I missing
>>> something here.
>>
>> I think Jonas' point was that signals are asynchronous, i.e. you could
>> get interrupted by a signal at virtually any time during the program's
>> execution.
> 
> No, I agree that the callee-saved regs don't need to be saved across a
> signal handler invocation.  It's really just the setcontext case that
> wants to be able to swap out the callee-saved regs.

I don't think that's needed either - and if thats mandated somewhere, it would
seem a unnecessary mis-optimization IMHO.

See, even a setcontext enabled control flow needs to be ABI compliant so that it
plays nicely with other normal flows of execution. Thus e.g. it can't fudge a
callee reg - it needs to save orig callee reg(s) and restore them in the end. And
if we agree to those semantics - I don't see any value in swapping the callee reg
context around usage of setcontext as it would be a wasted effort.

-Vineet
