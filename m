Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaKKPtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:49:00 -0500
Received: from mail-by2on0107.outbound.protection.outlook.com ([207.46.100.107]:47904
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751771AbaKKPs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:48:57 -0500
X-Greylist: delayed 899 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Nov 2014 10:48:56 EST
X-WSS-ID: 0NEVSKD-08-ZTS-02
X-M-MSG: 
Message-ID: <54622C58.1040701@amd.com>
Date: Tue, 11 Nov 2014 22:33:44 +0700
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] PCI: generic: Add set_msi_parent callback
References: <1415647480-3320-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1415647480-3320-3-git-send-email-suravee.suthikulpanit@amd.com>
 <20141111112424.GB16265@arm.com>
In-Reply-To: <20141111112424.GB16265@arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(189002)(199003)(479174003)(24454002)(164054003)(120916001)(46102003)(59896002)(83506001)(65816999)(86362001)(87266999)(50986999)(54356999)(92726001)(76176999)(107046002)(110136001)(50466002)(68736004)(92566001)(99136001)(36756003)(80316001)(44976005)(87936001)(23746002)(33656002)(31966008)(102836001)(99396003)(95666004)(62966003)(65956001)(21056001)(105586002)(97736003)(106466001)(20776003)(47776003)(4396001)(101416001)(84676001)(64706001)(77156002)(77096003)(65806001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Forefront-PRVS: 0392679D18
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/14 18:24, Will Deacon wrote:
>> @@ -313,6 +324,9 @@ static int gen_pci_probe(struct platform_device *pdev)
>> >  		return err;
>> >  	}
>> >
>> >+	pci->mchip = of_pci_find_msi_chip_by_node(of_parse_phandle(np,
>> >+						  "msi-parent", 0));
> This bit should be in the generic of_pci.c code and not duplicated for
> each host controller.
>
> Will

I forgot to mention and include in the patch that we are also 
introducing "msi-parent" binding to the generic host controller. I'll do 
that in v2.

Unless this is something that we would like to add to the generic OF 
binding for PCI, I think it should be in the pci-host-generic.c.

Thanks,
Suravee
