Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3JQPBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:01:14 -0400
Received: from 14.mo5.mail-out.ovh.net ([188.165.51.82]:52272 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756081Ab3JQPBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:01:12 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Oct 2013 11:01:12 EDT
Date: Thu, 17 Oct 2013 16:16:27 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Stuart MENEFY <stuart.menefy@st.com>, Lee Jones <lee.jones@linaro.org>,
        Stephen GALLIMORE <stephen.gallimore@st.com>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Subject: Re: [PATCH v5 1/4] i2c: busses: i2c-st: Add ST I2C controller
Message-ID: <20131017141627.GD14104@ns203013.ovh.net>
References: <1381754813-4679-1-git-send-email-maxime.coquelin@st.com>
 <1381754813-4679-2-git-send-email-maxime.coquelin@st.com>
 <20131016151419.GA14104@ns203013.ovh.net>
 <525F915D.9020501@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525F915D.9020501@st.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 17353213789680413476
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrfedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrfedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:27 Thu 17 Oct     , Maxime COQUELIN wrote:
> Hi Jean-Christophe,
> 
> On 10/16/2013 05:14 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> 
> ...
> >> +
> >> +static inline void st_i2c_set_bits(void __iomem *reg, u32 mask)
> >> +{
> >> +     writel(readl(reg) | mask, reg);
> >> +}
> >> +
> >> +static inline void st_i2c_clr_bits(void __iomem *reg, u32 mask)
> >> +{
> >> +     writel(readl(reg) & ~mask, reg);
> > use set_bit api and use relaxed version
> Using the set_bit api here does not match with the purpose of these 
> functions.
> We want to be able to set/clear multiple bits, and AFAICS the set_bit 
> api does not
> provide this possibility.
> 
> I took example on i2c-nomadik for these functions.
> 

so factorize the code not copy and paste
> >> +}
> >> +
> >> +/* From I2C Specifications v0.5 */
> >> +static struct st_i2c_timings i2c_timings[] = {
> >> +     [I2C_MODE_STANDARD] = {
> >> +             .rate                   = 100000,
> >> +             .rep_start_hold         = 4000,
> >> +             .rep_start_setup        = 4700,
> >> +             .start_hold             = 4000,
> >> +             .data_setup_time        = 250,
> >> +             .stop_setup_time        = 4000,
> >> +             .bus_free_time          = 4700,
> >> +     },
> >> +     [I2C_MODE_FAST] = {
> >> +             .rate                   = 400000,
> >> +             .rep_start_hold         = 600,
> >> +             .rep_start_setup        = 600,
> >> +             .start_hold             = 600,
> >> +             .data_setup_time        = 100,
> >> +             .stop_setup_time        = 600,
> >> +             .bus_free_time          = 1300,
> >> +     },
> >> +};
> > so how do you plane to support other rate that 100k and 400k?
> The SSC IP only supports Standard and Fast modes.
> There are no plans to support faster modes.
> >> +
> >> +static void st_i2c_flush_rx_fifo(struct st_i2c_dev *i2c_dev)
> >> +{
> >> +     int count, i;
> >> +
> >> +     /*
> >> +      * Counter only counts up to 7 but fifo size is 8...
> >> +      * When fifo is full, counter is 0 and RIR bit of status register is
> >> +      * set
> >> +      */
> >> +     if (readl(i2c_dev->base + SSC_STA) & SSC_STA_RIR)
> >> +             count = SSC_RXFIFO_SIZE;
> >> +     else
> >> +             count = readl(i2c_dev->base + SSC_RX_FSTAT) &
> >> +                     SSC_RX_FSTAT_STATUS;
> >> +
> >> +     for (i = 0; i < count; i++)
> >> +             readl(i2c_dev->base + SSC_RBUF);
> > use readsl
> Since the read content is flushed, I prefer keeping it as it is instead 
> of allocating
> a buffer of the FIFO's size.

keep point is to speedup the bus
> >
> > use relaxed version as much as possible
> I was not comfortable with the different possibilities (_raw_readl, 
> readl_relaxed, readl...).
> I found this interresting discussion: 
> _http://comments.gmane.org/gmane.linux.ports.arm.kernel/117626
>  From what I understood, you are right, I should be able to use 
> readl_relaxed everywhere.
> 
> Maybe I should perform a readl on the interrupt mask register before 
> returning from the interrupt handler,
> in order to ensure that the write to the IEN register is effective 
> before the IRQ for the device is re-enabled at GIC level.
> Maybe this could avoid the few spurious interrupts I face sometimes, I 
> will have a try.
ok
> 
> >> +}
> >> +
> ...
> >> +
> >> +static int st_i2c_wait_free_bus(struct st_i2c_dev *i2c_dev)
> >> +{
> >> +     u32 sta;
> >> +     int i;
> >> +
> >> +     for (i = 0; i < 10; i++) {
> >> +             sta = readl(i2c_dev->base + SSC_STA);
> >> +             if (!(sta & SSC_STA_BUSY))
> >> +                     return 0;
> >> +
> >> +             usleep_range(2000, 4000);
> > can not use interrupt?
> Sadly, no.
> There is no interrupt linked to the busy bit.
> >> +     }
> >> +
> ...
> >> +
> >> +static struct of_device_id st_i2c_match[] = {
> >> +     { .compatible = "st,comms-ssc-i2c", },
> > the rules is to put the first soc that use the ip in the compatible
> > as st,sti7100-scc-i2c
> Ok. There are no plans to upstream the SH4 platforms, it will only 
> remains in stlinux.com.
> Maybe I can set the first ARM platform (STiH415)?
> That would give st,stih415-ssc-i2c.

no you need to put the first soc even not mainline dt is not relaated to linux
mainline of not we describe hw

IIRC it was even present before sh4, on st200 IIRC need to check my old
datasheet

Best Regards,
J.
> 
> Thanks for the review,
> Maxime
> 
> >
> > Best Regards,
> > J.
