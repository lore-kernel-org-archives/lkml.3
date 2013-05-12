Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab3ELTFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 15:05:13 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:32377 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174Ab3ELTFL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 15:05:11 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIc89bh1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh906i1155h)
Date: Sun, 12 May 2013 12:05:04 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mark Brown <broonie@kernel.org>
CC: Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com>
 <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
 <20130510212422.GY3200@sirena.org.uk>
 <7e18bed3-ae6b-4aa0-bf23-b6c61ba8b85b@CO9EHSMHS030.ehs.local>
 <20130512143344.GC3200@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130512143344.GC3200@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <9e55c552-ce34-4663-9a57-bf2c626d7d58@TX2EHSMHS008.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 06:33:44PM +0400, Mark Brown wrote:
> On Sat, May 11, 2013 at 09:54:22AM -0700, Sören Brinkmann wrote:
> > On Fri, May 10, 2013 at 10:24:22PM +0100, Mark Brown wrote:
> 
> > > For your use case should these things be exposed by the FPGA device
> > > asking for that rather than by having the clocks available separately?
> > > Or is this part of the DT blob that's loaded incrementally along with
> > > the FPGA (which does make things more interesting of course...).
> 
> > Here may be some misunderstanding.
> > The clocks are not in the FPGA. The clocks are always there and part of
> > the processing system (PS), they are just routed to the FPGA where they
> > can be used as clocks for the FPGA design.
> 
> No, there's no confusion here - the clocks that are being exposed to
> userspace are the clocks which enter the FPGA.  The driver or whatever
> that understands the FPGA can do what is needed to control them,
> including routing them on to subdevices it instantiates or exposing them
> to userspace.
Such a driver does not exist in general.
For some IP cores, Linux drivers do exist and then
they are supposed to directly use the CCF, IMHO, no need to expose
things to userspace in that case.
I'm trying to cover cases, in which there is no driver available/needed for
the FPGA design, other than some simple clock controls.

As simple example, if you wrote your own HW blinken lights design, you
wouldn't have nor need a Linux driver for it, but if you used these
clocks as inputs you could change the blinking speed by adjusting the
frequency.

	Sören


