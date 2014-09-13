Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaIMMD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 08:03:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63975 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaIMMDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 08:03:25 -0400
Message-ID: <5414328B.6010307@linaro.org>
Date: Sat, 13 Sep 2014 13:03:23 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 3.17-rc4 v5 2/6] arm: fiq: Replace default FIQ handler
References: <1410272111-30516-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-3-git-send-email-daniel.thompson@linaro.org> <20140912171404.GO12361@n2100.arm.linux.org.uk>
In-Reply-To: <20140912171404.GO12361@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 18:14, Russell King - ARM Linux wrote:
> On Thu, Sep 11, 2014 at 12:31:14PM +0100, Daniel Thompson wrote:
>> This patch introduces a new default FIQ handler that is structured in a
>> similar way to the existing ARM exception handler and result in the FIQ
>> being handled by C code running on the SVC stack (despite this code run
>> in the FIQ handler is subject to severe limitations with respect to
>> locking making normal interaction with the kernel impossible).
>>
>> This default handler allows concepts that on x86 would be handled using
>> NMIs to be realized on ARM.
> 
> Okay, lastly... I sent you my version of this change, which contained
> the changes I've detailed in the previous three emails, which are absent
> from your version.
> 
> However, you've taken on board the "trace" thing to svc_entry, and
> renamed it to "call_trace".
> 
> Now if I add this to usr_entry, "call_trace" doesn't make any sense,
> nor does the .if/.endif placement because it's not just trace_hardirqs_off
> which needs to be disabled there, but also ct_user_exit as well.
> 
> I'm beginning to wonder why I tried to be nice here... it would've been
> a lot faster for me to take your patch, make my own changes and commit
> that instead.

I did not do a side by side diff of your FYI patch with my current code
and hence overlooked all these changes.

Sorry. I should have done that.

