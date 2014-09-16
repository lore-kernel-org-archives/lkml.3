Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbaIPT62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:58:28 -0400
Received: from mail-bn1on0136.outbound.protection.outlook.com ([157.56.110.136]:64096
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755514AbaIPT60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:58:26 -0400
X-Greylist: delayed 55613 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 15:58:26 EDT
Message-ID: <1410897494.24184.505.camel@snotra.buserror.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
From: Scott Wood <scottwood@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
CC: "J. German Rivera" <German.Rivera@freescale.com>,
        <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <agraf@suse.de>, <linuxppc-release@linux.freescale.net>
Date: Tue, 16 Sep 2014 14:58:14 -0500
In-Reply-To: <20140916142806.f255250be8df08c56241580f@freescale.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	 <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	 <20140915184451.962a3a19c4940792d182f10a@freescale.com>
	 <1410841881.24184.499.camel@snotra.buserror.net>
	 <20140916142806.f255250be8df08c56241580f@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:1df5:47d:d1ff:74d5]
X-ClientProxiedBy: BY2PR01CA0033.prod.exchangelabs.com (10.255.242.23) To
 DM2PR0301MB0734.namprd03.prod.outlook.com (25.160.97.142)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03361FCC43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(377424004)(24454002)(95666004)(92566001)(86362001)(99396002)(33646002)(23676002)(20776003)(85852003)(50986999)(19580395003)(102836001)(110136001)(47776003)(93886004)(19580405001)(106356001)(105586002)(64706001)(42186005)(77096002)(77156001)(87286001)(76176999)(79102003)(93916002)(62966002)(90102001)(76482001)(107046002)(83072002)(50226001)(89996001)(92726001)(87976001)(101416001)(31966008)(97736003)(77982003)(21056001)(4396001)(104166001)(74662003)(50466002)(81542003)(74502003)(103116003)(83322001)(88136002)(80022003)(81342003)(85306004)(46102003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0734;H:[IPv6:2601:2:5800:3f7:1df5:47d:d1ff:74d5];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 14:28 -0500, Kim Phillips wrote:
> On Mon, 15 Sep 2014 23:31:21 -0500
> Scott Wood <scottwood@freescale.com> wrote:
> 
> > On Mon, 2014-09-15 at 18:44 -0500, Kim Phillips wrote:
> > > On Thu, 11 Sep 2014 12:34:21 -0500
> > > "J. German Rivera" <German.Rivera@freescale.com> wrote:
> > > 
> > > > diff --git a/drivers/bus/fsl-mc/fsl_mc_sys.c b/drivers/bus/fsl-mc/fsl_mc_sys.c
> > > 
> > > > +/**
> > > > + * Map an MC portal in the kernel virtual address space
> > > > + */
> > > > +static int map_mc_portal(phys_addr_t mc_portal_phys_addr,
> > > > +			 uint32_t mc_portal_size,
> > > > +			 void __iomem **new_mc_portal_virt_addr)
> > > > +{
> > > > +	void __iomem *mc_portal_virt_addr = NULL;
> > > > +	struct resource *res = NULL;
> > > > +	int error = -EINVAL;
> > > > +
> > > > +	res =
> > > > +	    request_mem_region(mc_portal_phys_addr, mc_portal_size,
> > > > +			       "mc_portal");
> > > > +	if (res == NULL) {
> > > > +		pr_err("request_mem_region() failed for MC portal %#llx\n",
> > > > +		       mc_portal_phys_addr);
> > > > +		error = -EBUSY;
> > > > +		goto error;
> > > > +	}
> > > > +
> > > > +	mc_portal_virt_addr = ioremap_nocache(mc_portal_phys_addr,
> > > > +					      mc_portal_size);
> > > > +	if (mc_portal_virt_addr == NULL) {
> > > > +		pr_err("ioremap_nocache() failed for MC portal %#llx\n",
> > > > +		       mc_portal_phys_addr);
> > > > +		error = -EFAULT;
> > > > +		goto error;
> > > > +	}
> > > > +
> > > > +	*new_mc_portal_virt_addr = mc_portal_virt_addr;
> > > > +	return 0;
> > > > +error:
> > > > +	if (mc_portal_virt_addr != NULL)
> > > > +		iounmap(mc_portal_virt_addr);
> > > > +
> > > > +	if (res != NULL)
> > > > +		release_mem_region(mc_portal_phys_addr, mc_portal_size);
> > > > +
> > > > +	return error;
> > > > +}
> > > 
> > > unnecessary initializations, bad error codes (both should be
> > > -ENOMEM),
> > 
> > Why should the first one be -ENOMEM?  It's not allocating memory, but
> > rather reserving I/O space.
> 
> I was going with what most of the drivers are already doing, but I
> see EFAULT is 'Bad address', which, you're right, is probably more
> appropriate.

EFAULT is for userspace addresses that fault.

I don't see consistency on what other drivers use after
request_mem_region() -- some use ENOMEM, some ENODEV, some EBUSY... and
probably others.

I'd probably go with ENXIO or EBUSY.

-Scott


