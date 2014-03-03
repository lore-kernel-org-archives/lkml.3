Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaCCRgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 12:36:05 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:57546
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbaCCRgC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 12:36:02 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(z551biz98dIc89bh936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh906i1155h)
Date: Mon, 3 Mar 2014 09:35:43 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Gerhard Sittig <gsi@denx.de>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michal Simek <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 0/3] clk: CCF clock primitives + custom IO accessors
References: <1393630495-29689-1-git-send-email-soren.brinkmann@xilinx.com>
 <20140302202940.GQ3327@book.gsilab.sittig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140302202940.GQ3327@book.gsilab.sittig.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <19206d89-cd0d-4fea-9170-3fd0a8482bf5@VA3EHSMHS045.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-02 at 09:29PM +0100, Gerhard Sittig wrote:
> On Fri, Feb 28, 2014 at 15:34 -0800, Soren Brinkmann wrote:
> > 
> > [ MMIO registers assumed for clock control modules, but I2C
> > communication may be involved in other hardware, individual for
> > a (set of) clock(s) and not for an architecture or platform ]
> > 
> > Does anybody have a good idea how we could avoid all this code
> > duplication while enabling usage of the clock primitives with different
> > IO accessors?
> > Especially the divider and mux primitive have a lot of code that would
> > be painful to maintain twice.
> 
> Hasn't past discussion already reached the point where code
> duplication of the clock control logic was considered
> undesirable, and "low level ops" were outlined?  I.e. extending
> the compile time decision for a specific clk_{read,write}l()
> implementation by another potential redirection that is specific
> to a clock item?
> 
> Re-submitting a series which duplicates complete clock types,
> while the difference is only in how registers get accessed, is
> quite saddening.
I'm not really planning to submit this as is. I'm hoping to get some
input on how to resolve this properly. I know this is a big mess, but I
also don't see the way out (yet).

> 
> 
> > In the next step, I encountered a divider clock whose divider is stored
> > in 2 I2C registers. So now, the simple IO access replacement doesn't
> > work anymore either since this clock needs 2 registers to be read and
> > then shifting around the bitfields accordingly.
> 
> Are the registers adjacent and contain only bit fields for one
> clock?  Or do registers share parameters for several clocks, or
> are not adjacent?
> 
> In the former case you may use a table from "divider value" to
> "bit pattern to read/write".  In the latter case, the clock
> control module is rather special, and may not be easily get
> mapped to the common primitives.  Unless the ll_ops can implement
> the required special handling.
It would be nice if we could use the logic provided in the mux, div etc
primitives independently of how the HW is accessed and what is
necessary to shift and mask those register values around, right? I
mean, at then end we want to model a clk-(div|mux) and not a
clk-(div|mux) which has only a single, memory-mapped control register,
that does not overlap with other things, ...

	Sören


