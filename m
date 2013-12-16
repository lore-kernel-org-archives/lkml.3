Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3LPW5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 17:57:31 -0500
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:47602
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750935Ab3LPW50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 17:57:26 -0500
Message-ID: <1387234621.10013.408.camel@snotra.buserror.net>
Subject: Re: [PATCH v2] powerpc 8xx: Loading kernels over 8Mbytes without
 CONFIG_PIN_TLB
From: Scott Wood <scottwood@freescale.com>
To: leroy christophe <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Mon, 16 Dec 2013 16:57:01 -0600
In-Reply-To: <52A7A58F.8090705@c-s.fr>
References: <20131210112945.E4E311A2BF3@localhost.localdomain>
	 <1386714253.10013.123.camel@snotra.buserror.net> <52A79E31.9070304@c-s.fr>
	 <1386717537.10013.150.camel@snotra.buserror.net> <52A7A58F.8090705@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR04CA005.namprd04.prod.outlook.com (10.255.226.25) To
 DM2PR03MB399.namprd03.prod.outlook.com (10.141.84.148)
X-Forefront-PRVS: 0062BDD52C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(479174003)(24454002)(199002)(189002)(51704005)(377424004)(54316002)(76786001)(62966002)(74706001)(80022001)(76796001)(65816001)(80976001)(79102001)(90146001)(56776001)(59766001)(77982001)(47776003)(81342001)(81686001)(83322001)(23676002)(87286001)(87976001)(74366001)(53806001)(42186004)(76482001)(63696002)(50466002)(69226001)(81542001)(56816005)(89996001)(50226001)(4396001)(50986001)(47976001)(47736001)(49866001)(88136002)(31966008)(74662001)(47446002)(74502001)(51856001)(46102001)(83072002)(85852003)(77096001)(77156001)(85306002)(87266001)(74876001)(81816001)(33646001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB399;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 00:36 +0100, leroy christophe wrote:
> Le 11/12/2013 00:18, Scott Wood a écrit :
> > There wasn't previously an ifdef specifically around the setting of
> > SPRN_MD_CTR.  That's new.  There was an ifdef around the entire block,
> > which has gone away because you are now trying to map more than 8M
> > regardless of CONFIG_PIN_TLB, but that has nothing to do with whether
> > there should be an ifdef around SPRN_MD_CTR.
> >
> >
> Euh, ok, but then we have to fix it in the whole function, not only in 
> this block. Do you think it is worth doing it ?

Fix what in the whole function?  I was asking what harm there would be
if you just remove all the CONFIG_PIN_TLB ifdefs except around the
actual RSV4I setting -- do we really care what value goes in MD_CTR for
the non-pinned case, as long as it's different for each entry?

-Scott


