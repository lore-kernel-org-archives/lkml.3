Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaCBB0j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 20:26:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:57874 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbaCBB0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 20:26:37 -0500
Message-ID: <1393723559.12039.3.camel@pasglop>
Subject: Re: [PATCH v2 4/4] pci: Add support for creating a generic
 host_bridge from device tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Date: Sun, 02 Mar 2014 12:25:59 +1100
In-Reply-To: <1393723415.12039.1.camel@pasglop>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com>
	 <1393506402-11474-5-git-send-email-Liviu.Dudau@arm.com>
	 <18746655.qWHLpMg2Yy@wuerfel> <1393543924.14012.56.camel@pasglop>
	 <20140228095559.GU1692@e106497-lin.cambridge.arm.com>
	 <1393723415.12039.1.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-02 at 12:23 +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2014-02-28 at 09:55 +0000, Liviu Dudau wrote:
> > The next phase will be to see how much of the pci_controller structure can move
> > into the generic code and reduce its size. I do suffer from not having a PowerPC
> > platform where I can test the changes, but I can produce some compiled code that
> > someone can test.
> 
> Ok, we can probably start from there. I think the right approach is to actually
> kill pci_controller by merging it with the new host bridge structure.
> 
> Most of the resources are there now, we need to move the rest. We probably will
> need a way to attach platform specific bits to it though, and a few hooks to
> populate them but that isn't terribly hard.

Oh and regarding testing...

qemu should help. For qemu ppc64, try -M pseries, that's fairly well
maintained since it's the basis for all our new KVM based products,
and there's still some (hopefully) working 32-bit mac stuff in there.

With pseries, I would expect that you can install fedora, debian or
ubuntu (in fact you can also install SLES11/RHEL6 I believe).

Cheers,
Ben.


