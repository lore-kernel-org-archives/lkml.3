Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaKDRTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:19:54 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55751 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751035AbaKDRTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:19:50 -0500
Date: Tue, 4 Nov 2014 17:19:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Daniel Drake <drake@endlessm.com>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jon Medhurst <tixy@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3.17-rc4 v7 0/6] arm: Implement
 arch_trigger_all_cpu_backtrace
Message-ID: <20141104171939.GI4042@n2100.arm.linux.org.uk>
References: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org>
 <CAD8Lp44gPOBh_q1zDy3y1GkrRVAvix5YaNr-+E92+g8Q7fLKJA@mail.gmail.com>
 <20141014233126.GF27405@n2100.arm.linux.org.uk>
 <543F90ED.5030005@linaro.org>
 <54590755.1070204@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54590755.1070204@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 05:05:25PM +0000, Daniel Thompson wrote:
> This week with the help of one of my colleagues (thanks Tixy) I have
> been able to run some tests and figure out what it going on on vexpress-a9.
> 
> The summary is that on some GICv1 implementations the bit to enable
> group 1 interrupts cannot be accessed using secure memory accesses. More
> specifically the presence/absence of the EnableGrp1 bit in the secure
> version GICD_CTRL register is implementation defined.
> 
> My original patches overlooked this and as a result the existing code
> will migrate all interrupts to group but then cannot enable delivery of
> group 1 interrupts.
> 
> I'm planning to respin the code so it will automatically disable FIQ
> support when the EnableGrp1 bit is not implemented. This means
> vexpress-a9 will not benefit from FIQ support but will also not be
> harmed by it.

That's good news, and it should mean that the Versatile Express starts
booting on the nightly boot tests again.  Thanks for looking into it.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
