Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaELHdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:33:05 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:46459
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751385AbaELHdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:33:03 -0400
X-WSS-ID: 0N5GAAX-07-E4K-02
X-M-MSG: 
Message-ID: <53707926.5090609@amd.com>
Date: Mon, 12 May 2014 09:32:54 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ken Moffat <zarniwhoop@ntlworld.com>
CC: Alex Deucher <alexdeucher@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: More breakage on HD7480D [ Aruba ]
References: <20140512003405.GA3386@milliways>
 <20140512010310.GA4370@milliways>
In-Reply-To: <20140512010310.GA4370@milliways>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.154.50]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(51874003)(199002)(189002)(51704005)(24454002)(81542001)(87266999)(54356999)(21056001)(79102001)(64126003)(50466002)(65816999)(50986999)(81342001)(77096999)(59896001)(44976005)(77982001)(101416001)(36756003)(84676001)(92566001)(4396001)(99396002)(87936001)(23676002)(85202002)(85182001)(83072002)(85852003)(86362001)(19580395003)(92726001)(47776003)(83506001)(46102001)(64706001)(2009001)(99136001)(65806001)(76176999)(83322001)(65956001)(19580405001)(80022001)(74662001)(68736004)(76482001)(20776003)(31966008)(74502001)(62816006);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR02MB124;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0209425D0A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ken,

*sigh* did I already mentioned that I hate PLLs? As soon as you fix 
something another use case immediately starts to break.

Please provide dmesg output created with drm.debug=0xe with and without 
the patch breaking it.

Thanks in advance,
Christian.

Am 12.05.2014 03:03, schrieb Ken Moffat:
> On Mon, May 12, 2014 at 01:34:06AM +0100, Ken Moffat wrote:
>
>   /me swears at myself for failing to copy to lkml.
>
>> Hi Christian, Alex -
>>
>>   my A4 Trinity (Radeon HD7480D) was working fine by -rc3.  But now
>> that I've tested it in -rc5 it is again broken (the screen goes
>> blank when KMS starts).  Bisection blames:
>>
>> 3b333c55485fef0089ae7398906599d000df195e is the first bad commit
>> commit 3b333c55485fef0089ae7398906599d000df195e
>> Author: Christian König <christian.koenig@amd.com>
>> Date:   Thu Apr 24 18:39:59 2014 +0200
>>
>>      drm/radeon: avoid high jitter with small frac divs
>>      
>>      Signed-off-by: Christian König <christian.koenig@amd.com>
>>
>>   Reverting that from current HEAD [
>>
>> commit 7e338c9991ecee9c2ac7a4cee2c2e11ecb563d02
>> Merge: 9cf22e80df77 aa07c713ecfc
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Sun May 11 18:06:13 2014 +0900
>>
>>      Merge branch 'for-3.15' of git://linux-nfs.org/~bfields/linux
>>      
>>      Pull nfsd fixes from Bruce Fields.
>>
>> ]
>> makes it again boot.
>>
>>   Note to Alex - 3.15 has been an "interesting" cycle - you fixed my
>> earlier problem, despite my non-response, and thanks again for that.
>> After that, my other radeon broke after -rc2 (I retested it after
>> rc4 and found that although rc4 was broken, HEAD was fixed, so
>> thanks also for that.  Then I retested this one for -rc5.  It seems
>> that my boxes always break when I don't have time to test new
>> releases :-(
>>
>> ĸen
>> -- 
>> das eine Mal als Tragödie, dieses Mal als Farce

