Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab3DPPGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:06:13 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64567 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3DPPGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:06:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/zokz6lJWJc0G02lHodharM8/EtD22ldg=
Date: Tue, 16 Apr 2013 11:05:37 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Murray <Andrew.Murray@arm.com>
Cc: linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        siva.kallam@samsung.com, linux-pci@vger.kernel.org,
        linus.walleij@linaro.org, thierry.reding@avionic-design.de,
        Liviu.Dudau@arm.com, grant.likely@secretlab.ca, paulus@samba.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        jg1.han@samsung.com, jgunthorpe@obsidianresearch.com,
        thomas.abraham@linaro.org, benh@kernel.crashing.org, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        kgene.kim@samsung.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com, monstr@monstr.eu,
        linux-kernel@vger.kernel.org, suren.reddy@samsung.com
Subject: Re: [PATCH v7 0/3] of/pci: Provide common support for PCI DT
 parsing
Message-ID: <20130416150537.GC28693@titan.lakedaemon.net>
References: <1366107508-12672-1-git-send-email-Andrew.Murray@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366107508-12672-1-git-send-email-Andrew.Murray@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 11:18:25AM +0100, Andrew Murray wrote:
> This patchset factors out duplicated code associated with parsing PCI
> DT "ranges" properties across the architectures and introduces a
> "ranges" parser. This parser "of_pci_range_parser" can be used directly
> by ARM host bridge drivers enabling them to obtain ranges from device
> trees.
> 
> I've included the Reviewed-by and Tested-by's received from v5/v6 in this
> patchset, earlier versions of this patchset (v3) have been tested-by:
> 
> Thierry Reding <thierry.reding@avionic-design.de>
> Jingoo Han <jg1.han@samsung.com>
> 
> I've tested that this patchset builds and runs on ARM and that it builds on
> PowerPC and x86_64.

Series replaces v6 in mvebu/drivers

thx,

Jason.

> 
> Compared to the v6 sent by Andrew Murray, the following changes have
> been made in response to build errors/warnings:
> 
>  * Inclusion of linux/of_address.h in of_pci.c as suggested by Michal
>    Simek to prevent compilation failures on Microblaze (and others) and his
>    ack.
> 
>  * Use of externs, static inlines and a typo in linux/of_address.h in response
>    to linker errors (multiple defination) on x86_64 as spotted by a kbuild test
>    robot on (jcooper/linux.git mvebu/drivers)
> 
>  * Add EXPORT_SYMBOL_GPL to of_pci_range_parser function to be consistent
>    with of_pci_process_ranges function
