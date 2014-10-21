Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbaJUVCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:02:33 -0400
Received: from mail-bn1bon0070.outbound.protection.outlook.com ([157.56.111.70]:10304
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932723AbaJUVCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:02:31 -0400
Date: Tue, 21 Oct 2014 14:00:28 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Olof Johansson <olof@lixom.net>, Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <CAOesGMjAb5oXjauhbqjDhJXWct7qoXxy3XpA1=DioK7vPTwetA@mail.gmail.com>
 <5446C775.3030707@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5446C775.3030707@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21040.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <10cbd78315a84262bc3f7474dc970bd4@BN1BFFO11FD015.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377454003)(51704005)(377424004)(199003)(24454002)(189002)(74316001)(86362001)(575784001)(104016003)(50986999)(76176999)(102836001)(54356999)(47776003)(20776003)(21056001)(50466002)(108616004)(107046002)(23676002)(85306004)(99396003)(110136001)(33646002)(120916001)(76482002)(46102003)(80022003)(64706001)(31966008)(85202003)(106466001)(4396001)(95666004)(53416004)(77096002)(85852003)(85182001)(92566001)(6806004)(44976005)(19580405001)(87936001)(83506001)(19580395003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB039;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:3;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB039;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 10:52PM +0200, Andreas Färber wrote:
> Hi Olof and Sören,
> 
> Am 18.10.2014 um 06:28 schrieb Olof Johansson:
> > On Thu, Jul 24, 2014 at 4:00 PM, Andreas Färber <afaerber@suse.de> wrote:
> >> Hello,
> >>
> >> This patch series adds an initial device tree for the Parallella board.
> >> UART, SD card, Ethernet are enabled.
> >> Not yet enabled are HDMI, QSPI flash and 2x USB.
> > 
> > Andreas (Olofsson) kindly sent me a board, and I added it to the boot
> > farm today, it'll be included in boot reports from here on.
> 
> Good to hear.
> 
> > I did a test run with yesterday's -next It looks like networking isn't
> > working there at the moment, clock related. Same happens with 3.17 and
> > latest mainline, config multi_v7_defconfig:
> > 
> > [WARN] [    7.943648] macb e000b000.ethernet eth0: unable to generate
> > target frequency: 125000000 Hz
> > [WARN] [   10.948681] macb e000b000.ethernet eth0: unable to generate
> > target frequency: 125000000 Hz
> 
> I am unable to reproduce this in my setup - at Linus' tip
> c2661b806092d8ea2dccb7b02b65776555e0ee47 (v3.18-rc1-68-gc2661b8), make
> oldconfig'ing my /proc/config.gz.
> 
> Sören, in light of your explanations, should I be expecting problems
> with 1GbE or with 100MbE? My board is connected to a 1GbE switch.

Not in general. As I said, I haven't seen that on our boards yet and I
did a little bit of testing making sure that the fundamental code to
switch between frequencies works. I.e. on our zc706 and zc702 boards I
usually can use ethtool to force a certain speed on the interface and
Zynq adjusts to it just fine.

But as I said, it does rely on the divider being sourced with a
frequency that allows generating the required Ethernet clock by
adjusting the 6-bit divider only. If this requirement is not met,
I expect you may see issues like Olof posted.

Are you (Andreas/Olof) using the same bootloaders?

I hope that helps.

	Sören
