Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbaDIOJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:09:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:58676 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaDIOI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:08:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for pci_host_bridge.
Date: Wed, 09 Apr 2014 16:08:43 +0200
Message-ID: <5040304.p3jyCMi26Y@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAErSpo4BmoYzf6GxOPRni=q563zhON57s7=5Hz=2Cf-X2ft-1A@mail.gmail.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com> <20140409120750.GN985@e106497-lin.cambridge.arm.com> <CAErSpo4BmoYzf6GxOPRni=q563zhON57s7=5Hz=2Cf-X2ft-1A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:iiOCCkCPftdCprsraguw25wOmx9G0SrpuXh+Ea/AeFW
 H5MqHD6oeMkEFTsL8ASk+t2NCDoY7wZA0L72z1abJBUATqo2wB
 tEkUE8xNs5VZar0+rkCZMslDHV/po+EqeS8nLhViKczKNTezHP
 1Jh0tFeMvzvkzsal0kCVF0kofrMa17rITnm/PQEVUzoaLlhkyz
 YcVy0glWWgPu5GpUxJZGYHE6gmPfqHcByOYgF0Wp1X4A7F9KuG
 Tj4LDY+wcB1uZgAX4RPHXqJnh++amugtngGKrH2nZmDCRGooVJ
 B/WdCnix6j+ZirV1otMwcqbSY8ieTDs+B2lDxBGlKilVesSkkb
 U0CAG96bgFWMn3HlERaQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 April 2014 08:02:41 Bjorn Helgaas wrote:
> 
> It's possible we could manage domain numbers in the core.  On ACPI
> systems, we currently we use the ACPI _SEG value as the domain.  In
> some cases, e.g., on ia64, config space access is done via firmware
> interfaces, and those interfaces expect the _SEG values.  We could
> conceivably maintain a mapping between _SEG and domain, but I'm not
> sure there's an advantage there.

I think it's a safe assumption that we will never have more than
one firmware trying to enumerate the domains, so it would be
safe to let ACPI keep doing its own thing for domain numbers,
have the DT code pick domain number using some method we come up
with, and for everything else let the architecture code deal with
it. There are probably very few systems that have multiple domains
but use neither ACPI nor DT.

	Arnd
