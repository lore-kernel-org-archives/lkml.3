Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaDVLAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:00:37 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:41433
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755257AbaDVLAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:00:33 -0400
X-Greylist: delayed 892 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Apr 2014 07:00:32 EDT
Date: Tue, 22 Apr 2014 18:51:44 +0800
From: Robin Gong <b38343@freescale.com>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v1] dma: imx-sdma: add support for sdma memory copy
Message-ID: <20140422105142.GA9693@Robin-OptiPlex-780>
References: <1397728870-22086-1-git-send-email-b38343@freescale.com>
 <1397730289.11914.225.camel@smile.fi.intel.com>
 <20140418094057.GA11496@Robin-OptiPlex-780>
 <1398162484.11914.234.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1398162484.11914.234.camel@smile.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(189002)(199002)(51704005)(24454002)(377424004)(44976005)(74662001)(83322001)(92726001)(80976001)(19580395003)(31966008)(74502001)(19580405001)(87936001)(92566001)(6806004)(85852003)(46406003)(83072002)(76482001)(80022001)(81342001)(81542001)(23726002)(97756001)(20776003)(47776003)(76176999)(54356999)(77096999)(50466002)(77982001)(99396002)(50986999)(46102001)(83506001)(4396001)(33656001)(33716001)(42262001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR03MB031;H:az84smr01.freescale.net;FPR:FC08F088.AC0690D9.B0E35F86.4CE662C5.2031E;MLV:sfv;PTR:gate-az5.freescale.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 01894AD3B8
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:28:05AM +0000, Shevchenko, Andriy wrote:
> On Fri, 2014-04-18 at 17:41 +0800, Robin Gong wrote:
> > On Thu, Apr 17, 2014 at 10:24:50AM +0000, Shevchenko, Andriy wrote:
> > > On Thu, 2014-04-17 at 18:01 +0800, Robin Gong wrote:
> 
> []
> 
> > > > +	dev_dbg(sdma->dev, "memcpy: %x->%x, len=%d, channel=%d.\n",
> > > 
> > > %pad for dma_addr_t variables.
> > >
> > Yes, %x here is not proper, will be %#llx here to align with others similar
> > code in this file.
> 
> Why %#llx? You don't need the specific casting since kernel has special
> specifiers for phys_addr_t and dma_addr_t and their derivatives (see
> Documentation/printk-formats.txt)
>
I think both are ok, why I choose %llx is only for align the code style, you
can find the same code in sdma_prep_dma_cyclic function. below description also
copy from Documentation/printk-formats.txt:


If <type> is dependent on a config option for its size (e.g., sector_t,
blkcnt_t, phys_addr_t, resource_size_t) or is architecture-dependent
for its size (e.g., tcflag_t), use a format specifier of its largest
possible type and explicitly cast to it.  Example:

	printk("test: sector number/total blocks: %llu/%llu\n",
		(unsigned long long)sector, (unsigned long long)blockcount);
> > > > +		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
> > > > +				i, count, sg_src->dma_address,
> > > 
> > > %pad for dma_addr_t.
> > > 
> > Accept the idea, same as the above.
> 
> Same as above.
> 
> -- 
> Andy Shevchenko <andriy.shevchenko@intel.com>
> Intel Finland Oy
> ---------------------------------------------------------------------
> Intel Finland Oy
> Registered Address: PL 281, 00181 Helsinki 
> Business Identity Code: 0357606 - 4 
> Domiciled in Helsinki 
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
