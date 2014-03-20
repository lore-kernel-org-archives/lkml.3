Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbaCTRce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:32:34 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:41435 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755381AbaCTRc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:32:29 -0400
Message-ID: <532B2628.5080305@codethink.co.uk>
Date: Thu, 20 Mar 2014 18:32:24 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <damm@opensource.se>, Ben Dooks <ben-linux@fluff.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: DMABOUNCE in pci-rcar
References: <201402241200.21944.arnd@arndb.de> <5527822.QYtFYiIpiW@wuerfel> <532B137B.7010900@codethink.co.uk> <4884083.IuNl44Y6XD@wuerfel> <532B2485.6010005@codethink.co.uk> <20140320173106.GA19395@obsidianresearch.com>
In-Reply-To: <20140320173106.GA19395@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/14 18:31, Jason Gunthorpe wrote:
> On Thu, Mar 20, 2014 at 06:25:25PM +0100, Ben Dooks wrote:
>> So doing:
>>
>> static void pci_rcar_fixup(struct pci_dev *dev)
>> {
>> 	if (dev->bus->ops == &rcar_pci_ops) {
>> 		dev_info(&dev->dev, "applying new dma mask\n");
>> 		dev->dma_mask = DMA_BIT_MASK(31);
>> 	}
>> }
>>
>> DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, pci_rcar_fixup);
>>
>> Did not work for me :(
>
> Seems like it should work, do you have CONFIG_PCI_QUIRKS turned on?

Yes, see the print happening, just still PCI OHCI dies horribly.


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
