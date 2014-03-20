Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbaCTN0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:26:49 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60730 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755353AbaCTN0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:26:47 -0400
Date: Thu, 20 Mar 2014 13:26:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: tda998x: Fix lack of required reg in DT
	documentation
Message-ID: <20140320132633.GT7528@n2100.arm.linux.org.uk>
References: <20140320092639.48F68A6279@smtp3-g21.free.fr> <532ADFD8.80301@gmail.com> <20140320140156.5d768b1f@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140320140156.5d768b1f@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 02:01:56PM +0100, Jean-Francois Moine wrote:
> On Thu, 20 Mar 2014 13:32:24 +0100
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
> 
> > > +  - reg: I2C address - must be <0x70>  
> > 
> > TDA9983b datasheet says:
> > 
> > "Bits A0 and A1 of the I2C-bus device address are externally selected
> > by pins A0 and A1."
> > 
> > Therefore, 0x70, 0x71, 0x72, and 0x73 are valid i2c addresses.
> 
> Sebastian,
> 
> That's interesting!
> 
> For the Cubox and the AMX33XX boards, the I2C address of the HDMI
> registers is 0x70, and the I2C address of the CEC registers is 0x34.
> 
> For other boards using the TDA998x family, if the I2C address is
> different from 0x70, have you an idea about what can be the CEC I2C
> address? (this value is actually hard-coded in the TDA998x driver)

For the TDA9983, it's configurable as Sebastian says.  For the TDA19988,
they're fixed at 0x70 and 0x34.

To put it another way: it is chip specific, and is specified by the
data sheet, not by the software, and should not be specified as an
"required value" with any particular value in the DT binding
specification.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
