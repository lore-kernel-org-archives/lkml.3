Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbaD3SOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:14:44 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:20364
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752186AbaD3SOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:14:43 -0400
Message-ID: <1398881677.24575.197.camel@snotra.buserror.net>
Subject: Re: [PATCH] powerpc 32: Provides VIRT_CPU_ACCOUNTING
From: Scott Wood <scottwood@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Christophe Leroy <christophe.leroy@c-s.fr>,
        Paul Mackerras <paulus@samba.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Wed, 30 Apr 2014 13:14:37 -0500
In-Reply-To: <1398833787.31586.8.camel@pasglop>
References: <20140319215241.236B21A4BDE@localhost.localdomain>
	 <1395266717.12479.293.camel@snotra.buserror.net>
	 <1398833787.31586.8.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:55b5:c8fb:7ca4:3149]
X-ClientProxiedBy: BN1PR02CA0043.namprd02.prod.outlook.com (10.141.56.43) To
 BL2PR03MB388.namprd03.prod.outlook.com (10.141.91.153)
X-Forefront-PRVS: 0197AFBD92
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(51704005)(199002)(189002)(377424004)(79102001)(83072002)(93916002)(33646001)(86362001)(101416001)(50986999)(50466002)(85852003)(87976001)(20776003)(47776003)(50226001)(81542001)(4396001)(81342001)(99396002)(80022001)(80976001)(74662001)(74502001)(31966008)(62966002)(89996001)(92726001)(77982001)(42186004)(87286001)(23676002)(76176999)(77156001)(92566001)(83322001)(76482001)(46102001)(88136002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB388;H:[IPv6:2601:2:5800:3f7:55b5:c8fb:7ca4:3149];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 14:56 +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2014-03-19 at 17:05 -0500, Scott Wood wrote:
> > On Wed, 2014-03-19 at 22:52 +0100, Christophe Leroy wrote:
> > > This patch provides VIRT_CPU_ACCOUTING to PPC32 architecture.
> > > Unlike PPC64, PPC32 doesn't provide the PACA register. Therefore the
> > > implementation is similar to the one done in the IA64 architecture.
> > > It is based on additional information added to the Task Info structure.
> > 
> > PACA isn't a register -- just a convention for how Linux uses a GPR.
> > Maybe it's time to use it on PPC32 as well?
> 
> PACA is actually a data structure and you really really don't want it
> on ppc32 :-) Having a register point to current works, having a register
> point to per-cpu data instead works too (ie, change what we do today),
> but don't introduce a PACA *please* :-)

What is special about 64-bit that warrants doing things differently from
32-bit?

What is the difference between PACA and "per-cpu data", other than the
obscure name?
 
-Scott


