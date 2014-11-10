Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaKJXD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:03:56 -0500
Received: from mail-bl2on0138.outbound.protection.outlook.com ([65.55.169.138]:46544
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751352AbaKJXDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:03:54 -0500
X-WSS-ID: 0NEUIQA-08-91G-02
X-M-MSG: 
Message-ID: <54614455.7070700@amd.com>
Date: Mon, 10 Nov 2014 17:03:49 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Chen Yucong <slaoub@gmail.com>, <tony.luck@intel.com>,
        <ak@linux.intel.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] x86, mce, severity: extend the the mce_severity
 mechanism to handle UCNA/DEFERRED error
References: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
 <1415410821-15063-2-git-send-email-slaoub@gmail.com>
 <546136C8.5060104@amd.com> <20141110221728.GA23419@pd.tnic>
In-Reply-To: <20141110221728.GA23419@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(24454002)(377454003)(479174003)(199003)(164054003)(189002)(51444003)(84676001)(68736004)(19580405001)(19580395003)(44976005)(83506001)(101416001)(99396003)(120916001)(87936001)(36756003)(120886001)(92726001)(97736003)(92566001)(87266999)(54356999)(65816999)(50986999)(46102003)(76176999)(4396001)(86362001)(65806001)(64126003)(102836001)(50466002)(31966008)(20776003)(47776003)(64706001)(65956001)(21056001)(95666004)(105586002)(93886004)(77156002)(62966003)(107046002)(106466001)(23676002)(117636001)(110136001)(59896002)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB193;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 4:17 PM, Borislav Petkov wrote:
> On Mon, Nov 10, 2014 at 04:06:00PM -0600, Aravind Gopalakrishnan wrote:
>>> +	MCESEV(
>>> +		DEFERRED, "Deferred error",
>>> +		NOSER, MASK(MCI_STATUS_UC|MCI_STATUS_DEFERRED|MCI_STATUS_POISON, MCI_STATUS_DEFERRED)
>>>   		),
>> We don't need to have MCI_STATUS_POISON in the MASK() here as a deferred
>> error is indicated by a {UC=0, Deferred = 1}
>> (Older docs might be unclear on that..)
> Well, I think that's ok because the MASK() macro actually makes the
> check do:
>
> look at bits MCI_STATUS_UC|MCI_STATUS_DEFERRED|MCI_STATUS_POISON and of
> them three MCI_STATUS_DEFERRED has to be the only one set.
>
> And that makes sense - we want deferred errors where we didn't attempt
> to consume poisoned data (which is signalled by MCI_STATUS_POISON)....

Yeah, makes sense.

Reviewed-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

Thanks,
-Aravind.

