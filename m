Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbaJCOkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:40:10 -0400
Received: from mail-bn1on0141.outbound.protection.outlook.com ([157.56.110.141]:32922
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752224AbaJCOkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:40:06 -0400
X-WSS-ID: 0NCVI2L-08-HCJ-02
X-M-MSG: 
Message-ID: <542EB53E.30507@amd.com>
Date: Fri, 3 Oct 2014 09:39:58 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <tglx@linutronix.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <bp@suse.de>,
        <dan.carpenter@oracle.com>, <dougthompson@xmission.com>,
        <m.chehab@samsung.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] edac, amd64_edac: Add F15h M60h support
References: <1411070230-10298-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141001113235.GC18271@pd.tnic> <542C1EAA.4050408@amd.com>
 <20141001154523.GF18271@pd.tnic>
In-Reply-To: <20141001154523.GF18271@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(57704003)(189002)(164054003)(24454002)(479174003)(377454003)(68736004)(92566001)(92726001)(20776003)(47776003)(64706001)(80022003)(76176999)(50986999)(65816999)(54356999)(86362001)(85852003)(44976005)(84676001)(105586002)(10300001)(107046002)(95666004)(46102003)(99396003)(101416001)(106466001)(102836001)(83506001)(23676002)(76482002)(21056001)(4396001)(36756003)(85306004)(93886004)(50466002)(65806001)(120886001)(120916001)(87936001)(31966008)(33656002)(97736003)(110136001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Forefront-PRVS: 0353563E2B
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/2014 10:45 AM, Borislav Petkov wrote:
> On Wed, Oct 01, 2014 at 10:32:58AM -0500, Aravind Gopalakrishnan wrote:
>>>> +			if (dcsm & 0x3) {
>>>> +				/* LRDIMMs */
>>>> +				edac_dbg(1, "  DIMM type: LRDIMM %dx rank multiply;"
>>>> +					 "CS = %d; all DIMMs support ECC: %s\n",
>>>> +					 (dcsm & 0x3), cs,
>>>> +					 (dclr & BIT(19)) ? "yes" : "no");
>>> Why do we need to iterate over the DRAM CS sets? Just for the rank
>>> multiplier, apparently. We dump those normally in read_dct_base_mask(),
>>> though.
>> It's not just for rank multiplier.. we find that it's LRDIMM only by
>> examining dcsm. Hence the iteration here..
> So we can look only at the first DCSM, no? Or are there systems with
> different types of LRDIMMs on one DCT?
>

So it seems we can theoretically have systems in this manner, but that 
is not a common case..

So, shall I just use first DCSM to keep it simple for now?
And find rank multiplier iteratively as and when need arises?

Thanks,
-Aravind.
