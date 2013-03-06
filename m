Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab3CFLui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:50:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49218 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab3CFLuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:50:37 -0500
Message-ID: <1362570681.5269.98.camel@coredoba.hi.pengutronix.de>
Subject: Re: RFC: Zynq Clock Controller
From: Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
To: =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc: Mike Turquette <mturquette@linaro.org>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, git@xilinx.com
Date: Wed, 06 Mar 2013 12:51:21 +0100
In-Reply-To: <37032699-343e-485c-80e0-9b23e3706c58@VA3EHSMHS013.ehs.local>
References: <37032699-343e-485c-80e0-9b23e3706c58@VA3EHSMHS013.ehs.local>
Organization: Pengutronix
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:99ff:fe56:8d7
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sören,

On Tue, 2013-03-05 at 12:04 -0800, Sören Brinkmann wrote:
> For this reasons, I'd like to propose moving Zynq into the same
> direction. I.e. adding a clock controller with the following DT
> description (details may change but the general idea should become
> clear):
> 	clkc: clkc {
>                 #clock-cells = <1>;
>                 compatible = "xlnx,ps7-clkc";
>                 ps_clk_frequency = <33333333>;	# board x-tal
>                 # optional props
>                 gem0_emio_clk_freq = <125000000>;
>                 gem1_emio_clk_freq = <50000000>;
>                 can_mio_clk_freq_xx = <1234>; # this is possible 54 times with xx = 00..53
>         };

The clock controller should only contain properties for input frequency
(which can obviously not be calculated at run-time).

Are the gem*, can* properties inputs? If they are actually outputs, the
corresponding frequencies should be requested by the clock consumers and
not hard-coded in DT.

Please keep in mind that DT properties use dashes instead of
underscores.

Best regards,
Jan
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

