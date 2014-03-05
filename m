Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbaCESWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:22:55 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:4458 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221AbaCESWx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:22:53 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z551biz98dIc89bh936eI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h906i1155h)
Date: Wed, 5 Mar 2014 10:22:05 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-serial@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH RFC 3/6] tty: Rename xilinx_uart -> cadence_uart
References: <1393953449-28551-1-git-send-email-soren.brinkmann@xilinx.com>
 <1393953449-28551-4-git-send-email-soren.brinkmann@xilinx.com>
 <20140304193913.71c6f307@alan.etchedpixels.co.uk>
 <201403042316.26221.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <201403042316.26221.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <0c95ba9c-30bd-4fb2-ae44-e0e3e4553e84@CO9EHSMHS018.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd, Alan,

On Tue, 2014-03-04 at 11:16PM +0100, Arnd Bergmann wrote:
> On Tuesday 04 March 2014, One Thousand Gnomes wrote:
> > On Tue,  4 Mar 2014 09:17:26 -0800
> > Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> 
> > The following aspects of the change set are IMHO acceptable
> > 
> > - Cleaning up all the code formatting
> > - Update the driver comments and header to explain the Cadence/Xilinx
> >   thing
> > - change "Xilinx PS UART Support" text to "Cadence (Xilinx PS) Support"
> >   or similar wording in Kconfig
> > - Adding the cadence devicetree compatibility strings and inputs *in
> >   addition* to the existing ones.
> > - Documentation for the new options
> 
> I agree. I think it would also be nice to allow the standard clock names
> to be used as an alternative to the bogus ref_clk" and "aper_clk"
> names, but just like the compatible string, it's too late to remove
> support for the existing ones.
> 
> Regarding the "xlnx,xuartps" compatible string, even if we were to break
> backwards comptibility with the clocks, I would still want to see this
> string being used in addition to "cdns,uart-r1p8" so we have a way to
> detect possible changes that xilinx did on top of the r1p8 version.
> I also wonder if "cdns,uart-r1p8" is actually specific enough: r1p8
> looks like a version number rather than a name, and it seems possible
> that Cadence has produced more than one uart implemention in the past
> or will do another one in the future that is not just a different
> revision of this one but instead something completely different.

This was pretty much what I expected, but I wanted to at least try,
before documenting the binding.

So, to summarize:
 - don't rename the file
 - I think changing the Kconfig option might be possible, but doesn't
   really matter either. So, I'll leave it as is.
 - compat strings is the easy part, we can simple add another one
 - clock-names is not that forgiving. I'm inclined to document only the
   Cadence names, but allow both with issuing a deprecated warning when
   the Zynq ones are used. Then we can remove those probably a little
   later(?)
 - I'll do something like Alan's suggestion for the Kconfig prompt

Regarding how specific we can make the compat string: I asked myself the
same question when I looked at the docs. But they don't seem to use any
fancy names or anything. It's pretty much just a UART. The other problem
I have is, I'd have to double check what information, beyond what already
is in the Zynq TRM, is allowed to be disclosed.

	Thanks,
	Sören


