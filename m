Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3CFR14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:27:56 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:32960
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866Ab3CFR1z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:27:55 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz98dIc89bh936eI1432I1519Mzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah906i1155h)
Date: Wed, 6 Mar 2013 09:27:46 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Jan =?utf-8?B?TMO8YmJl?= <jlu@pengutronix.de>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <git@xilinx.com>
Subject: Re: RFC: Zynq Clock Controller
References: <37032699-343e-485c-80e0-9b23e3706c58@VA3EHSMHS013.ehs.local>
 <1362570681.5269.98.camel@coredoba.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1362570681.5269.98.camel@coredoba.hi.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 06 Mar 2013 17:27:47.0962 (UTC) FILETIME=[EBD5B5A0:01CE1A8F]
X-RCIS-Action: ALLOW
Message-ID: <f288874c-d0ae-4581-8d0f-2b9abe4d3117@CO9EHSMHS002.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,
 
what a small world. Good to hear from you.

On Wed, Mar 06, 2013 at 12:51:21PM +0100, Jan Lübbe wrote:
> Hi Sören,
> 
> On Tue, 2013-03-05 at 12:04 -0800, Sören Brinkmann wrote:
> > For this reasons, I'd like to propose moving Zynq into the same
> > direction. I.e. adding a clock controller with the following DT
> > description (details may change but the general idea should become
> > clear):
> > 	clkc: clkc {
> >                 #clock-cells = <1>;
> >                 compatible = "xlnx,ps7-clkc";
> >                 ps_clk_frequency = <33333333>;	# board x-tal
> >                 # optional props
> >                 gem0_emio_clk_freq = <125000000>;
> >                 gem1_emio_clk_freq = <50000000>;
> >                 can_mio_clk_freq_xx = <1234>; # this is possible 54 times with xx = 00..53
> >         };
> 
> The clock controller should only contain properties for input frequency
> (which can obviously not be calculated at run-time).
> 
> Are the gem*, can* properties inputs? If they are actually outputs, the
> corresponding frequencies should be requested by the clock consumers and
> not hard-coded in DT.
They are inputs. GEM and CAN have the option to be clocked through (E)MIO pins, i.e. some external clock input which cannot be derived from ps_clk like all other clocks. I plan to register a fixed rate, root clock for each of those properties, if present.

> 
> Please keep in mind that DT properties use dashes instead of
> underscores.
Okay, I'll make that substitution.

	Sören


