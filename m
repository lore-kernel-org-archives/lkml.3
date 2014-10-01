Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaJAQCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:02:38 -0400
Received: from mail-bn1bon0142.outbound.protection.outlook.com ([157.56.111.142]:23632
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752161AbaJAQCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:02:35 -0400
X-WSS-ID: 0NCRWJT-07-AUB-02
X-M-MSG: 
Message-ID: <542C2588.2040004@amd.com>
Date: Wed, 1 Oct 2014 11:02:16 -0500
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
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(164054003)(199003)(479174003)(377454003)(189002)(57704003)(47776003)(44976005)(80316001)(33656002)(120886001)(101416001)(23676002)(21056001)(110136001)(20776003)(59896002)(85852003)(64126003)(97736003)(99396003)(83506001)(65806001)(65956001)(76482002)(10300001)(86362001)(120916001)(50986999)(92726001)(92566001)(84676001)(102836001)(76176999)(85306004)(65816999)(54356999)(64706001)(87266999)(4396001)(87936001)(93886004)(95666004)(50466002)(105586002)(46102003)(106466001)(68736004)(31966008)(36756003)(107046002)(80022003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-Forefront-PRVS: 0351D213B3
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB120;
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

Not AFAIK, But I'll ask to make sure.
If different LRDIMMs on one DCT don't exist, then sure, I'll modify the 
code to use first DCSM.

Regarding resend-
I'm not sure how you'll want the patches.. I just noticed a 
'edac-for-3.19' branch.
Would you prefer I based changes on top of this for merging purposes?
Or just resend the original 4 patches based off tip as usual?

Thanks,
-Aravind.
