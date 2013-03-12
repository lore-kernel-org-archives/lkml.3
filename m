Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab3CLOBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:01:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51533 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3CLOBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:01:32 -0400
Message-ID: <513F352B.3050608@ti.com>
Date: Tue, 12 Mar 2013 16:01:15 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 23/24] ARM: OMAP2+: Allow clock alias provision from device
 tree
References: <1363088606-2692-1-git-send-email-rogerq@ti.com> <1363088606-2692-24-git-send-email-rogerq@ti.com> <513F2AEB.8070702@ti.com>
In-Reply-To: <513F2AEB.8070702@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On 03/12/2013 03:17 PM, Benoit Cousson wrote:
> Hi Roger,
> 
> On 03/12/2013 12:43 PM, Roger Quadros wrote:
>> Currently on OMAP, it is not possible to specify a clock consumer
>> to any of the OMAP generated clocks using the device tree. This can pose
>> a problem for external devices that run off an OMAP clock as we
>> can't reliably provide a reference to the clock in the device tree.
> 
> I'm really confused by that statement... Why cannot you use the current
> clock binding definition?
> 
> The point is that we should avoid defining temporary custom bindings.
> Especially when a generic one already exist.
> 
> I know you already discussed that on the list, but I cannot really find
> the rational in the previous thread.
> 
> Here is a quote from the original "Subject: Re: how to specify an OMAP
> clock in device tree?" thread.
> 
>> /* provider */
>> clks: omapclocks {
>>         compatible = "ti,omapclocks";
>>         #clock-cells = <1>;
>> };
>>
>> /* consumer */
>> hsusb1_phy: hsusb1_phy {
>> 	compatible = "usb-nop-xceiv";
>> 	clocks = <&clks "auxclk3_ck">;	/* FREF_CLK3 */
>> 	clock-names = "main-clk";
>> };
>>
>> The only problem I see is that the argument to the clks phandle
>> cannot be a string. It needs to be u32.
>>
>> In that case we need to map all clocks into a u32 index.
>>
>> If we can do that only for auxclks, my problem is solved for panda.
> 
> phandle is u32 as always, but you should not care about that.
> What you care about is the clock node referenced by the phandle, not the
> phandle itself.
> 
> What is missing right now is a proper of_clk_add_provider call to
> declare a generic OMAP clock provider and thus allow OMAP clocks to be
> used with DT.
> 
> The AUXCLOCKs are managed by the SCRM which is outside the PRCM, so you
> should be able to add a clock providers dedicated to the SCRM clocks only.

Okay, I will convert at least the SCRM clocks to be provided by device tree.

Tony,

Please drop this patch and patch 24. The rest should be fine.
Just that Panda EHCI won't work till we have the PHY clock correctly
provided.

cheers,
-roger
