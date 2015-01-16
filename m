Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbbAPPyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:54:51 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:52922 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbAPPyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:54:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-acpi@lists.linaro.org
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh@kernel.org>,
        Timur Tabi <timur@codeaurora.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
Date: Fri, 16 Jan 2015 16:53:33 +0100
Message-ID: <1887263.kzglbjcc0t@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150116154913.GW7091@arm.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1809831.d9GPSfLUEN@wuerfel> <20150116154913.GW7091@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:bwTF70bGhHtUtZGUXhtUmUioGOKJPQiyxKfDfEEVuTJAWVnnP/l
 ZT/4GVzS1NN6fGyX1FJQfdLn5llvPzbfw0n6z/+5zFji4y9kGGZRiTusJYisvJWdV7ixI4b
 /XfyrolBzz/kLF37VaY+zoVHZKRoO6YQ6X3ATlZGr2IQ1SBIHsMcZudIr+L/7fKqdmyRO6U
 vP8RMsVs3CnGcWlhe5tNg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2015 15:49:13 Will Deacon wrote:
> 
> The on-board ethernet on Seattle requires the driver to program its AXI
> attributes, so configuring it to be a coherent master actually means
> "program the same cacheable AXI settings as you have on the CPU". That
> sounds like Linux should be doing it to me, but even if the firmware takes
> a guess at "normal cacheable WBRWA", it's not clear to me whether that
> register persists across things like adapter reset.
> 
> Tom?
> 
> There's also the situation where the firmware hasn't initialised the
> register and Linux realises this during probe. What should it do then?

In case of a 10gbit ethernet adapter, there really should be no question
regarding whether to set it coherent or not. Can't Linux just always
set this AXI attribute in the driver?

	Arnd
