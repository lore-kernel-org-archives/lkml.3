Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3GYAak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 20:30:40 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:52298 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3GYAai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 20:30:38 -0400
Date: Thu, 25 Jul 2013 03:30:30 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Daniel Mack <zonque@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: v3.11-rc1 USB regressions
Message-ID: <20130725003029.GD26943@blackmetal.musicnaut.iki.fi>
References: <20130715225647.GE3296@blackmetal.musicnaut.iki.fi>
 <51E4E922.2040707@gmail.com>
 <20130716175710.GA14385@blackmetal.musicnaut.iki.fi>
 <20130724185119.GB26943@blackmetal.musicnaut.iki.fi>
 <51F0253C.7090205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F0253C.7090205@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 24, 2013 at 09:04:28PM +0200, Daniel Mack wrote:
> On 24.07.2013 20:51, Aaro Koskinen wrote:
> >> When I revert fe4cb0912f8e737f8e4b8b38b9e692f8062f5423 and
> >> 8b125df5b24cfb0ec7fa1971e343cc0badc1827d, it works like before (3.10):
> > 
> > I'm now running -rc2 with above fixes and reverts (the only way to get
> > USB working). I'm seeing an additional issue, the following crash happens
> > always on N900 when doing "poweroff":
> 
> Yes, with the mentioned patches reverted, musb_to_hcd() will return a
> faulty pointer. You can't easily revert them unfortunately.
> 
> Your platform needs a real fix, I just have trouble understanding why a
> removed usb_add_hcd() would make the gadget code fail.
> 
> Sorry for the trouble, but I don't currently have a board with musb in
> gadget mode to reproduce this issue.

If you have any ideas what to look for, I can maybe try to debug this
issue.

Below are some logs with additional DEBUGs enabled.

Broken:

[    4.111480] udc musb-hdrc.0.auto: registering UDC driver [g_ether]
[    4.136962] using random self ethernet address
[    4.144134] using random host ethernet address
[    4.151000] g_ether gadget: adding config #1 'CDC Ethernet (ECM)'/bf03f2c0
[    4.160552] g_ether gadget: adding 'cdc_ethernet'/cef92e40 to config 'CDC Ethernet (ECM)'/bf03f2c0
[    4.186828] usb0: HOST MAC f6:4a:86:02:5d:ec
[    4.193939] usb0: MAC 26:e9:7c:49:4a:2e
[    4.200256] g_ether gadget: CDC Ethernet: dual speed IN/ep1in OUT/ep1out NOTIFY/ep2in
[    4.210906] g_ether gadget: cfg 1/bf03f2c0 speeds: high full
[    4.219207] g_ether gadget:   interface 0 = cdc_ethernet/cef92e40
[    4.227874] g_ether gadget:   interface 1 = cdc_ethernet/cef92e40
[    4.236480] g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
[    4.245635] g_ether gadget: g_ether ready
[    4.261627] twl4030_usb twl4030_usb: twl4030_phy_resume
[    4.281433] usb0: eth_open
[    4.560974] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb000d tx0001 rx0000
[    4.570983] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0xd
[    4.579681] musb-hdrc musb-hdrc.0.auto: SUSPEND (b_idle) devctl 99
[    4.588378] musb-hdrc musb-hdrc.0.auto: BUS RESET as b_peripheral
[    4.596984] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55df0
[    4.607055] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 18 buf cef1a000
[    4.617248] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    4.627044] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    4.728790] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb000c tx0001 rx0000
[    4.738616] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0xc
[    4.747222] musb-hdrc musb-hdrc.0.auto: BUS RESET as b_peripheral
[    4.755645] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55df0
[    4.765533] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    4.775207] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    4.784637] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    4.794281] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    4.802703] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55df0
[    4.812500] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 18 buf cef1a000
[    4.822509] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    4.832153] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    4.840576] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55dd0
[    4.850372] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 9 buf cef1a000
[    4.860198] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    4.869781] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    4.878112] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55ce8
[    4.887847] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 64 buf cef1a000
[    4.897674] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    4.907257] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    4.915588] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 24 buf cef1a040
[    4.925506] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    4.935089] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    4.943450] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55ce8
[    4.953247] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 4 buf cef1a000
[    4.963012] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    4.972595] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    4.980926] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55ce8
[    4.990692] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 32 buf cef1a000
[    5.000549] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.010101] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.018432] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55ce8
[    5.028167] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 64 buf cef1a000
[    5.038024] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.047576] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.055908] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 52 buf cef1a040
[    5.065765] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.075378] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.083740] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55ce8
[    5.093536] g_ether gadget: high-speed config #1: CDC Ethernet (ECM)
[    5.102172] g_ether gadget: init ecm
[    5.107818] g_ether gadget: notify connect false
[    5.114562] musb-hdrc musb-hdrc.0.auto: TX ep2 fifo fa0ab028 count 8 buf c08d53c0

Working (with the reverts):

[    4.106201] udc musb-hdrc.0.auto: registering UDC driver [g_ether]
[    4.130065] using random self ethernet address
[    4.137237] using random host ethernet address
[    4.144134] g_ether gadget: adding config #1 'CDC Ethernet (ECM)'/bf03f2c0
[    4.153656] g_ether gadget: adding 'cdc_ethernet'/cef3a9c0 to config 'CDC Ethernet (ECM)'/bf03f2c0
[    4.179870] usb0: HOST MAC 72:08:7d:47:a9:e4
[    4.186981] usb0: MAC 4a:07:75:00:12:7e
[    4.193298] g_ether gadget: CDC Ethernet: dual speed IN/ep1in OUT/ep1out NOTIFY/ep2in
[    4.203918] g_ether gadget: cfg 1/bf03f2c0 speeds: high full
[    4.212219] g_ether gadget:   interface 0 = cdc_ethernet/cef3a9c0
[    4.220916] g_ether gadget:   interface 1 = cdc_ethernet/cef3a9c0
[    4.229522] g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
[    4.238616] g_ether gadget: g_ether ready
[    4.254211] twl4030_usb twl4030_usb: twl4030_phy_resume
[    4.262084] musb-hdrc musb-hdrc.0.auto: MUSB HDRC host driver
[    4.270263] musb-hdrc musb-hdrc.0.auto: new USB bus registered, assigned bus number 1
[    4.280761] musb-hdrc musb-hdrc.0.auto: supports USB remote wakeup
[    4.289581] usb usb1: default language 0x0409
[    4.296356] usb usb1: udev 1, busnum 1, minor = 0
[    4.303527] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.312927] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.322753] usb usb1: Product: MUSB HDRC host driver
[    4.330230] usb usb1: Manufacturer: Linux 3.11.0-rc2-n9xx-00003-gd4a7806-dirty musb-hcd
[    4.340942] usb usb1: SerialNumber: musb-hdrc.0.auto
[    4.349884] usb usb1: usb_probe_device
[    4.356170] usb usb1: configuration #1 chosen from 1 choice
[    4.364379] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.383575] hub 1-0:1.0: usb_probe_interface
[    4.390502] hub 1-0:1.0: usb_probe_interface - got id
[    4.397918] hub 1-0:1.0: USB hub found
[    4.403961] hub 1-0:1.0: 1 port detected
[    4.410095] hub 1-0:1.0: standalone hub
[    4.416046] hub 1-0:1.0: individual port power switching
[    4.423553] hub 1-0:1.0: no over-current protection
[    4.430664] hub 1-0:1.0: Single TT
[    4.436126] hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
[    4.444793] hub 1-0:1.0: power on to power good time: 10ms
[    4.452545] hub 1-0:1.0: local power source is good
[    4.459747] hub 1-0:1.0: enabling power on all ports
[    4.479187] usb0: eth_open
[    4.522949] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0001 tx0000 rx0000
[    4.532714] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x1
[    4.541137] musb-hdrc musb-hdrc.0.auto: SUSPEND (b_idle) devctl 99
[    4.567230] hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0000
[    4.574951] hub 1-0:1.0: hub_suspend
[    4.580596] usb usb1: bus auto-suspend, wakeup 1
[    4.647338] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0004 tx0000 rx0000
[    4.656921] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x4
[    4.665252] musb-hdrc musb-hdrc.0.auto: BUS RESET as b_peripheral
[    4.758178] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    4.767730] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    4.776123] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55df0
[    4.785949] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 18 buf cefba000
[    4.795928] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    4.805572] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    4.814086] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb000c tx0000 rx0000
[    4.823760] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0xc
[    4.832244] musb-hdrc musb-hdrc.0.auto: BUS RESET as b_peripheral
[    4.905944] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    4.915618] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    4.924102] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55df0
[    4.934082] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    4.943786] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    4.953857] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    4.963531] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    4.971984] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55df0
[    4.981842] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 18 buf cefba000
[    4.991790] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.001434] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.009857] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55df0
[    5.019653] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 9 buf cefba000
[    5.029449] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.039031] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.047424] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55df0
[    5.057189] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 64 buf cefba000
[    5.067047] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.076629] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.085021] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 24 buf cefba040
[    5.094940] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.104522] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.112915] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55d08
[    5.122741] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 4 buf cefba000
[    5.132537] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.142120] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.150512] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55d08
[    5.160278] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 32 buf cefba000
[    5.170135] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.179687] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.188018] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55d08
[    5.197784] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 64 buf cefba000
[    5.207611] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.217163] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.225524] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 52 buf cefba040
[    5.235382] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.244964] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.253356] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55d08
[    5.263153] g_ether gadget: high-speed config #1: CDC Ethernet (ECM)
[    5.271759] g_ether gadget: init ecm
[    5.277435] g_ether gadget: notify connect false
[    5.284179] musb-hdrc musb-hdrc.0.auto: TX ep2 fifo fa0ab028 count 8 buf c08f33c0
[    5.294067] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.303771] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.312255] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55d08
[    5.322113] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 64 buf cefba000
[    5.332092] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.341796] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.350280] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 2 buf cefba040
[    5.360168] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.369873] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.378387] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55d08
[    5.388305] g_ether gadget: activate ecm
[    5.394439] usb0: qlen 10
[    5.399139] g_ether gadget: ecm_open
[    5.404907] usb0: eth_start
[    5.409881] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.419677] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.428222] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55d08
[    5.438171] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 26 buf cefba000
[    5.448211] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.457946] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.466430] musb-hdrc musb-hdrc.0.auto: RX ep0 fifo fa0ab020 count 8 buf c0c55d08
[    5.476318] musb-hdrc musb-hdrc.0.auto: TX ep0 fifo fa0ab020 count 36 buf cefba000
[    5.486297] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0001 rx0000
[    5.495941] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.548889] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0004 rx0000
[    5.558563] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.566986] g_ether gadget: notify connect true
[    5.573730] musb-hdrc musb-hdrc.0.auto: TX ep2 fifo fa0ab028 count 8 buf c08f33c0
[    5.612884] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0004 rx0000
[    5.622619] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.631134] g_ether gadget: notify speed 425984000
[    5.638214] musb-hdrc musb-hdrc.0.auto: TX ep2 fifo fa0ab028 count 16 buf c08f33c0
[    5.676879] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0004 rx0000
[    5.686706] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.970092] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0000 rx0002
[    5.979888] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    5.988494] musb-hdrc musb-hdrc.0.auto: RX ep1 fifo fa0ab024 count 78 buf ceecf002
[    6.970275] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0000 rx0002
[    6.980102] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[    6.988677] musb-hdrc musb-hdrc.0.auto: RX ep1 fifo fa0ab024 count 70 buf ceecf802
[   10.974395] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0000 rx0002
[   10.984252] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[   10.992858] musb-hdrc musb-hdrc.0.auto: RX ep1 fifo fa0ab024 count 70 buf cefdc002
[   14.606536] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0000 rx0002
[   14.616424] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[   14.625091] musb-hdrc musb-hdrc.0.auto: RX ep1 fifo fa0ab024 count 90 buf cefdc802
[   14.982360] musb-hdrc musb-hdrc.0.auto: ** IRQ peripheral usb0008 tx0000 rx0002
[   14.992248] musb-hdrc musb-hdrc.0.auto: <== DevCtl=99, int_usb=0x8
[   15.000915] musb-hdrc musb-hdrc.0.auto: RX ep1 fifo fa0ab024 count 70 buf cefdd002

A.
