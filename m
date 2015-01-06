Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbbAFPYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:24:34 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:42021 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbbAFPYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:24:32 -0500
Message-ID: <54ABFE26.9010208@mm-sol.com>
Date: Tue, 06 Jan 2015 17:24:22 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 5/5] ARM: qcom: Add Qualcomm APQ8084 SoC
References: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com> <1418404441-5518-6-git-send-email-svarbanov@mm-sol.com> <1671186.DiHNtkP1SP@wuerfel>
In-Reply-To: <1671186.DiHNtkP1SP@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for the comments!

On 12/12/2014 07:33 PM, Arnd Bergmann wrote:
> On Friday 12 December 2014 19:14:01 Stanimir Varbanov wrote:
>> +config ARCH_APQ8084
>> +       bool "Enable support for APQ8084"
>> +       select HAVE_ARM_ARCH_TIMER
>> +       select PCI
>> +       select PCI_DOMAINS
>> +       select PCI_MSI
>> +
> 
> I would prefer not to see 'select PCI' here. Also the driver is written
> to work without PCI_MSI, so I'd be much happier with just
> 
> config ARCH_APQ8084
> 	bool "Enable support for APQ8084"
> 	select HAVE_ARM_ARCH_TIMER
> 	select PCI_DOMAINS if PCI

What about this

config ARCH_APQ8084
	bool "Enable support for APQ8084"
	select HAVE_ARM_ARCH_TIMER
	select MIGHT_HAVE_PCI
	select PCI_DOMAINS if PCI

-- 
regards,
Stan
