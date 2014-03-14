Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbaCNWf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:35:27 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:29967
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753921AbaCNWfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:35:25 -0400
Message-ID: <1394836465.12479.123.camel@snotra.buserror.net>
Subject: Re: [PATCH 3/9] powerpc/rcpm: add RCPM driver
From: Scott Wood <scottwood@freescale.com>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Date: Fri, 14 Mar 2014 17:34:25 -0500
In-Reply-To: <20140312035954.GB4706@localhost.localdomain>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-3-git-send-email-chenhui.zhao@freescale.com>
	 <1394581371.13761.62.camel@snotra.buserror.net>
	 <20140312035954.GB4706@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: CO2PR06CA010.namprd06.prod.outlook.com (10.141.194.168)
 To BLUPR03MB389.namprd03.prod.outlook.com (10.141.78.11)
X-Forefront-PRVS: 0150F3F97D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(189002)(199002)(51704005)(377424004)(50466002)(77096001)(74876001)(77156001)(87266001)(76786001)(76796001)(56816005)(74706001)(74366001)(87976001)(97186001)(92566001)(90146001)(81342001)(81542001)(92726001)(50986001)(85306002)(47976001)(83072002)(85852003)(49866001)(47736001)(50226001)(89996001)(62966002)(80976001)(83322001)(95666003)(79102001)(59766001)(88136002)(74662001)(81686001)(74502001)(47446002)(23676002)(31966008)(63696002)(47776003)(20776003)(93516002)(51856001)(81816001)(46102001)(69226001)(93916002)(95416001)(86362001)(53806001)(33646001)(42186004)(94316002)(94946001)(65816001)(80022001)(56776001)(76482001)(54316002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB389;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:FC44F4B4.2013DC39.3DDB6D7F.94F74B53.201E3;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 11:59 +0800, Chenhui Zhao wrote:
> On Tue, Mar 11, 2014 at 06:42:51PM -0500, Scott Wood wrote:
> > On Fri, 2014-03-07 at 12:57 +0800, Chenhui Zhao wrote:
> > > +int fsl_rcpm_init(void)
> > > +{
> > > +	struct device_node *np;
> > > +
> > > +	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-rcpm-2.0");
> > > +	if (np) {
> > > +		rcpm_v2_regs = of_iomap(np, 0);
> > > +		of_node_put(np);
> > > +		if (!rcpm_v2_regs)
> > > +			return -ENOMEM;
> > > +
> > > +		qoriq_pm_ops = &qoriq_rcpm_v2_ops;
> > > +
> > > +	} else {
> > > +		np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-rcpm-1.0");
> > > +		if (np) {
> > > +			rcpm_v1_regs = of_iomap(np, 0);
> > > +			of_node_put(np);
> > > +			if (!rcpm_v1_regs)
> > > +				return -ENOMEM;
> > > +
> > > +			qoriq_pm_ops = &qoriq_rcpm_v1_ops;
> > > +
> > > +		} else {
> > > +			pr_err("%s: can't find the rcpm node.\n", __func__);
> > > +			return -EINVAL;
> > > +		}
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > 
> > Why isn't this a proper platform driver?
> > 
> > -Scott
> 
> The RCPM is not a single function IP block, instead it is a collection
> of device run control and power management. It would be called by other
> drivers and functions. For example, the callback .freeze_time_base()
> need to be called at early stage of kernel init. Therefore, it would be
> better to init it at early stage.

OK, but consider using of_find_matching_node_and_match().

-Scott


