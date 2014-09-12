Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaILROO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:14:14 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53339 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750846AbaILRON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:14:13 -0400
Date: Fri, 12 Sep 2014 18:14:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 3.17-rc4 v5 2/6] arm: fiq: Replace default FIQ handler
Message-ID: <20140912171404.GO12361@n2100.arm.linux.org.uk>
References: <1410272111-30516-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-3-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410435078-28462-3-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 12:31:14PM +0100, Daniel Thompson wrote:
> This patch introduces a new default FIQ handler that is structured in a
> similar way to the existing ARM exception handler and result in the FIQ
> being handled by C code running on the SVC stack (despite this code run
> in the FIQ handler is subject to severe limitations with respect to
> locking making normal interaction with the kernel impossible).
> 
> This default handler allows concepts that on x86 would be handled using
> NMIs to be realized on ARM.

Okay, lastly... I sent you my version of this change, which contained
the changes I've detailed in the previous three emails, which are absent
from your version.

However, you've taken on board the "trace" thing to svc_entry, and
renamed it to "call_trace".

Now if I add this to usr_entry, "call_trace" doesn't make any sense,
nor does the .if/.endif placement because it's not just trace_hardirqs_off
which needs to be disabled there, but also ct_user_exit as well.

I'm beginning to wonder why I tried to be nice here... it would've been
a lot faster for me to take your patch, make my own changes and commit
that instead.

Frustrated.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
