Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab3G2Ov1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:51:27 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48492 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756919Ab3G2Ov0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:51:26 -0400
Date: Mon, 29 Jul 2013 11:51:30 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 3/5] ARM: dove: add MBus DT node
Message-ID: <20130729145129.GD2417@localhost>
References: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1375101114-28858-4-git-send-email-sebastian.hesselbarth@gmail.com>
 <51F661DE.1070106@gmail.com>
 <20130729135227.GA2417@localhost>
 <51F67AD8.1070904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51F67AD8.1070904@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 04:23:20PM +0200, Sebastian Hesselbarth wrote:
> On 07/29/2013 03:52 PM, Ezequiel Garcia wrote:
> > Hi Sebastian,
> >
> > (Ccing devicetree ML)
> >
> > On Mon, Jul 29, 2013 at 02:36:46PM +0200, Sebastian Hesselbarth wrote:
> >> On 07/29/2013 02:31 PM, Sebastian Hesselbarth wrote:
> >>> This adds a MBus node including ranges and pcie apertures required later.
> >>>
> >>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> >>> ---
> >>>    arch/arm/boot/dts/dove.dtsi |   19 +++++++++++++++++++
> >>>    1 file changed, 19 insertions(+)
> >>>
> >>> diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
> >>> index 397674c..bdda016 100644
> >>> --- a/arch/arm/boot/dts/dove.dtsi
> >>> +++ b/arch/arm/boot/dts/dove.dtsi
> >>> @@ -29,6 +29,20 @@
> >>>    		marvell,tauros2-cache-features = <0>;
> >>>    	};
> >>>
> >>> +	mbus {
> >>> +		compatible = "marvell,dove-mbus", "marvell,mbus", "simple-bus";
> >>> +		#address-cells = <2>;
> >>> +		#size-cells = <1>;
> >>> +		pcie-mem-aperture = <0xe0000000 0x10000000>; /* 256M MEM space */
> >>> +		pcie-io-aperture  = <0xf2000000 0x00200000>; /*   2M I/O space */
> >>
> >> Actually, current v9 of the mbus patch set still requires "controller"
> >> property to match the corresponding controller node. I had a short
> >> discussion with Ezequiel to possibly just use of_find_compatible_node
> >> and blindly assumed post-v8 will already use it.
> >
> > Ah, regarding this: despite your good arguin against the 'controller' property approach,
> > I still feel a bit inclined for it, as I like the way it tightly-binds the two nodes.
> 
> I understand that the phandle property *shows* you that both are
> related. But with DT you should always ask for every property, if
> (a) it is really required to do the job and (b) does it really
> describe the HW or just your SW needs/wishes.
> 

I see and I understand your point. For some reason it still feels
a bit dirty to set this kind of compatible nodes requirement (one
node simply requiring another node).

I would hate to set a precedent for a dirty solution...

Maybe the DT maintainers can shed some light on this?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
