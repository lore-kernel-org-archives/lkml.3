Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbbAUTvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:51:17 -0500
Received: from mail-bn1on0071.outbound.protection.outlook.com ([157.56.110.71]:53248
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752806AbbAUTvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:51:10 -0500
X-Greylist: delayed 8274 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2015 14:51:09 EST
Message-ID: <54BFDF2B.80708@caviumnetworks.com>
Date: Wed, 21 Jan 2015 09:17:31 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: David Daney <ddaney.cavm@gmail.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        "Anton Vorontsov" <avorontsov@ru.mvista.com>,
        Vinita Gupta <vgupta@caviumnetworks.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Ralf Baechle <ralf@linux-mips.org>, Tejun Heo <tj@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] SATA: OCTEON: support SATA on OCTEON platform
References: <1421681040-3392-1-git-send-email-aleksey.makarov@auriga.com> <20150119154357.GH21553@leverpostej> <54BD580C.6030701@gmail.com> <20150121165427.GA8722@leverpostej>
In-Reply-To: <20150121165427.GA8722@leverpostej>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.194]
X-ClientProxiedBy: BLUPR07CA095.namprd07.prod.outlook.com (25.160.24.50) To
 BY1PR0701MB1110.namprd07.prod.outlook.com (25.160.104.20)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=David.Daney@caviumnetworks.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY1PR0701MB1110;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY1PR0701MB1110;
X-Forefront-PRVS: 04631F8F77
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(979002)(6009001)(24454002)(189002)(199003)(51704005)(57704003)(164054003)(479174004)(377454003)(110136001)(2950100001)(36756003)(64126003)(87976001)(23756003)(105586002)(106356001)(50986999)(62966003)(77156002)(76176999)(69596002)(65816999)(81156004)(33656002)(54356999)(68736005)(65806001)(65956001)(66066001)(47776003)(122386002)(64706001)(40100003)(42186005)(92566002)(83506001)(97736003)(93886004)(101416001)(53416004)(50466002)(46102003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0701MB1110;H:dl.caveonetworks.com;FPR:;SPF:None;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0701MB1110;
X-OriginatorOrg: caviumnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2015 17:17:36.1242 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0701MB1110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 08:54 AM, Mark Rutland wrote:
> On Mon, Jan 19, 2015 at 07:16:28PM +0000, David Daney wrote:
[...]
>>>> @@ -67,6 +76,7 @@ static const struct of_device_id ahci_of_match[] = {
>>>>    	{ .compatible = "ibm,476gtr-ahci", },
>>>>    	{ .compatible = "snps,dwc-ahci", },
>>>>    	{ .compatible = "hisilicon,hisi-ahci", },
>>>> +	{ .compatible = "cavium,octeon-7130-ahci", },
>>>>    	{},
>>>
>>> I was under the impression that the strings other than "generic-ahci"
>>> were only for compatibility with existing DTBs. Why do we need to add
>>> new platform-specific strings here?
>>
>> Because it is an "existing DTB", The device tree doesn't contain the
>> compatible property of "generic-ahci", only "cavium,octeon-7130-ahci".
>
> While the DTB may already exist, the string "cavium,octeon-7130-ahci"
> isn't in mainline, and as far as I can see has never been supported.

There seems to be a disconnect here.  The DTB comes from the hardware 
boot environment.  The hardware is in some cases already deployed.  It 
is for all practical purposes, impossible to change the DTB.

The idea that the kernel source code controls the content of the device 
tree doesn't apply here.

> We
> _maintain_ support for existing DTBs, we don't just copy what some
> forked kernel happens to do.
>
> Trying to push that under the "don't break existing DTBs" rule is
> bending the definition.

The purpose of the kernel is to provide services on top of actual 
hardware.  In general, for a kernel driver to support any given device, 
it may have to add device specific identifiers, that correspond to the 
device, in the probing code.

David Daney

>
> Thanks,
> Mark.
>
>

