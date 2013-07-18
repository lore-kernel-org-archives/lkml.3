Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab3GROzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 10:55:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56279 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074Ab3GROzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 10:55:19 -0400
Message-ID: <51E801C9.60609@ti.com>
Date: Thu, 18 Jul 2013 20:25:05 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com> <1374141687-10790-3-git-send-email-sourav.poddar@ti.com> <20130718104233.GG22506@sirena.org.uk> <51E7D569.2010709@ti.com> <20130718131822.GN22506@sirena.org.uk> <20130718133158.GA1628@arwen.pp.htv.fi> <20130718144241.GO22506@sirena.org.uk>
In-Reply-To: <20130718144241.GO22506@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
On Thursday 18 July 2013 08:12 PM, Mark Brown wrote:
> On Thu, Jul 18, 2013 at 04:31:58PM +0300, Felipe Balbi wrote:
>> On Thu, Jul 18, 2013 at 02:18:22PM +0100, Mark Brown wrote:
>>> So why do we report that we handled the interrupt then?  Shouldn't we at
>>> least warn if we're getting spurious IRQs?
>> not spurious. OMAP has two sets of IRQ status registers. One is call
>> IRQSTATUS$n (n = 0, 1, ...) and IRQSTATUS_RAW$n.
>> IRQSTATUS$n will only enable the bits which fired IRQs and aren't
>> masked while IRQSTATUS_RAW$n will also enable the bits which are masked.
>> I could never come up with a use case where we would need to handle IRQs
>> which we decided to mask, but perhaps there might be some cases, I don't
>> know.
>> Based on that, I believe Sourav is reading IRQSTATUS_RAW$n, then he need
>> to clear the masked bits.
> That's not the issue - the issue is that if none of the unmasked
> interrupts are being asserted we shouldn't be in the interrupt handler
> in the first place but the driver silently accepts that and reports that
> it handled the interrupt.
I believe this is what you hinted at doing..

there is a QSPI_INTR_STATUS_ENABLED_CLEAR register, which indicated the 
interrupt
status.
if nothing is set in the above register, I should return IRQ_NONE.
