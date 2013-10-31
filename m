Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3JaM5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:57:21 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:45049 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753970Ab3JaM5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:57:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18K5MaqfQDhtl584yY3TVRGwCBB6XnyUaQ=
Date: Thu, 31 Oct 2013 08:57:13 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 devicetree tree
Message-ID: <20131031125713.GK26784@titan.lakedaemon.net>
References: <20131031192354.32945644fbdca2e0d6ca5455@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031192354.32945644fbdca2e0d6ca5455@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

Glad to see you're back at it!  Nice meeting you and your wife in
Edinburgh.

Adding Thomas Petazzoni to the Cc.

On Thu, Oct 31, 2013 at 07:23:54PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/pci/host/pci-mvebu.c between commit 16b84e5a505c ("of/irq: Create
> of_irq_parse_and_map_pci() to consolidate arch code.") from the
> devicetree tree and commit e5615c30c1c9 ("PCI: mvebu: remove
> subsys_initcall") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

This looks fine by me.

thx,

Jason.

> diff --cc drivers/pci/host/pci-mvebu.c
> index 07ddb3a13c6e,80b2250ea19a..000000000000
> --- a/drivers/pci/host/pci-mvebu.c
> +++ b/drivers/pci/host/pci-mvebu.c
> @@@ -693,9 -732,10 +719,10 @@@ static void mvebu_pcie_enable(struct mv
>   	hw.private_data   = (void **)&pcie;
>   	hw.setup          = mvebu_pcie_setup;
>   	hw.scan           = mvebu_pcie_scan_bus;
>  -	hw.map_irq        = mvebu_pcie_map_irq;
>  +	hw.map_irq        = of_irq_parse_and_map_pci;
>   	hw.ops            = &mvebu_pcie_ops;
>   	hw.align_resource = mvebu_pcie_align_resource;
> + 	hw.add_bus        = mvebu_pcie_add_bus;
>   
>   	pci_common_init(&hw);
>   }


