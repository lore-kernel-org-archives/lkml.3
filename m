Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaACAE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:04:28 -0500
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:2004
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751966AbaACAE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:04:26 -0500
Message-ID: <1388707457.11795.32.camel@snotra.buserror.net>
Subject: Re: commit e38c0a1f breaks powerpc boards with uli1575 chip
From: Scott Wood <scottwood@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Dmitry Krivoschekov <dkrivoschokov@dev.rtsoft.ru>,
        "Alexey Lugovskoy" <lugovskoy@dev.rtsoft.ru>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-kernel@vger.kernel.org>, "Rob Herring" <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Thu, 2 Jan 2014 18:04:17 -0600
In-Reply-To: <1388373200.4373.25.camel@pasglop>
References: <201312171135.38576@blacky.localdomain>
	 <52B1EC15.5070606@gmail.com> <201312190842.02702@blacky.localdomain>
	 <1388373200.4373.25.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BY2PR01CA015.prod.exchangelabs.com (10.242.234.173) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 00808B16F3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(24454002)(377424004)(51704005)(199002)(189002)(83322001)(77156001)(4396001)(49866001)(47736001)(50226001)(77096001)(50986001)(47976001)(87976001)(87266001)(87286001)(81686001)(81816001)(80976001)(74876001)(74706001)(50466002)(76796001)(76786001)(85306002)(81342001)(81542001)(69226001)(62966002)(83072002)(85852003)(56816005)(88136002)(90146001)(89996001)(33646001)(74366001)(65816001)(31966008)(74502001)(74662001)(80022001)(54316002)(59766001)(77982001)(47776003)(63696002)(47446002)(79102001)(56776001)(53806001)(46102001)(51856001)(76482001)(42186004)(23676002)(3826001)(505234006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-30 at 14:13 +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2013-12-19 at 08:42 +0400, Nikita Yushchenko wrote:
> > No, this does not help.
> > 
> > I've dumped the actual content of 'range' and 'addr' at the failure
> > point 
> > (i.e. ar point that returns error with e38c0a1f but passes without 
> > e38c0a1f ):
> > 
> > OF: default map, cp=0, s=10000, da=70
> > range:  01 00 00 00 00 00 00 00 00 00 00 00
> >  addr:  00 00 00 00 00 00 00 00 00 00 00 70
> 
> Something that has a #address-cells larger than 2, or more generally,
> an address field that contains more than a single number, must have
> a specific translation backend, like we have for PCI.
> 
> This is a bit annoying but originates from the original OFW stuff on
> which this stuff is based where the bus node would provide the methods
> for translation.

I can maybe see that for PCI which has a special encoding, but why is it
always needed?  E.g. if Freescale localbus had a 64-bit offset instead
of 32-bit, the child nodes would have 3 address cells, but
straightforward use of ranges would bring it down to 2 for the final
physical address.  Existing localbus nodes already have "an address
field that contains more than a single number"; it's just a simple
enough encoding that it works to treat it as if it were a single large
number.

-Scott


