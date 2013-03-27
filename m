Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3C0J7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:59:03 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:38515 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab3C0J7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:59:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] clk: allow reentrant calls into the clk framework
Date: Wed, 27 Mar 2013 10:59:49 +0100
Message-ID: <7889001.WUy2IIhd2C@avalon>
User-Agent: KMail/4.10 (Linux/3.7.10-gentoo; KDE/4.10.0; x86_64; ; )
In-Reply-To: <alpine.LFD.2.02.1303270941320.22263@ionos>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org> <alpine.LFD.2.02.1303270941320.22263@ionos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Wednesday 27 March 2013 10:40:28 Thomas Gleixner wrote:
> On Wed, 27 Mar 2013, Mike Turquette wrote:
> > Reentrancy into the clock framework from the clk.h api is necessary
> > for clocks that are prepared and unprepared via i2c_transfer (which
> > includes many PMICs and discrete audio chips) as well as for several
> > other use cases.
> 
> That explanation sucks.
> 
> Why does an i2c clock need reentrancy? Just because it's i2c or what?

That's just an example, other clocks need reentrancy as well.

> What exactly are the "several other use cases"?

Please see below.

> Why do you need the spinlock side reentrant? If a clock is handled by
> i2c it hardly can hold the spinlock over a i2c transfer.
> 
> A few pointers to code which needs this would be nice as well.

See for instance 
http://git.linuxtv.org/pinchartl/media.git/commitdiff/c4abb868a4cb6ad33fde76a6383543f3bd6699b0

That commit exposes the XCLKA and XCLKB clock outputs of the OMAP3 ISP (camera 
interface) as clock framework objects. The issue here is that the ISP has 
several inputs clocks. One of them is a parent of XCLK[AB], and another one 
controls access to the ISP registers (L4 bus clock). The ISP driver thus needs 
to enable/disable and prepare/unprepare the L4 clock in the XCLK[AB] 
enable/disable and prepare/unprepare operation handlers.

> I'm refraining from reviewing the horrible implementation until I get
> proper answers to the above questions.

-- 
Regards,

Laurent Pinchart

