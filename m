Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966752Ab3DRIvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 04:51:48 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:38223 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966221Ab3DRIvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:51:46 -0400
To: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 18 Apr 2013 10:51:43 +0200
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: PranavkumarSawargaonkar <pranavkumar@linaro.org>,
        <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <linux-kernel@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
Organization: ARM Ltd
In-Reply-To: <CAFEAcA-38=zx-s3NaBAu-yvDNRbt=KcTs-3c1QJR3COB3G1n2A@mail.gmail.com>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org> <ede8ee08bb2616c2ed642200e3357367@localhost> <CAFEAcA-38=zx-s3NaBAu-yvDNRbt=KcTs-3c1QJR3COB3G1n2A@mail.gmail.com>
Message-ID: <b67c5c681ce96942c3cc3bd05b8c80d2@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: peter.maydell@linaro.org, pranavkumar@linaro.org, linaro-kernel@lists.linaro.org, patches@linaro.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013 09:30:52 +0100, Peter Maydell
<peter.maydell@linaro.org> wrote:
> On 18 April 2013 07:49, Marc Zyngier <maz@misterjones.org> wrote:
>> If you need an early console, why not simply wire the 8250 emulation in
>> kvmtool to be useable from the MMIO bus? I reckon this would solve your
>> problem in a more elegant way...
> 
> The other approach I thought of would be something involving
> defining a hypercall interface for console I/O, in the same
> way that we have hypercalls for "start cpu"/"stop cpu"/etc.
> Is there any mileage in considering that approach, or is it
> a non-starter?

That's always possible, but that becomes architecture dependent, which
means code duplication across architectures. I'd rather use the MMIO
infrastructure, which has some commonalities across the board.

        M.
-- 
Fast, cheap, reliable. Pick two.
