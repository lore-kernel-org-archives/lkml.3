Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaEHOkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:40:04 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:42951
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753710AbaEHOkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:40:01 -0400
X-WSS-ID: 0N59FEK-07-3UJ-02
X-M-MSG: 
Message-ID: <536B973B.2000207@amd.com>
Date: Thu, 8 May 2014 09:39:55 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>,
        "Daniel J Blueman" <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH V3 1/3] x86/PCI: Fix PCI root numa_node info on AMD family15h
References: <1399489127-6961-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1399489127-6961-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20140508085905.GK32718@rric.localhost>
 <20140508090148.GL32718@rric.localhost>
In-Reply-To: <20140508090148.GL32718@rric.localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(377454003)(51704005)(24454002)(479174003)(46102001)(87936001)(87266999)(76482001)(77096999)(77982001)(76176999)(54356999)(50986999)(101416001)(97736001)(59896001)(81542001)(65816999)(36756003)(83322001)(68736004)(65806001)(92566001)(83506001)(4396001)(64706001)(81342001)(79102001)(64126003)(20776003)(84676001)(2009001)(99396002)(47776003)(65956001)(50466002)(19580405001)(19580395003)(33656001)(44976005)(23756003)(80022001)(86362001)(92726001)(31966008)(74662001)(21056001)(83072002)(85852003)(74502001)(3076001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR02MB119;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0205EDCD76
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/2014 4:01 AM, Robert Richter wrote:
> On 08.05.14 10:59:05, Robert Richter wrote:
>> On 07.05.14 13:58:45, suravee.suthikulpanit@amd.com wrote:
>>> @@ -113,10 +122,17 @@ static int __init early_fill_mp_bus_info(void)
>>>   		info = alloc_pci_root_info(min_bus, max_bus, node, link);
>>>   	}
>>>
>>> +	/*
>>> +	 * The following code is only supported until Fam11h.
>>> +	 * Newer processors will depend on ACPI MCFG table instead.
>>> +	 */
>>> +	if (boot_cpu_data.x86 > 0x11)
>>> +		return 0;
>>> +
>>>   	/* get the default node and link for left over res */
>>
>> As this is the only substantial change of your patch, I would better
>> drop ther rest or at least split it in two patches. Should this change
>> also be for stable?
>
> Of course adding the hostbridge must be also part of the patch, didn't
> note this due to the other noise. See why the split would be good?
>
>>
>> -Robert


Robert,

I have already added the hostbridge for family15h in this patch.

+static struct amd_hostbridge hb_probes[] __initdata = {
+	{ 0, 0x18, 0x1100 }, /* K8 */
+	{ 0, 0x18, 0x1200 }, /* Family10h */
+	{ 0xff, 0, 0x1200 }, /* Family10h */
+	{ 0, 0x18, 0x1300 }, /* Family11h */
+	{ 0, 0x18, 0x1600 }, /* Family15h */ <--- HERE
  };

The rest of the changes are mostly comments, some minor renaming of 
variables for clarity, and replace hardcode values with preprocessor 
macro.  If needed, I can split them.

Suravee
