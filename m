Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaHBRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 13:09:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49847 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbaHBRJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 13:09:25 -0400
Date: Sat, 2 Aug 2014 19:08:11 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thor Thayer <tthayer@opensource.altera.com>
Cc: Lee Jones <lee.jones@linaro.org>, robherring2@gmail.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, atull@altera.com, delicious.quinoa@gmail.com,
        dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, bp@alien8.de, sameo@linux.intel.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tthayer.linux@gmail.com,
        Alan Tull <atull@opensource.altera.com>
Subject: Re: [PATCHv9 1/3] mfd: altera: Add Altera SDRAM Controller
Message-ID: <20140802170811.GA20550@pengutronix.de>
References: <1406744573-609-1-git-send-email-tthayer@opensource.altera.com>
 <1406744573-609-2-git-send-email-tthayer@opensource.altera.com>
 <20140731082637.GH9030@lee--X1>
 <53DAA072.4010902@opensource.altera.com>
 <20140801081317.GL9030@lee--X1>
 <53DC146D.1070504@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DC146D.1070504@opensource.altera.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:58:47 up 29 days,  3:34, 23 users,  load average: 0,03, 0,03,
 0,05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri, Aug 01, 2014 at 05:27:57PM -0500, Thor Thayer wrote:
> 
> On 08/01/2014 03:13 AM, Lee Jones wrote:
> >On Thu, 31 Jul 2014, Thor Thayer wrote:
> >>On 07/31/2014 03:26 AM, Lee Jones wrote:
> >>>On Wed, 30 Jul 2014, tthayer@opensource.altera.com wrote:

[...]

> >>>>+u32 altera_sdr_readl(struct altera_sdr *sdr, u32 reg_offset)
> >>>>+{
> >>>>+	return readl(sdr->reg_base + reg_offset);
> >>>>+}
> >>>>+EXPORT_SYMBOL_GPL(altera_sdr_readl);
> >>>>+
> >>>>+void altera_sdr_writel(struct altera_sdr *sdr, u32 reg_offset, u32 value)
> >>>>+{
> >>>>+	writel(value, sdr->reg_base + reg_offset);
> >>>>+}
> >>>>+EXPORT_SYMBOL_GPL(altera_sdr_writel);
> We'd prefer to use syscon and that is what we started with. If you'd
> like to be our advocate, I will return to that because it was pretty
> clean. My primary concern is to get it upstreamed and if it is MFD
> then I'll make the changes.
> 
> Here are the threads.
> http://marc.info/?l=linux-kernel&m=140128791902800&w=2

The conclusion of this thread was syscon for offset 0x0, no ?!
And if you decide to have new writel/readl functions, I'd prefer if you don't
change the order of parameters just because. That always weirds me out, when
there are vendorname_writel functions, that only change the API of writel and
nothing else (not exactly the case here).

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
