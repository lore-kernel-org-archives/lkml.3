Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab3LQWid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:38:33 -0500
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:39397
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752003Ab3LQWic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:38:32 -0500
Message-ID: <1387319904.10013.482.camel@snotra.buserror.net>
Subject: Re: [PATCH v2] powerpc 8xx: Loading kernels over 8Mbytes without
 CONFIG_PIN_TLB
From: Scott Wood <scottwood@freescale.com>
To: leroy christophe <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Tue, 17 Dec 2013 16:38:24 -0600
In-Reply-To: <52AFE70D.70407@c-s.fr>
References: <20131210112945.E4E311A2BF3@localhost.localdomain>
	 <1386714253.10013.123.camel@snotra.buserror.net> <52A79E31.9070304@c-s.fr>
	 <1386717537.10013.150.camel@snotra.buserror.net> <52A7A58F.8090705@c-s.fr>
	 <1387234621.10013.408.camel@snotra.buserror.net> <52AFE70D.70407@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR02CA004.namprd02.prod.outlook.com (10.141.66.14) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 006339698F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(51704005)(479174003)(189002)(199002)(377424004)(24454002)(23676002)(50986001)(90146001)(42186004)(53806001)(85306002)(89996001)(56816005)(80976001)(51856001)(76482001)(49866001)(79102001)(63696002)(83322001)(81816001)(47776003)(47736001)(4396001)(65816001)(47976001)(81686001)(69226001)(46102001)(87976001)(59766001)(88136002)(85852003)(77096001)(87266001)(77982001)(54316002)(87286001)(74366001)(56776001)(76786001)(83072002)(80022001)(81542001)(31966008)(74502001)(74662001)(47446002)(81342001)(74706001)(50226001)(76796001)(77156001)(50466002)(74876001)(33646001)(62966002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 06:54 +0100, leroy christophe wrote:
> Le 16/12/2013 23:57, Scott Wood a écrit :
> > On Wed, 2013-12-11 at 00:36 +0100, leroy christophe wrote:
> >> Le 11/12/2013 00:18, Scott Wood a écrit :
> >>> There wasn't previously an ifdef specifically around the setting of
> >>> SPRN_MD_CTR.  That's new.  There was an ifdef around the entire block,
> >>> which has gone away because you are now trying to map more than 8M
> >>> regardless of CONFIG_PIN_TLB, but that has nothing to do with whether
> >>> there should be an ifdef around SPRN_MD_CTR.
> >>>
> >>>
> >> Euh, ok, but then we have to fix it in the whole function, not only in
> >> this block. Do you think it is worth doing it ?
> > Fix what in the whole function?  I was asking what harm there would be
> > if you just remove all the CONFIG_PIN_TLB ifdefs except around the
> > actual RSV4I setting -- do we really care what value goes in MD_CTR for
> > the non-pinned case, as long as it's different for each entry?
> >
> >
> MD_CTR is decremented after each entry added.
> However, the function populates entry 28, then 29, then 30, then 31. At 
> the end MD_CTR has then value 30, ready to overide entry 30 then 29 then 
> 28 then 27 .....
> 
> So I will remove all the CONFIG_PIN_TLB, but I'll also have to fix the 
> value set in MD_CTR to start from 31, won't I ?

OK, so the answer is that we rely on autodecrement avoiding entries over
28 in the CONFIG_PIN_TLB case.  Leave the ifdefs, then.

> Do you have any comment/recommendation on my tentative v3 patch where I 
> have tried to implement based on the use of r7 as you recommended ?

I haven't reviewed it yet.

-Scott


