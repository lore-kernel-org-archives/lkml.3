Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaG1NDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:03:01 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:59417 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaG1NC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:02:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Srikanth Thokala <sthokal@xilinx.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        svemula@xilinx.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>, anirudh@xilinx.com,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v5] pcie: Add Xilinx PCIe Host Bridge IP driver
Date: Mon, 28 Jul 2014 15:02:52 +0200
Message-ID: <8258903.Rn4s07GKGV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CA+mB=1JhDF=BBXcyTbgVB8S7qH=Mb1JH78HLL4pA9OBH19hQvA@mail.gmail.com>
References: <1406131381-25577-1-git-send-email-sthokal@xilinx.com> <CA+mB=1JhDF=BBXcyTbgVB8S7qH=Mb1JH78HLL4pA9OBH19hQvA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:oX9G7BcyooVrPZfPwpX3q0O7wsx/d7mUvsAz1cs/34q
 jySYUovp7L4aCPD6+segMV4En2+s6i+Ux7Vmz2RDa93hgzvcjr
 8ajmtzgB3Lb68OzPeaOOs2rL0lqs587shgkeKmCgpes5z0Gk7N
 ktSvGzuMnFavuM3wp1F38qEIwlCPrlsVEboDHN/h0x+aSnAhsb
 OoS1B+ZUfiyv2Rtey6k8TmtgYadGLlRhHQnRw2ViZmRo32KWPU
 rwyBcevgKOaECSbv5rAl7u13a2dy8omse+YF7jozpsDII0bmYz
 aTWJefP9f3YI0q+bnTuyGeHhIOm77ES8w2zZlK02rdJvXdTZsZ
 zUhCjpCCWvr0UzZAnE8o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2014 18:04:34 Srikanth Thokala wrote:
> Hi Arnd and Rob,
> 
> I discussed with Bjorn and we believe this patch is in good shape to
> apply.  And Bjorn requires ACKs to apply this patch.  So, could you
> guys please review this patch and provided your ACKs to this patch.

Looks great for the most part. I've looked through the whole driver
again, and I have two small issues remaining:

a) Please clarify in the changeset description why there is no support
   for PCI I/O space. 

b) I think you should use the 'msi-parent' property, and the
   of_pci_find_msi_chip_by_node() to find the msi_chip for the
   PCI controller. This will make it possible to forward MSIs
   to the main interrupt controller in the system, which is more
   efficient. See the pcie-mvebu driver for an example of this.

Other than these:

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
