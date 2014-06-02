Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaFBTQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:16:12 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52120 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaFBTQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:16:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kumar Gala <galak@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 1/2] pci: Add IORESOURCE_BIT entry for PCIe ECAM resources.
Date: Mon, 02 Jun 2014 21:15:46 +0200
Message-ID: <4495090.ktpdXEyibD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2F6515B1-48FE-4ED6-908E-CC1CAD7AF403@codeaurora.org>
References: <20140530233034.GH1677@bart.dudau.co.uk> <20140602162306.4AB0FC40476@trevor.secretlab.ca> <2F6515B1-48FE-4ED6-908E-CC1CAD7AF403@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:kbANSz/rmYJN5ZcEmBjqAEJHmCob8MGiJb4VYYew7Uo
 /9YoqAcqiT5yzYKqdYBCOlQhqUPP3D8x+txv1729KqBBMqTqxK
 vqOG+DuwnBc28GODLMf3/h9oAEtSMgKTnlU8eJfjS7UukgElqs
 bKKSGD89yrUt6M6M4JC9RW2wsBa2ZffZ0n7vfygaI0W8nYFc0U
 4jdo6w7JgGKwIfAlfSIehmcfEVMuK0+XAAJgXueBpO5IAMBA6Q
 /wfE/9ZRJJ9XjiOBHyz4I6q1nq+CzIW+ZLgQ6AMdZ9AlwG+Wm7
 p16hyrxuYYfObyIgcfRBmihYH623nz6dQ35gyQoZjAjvkts6p7
 3BmaMIfQ/3XS7qDHFjxM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2014 13:09:08 Kumar Gala wrote:
> > However, what do we do with the 2 cases that exist in upstream that
> >> are using ranges for cfg space?
> > 
> > Ignore them in the core code? Make the specific host controller handle
> > them I would think.
> 
> I just meant, should we ‘break’ their DTs and move them from using ranges to reg?

dw-pcie is used on a lot of systems, I think we should make the common
part of that driver always handle config space in a common way, and
move out the part that parses the ranges property into the individual
soc-specific glue drivers that want to keep optional backwards compatibility
with existing dtbs.

Which one is the other driver?

	Arnd
