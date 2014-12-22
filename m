Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaLVC1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:27:34 -0500
Received: from mail-bl2on0132.outbound.protection.outlook.com ([65.55.169.132]:8958
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753633AbaLVC1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:27:32 -0500
Date: Mon, 22 Dec 2014 09:18:44 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Sanchayan Maity <maitysanchayan@gmail.com>
CC: <stefan@agner.ch>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] usb: chipidea: add one errata for revision 2.40a
Message-ID: <20141222011840.GB9242@shlinux2>
References: <cover.1418981438.git.maitysanchayan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1418981438.git.maitysanchayan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(51704005)(24454002)(43544003)(199003)(33656002)(21056001)(99396003)(85426001)(54356999)(87936001)(50986999)(77096005)(2950100001)(31966008)(68736005)(15975445007)(97756001)(83506001)(62966003)(77156002)(76176999)(19580395003)(6806004)(33716001)(110136001)(50466002)(47776003)(20776003)(64706001)(107046002)(23726002)(46102003)(4396001)(46406003)(86362001)(1411001)(92566001)(105606002)(120916001)(106466001)(97736003)(104016003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0635;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0635;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0635;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0635;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 02:27:28.2884
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB0635
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 03:25:26PM +0530, Sanchayan Maity wrote:
> The first two patches add identification register API's. These can
> be used to get controller's revision. 
> 
> The third patch implements an errata for revision 2.40a. Not sure
> which other SOCs implement this version of the Chipidea core but
> this fixes the usb client issue observed on Vybrids. The patch was
> tested on a Toradex Colibri VF61 module with the 3.18 kernel. iperf
> tests ran for three hours plus, with these patches applied have found
> the USB client connection to be now reliable.

Would you help do a overnight test? It is passed, I will queue them,
thanks.

Peter
> 
> This patchset is based off on Shawn Guo's for-next branch
> https://git.kernel.org/cgit/linux/kernel/git/shawnguo/linux.git/tree/?h=for-next
> 
> The credit for the patches and fix goes to Matthieu Castet and Peter Chen.
> First two patches are by Peter Chen and the third patch which fixed the
> bug we observed was reported by Matthieu Castet.
> 
> The discussion of the problem and the relevant testing details can be found
> at this link: http://www.spinics.net/lists/linux-usb/msg118544.html
> 
> The first version of this patchset originally send by Peter Chen can be
> found at this link: http://www.spinics.net/lists/linux-usb/msg118753.html
> 
> Comments for review are welcome :).
> Note: I am going on a vacation so will not be able to reply or do any further
> tests till Monday. Will attend and take care of any comments/requests for 
> further changes/testing from Tuesday. Apologize for the delay in advance.
> 
> Sanchayan Maity (3):
>   usb: chipidea: Add identification registers access APIs
>   usb: chipidea: Add chipidea revision information
>   usb: chipidea: Add errata for revision 2.40a
> 
>  drivers/usb/chipidea/bits.h |   10 ++++++++
>  drivers/usb/chipidea/ci.h   |   53 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/usb/chipidea/core.c |   23 +++++++++++++++++--
>  drivers/usb/chipidea/udc.c  |   20 ++++++++++++++++
>  4 files changed, 104 insertions(+), 2 deletions(-)
> 
> -- 
> 1.7.9.5
> 

-- 

Best Regards,
Peter Chen
