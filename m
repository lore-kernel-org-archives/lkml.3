Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaIPP5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:57:48 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59028 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754334AbaIPP5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:57:47 -0400
Date: Tue, 16 Sep 2014 16:57:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 3.17-rc4 v6 2/6] arm: fiq: Replace default FIQ handler
Message-ID: <20140916155738.GI12361@n2100.arm.linux.org.uk>
References: <1410695835-10496-1-git-send-email-daniel.thompson@linaro.org> <1410695835-10496-3-git-send-email-daniel.thompson@linaro.org> <54176F7C.6030908@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54176F7C.6030908@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 12:00:12AM +0100, Daniel Thompson wrote:
> On 14/09/14 12:57, Daniel Thompson wrote:
> > This patch introduces a new default FIQ handler that is structured in a
> > similar way to the existing ARM exception handler and result in the FIQ
> > being handled by C code running on the SVC stack (despite this code run
> > in the FIQ handler is subject to severe limitations with respect to
> > locking making normal interaction with the kernel impossible).
> > 
> > This default handler allows concepts that on x86 would be handled using
> > NMIs to be realized on ARM.
> > 
> > Credit:
> > 
> >     This patch is a near complete re-write of a patch originally
> >     provided by Anton Vorontsov. Today only a couple of small fragments
> >     survive, however without Anton's work to build from this patch would
> >     not exist. Thanks also to Russell King for spoonfeeding me a variety
> >     of fixes during the review cycle.
> 
> I've send this patch to the your patch tracker as complete respin (#8150/2).
> 
> If you'd rather handle it as a follow on patch please let me know and I
> will prepare it as one.

Thanks, as you will see, I've merged this patch, along with my two
patches, one removing do_unexp_fiq() and the newline removal in
show_regs().  They should be appearing in a linux-next rsn.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
