Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500AbaCRXVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:21:31 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:13961
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757723AbaCRXVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:21:30 -0400
Message-ID: <1395184882.12479.253.camel@snotra.buserror.net>
Subject: Re: [PATCH 7/9] fsl: add EPU FSM configuration for deep sleep
From: Scott Wood <scottwood@freescale.com>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Date: Tue, 18 Mar 2014 18:21:22 -0500
In-Reply-To: <20140317102727.GB6204@localhost.localdomain>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-7-git-send-email-chenhui.zhao@freescale.com>
	 <1394582923.13761.81.camel@snotra.buserror.net>
	 <20140312083410.GF4706@localhost.localdomain>
	 <1394837469.12479.134.camel@snotra.buserror.net>
	 <20140317102727.GB6204@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR01CA006.prod.exchangelabs.com (10.141.66.46) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 0154C61618
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(199002)(189002)(377424004)(51704005)(74366001)(81686001)(74502001)(62966002)(53806001)(81542001)(47446002)(92726001)(51856001)(97186001)(74662001)(81342001)(56816005)(42186004)(33646001)(31966008)(88136002)(80022001)(86362001)(65816001)(93136001)(47736001)(80976001)(69226001)(95666003)(76482001)(46102001)(54316002)(90146001)(76796001)(76786001)(77982001)(77156001)(77096001)(74706001)(4396001)(83072002)(93516002)(59766001)(20776003)(47776003)(87286001)(94946001)(63696002)(79102001)(87976001)(94316002)(83322001)(81816001)(56776001)(85306002)(97336001)(85852003)(50226001)(23676002)(92566001)(95416001)(47976001)(50986001)(74876001)(89996001)(93916002)(49866001)(87266001)(50466002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:389BF31C.AED4D429.FFFD31AA.94E8E103.20296;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-17 at 18:27 +0800, Chenhui Zhao wrote:
> On Fri, Mar 14, 2014 at 05:51:09PM -0500, Scott Wood wrote:
> > On Wed, 2014-03-12 at 16:34 +0800, Chenhui Zhao wrote:
> > > On Tue, Mar 11, 2014 at 07:08:43PM -0500, Scott Wood wrote:
> > > > On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> > > > > +	/* Configure the EPU Counters */
> > > > > +	epu_write(EPCCR15, 0x92840000);
> > > > > +	epu_write(EPCCR14, 0x92840000);
> > > > > +	epu_write(EPCCR12, 0x92840000);
> > > > > +	epu_write(EPCCR11, 0x92840000);
> > > > > +	epu_write(EPCCR10, 0x92840000);
> > > > > +	epu_write(EPCCR9, 0x92840000);
> > > > > +	epu_write(EPCCR8, 0x92840000);
> > > > > +	epu_write(EPCCR5, 0x92840000);
> > > > > +	epu_write(EPCCR4, 0x92840000);
> > > > > +	epu_write(EPCCR2, 0x92840000);
> > > > > +
> > > > > +	/* Configure the SCUs Inputs */
> > > > > +	epu_write(EPSMCR15, 0x76000000);
> > > > > +	epu_write(EPSMCR14, 0x00000031);
> > > > > +	epu_write(EPSMCR13, 0x00003100);
> > > > > +	epu_write(EPSMCR12, 0x7F000000);
> > > > > +	epu_write(EPSMCR11, 0x31740000);
> > > > > +	epu_write(EPSMCR10, 0x65000030);
> > > > > +	epu_write(EPSMCR9, 0x00003000);
> > > > > +	epu_write(EPSMCR8, 0x64300000);
> > > > > +	epu_write(EPSMCR7, 0x30000000);
> > > > > +	epu_write(EPSMCR6, 0x7C000000);
> > > > > +	epu_write(EPSMCR5, 0x00002E00);
> > > > > +	epu_write(EPSMCR4, 0x002F0000);
> > > > > +	epu_write(EPSMCR3, 0x2F000000);
> > > > > +	epu_write(EPSMCR2, 0x6C700000);
> > > > 
> > > > Where do these magic numbers come from?  Which chips are they valid for?
> > > 
> > > They are for T1040. Can be found in the RCPM chapter of T1040RM.
> > 
> > Then put in a comment to that effect, including what part of the RCPM
> > chapter.
> > 
> > How do you plan to handle the addition of another SoC with different
> > values?
> > 
> > -Scott
> 
> Had thought that using an array to put these values (pairs of offset and value)
> and passing the array to the function.

Arrays are better than a long sequence of function calls in any case.

> However, luckily T104x and LS1 have same values for these registers
> according to the current Reference Manuals.

If it's likely that the values will remain the same on all chips for the
near future, then a fancy mechanism to select the array to use can wait
-- but you should still use an array, and have a comment acknowledging
the possibility of needing to accommodate different values in the
future.

-Scott


