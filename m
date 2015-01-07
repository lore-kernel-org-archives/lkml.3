Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbbAGQc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:32:59 -0500
Received: from mail-bl2on0096.outbound.protection.outlook.com ([65.55.169.96]:52672
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753520AbbAGQc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:32:58 -0500
Date: Wed, 7 Jan 2015 08:32:48 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Kedareswara rao Appana <appana.durga.rao@xilinx.com>, <wg@grandegger.com>,
        <michal.simek@xilinx.com>, <grant.likely@linaro.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v4] can: Convert to runtime_pm
References: <58f37b6fd9104ce185c413c473fe047b@BY2FFO11FD050.protection.gbl>
 <54AD267C.4060004@pengutronix.de>
 <a868331b44ce4b2a80b572399530f1f9@BN1BFFO11FD043.protection.gbl>
 <54AD5F13.1020107@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54AD5F13.1020107@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21232.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <1d3216d75e9d494fb68ce9a3b24e7ca3@BL2FFO11FD017.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(377454003)(479174004)(24454002)(199003)(377424004)(51704005)(62966003)(76176999)(50986999)(77156002)(54356999)(93886004)(92566001)(23676002)(2950100001)(108616004)(106466001)(92726002)(85202003)(107046002)(4396001)(104016003)(64706001)(53416004)(50466002)(74316001)(6806004)(99396003)(120916001)(86362001)(47776003)(31966008)(46102003)(21056001)(20776003)(85182001)(83506001)(87936001)(110136001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB036;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB036;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB036;
X-Forefront-PRVS: 044968D9E1
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB036;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2015 16:32:55.5351
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB036
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-07 at 05:30PM +0100, Marc Kleine-Budde wrote:
> On 01/07/2015 04:58 PM, Sören Brinkmann wrote:
> >> I think you have to convert the _remove() function, too. Have a look at
> >> the gpio-zynq.c driver:
> >>
> >>> static int zynq_gpio_remove(struct platform_device *pdev)
> >>> {
> >>> 	struct zynq_gpio *gpio = platform_get_drvdata(pdev);
> >>>
> >>> 	pm_runtime_get_sync(&pdev->dev);
> >>
> >> However I don't understand why the get_sync() is here. Maybe Sören can help?
> > 
> > IIRC, the concern was that the remove function may be called while the device is
> > runtime suspended. Hence the remove function needs to resume the device since the
> > remove function may access the HW.
> 
> What about the corresponding runtime_put()? Would some counter be
> unbalanced upon device removal?

Aren't those counters destroyed with module unloading?

	Sören
