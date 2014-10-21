Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbaJUTmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:42:10 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:45134 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932382AbaJUTmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:42:09 -0400
X-Greylist: delayed 79391 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2014 15:42:08 EDT
Message-ID: <5446B708.6070404@hurleysoftware.com>
Date: Tue, 21 Oct 2014 15:42:00 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Kumar Gala <galak@codeaurora.org>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] tty: serial: msm: Fix lock init issue with earlycon
References: <1413551588-14877-1-git-send-email-galak@codeaurora.org> <544553F6.1020409@codeaurora.org> <544580ED.3050604@hurleysoftware.com> <20141020221656.GC12469@codeaurora.org> <20141020222003.GD12469@codeaurora.org>
In-Reply-To: <20141020222003.GD12469@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 06:20 PM, Stephen Boyd wrote:
> On 10/20, Stephen Boyd wrote:
>> On 10/20, Peter Hurley wrote:
>>>
>>> FWIW, __msm_console_write() is a deadlock-waiting-to_happen since it does
>>> not disable interrupts with spin_lock_irqsave().
>>>
>>
>> Yeah we should fix that. As far as I can tell we've never used
>> the irqsave variant of the lock in the console path. Did this
>> become necessary at some point since this driver was introduced?
>> I'm wondering how many stable trees need the fix.
> 
> Actually I don't see this case. It looks like the console is
> always called in call_console_drivers() with irqs saved and
> disabled via the logbuf_lock in console_cont_flush() or
> console_unlock().

Thanks for bringing that to my attention.

That looks like a vestige of the initial transition away from BKL.
I might look into just disabling preemption; even that might not
really be necessary.

Regards,
Peter Hurley

