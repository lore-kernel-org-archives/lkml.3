Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbbAPLCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:02:34 -0500
Received: from mail-bn1bon0075.outbound.protection.outlook.com ([157.56.111.75]:7905
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753057AbbAPLCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:02:32 -0500
Date: Fri, 16 Jan 2015 12:02:02 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <monstr@monstr.eu>, Olof Johansson <olof@lixom.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-serial@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Cox <alan@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tty: serial: 8250_core: Check that port->line is
 >=0
References: <3293c93689f5d8c684133a9d9952411a201609dc.1421333585.git.michal.simek@xilinx.com>
 <d3a26f5ecd44e1415f213e6ee7f33005c1b23f4a.1421333585.git.michal.simek@xilinx.com>
 <54B8D32E.5000805@linutronix.de>
 <df5d7450de9f4382b1cb43791f69e25c@BL2FFO11FD013.protection.gbl>
 <54B8ED20.60308@linutronix.de>
In-Reply-To: <54B8ED20.60308@linutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21256.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <3ecb2012312c4af5bbd395391aa82921@BY2FFO11FD005.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(479174004)(199003)(51704005)(377454003)(164054003)(189002)(64126003)(2950100001)(83506001)(2201001)(106466001)(19580405001)(6806004)(19580395003)(92566002)(46102003)(92726002)(23746002)(108616004)(50466002)(74316001)(77096005)(93886004)(62966003)(77156002)(64706001)(76176999)(54356999)(50986999)(47776003)(104016003)(87936001)(575784001)(86362001)(65806001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB034;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB034;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2FFO11HUB034;
X-Forefront-PRVS: 04583CED1A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB034;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2015 11:02:23.7753
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[62.221.5.235]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2FFO11HUB034
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 11:51 AM, Sebastian Andrzej Siewior wrote:
> - Yoshihiro YUNOMAE
> (reason: 550 5.1.1 <yoshihiro.yunomae.ez@hitachi.com>: Recipient
> address rejected: User Unknown)
> 
> On 01/16/2015 11:37 AM, Michal Simek wrote:
>> Hi,
> 
> Hi,
> 
>> Origin patch looks good to me but this checking will be good to add.
>> Are you using of_serial.c because I didn't find any of_alias_get_id call
>> for 8250?
> 
> I'm using of_alias_get_id() in 8250_omap.c which made it into
> v3.19-rc1. I think the change you mention made it one release earlier.

I see
serial: of-serial: fetch line number from DT
commit 1bd8324535ec1ff44aef55c0e40b9e7d56b310fb

but it was reverted

Revert "serial: of-serial: fetch line number from DT"
commit e4c787dac21e50ac9ef53fac91b9182d4fede465

Olof: what was the reason for that breakage?
Is it missing alias list on Tegra?
which caused that port->line number is bogus.

Thanks,
Michal

