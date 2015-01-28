Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbbA1U4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:56:11 -0500
Received: from mail-bn1on0096.outbound.protection.outlook.com ([157.56.110.96]:5728
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754547AbbA1U4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:56:07 -0500
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        Michal Simek <michals@xilinx.com>, Soren Brinkmann <sorenb@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
CC: "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v5] can: Convert to runtime_pm
Thread-Topic: [PATCH v5] can: Convert to runtime_pm
Thread-Index: AQHQOwkzSY2jDvOc5kyJ0NKKGkOzpZzVpLvQ
Date: Wed, 28 Jan 2015 15:19:24 +0000
References: <baf987c11c0242c2bf87b81f9396b09d@BN1BFFO11FD018.protection.gbl>
 <54C8F62D.6090909@pengutronix.de>
In-Reply-To: <54C8F62D.6090909@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.228.216]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21288.007
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <1ae6a3ca4fad4104a673b9a6c7e44998@BY2FFO11FD036.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; vger.kernel.org; dkim=none
 (message not signed) header.d=none;
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(479174004)(51704005)(377454003)(24454002)(106466001)(2501002)(16601075003)(92566002)(92726002)(104016003)(15975445007)(87936001)(6806004)(102836002)(2950100001)(19580405001)(86362001)(19580395003)(53416004)(50466002)(23676002)(62966003)(54356999)(108616004)(50986999)(76176999)(74316001)(2656002)(106116001)(77156002)(46102003)(47776003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB008;H:xsj-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB008;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2FFO11HUB008;
X-Forefront-PRVS: 047001DADA
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB008;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2015 15:19:27.4478
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2FFO11HUB008
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0SL6FCB006854

Hi Marc,

> -----Original Message-----
> From: Marc Kleine-Budde [mailto:mkl@pengutronix.de]
> Sent: Wednesday, January 28, 2015 8:16 PM
> To: Appana Durga Kedareswara Rao; wg@grandegger.com; Michal Simek;
> Soren Brinkmann; grant.likely@linaro.org; robh+dt@kernel.org
> Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; Appana Durga Kedareswara Rao
> Subject: Re: [PATCH v5] can: Convert to runtime_pm
>
> On 01/12/2015 04:04 PM, Kedareswara rao Appana wrote:
> > Instead of enabling/disabling clocks at several locations in the
> > driver, Use the runtime_pm framework. This consolidates the actions
> > for runtime PM In the appropriate callbacks and makes the driver more
> readable and mantainable.
> >
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> > ---
> > Changes for v5:
> >  - Updated with the review comments.
> >    Updated the remove fuction to use runtime_pm.
> > Chnages for v4:
> >  - Updated with the review comments.
> > Changes for v3:
> >   - Converted the driver to use runtime_pm.
> > Changes for v2:
> >   - Removed the struct platform_device* from suspend/resume
> >     as suggest by Lothar.
>
> Any plans to submit a v6?

I was on vacation till yesterday just came to office today only. Will look into it and will send v6 at the earliest.

Regards,
Kedar.

>
> Marc
> --
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
