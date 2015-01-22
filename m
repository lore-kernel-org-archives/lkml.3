Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbbAVFNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:13:01 -0500
Received: from mail-by2on0107.outbound.protection.outlook.com ([207.46.100.107]:57056
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754296AbbAVFMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:12:52 -0500
Date: Thu, 22 Jan 2015 13:13:46 +0800
From: Zidan Wang <b50113@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: Zidan Wang <zidan.wang@freescale.com>, <timur@tabi.org>,
        <Xiubo.Lee@gmail.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel][PATCH 3/3] ASoC: fsl_sai: Add support for Right-J
 mode
Message-ID: <20150122051344.GA6907@b50113>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
 <1421756480-7055-4-git-send-email-zidan.wang@freescale.com>
 <20150121185319.GA4238@Alpha>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150121185319.GA4238@Alpha>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B50113@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(51704005)(24454002)(77156002)(50466002)(64706001)(47776003)(46406003)(54356999)(76176999)(6806004)(50986999)(33656002)(104016003)(92566002)(33716001)(106466001)(1411001)(97736003)(110136001)(86362001)(87936001)(19580405001)(85426001)(77096005)(19580395003)(23726002)(105606002)(46102003)(68736005)(83506001)(2950100001)(97756001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1255;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY1PR0301MB1255;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY1PR0301MB1255;
X-Forefront-PRVS: 0464DBBBC4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1255;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2015 05:12:45.8546
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1255
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1173;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:53:20AM -0800, Nicolin Chen wrote:
> On Tue, Jan 20, 2015 at 08:21:20PM +0800, Zidan Wang wrote:
> > Add Right-J mode and set TCR5 FBT bit to let data right justify.
> > 
> > Signed-off-by: Zidan Wang <zidan.wang@freescale.com>
> 
> > -	if (sai->is_lsb_first)
> > +	if (sai->is_lsb_first && sai->is_right_j_mode)
> >  		val_cr5 |= FSL_SAI_CR5_FBT(0);
> 
> Are you sure that FBT(0) is correct for right justified mode?
> Because the original code is using FBT(0) for the lsb_first
> situation and it shouldn't be right justified mode as default.
>
I am not sure about that. 

I assume lsb_first as big endian data.

For 16 bit data format, the 2 bytes data will in high address of 4 bytes
fifo. So the FBT is 16 for left-j and 0 for right-j. But big endian is
bytes convert not bits convert. It makes me confuse. And send to
community for help.

> Nicolin
