Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaJ0Veh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:34:37 -0400
Received: from mail-bl2on0059.outbound.protection.outlook.com ([65.55.169.59]:32448
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751605AbaJ0Vee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:34:34 -0400
Message-ID: <544EBA84.7080109@opensource.altera.com>
Date: Mon, 27 Oct 2014 16:35:00 -0500
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <m.chehab@samsung.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <dinguyen@opensource.altera.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: Re: [PATCHv2 0/4] Add Altera peripheral memories to EDAC framework
References: <1413578029-13205-1-git-send-email-tthayer@opensource.altera.com> <544E93F0.3030409@opensource.altera.com> <20141027204307.GB4741@pd.tnic>
In-Reply-To: <20141027204307.GB4741@pd.tnic>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR08CA041.namprd08.prod.outlook.com (10.141.248.159) To
 BN1PR03MB122.namprd03.prod.outlook.com (10.255.201.19)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB122;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0377802854
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(377454003)(479174003)(199003)(24454002)(52604005)(189002)(65956001)(42186005)(20776003)(80316001)(66066001)(65806001)(99396003)(47776003)(64706001)(77096002)(105586002)(107046002)(23676002)(83506001)(95666004)(31966008)(120916001)(21056001)(46102003)(80022003)(122386002)(54356999)(76176999)(87266999)(50986999)(92726001)(92566001)(87976001)(65816999)(76482002)(40100003)(102836001)(101416001)(97736003)(59896002)(106356001)(4396001)(86362001)(85306004)(110136001)(50466002)(85852003)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB122;H:[137.57.160.203];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/27/2014 03:43 PM, Borislav Petkov wrote:
> On Mon, Oct 27, 2014 at 01:50:24PM -0500, Thor Thayer wrote:
>> Do you have any comments about this driver?
> Just a question: why do you have three .c files for something which
> does only error injection and nothing else AFAICT? Why isn't this part
> of altera_edac.c?
>
There are 2 files for doing the error injection (altera_l2_edac.c and 
altera_ocram_edac.c) and then 1 file for the irq handling and probe 
(altera_edac_mgr.c).

The L2 cache and the On-Chip RAM drivers were based on the Calxeda L2 
cache driver and when written as 2 separate files, the resulting code 
was very similar from the probe and error handling standpoint so the 
common code was combined (altera_edac_mgr.c).

The Memory Controller model was used for the SDRAM EDAC (altera_edac.c) 
since it matches the DIMM model.  The MC model didn't seem to fit the 
discrete memories like OCRAM and L2 cache (these files) so I used the 
EDAC device model which agreed with the Calxeda L2 cache driver.

Should I move the EDAC Device probe and error handling from 
altera_edac_mgr.c to altera_edac.c? Can I mix the MC and Device models 
in the same file?

Thanks for reviewing and for commenting.

Thor
