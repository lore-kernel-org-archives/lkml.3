Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbaIDTO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:14:28 -0400
Received: from mail-by2on0086.outbound.protection.outlook.com ([207.46.100.86]:16864
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755210AbaIDTOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:14:25 -0400
X-Greylist: delayed 878 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2014 15:14:25 EDT
Message-ID: <5408B5D6.6020101@opensource.altera.com>
Date: Thu, 4 Sep 2014 13:56:22 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, <tthayer@opensource.altera.com>
CC: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <atull@opensource.altera.com>, <delicious.quinoa@gmail.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>
Subject: Re: [PATCHv10 1/2] edac: altera: Add Altera SDRAM EDAC support.
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com> <1407770293-27190-2-git-send-email-tthayer@opensource.altera.com> <20140829160204.GA8835@nazgul.tnic>
In-Reply-To: <20140829160204.GA8835@nazgul.tnic>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR08CA0029.namprd08.prod.outlook.com (10.242.217.157) To
 BN3PR0301MB1187.namprd03.prod.outlook.com (25.160.156.149)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0324C2C0E2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009015)(6009001)(6049001)(51704005)(377454003)(479174003)(199003)(24454002)(189002)(86362001)(80022001)(87976001)(65806001)(20776003)(95666004)(47776003)(65956001)(80316001)(64126003)(83506001)(42186005)(92566001)(64706001)(92726001)(79102001)(66066001)(83072002)(81542001)(85852003)(19580405001)(83322001)(54356999)(59896002)(101416001)(50986999)(46102001)(4396001)(74502001)(76482001)(81342001)(85306004)(19580395003)(77982001)(74662001)(76176999)(65816999)(31966008)(87266999)(99396002)(90102001)(77096002)(106356001)(21056001)(105586002)(50466002)(33656002)(23676002)(102836001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1187;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2014 11:02 AM, Borislav Petkov wrote:
> On Mon, Aug 11, 2014 at 10:18:12AM -0500, tthayer@opensource.altera.com wrote:
>> From: Thor Thayer <tthayer@opensource.altera.com>
>>
>> This patch adds support for the CycloneV and ArriaV SDRAM controllers.
>> Correction and reporting of SBEs, Panic on DBEs.
>>
>> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
>> ---
>> v2: Use the SDRAM controller registers to calculate memory size
>>     instead of the Device Tree. Update To & Cc list. Add maintainer
>>     information.
>>
>> v3: EDAC driver cleanup based on comments from Mailing list.
>>
>> v4: Panic on DBE. Add macro around inject-error reads to prevent
>>     them from being optimized out. Remove of_match_ptr since this
>>     will always use Device Tree.
>>
>> v5: Addition of printk to trigger function to ensure read vars
>>     are not optimized out.
>>
>> v6: Changes to split out shared SDRAM controller reg (offset 0x00)
>>     as a syscon device and allocate ECC specific SDRAM registers
>>     to EDAC.
>>
>> v7: No changes. Bump for consistency.
>>
>> v8: Alphabetize headers.
>>
>> v9: Changes to support a MFD SDRAM controller with nested EDAC.
>>
>> v10: Revert to version 5 (syscon) and fix errors found in v5.
> 
> EDAC bits look ok to me,
> 
> Acked-by: Borislav Petkov <bp@suse.de>
> 
> Dinh, please convert that version information above to a nice commit
> message and add it when applying as it is very useful for future
> reference.
> 

Thank Boris. I had to fix up the patch a bit by making EDAC_ALTERA_MC a
tristate instead of bool to prevent a build error with allmodconfig.

Dinh
> Thanks.
> 

