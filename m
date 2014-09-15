Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbaIOWlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:41:42 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60254 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbaIOWlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:41:39 -0400
Date: Tue, 16 Sep 2014 08:37:22 +1000
From: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
        linux-cris-kernel@axis.com, Jesper Nilsson <jespern@axis.com>,
        Mikael Starvik <starvik@axis.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: Status of 'cris' architecture support in Linux kernel
Message-ID: <20140915223722.GI16081@toto>
References: <20140831175010.GA15408@roeck-us.net>
 <20140915145203.GK4659@axis.com>
 <20140915195514.GC18175@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915195514.GC18175@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Mon, Sep 15, 2014 at 12:55:14PM -0700, Guenter Roeck wrote:
> On Mon, Sep 15, 2014 at 04:52:03PM +0200, Jesper Nilsson wrote:
> > Hi Guenter,
> > 
> > Sorry for not answering earlier, like some have said in
> > the thread followups, I have been on parental leave for quite some time.
> > 
> > On Sun, Aug 31, 2014 at 10:50:10AM -0700, Guenter Roeck wrote:
> > > The idea was to create a crisv32 kernel and initramfs to work with qemu
> > > for the ongoing Linux kernel test project.
> > 
> > A very ambitious goal. :-)
> > 
> > > After spending a number of days (and nights) on it, the results don't look
> > > very encouraging.
> > > 
> > > My overall conclusion is that 'cris' architecture support in the Linux kernel
> > > is in bad shape, does not work anymore, and would require substantial effort
> > > to get it into working state.
> > 
> > Your conclusion is not completely off, but it could be better than it looks. :-)
> > 
> > I'll try to explain the state of the CRIS port as it currently stands:
> > 
> > (Background: CRIS port supports 3 different SoC:s, where the CRISv10 is
> > older and subsequently less used. The other two are ETRAX FS and ARTPEC-3,
> > which in principle share the same CPU-core (CRISv32) but contain some changes to
> > the peripheral hardware IPs)
> > 
> > CRISv10 is only supported by me as a hobby project, AXIS does not have any
> > current shipping units with this SoC, thus support for this is waning fast.
> > QEMU support is not available for this SoC.
> > Additionally, newer gcc assumes TLS support, which CRISv10 does not have,
> > and older gcc:s yields an ICE (internal compiler error) on newer kernels.
> > 
> > Units with ETRAX FS is no longer actively upgraded by AXIS with newer kernels,
> > and I have a problem testing anything other than the AXIS 88 developer board
> > (Last relase of the SDK was a couple of years ago with the 2.6.32 kernel IIRC)
> > which is not up to date, but at least have a lot in common with ARTPEC-3 and
> > so is not so hard to support.
> > 
> > ARTPEC-3 support is not complete as some drivers are not included in upstream
> > (ethernet and serial are the most notable ones) but is actually in best shape,
> > we have 3.16 booting on real hardware in house.
> > 
> > I'll add the missing drivers and current patches we have locally to a
> > git tree on git-hub, I'll get back to you on that.
> > 
> Would be great.
> 
> > It is also the ARTPEC-3 SoC that is implemented in QEMU unless I'm mistaken.
> > 
> The only machine supported in qemu is axis-88.
> 
> qemu-system-cris -M ?
> Supported machines are:
> none                 empty machine
> axis-dev88           AXIS devboard 88 (default)
> 
> Does that include or imply ARTPEC-3 ?

The machine/board available in upstream QEMU is an ETRAX-FS based one.

I might still have the kernel sources for the image on the QEMU wiki around.
Will see if I can find the code and let you know.

Would be awesome if we could get a simple console driver for the ETRAX-FS
upstream to at least have the kernel booting to a prompt on QEMU.

Cheers,
Edgar
