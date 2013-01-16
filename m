Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3APPGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:06:17 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46311 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab3APPGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:06:14 -0500
Message-ID: <50F6C1CD.7020001@ti.com>
Date: Wed, 16 Jan 2013 17:05:49 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <sshtylyov@mvista.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>, <bjorn@mork.no>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 04/22] mfd: omap-usb-tll: Clean up clock handling
References: <1358347433-329-1-git-send-email-rogerq@ti.com> <1358347433-329-5-git-send-email-rogerq@ti.com> <20130116145530.GU23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130116145530.GU23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 04:55 PM, Russell King - ARM Linux wrote:
> On Wed, Jan 16, 2013 at 04:43:35PM +0200, Roger Quadros wrote:
>> +	spin_lock_irqsave(&tll->lock, flags);
>> +
>> +	for (i = 0; i < tll->nch; i++) {
>> +		char clkname[] = "usb_tll_hs_usb_chx_clk";
>> +		struct clk *fck;
>> +
>> +		snprintf(clkname, sizeof(clkname),
>> +					"usb_tll_hs_usb_ch%d_clk", i);
>> +		fck = clk_get(dev, clkname);
> 
> NAK.  Why are you doing this under a spinlock?
> 
> clk_get() takes a mutex.  You must not be in an atomic region (iow, you
> must not be holding a spinlock, and you must not have IRQs disabled)
> when you call clk_get().
> 
Right. Good catch :).

--
cheers,
-roger.
