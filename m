Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaJSP5P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:57:15 -0400
Received: from mail-bn1bon0086.outbound.protection.outlook.com ([157.56.111.86]:56915
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751606AbaJSP5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:57:12 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Olof Johansson <olof@lixom.net>,
        =?iso-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>
CC: Michal Simek <michals@xilinx.com>, Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        "Sean Rickerd" <srickerd@suse.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: RE: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella
Thread-Topic: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella
Thread-Index: AQHPp5MsFb0sap2zPkuGYoaeW+pqmZw2PgEAgAHaMFY=
Date: Sun, 19 Oct 2014 15:57:06 +0000
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>,<CAOesGMjAb5oXjauhbqjDhJXWct7qoXxy3XpA1=DioK7vPTwetA@mail.gmail.com>
In-Reply-To: <CAOesGMjAb5oXjauhbqjDhJXWct7qoXxy3XpA1=DioK7vPTwetA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.19.116.98]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21036.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <30e1a5024949427cb08f5c1c8b4ac87f@BY2FFO11FD031.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(24454002)(199003)(377454003)(189002)(51704005)(4396001)(6806004)(19580395003)(95666004)(106466001)(21056001)(85852003)(44976005)(107046002)(77096002)(31966008)(76176999)(54356999)(50986999)(53416004)(47776003)(15202345003)(20776003)(64706001)(19580405001)(566704002)(92566001)(106116001)(15975445006)(23756003)(104016003)(87936001)(2656002)(86362001)(74316001)(76482002)(46102003)(120916001)(85306004)(108616004)(99396003)(80022003)(50466002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB045;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB045;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0369E8196C
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, for top-posting, but I currently just have Outlook webmail.
The cause for this issue is relatively easily identified. The ethernet drivers sets the Ethernet clock according to the negotioated link speed. For this adjustment a 6-bit divider in the clock path is used. In this case, it seems, the input to the 6-bit divider doesn't allow generating the full range of required frequencies for all supported link speeds.

I guess this could be solved in multiple ways.
1. Disable 1G mode/auto negotiation, the other modes are probably fine (yeah, not a solution, but might give you a working ethernet link)
2. Ensure the divider input allows to generate all required frequencies. This essentially means to go back into Xilinx tools and play around with the clock/PLL setup and re-generating a bootloader that sets things up with the updated values.
3. Support to run-time-adust the PLLs in Zynq. This is definitely the most complex one. I never seriously pursued this, since it seemed close to impossible to change the PLLs at run-time without crashing pretty much every downstream user except for the one that requested the frequency change. And even if every driver would be able to handle such a change, I could imagine that frequency constraints from  all the drivers together would still prevent any change.

        Thanks,
        Sören

________________________________________
From: devicetree-owner@vger.kernel.org [devicetree-owner@vger.kernel.org] on behalf of Olof Johansson [olof@lixom.net]
Sent: Friday, October 17, 2014 9:28 PM
To: Andreas Färber
Cc: Michal Simek; Andreas Olofsson; Matteo Vit; Sean Rickerd; devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Punnaiah Choudary Kalluri; Lars-Peter Clausen
Subject: Re: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella

Hi Andreas,

On Thu, Jul 24, 2014 at 4:00 PM, Andreas Färber <afaerber@suse.de> wrote:
> Hello,
>
> This patch series adds an initial device tree for the Parallella board.
> UART, SD card, Ethernet are enabled.
> Not yet enabled are HDMI, QSPI flash and 2x USB.

Andreas (Olofsson) kindly sent me a board, and I added it to the boot
farm today, it'll be included in boot reports from here on.

I did a test run with yesterday's -next It looks like networking isn't
working there at the moment, clock related. Same happens with 3.17 and
latest mainline, config multi_v7_defconfig:

[WARN] [    7.943648] macb e000b000.ethernet eth0: unable to generate
target frequency: 125000000 Hz
[WARN] [   10.948681] macb e000b000.ethernet eth0: unable to generate
target frequency: 125000000 Hz

Full boot log at:

http://arm-soc.lixom.net/bootlogs/misc/next-20141017/parallella-arm-multi_v7_defconfig.html

I'll be happy to try things, but I'm a bit short on cycles to debug
myself. Should hopefully be easy to reproduce.


-Olof
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

