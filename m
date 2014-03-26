Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaCZO2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:28:46 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:63866 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbaCZO2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:28:43 -0400
MIME-Version: 1.0
In-Reply-To: <1395270762-6055-3-git-send-email-tinamdar@apm.com>
References: <1395270762-6055-1-git-send-email-tinamdar@apm.com>
	<1395270762-6055-3-git-send-email-tinamdar@apm.com>
Date: Wed, 26 Mar 2014 09:28:42 -0500
Message-ID: <CAL_Jsq+XxAtUeNKFi0hH=ehb_fhFvkM0U1Zm_j1LdtQZbvSzfA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] arm64: dts: APM X-Gene PCIe device tree nodes
From: Rob Herring <robherring2@gmail.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 6:12 PM, Tanmay Inamdar <tinamdar@apm.com> wrote:
> This patch adds the device tree nodes for APM X-Gene PCIe controller and
> PCIe clock interface. Since X-Gene SOC supports maximum 5 ports, 5 dts
> nodes are added.

[snip]

> +               pcie0: pcie@1f2b0000 {
> +                       status = "disabled";
> +                       device_type = "pci";
> +                       compatible = "apm,xgene-storm-pcie", "apm,xgene-pcie";
> +                       #interrupt-cells = <1>;
> +                       #size-cells = <2>;
> +                       #address-cells = <3>;
> +                       reg = < 0x00 0x1f2b0000 0x0 0x00010000   /* Controller registers */
> +                               0xe0 0xd0000000 0x0 0x00200000>; /* PCI config space */

Where is the right place for config space? This binding has it here
and others have it in ranges. Given that config space type is defined
for ranges, I would think that is the right place. But Liviu's patches
do not process config space entries in ranges. Perhaps we need a
config space resource populated in the bridge struct.

Rob


> +                       reg-names = "csr", "cfg";
> +                       ranges = <0x01000000 0x00 0x00000000 0xe0 0x00000000 0x00 0x00010000   /* io */
> +                                 0x02000000 0x00 0x10000000 0xe0 0x10000000 0x00 0x80000000>; /* mem */
