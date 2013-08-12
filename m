Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab3HLPeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:34:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:38195 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab3HLPeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:34:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,862,1367996400"; 
   d="scan'208";a="385058765"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: RE: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Thread-Topic: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Thread-Index: AQHOl3EJ+LOhDwhcJk66G4xsErj9mpmRs3Ig
Date: Mon, 12 Aug 2013 15:34:09 +0000
Message-ID: <1DC40B07CD6EC041A66726C271A73AE61AA5EB4C@IRSMSX102.ger.corp.intel.com>
References: <20130812115327.7bcbb203ac8614d16d32ba52@canb.auug.org.au>
 <20130812151514.GD27408@tuxdriver.com>
In-Reply-To: <20130812151514.GD27408@tuxdriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think I have this slightly different in wireless-testing.  Johannes, please
> review and advise...

> > Today's linux-next merge of the wireless-next tree got a conflict in
> > drivers/net/wireless/iwlwifi/pcie/trans.c between commit eabc4ac5d760
> > ("iwlwifi: pcie: disable L1 Active after pci_enable_device") from
> > thewireless tree and commit f2532b04b2ec ("iwlwifi: pcie: don't
> > disable
> > L1 for newest NICs") from the wireless-next tree.
> >
> > I fixed it up (maybe - see below) and can carry the fix as necessary
> > (no action is required).


> > diff --cc drivers/net/wireless/iwlwifi/pcie/trans.c
> > index 390e2f0,e52d1ce..0000000
> > --- a/drivers/net/wireless/iwlwifi/pcie/trans.c
> > +++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
> > @@@ -1502,16 -1400,22 +1400,22 @@@ struct iwl_trans
> *iwl_trans_pcie_alloc(
> >   	spin_lock_init(&trans_pcie->reg_lock);
> >   	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
> >
> >  +	if (pci_enable_device(pdev)) {
> >  +		err = -ENODEV;
> >  +		goto out_no_pci;
> >  +	}
> >  +
> > - 	/* W/A - seems to solve weird behavior. We need to remove this if
> we
> > - 	 * don't want to stay in L1 all the time. This wastes a lot of power */
> > - 	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
> PCIE_LINK_STATE_L1 |
> > - 			       PCIE_LINK_STATE_CLKPM);
> > + 	if (!cfg->base_params->pcie_l1_allowed) {
> > + 		/*
> > + 		 * W/A - seems to solve weird behavior. We need to remove
> this
> > + 		 * if we don't want to stay in L1 all the time. This wastes a
> > + 		 * lot of power.
> > + 		 */
> > + 		pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
> > + 				       PCIE_LINK_STATE_L1 |
> > + 				       PCIE_LINK_STATE_CLKPM);
> > + 	}
> >
> >  -	if (pci_enable_device(pdev)) {
> >  -		err = -ENODEV;
> >  -		goto out_no_pci;
> >  -	}
> >  -
> >   	pci_set_master(pdev);
> >
> >   	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));

This looks fine, and it seems to be exactly what you have in wireless-testing/master. I have yet another change pending to this which removes the err= in favour of taking it from pci_enable_device() though.

johannes
(sorry for the outlook mess - might want to use johannes@sipsolutions.net)
-- 

Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Christian Lamprechter, Hannes Schwaderer, Douglas Lusk
Registergericht: Muenchen HRB 47456
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

