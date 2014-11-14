Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965621AbaKNNed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:34:33 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61908 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965282AbaKNNea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:34:30 -0500
Date: Fri, 14 Nov 2014 13:34:25 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        srinivas.kandagatla@gmail.com, patrice.chotard@st.com,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        maxime.coquelin@st.com
Subject: Re: [PATCH v2 13/14] ARM: STi: DT: STiH410: Add usb2 picophy dt nodes
Message-ID: <20141114133425.GA28680@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
 <2401196.5cvW5dPSz2@wuerfel>
 <20141114095621.GA1648@griffinp-ThinkPad-X1-Carbon-2nd>
 <1546892.RCPeXgVQNJ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546892.RCPeXgVQNJ@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for taking the time to explain this.

On Fri, 14 Nov 2014, Arnd Bergmann wrote:
<snip>
> > address of the device's resources within the address space defined by its parent bus").
> 
> You will also have to add an appropriate 'ranges' property then.
> 
> > Or maybe you meant, if I want to keep the picophy node where it is (under soc), I need to stop using the reg
> > property?
> 
> That would also be possible, just put the register numbers into your 'st,syscfg'
> property after the phandle, and leave the reg property empty then.

I think this is the best approach and whay I will do, as it would also extend well to devices with sysconfig
registers in different banks.
> 
> > The other problem I was describing is a device with some memory mapped registers and some
> > sysconfig registers you can find examples already upstream in stih416.dtsi file with the
> > ethernet0 and miphy365x_phy nodes.
> > 
> > Here the first 1/2 reg properties are expressed as a 32 bit physical address and size (meets the spec definition),
> > and the last is expressed as a sysconfig offset and size (which AFAIK doesn't match the spec definition).
> > This change in address space is however documented in the bindings documentation.
> > 
> > How should devices which have multiple address spaces ideally be handled?
> 
> There should at most be one 'reg' address space, so put it under the node whose
> bus these refer to. Put all offsets that are relative to a syscon link into
> the phandle that refers to the syscon device, or hardcode the offsets in the
> driver.

Ok makes sense.
> 
> > From looking around in the source I see a few different ways people have done this: -
> > 
> > 1) Some drivers encode the data statically into the source and make a decision based on compatible string.
> > 2) Some drivers add a couple of extra dt properties to encode the offset (spifsm in stih416)
> > 3) Some drivers mix address spaces in the reg properties (examples given above) 
> > 3) Probably some other ways I've not found yet
> >
> > Is there a blessed way of doing this? It would be nice at least for all the drivers in STI to be doing
> > it the same as currently there seems to be a mix of implementations.
> 
> You can do 1 or 2, not 3.

Yep got it.

One last question, what are the rules about updating ethernet and miphy365 over to using this method for there sysconfig registers? 

regards,

Peter.
