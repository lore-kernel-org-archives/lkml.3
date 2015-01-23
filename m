Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbbAWAn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:43:57 -0500
Received: from mail-bl2on0148.outbound.protection.outlook.com ([65.55.169.148]:38259
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752235AbbAWAny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:43:54 -0500
Message-ID: <1421973825.4961.253.camel@freescale.com>
Subject: Re: [PATCH] powerpc/fsl_pci: Fix pci stack build bug with FRAME_WARN
From: Scott Wood <scottwood@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wang Dongsheng <dongsheng.wang@freescale.com>,
        Anton Blanchard <anton@samba.org>,
        "Himangi Saraogi" <himangi774@gmail.com>,
        Aaron Sierra <asierra@xes-inc.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Thu, 22 Jan 2015 18:43:45 -0600
In-Reply-To: <20150122182056.cc3436bd90a6cbba70da538a@freescale.com>
References: <20150120140349.a7a9885065c241b555b91717@freescale.com>
	 <1421800292.4961.215.camel@freescale.com>
	 <20150121204844.fda3d4ab23a8226b6cdfdaf6@freescale.com>
	 <1421895747.4961.232.camel@freescale.com>
	 <20150122182056.cc3436bd90a6cbba70da538a@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: SN2PR10CA0027.namprd10.prod.outlook.com (25.160.12.165) To
 BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
Authentication-Results: freescale.com; dkim=none (message not signed)
 header.d=none;freescale.com; dmarc=none action=none
 header.from=freescale.com;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0728;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0728;
X-Forefront-PRVS: 0465429B7F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(377424004)(24454002)(42186005)(92566002)(50986999)(47776003)(46102003)(19580395003)(76176999)(19580405001)(86362001)(87976001)(50226001)(62966003)(77156002)(36756003)(40100003)(93886004)(23676002)(33646002)(103116003)(50466002)(2950100001)(110136001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 00:43:51.1694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0728
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-22 at 18:20 -0600, Kim Phillips wrote:
> On Wed, 21 Jan 2015 21:02:27 -0600
> Scott Wood <scottwood@freescale.com> wrote:
> 
> > On Wed, 2015-01-21 at 20:48 -0600, Kim Phillips wrote:
> > > fake_pci_bus()' version is static, so it's not on the stack.
> > > 
> > > given that, maybe fsl_pcie_check_link()'s should be static too?
> > 
> > Oh.  How would you ensure that it's only called once at a time?  It
> > doesn't look like this is only called during early boot.
> > fsl_pcie_check_link() is called every time we do any config read through
> > the normal interface.  This is also a concern for the call to
> > early_read_config_dword().
> 
> I really don't know how that works: that code has been there since
> before linux was maintained in git.

Regardless, now that it's been noticed we should figure it out.
fsl_pcie_check_link() is using the early_*() functions in a context that
is not early and thus appears to be breaking the assumption that
fake_pci_bus() makes.

fsl_pcie_check_link() is fairly recent, FWIW.

> Below is the v2.

Please send as a standalone patch so I don't have to edit all the
discussion out of the commit message.

-Scott


