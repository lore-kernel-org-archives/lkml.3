Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaIOPUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:20:08 -0400
Received: from mail-bl2on0136.outbound.protection.outlook.com ([65.55.169.136]:43680
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752972AbaIOPUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:20:05 -0400
X-WSS-ID: 0NBY7X9-08-TQH-02
X-M-MSG: 
Message-ID: <5417039E.2000105@amd.com>
Date: Mon, 15 Sep 2014 10:19:58 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4] edac, amd64_edac: Modify usage of amd64_read_dct_pci_cfg()
References: <1410292346-3352-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <20140915120925.GD3340@nazgul.tnic> <5416FDDA.2070208@amd.com>
 <20140915150823.GH3340@nazgul.tnic>
In-Reply-To: <20140915150823.GH3340@nazgul.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(199003)(24454002)(189002)(479174003)(377454003)(92726001)(99396002)(83322001)(65816999)(74662001)(83072002)(64706001)(65806001)(33656002)(93886004)(76482001)(79102001)(4396001)(77982001)(46102001)(81342001)(64126003)(90102001)(107046002)(85306004)(21056001)(76176999)(106466001)(92566001)(110136001)(84676001)(80316001)(101416001)(81542001)(83506001)(97736003)(95666004)(20776003)(23676002)(68736004)(80022001)(50466002)(87936001)(86362001)(87266999)(54356999)(65956001)(36756003)(85852003)(31966008)(102836001)(105586002)(50986999)(47776003)(44976005)(74502001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR02MB483;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03355EE97E
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/2014 10:08 AM, Borislav Petkov wrote:
>>>>   	amd64_read_pci_cfg(pvt->F3, F10_ONLINE_SPARE, &pvt->online_spare);
>>>> -	amd64_read_dct_pci_cfg(pvt, DCLR0, &pvt->dclr0);
>>>> -	amd64_read_dct_pci_cfg(pvt, DCHR0, &pvt->dchr0);
>>>> -
>>>> -	if (!dct_ganging_enabled(pvt)) {
>>>> -		amd64_read_dct_pci_cfg(pvt, DCLR1, &pvt->dclr1);
>>>> -		amd64_read_dct_pci_cfg(pvt, DCHR1, &pvt->dchr1);
>>>> -	}
>>>> +	amd64_read_dct_pci_cfg(pvt, 0, DCLR0, &pvt->dclr0);
>>>> +	amd64_read_dct_pci_cfg(pvt, 0, DCHR0, &pvt->dchr0);
>>>>   	pvt->ecc_sym_sz = 4;
>>>>   	if (pvt->fam >= 0x10) {
>>>> +		amd64_read_dct_pci_cfg(pvt, 1, DCLR0, &pvt->dclr1);
>>>> +		amd64_read_dct_pci_cfg(pvt, 1, DCHR0, &pvt->dchr1);
>>> This doesn't look equivalent - above we're checking whether we're ganged
>>> now you're doing it for >= F10h. Why?
>>>
>>> Because only F10h supports ganging?
>> That's right.
>> If ganging is enabled (which is a condition we check for in
>> amd64_read_dct_pci_cfg();
>> Then we return 0.
> Right, but you're reading them now even if you don't have to. So why are
> you even changing this? What's wrong with doing:
>
> 	if (!dct_ganging_enabled(pvt)) {
> 		amd64_read_dct_pci_cfg(pvt, 1, DCLR0, &pvt->dclr1);
> 		amd64_read_dct_pci_cfg(pvt, 1, DCHR0, &pvt->dchr1);
> 	}
>
> which is much clearer than doing the family check.
>

Just thought we could remove one more condition..
Allright, I'll change this.

-Aravind.
