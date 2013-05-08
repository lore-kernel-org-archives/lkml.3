Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3EHOpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:45:34 -0400
Received: from mo3.mail-out.ovh.net ([178.32.228.3]:54319 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab3EHOpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:45:32 -0400
Date: Wed, 8 May 2013 16:39:08 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        linux-doc@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will.deacon@arm.com>, jslaby@suse.cz,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        linux-serial@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Message-ID: <20130508143908.GJ24282@game.jcrosoft.org>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <1368022248-2153-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081634.43498.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305081634.43498.arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7246573276538972932
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:34 Wed 08 May     , Arnd Bergmann wrote:
> On Wednesday 08 May 2013, Srinivas KANDAGATLA wrote:
> > From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> > +*st-asc(Serial Port)
> > +
> > +Required properties:
> > +- compatible : Should be "st,asc".
> 
> Are there any hardware revision numbers for the asc? If there are potentially
> incompatible or backwards-compatible variants, it would be good to include
> the version in this string.

The st,asc come from st20 or st200 IIRC which was not ARM but a ST arch
and then used on st40 series

an the st,asc for st200 and st40 are not compatible completly
> 
> > +- reg, reg-names, interrupts, interrupt-names	: Standard way to define device
> > +			resources with names. look in
> > +			Documentation/devicetree/bindings/resource-names.txt
> > +
> > +Optional properties:
> > +- st,hw-flow-ctrl	bool flag to enable hardware flow control.
> > +- st,force-m1		bool flat to force asc to be in Mode-1 recommeded
> > +			for high bit rates (above 19.2K)
> > +Example:
> > +serial@fe440000{
> > +    compatible    = "st,asc";
> > +    reg         = <0xfe440000 0x2c>;
> > +    interrupts     =  <0 209 0>;
> > +};
> 
> I would also recommed adding a way to set the default baud rate through
> a property. Following the example of the 8250 driver, you should probably
> call that "current-speed".
on st it has always be 38k

> 
> > diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> > index 7e7006f..346f325 100644
> > --- a/drivers/tty/serial/Kconfig
> > +++ b/drivers/tty/serial/Kconfig
> > @@ -1484,6 +1484,25 @@ config SERIAL_RP2_NR_UARTS
> >  	  If multiple cards are present, the default limit of 32 ports may
> >  	  need to be increased.
> >  
> > +config SERIAL_ST_ASC
> > +	tristate "ST ASC serial port support"
> > +	depends on PLAT_STIXXXX
> > +	default y
> > +	select SERIAL_CORE
> > +	help
> > +	  This driver is for the on-chip Asychronous Serial Controller on
> > +	  STMicroelectronics STixxxx SoCs.
> > +	  ASC is embedded in ST COMMS IP block. It supports Rx & Tx functionality.
> > +	  It support all industry standard baud rates.
> > +
> > +	  If unsure, say N.
> 
> I would not make it "default y".
me too
> 
> > +config SERIAL_ST_ASC_CONSOLE
> > +	bool "Support for console on ST ASC"
> > +	depends on SERIAL_ST_ASC
> > +	default y
> > +	select SERIAL_CORE_CONSOLE
> > +
> >  endmenu
> 
> This needs to be "depends on SERIAL_ST_ASC=y". You would get a link error
> if you try to make SERIAL_ST_ASC a loadable module and SERIAL_ST_ASC_CONSOLE
> built-in.
> 
> > +
> > +static struct asc_port asc_ports[ASC_MAX_PORTS];
> > +static struct uart_driver asc_uart_driver;
> > +
> > +/*---- Forward function declarations---------------------------*/
> > +static irqreturn_t asc_interrupt(int irq, void *ptr);
> > +static void asc_transmit_chars(struct uart_port *);
> > +static int asc_set_baud(struct asc_port *ascport, int baud);
> > +
> 
> Please remove all forward declarations, by reordering the functions in
> the way they are called.
> 
and drop the dummy functions
> 
> > diff --git a/drivers/tty/serial/st-asc.h b/drivers/tty/serial/st-asc.h
> > new file mode 100644
> > index 0000000..e59f818
> > --- /dev/null
> > +++ b/drivers/tty/serial/st-asc.h
> > +#ifndef _ST_ASC_H
> > +#define _ST_ASC_H
> > +
> > +#include <linux/serial_core.h>
> > +#include <linux/clk.h>
> > +
> > +struct asc_port {
> > +	struct uart_port port;
> > +	struct clk *clk;
> > +	unsigned int hw_flow_control:1;
> > +	unsigned int check_parity:1;
> > +	unsigned int force_m1:1;
> > +};
> 
> Since this header file is only used in one place, just merge it into
> the driver itself.
> 
> > +#define ASC_MAJOR		204
> > +#define ASC_MINOR_START		40
> 
> I don't know what the current policy is on allocating major/minor numbers,
> but I'm sure you cannot just reuse one that is already used.
> 
> Documentation/devices.txt lists the ones that are officially assigned.
> Can't you use dynamic allocation here?
> 
> 	Arnd
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
