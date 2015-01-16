Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbbAPKwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:52:25 -0500
Received: from mail-bl2on0097.outbound.protection.outlook.com ([65.55.169.97]:14512
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751750AbbAPKwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:52:22 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 05:52:22 EST
Date: Fri, 16 Jan 2015 11:37:01 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <monstr@monstr.eu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-serial@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Cox <alan@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tty: serial: 8250_core: Check that port->line is
 >=0
References: <3293c93689f5d8c684133a9d9952411a201609dc.1421333585.git.michal.simek@xilinx.com>
 <d3a26f5ecd44e1415f213e6ee7f33005c1b23f4a.1421333585.git.michal.simek@xilinx.com>
 <54B8D32E.5000805@linutronix.de>
In-Reply-To: <54B8D32E.5000805@linutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21256.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <df5d7450de9f4382b1cb43791f69e25c@BL2FFO11FD013.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(6009001)(438002)(479174004)(189002)(377454003)(51704005)(24454002)(164054003)(199003)(77096005)(2201001)(92726002)(2950100001)(108616004)(92566002)(19580395003)(106466001)(6806004)(104016003)(86362001)(65956001)(65806001)(87936001)(54356999)(76176999)(23746002)(74316001)(64706001)(83506001)(77156002)(62966003)(47776003)(50466002)(50986999)(46102003)(64126003)(65826006)(107986001)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB065;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:ovrnspm;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB065;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB065;
X-Forefront-PRVS: 04583CED1A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB065;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2015 10:37:16.8933
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[62.221.5.235]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB065
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/16/2015 10:00 AM, Sebastian Andrzej Siewior wrote:
> On 01/15/2015 03:55 PM, Michal Simek wrote:
>> This patch should be the part of:
>> "tty: serial: 8250_core: use the ->line argument as a hint in
>> serial8250_find_match_or_unused()"
>> (sha1: 59b3e898ddfc81a65975043b5eb44103cc29ff6e)
>>
>> port->line can be setup by DT driver to -1 which needs to
>> be also checked.
> 
> This is what I have in 8250_omap to make sure it does not get < 0:
> 
>          if (pdev->dev.of_node) {
>                  ret = of_alias_get_id(pdev->dev.of_node, "serial");
> 
>                  of_property_read_u32(pdev->dev.of_node, "clock-frequency",
>                                       &up.port.uartclk);
>                  priv->wakeirq = irq_of_parse_and_map(pdev->dev.of_node, 1);
>          } else {
>                  ret = pdev->id;
>          }
>          if (ret < 0) {
>                  dev_err(&pdev->dev, "failed to get alias/pdev id\n");
>                  return ret;
>          }
>          up.port.line = ret;
> 
> but I didn't think of that others might pass < 0 since it wasn't used
> before.
> Does the original patch (you noted) break anything as of now? Because
> then this patch should go stable.

Origin patch looks good to me but this checking will be good to add.
Are you using of_serial.c because I didn't find any of_alias_get_id call
for 8250?

Your logic here is a little bit different than I have in my tree.
(Some sort of pl011 solution). You don't need to failed if you port.line is
below 0 but if you are not able to read aliases port enumeration
may be unpredictable.

Thanks,
Michal




