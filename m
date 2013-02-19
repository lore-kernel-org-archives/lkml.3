Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab3BSDkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 22:40:17 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:52578 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933Ab3BSDkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 22:40:16 -0500
Date: Tue, 19 Feb 2013 09:09:31 +0530
From: Afzal Mohammed <afzal.mohd.ma@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Question about fixed-clock
Message-ID: <20130219033931.GA2479@afzal-ThinkPad-R50e>
References: <5122BF88.1050007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5122BF88.1050007@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, Feb 19, 2013 at 12:55:52AM +0100, Daniel Mack wrote:

> 	ref25: ref25M {
> 		compatible = "fixed-clock";
> 		#clock-cells = <0>;
> 		clock-frequency = <25000000>;
> 	};
> 
> 	clock-generator@0 {
> 				/* ... */
> 				#clock-cells = <1>;
> 				clocks = <&ref25>;
> 	}
> 
> The device driver for clock-generator uses something like the following
> call to get its clock:
> 
> 	clk = of_clk_get(np, 0);
> 
> but the return value is ERR_PTR(-ENOENT) and I also can't find this
> clock in the clk debugfs tree.

Hope invoking of_clk_init before clock generator driver helps

Regards
Afzal
