Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbbAIRG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:06:58 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53692 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbbAIRG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:06:57 -0500
Message-ID: <54B00AAE.1050504@linaro.org>
Date: Fri, 09 Jan 2015 17:06:54 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH] arm: Remove early stack deallocation from restore_user_regs
References: <1418382718-16323-1-git-send-email-daniel.thompson@linaro.org> <1420470758-5874-1-git-send-email-daniel.thompson@linaro.org> <20150109164608.GV12302@n2100.arm.linux.org.uk>
In-Reply-To: <20150109164608.GV12302@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/15 16:46, Russell King - ARM Linux wrote:
> On Mon, Jan 05, 2015 at 03:12:38PM +0000, Daniel Thompson wrote:
>> Currently restore_user_regs deallocates the SVC stack early in
>> its execution and relies on no exception being taken between
>> the deallocation and the registers being restored. The introduction
>> of a default FIQ handler that also uses the SVC stack breaks this
>> assumption and can result in corrupted register state.
>>
>> This patch works around the problem by removing the early
>> stack deallocation and using r2 as a temporary instead. I have
>> not found a way to do this without introducing an extra mov
>> instruction to the macro.
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>> ---
> 
> Please put it in the patch system, thanks.

Will do.


> I think we should queue
> this one for stable too, as I think we need this for v3.18
> (as a result of c0e7f7ee717e2b4c5791e7422424c96b5008c39e,
> ARM: 8150/3: fiq: Replace default FIQ handler)?

It's a close call.

Before 8150/3 the system would probably crash if the default FIQ handler
ran. After 8150/3 the system is also likely to crash since there's no
code hooked into the handler in v3.18 that can clear the source of FIQ
leaving us stuck re-entering the FIQ handler.

Nevertheless, this is a nasty gremlin to leave for backporters (it
wasn't easy to find) so I'd be very happy to Cc: stable and see what
they think.


Daniel.
