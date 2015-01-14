Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbbANOtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:49:03 -0500
Received: from smtp-out6.electric.net ([192.162.217.184]:54047 "EHLO
	smtp-out6.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbbANOtB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:49:01 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'David Miller'" <davem@davemloft.net>,
        "lambert.quentin@gmail.com" <lambert.quentin@gmail.com>
CC: "chas@cmf.nrl.navy.mil" <chas@cmf.nrl.navy.mil>,
        "linux-atm-general@lists.sourceforge.net" 
	<linux-atm-general@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] atm: remove deprecated use of pci api
Thread-Topic: [PATCH v2 1/1] atm: remove deprecated use of pci api
Thread-Index: AQHQL6YtnKU7gOXE/Umeh4mrY5nVG5y/sdLA
Date: Wed, 14 Jan 2015 14:47:28 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CAC79B3@AcuExch.aculab.com>
References: <20150112161042.GA11374@sloth>
 <20150113.215944.1703977685948196746.davem@davemloft.net>
In-Reply-To: <20150113.215944.1703977685948196746.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Outbound-IP: 213.249.233.130
X-Env-From: David.Laight@ACULAB.COM
X-PolicySMART: 3396946, 3397078
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller
> From: Quentin Lambert <lambert.quentin@gmail.com>
> Date: Mon, 12 Jan 2015 17:10:42 +0100
> 
> > @@ -2246,7 +2246,8 @@ static int eni_init_one(struct pci_dev *pci_dev,
> >  		goto err_disable;
> >
> >  	zero = &eni_dev->zero;
> > -	zero->addr = pci_alloc_consistent(pci_dev, ENI_ZEROES_SIZE, &zero->dma);
> > +	zero->addr = dma_alloc_coherent(&pci_dev->dev, ENI_ZEROES_SIZE,
> > +					&zero->dma, GFP_ATOMIC);
> >  	if (!zero->addr)
> >  		goto err_kfree;
> >
> 
> I really would like you to look at these locations and see if
> GFP_KERNEL can be used instead of GFP_ATOMIC.  I bet that nearly
> all of these can, and it is preferred.

And there isn't much point inlining the wrapper until that has been done.
Not only that, the corresponding pci_free_consistent() calls need changing
at (much) the same time.

	David

