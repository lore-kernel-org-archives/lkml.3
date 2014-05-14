Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaENI0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:26:53 -0400
Received: from mail-by2on0098.outbound.protection.outlook.com ([207.46.100.98]:26794
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751253AbaENI0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:26:50 -0400
X-Greylist: delayed 3554 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2014 04:26:50 EDT
X-WSS-ID: 0N5JV2E-08-2RP-02
X-M-MSG: 
Message-ID: <53730504.4080201@amd.com>
Date: Wed, 14 May 2014 00:54:12 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>, "Robert Richter" <rric@kernel.org>,
        Daniel J Blueman <daniel@numascale.com>,
        "Andreas Herrmann" <herrmann.der.user@googlemail.com>
Subject: Re: [PATCH V4 0/4] x86/pci Fix numa_node info for AMD hostbridge
 and misc clean up.
References: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(479174003)(24454002)(51704005)(377454003)(92566001)(21056001)(50466002)(54356999)(92726001)(85852003)(65806001)(101416001)(64706001)(59896001)(77982001)(15975445006)(80022001)(83072002)(47776003)(20776003)(76176999)(65956001)(87936001)(83506001)(97736001)(77096999)(79102001)(65816999)(50986999)(74662001)(31966008)(81542001)(76482001)(74502001)(19580405001)(19580395003)(44976005)(36756003)(23756003)(81342001)(68736004)(86362001)(46102001)(87266999)(99396002)(2009001)(84676001)(4396001)(64126003)(83322001)(102836001)(62816006);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR02MB055;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0211965D06
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,

I am following up on this patch set.  Do you have any other concerns?

Thank you,

Suravee

On 05/08/2014 11:44 AM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> This in the V4 of the patch set which trys to fixed up numa_node for AMD hostbridges.
> This topic was discussed in the following threads:
>
> V1: https://lkml.org/lkml/2014/3/5/898
> V2: https://lkml.org/lkml/2014/4/18/623
> V3: https://lkml.org/lkml/2014/5/7/588
>
> Change from V3:
> Split up the changes in patch1 into two per Robert's suggestions. The second patch has
> no functional change.
>
> Change from V2:
> As requested by Bjorn, the patch set will only add supports for family15h, and
> also deprecating the mechanism, as future platforms should be relying on the ACPI info.
> He has also requested to keep the changes to the minimum. Therefore, the V2 patch 2 and 3
> has been removed.
>
> Suravee Suthikulpanit (2):
>    Patch1: x86/PCI: Fix PCI root numa_node info on AMD family15h
>    Patch2: x86/PCI: Clean up and mark early_root_info_init as deprecated
>
> Myron Stowe (2):
>    Patch3: ACPI/PCI: Warn if we have to "guess" host bridge node information
>    Patch4: X86/PCI: Remove unnecessary 'quirk_amd_nb_node'
>
>   arch/x86/kernel/quirks.c | 58 -------------------------------------
>   arch/x86/pci/acpi.c      |  6 +++-
>   arch/x86/pci/amd_bus.c   | 75 +++++++++++++++++++++++++++++-------------------
>   3 files changed, 51 insertions(+), 88 deletions(-)
>
