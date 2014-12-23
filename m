Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaLWBdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 20:33:05 -0500
Received: from mail-bn1on0117.outbound.protection.outlook.com ([157.56.110.117]:55757
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751127AbaLWBdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 20:33:03 -0500
X-Greylist: delayed 870 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2014 20:33:03 EST
Date: Tue, 23 Dec 2014 08:09:44 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Sanchayan Maity <maitysanchayan@gmail.com>
CC: <stefan@agner.ch>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] usb: chipidea: add one errata for revision 2.40a
Message-ID: <20141223000940.GA11551@shlinux2>
References: <cover.1418981438.git.maitysanchayan@gmail.com>
 <20141222011840.GB9242@shlinux2> <54981816.4010708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54981816.4010708@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(51704005)(24454002)(479174004)(189002)(199003)(43544003)(377454003)(85426001)(97756001)(83506001)(84676001)(110136001)(6806004)(19580395003)(50466002)(46102003)(104016003)(106466001)(107046002)(99396003)(120916001)(105606002)(46406003)(21056001)(86362001)(4396001)(50986999)(54356999)(76176999)(87936001)(92566001)(1411001)(2950100001)(77096005)(33656002)(33716001)(31966008)(23726002)(62966003)(97736003)(77156002)(64706001)(15975445007)(68736005)(20776003)(47776003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0629;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0629;
X-Forefront-PRVS: 04347F8039
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 01:18:29.9764
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0629
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 06:39:42PM +0530, Sanchayan Maity wrote:
> On 12/22/2014 06:48 AM, Peter Chen wrote:
> > On Fri, Dec 19, 2014 at 03:25:26PM +0530, Sanchayan Maity wrote:
> >> The first two patches add identification register API's. These can
> >> be used to get controller's revision. 
> >>
> >> The third patch implements an errata for revision 2.40a. Not sure
> >> which other SOCs implement this version of the Chipidea core but
> >> this fixes the usb client issue observed on Vybrids. The patch was
> >> tested on a Toradex Colibri VF61 module with the 3.18 kernel. iperf
> >> tests ran for three hours plus, with these patches applied have found
> >> the USB client connection to be now reliable.
> > 
> > Would you help do a overnight test? It is passed, I will queue them,
> > thanks.
> 
> Yes definitely I can help with the testing. Are you looking for iperf
> tests only or something else? iperf tests running for 12 or 24 hours 
> will do? I will need a bit of time to set things up here, as I am away
> from work, but, ya I will do them. 
> 

iperf for g_ncm or g_ether and bonnie++ for g_mass_storage if you can
run, thanks.

Peter

> -Regards,
> Sanchayan.
> > 
> > Peter
> >>
> >> This patchset is based off on Shawn Guo's for-next branch
> >> https://git.kernel.org/cgit/linux/kernel/git/shawnguo/linux.git/tree/?h=for-next
> >>
> >> The credit for the patches and fix goes to Matthieu Castet and Peter Chen.
> >> First two patches are by Peter Chen and the third patch which fixed the
> >> bug we observed was reported by Matthieu Castet.
> >>
> >> The discussion of the problem and the relevant testing details can be found
> >> at this link: http://www.spinics.net/lists/linux-usb/msg118544.html
> >>
> >> The first version of this patchset originally send by Peter Chen can be
> >> found at this link: http://www.spinics.net/lists/linux-usb/msg118753.html
> >>
> >> Comments for review are welcome :).
> >> Note: I am going on a vacation so will not be able to reply or do any further
> >> tests till Monday. Will attend and take care of any comments/requests for 
> >> further changes/testing from Tuesday. Apologize for the delay in advance.
> >>
> >> Sanchayan Maity (3):
> >>   usb: chipidea: Add identification registers access APIs
> >>   usb: chipidea: Add chipidea revision information
> >>   usb: chipidea: Add errata for revision 2.40a
> >>
> >>  drivers/usb/chipidea/bits.h |   10 ++++++++
> >>  drivers/usb/chipidea/ci.h   |   53 +++++++++++++++++++++++++++++++++++++++++++
> >>  drivers/usb/chipidea/core.c |   23 +++++++++++++++++--
> >>  drivers/usb/chipidea/udc.c  |   20 ++++++++++++++++
> >>  4 files changed, 104 insertions(+), 2 deletions(-)
> >>
> >> -- 
> >> 1.7.9.5
> >>
> > 

-- 

Best Regards,
Peter Chen
