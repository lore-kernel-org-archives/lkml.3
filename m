Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaIXQG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:06:58 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54875 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaIXQGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:06:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, Liviu Dudau <liviu.dudau@arm.com>,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>,
        Sunil Goutham <sgoutham@cavium.com>
Subject: Re: [PATCH 3/6] pci, thunder: Add PCIe host controller devicetree bindings
Date: Wed, 24 Sep 2014 18:06:04 +0200
Message-ID: <3082935.e3X4GsVUDn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411573068-12952-4-git-send-email-rric@kernel.org>
References: <1411573068-12952-1-git-send-email-rric@kernel.org> <1411573068-12952-4-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ig5lUCqvvjBJTo/1M7fK/j0jt8HALfN8cvEUn08O+QA
 w06r+erBCZmc5pHw7fUlP4t6rSwNaeiy3Zo+yN3fBthKKtZ6lT
 zMy8p/C7CZzqbpTIycauMl4xiKeHnhR8oPsYF8/XixBlTzEf74
 1cPDpSyocM8sLVb0nigSh65BDnydM+F42vIZU8yXaxm22k+jPm
 V8VBmhnGv/tCkF2dhTMDjpA+XMUZWdcHr3IQ1XnDpRpJSRT6To
 3FhUIBS0xJdlVoOtrD7Phx5qJeA9isP8p0oD31poJfk/6SZglp
 0ZUbJ17J4WpL7ot7wTzUR9KAok0ILchFpILVreqmuFNvgB7a2B
 qh+nx7REHuEKSbI09jqQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014 17:37:45 Robert Richter wrote:
> 
> +       pcie0@0x8480,00000000 {

The name should be pci, not pci0.

> +               compatible = "cavium,thunder-pcie";
> +               device_type = "pci";
> +               msi-parent = <&its>;
> +               bus-range = <0 255>;
> +               #size-cells = <2>;
> +               #address-cells = <3>;
> +               reg = <0x8480 0x00000000 0 0x10000000>;  /* Configuration space */
> +               ranges = <0x03000000 0x8010 0x00000000 0x8010 0x00000000 0x70 0x00000000>, /* mem ranges */
> +                       <0x03000000 0x8300 0x00000000 0x8300 0x00000000 0x80 0x00000000>,
> +                       <0x03000000 0x87e0 0x00000000 0x87e0 0x00000000 0x01 0x00000000>;
> +        };

If you claim the entire 0-255 bus range, I think you should also
specify a domain, otherwise it's not predictable which domain you
get.

The interrupt-map and interrupt-map-mask properties are required for PCI,
otherwise you can't do LSI interrupts.

If your hardware can support it, you should also list I/O space and prefetchable
memory spaces. Can you explain why you have multiple non-prefetchable ranges?

	Arnd
