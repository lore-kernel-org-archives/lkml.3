Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaDONJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:09:38 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:56922
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752933AbaDONJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:09:33 -0400
X-WSS-ID: 0N42PV4-07-GR1-02
X-M-MSG: 
Message-ID: <534D2F6E.1020608@amd.com>
Date: Tue, 15 Apr 2014 15:09:02 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>, Borislav Petkov <bp@alien8.de>
CC: Alex Deucher <alexander.deucher@amd.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Subject: Re: 15-rc1: radeon modesetting fails
References: <20140415070204.GA4806@pd.tnic>	<534CFBD7.3070604@amd.com>
	<20140415120740.GA8306@nazgul.tnic>
 <CADnq5_PpPa_fbm=1KH__q-W2OuvfoHr2wquimQ8TCq=xwwYq_Q@mail.gmail.com>
In-Reply-To: <CADnq5_PpPa_fbm=1KH__q-W2OuvfoHr2wquimQ8TCq=xwwYq_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.152.106]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(24454002)(51704005)(377454003)(20776003)(4396001)(47776003)(76482001)(23676002)(15202345003)(85852003)(83072002)(81542001)(83506001)(99396002)(81342001)(575784001)(80976001)(84676001)(64126003)(59896001)(50466002)(36756003)(19580405001)(97736001)(2009001)(85202002)(74502001)(92726001)(85182001)(54356999)(87266999)(76176999)(83322001)(19580395003)(86362001)(77982001)(46102001)(44976005)(50986999)(87936001)(65806001)(15975445006)(65956001)(77096999)(79102001)(65816999)(74662001)(80022001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB114;H:atltwp01.amd.com;FPR:BC61F0F4.AB52D450.FAF39377.89FC09BF.202EB;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0182DBBB05
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does reverting:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=32167016076f714f0e35e287fbead7de0f1fb179
> fix the issue?  We may need to tweak the pll parameters for older asics.

Yeah, indeed the most likely cause. Please provide dmesg outputs created 
with drm.ebug=0xe for the old and the new kernel.

Christian.

Am 15.04.2014 15:06, schrieb Alex Deucher:
> On Tue, Apr 15, 2014 at 8:07 AM, Borislav Petkov <bp@alien8.de> wrote:
>> Hi Christian,
>>
>> On Tue, Apr 15, 2014 at 11:28:55AM +0200, Christian König wrote:
>>> Hi Borislav,
>>>
>>> that's a known issue and should be fixed in the next rc, see this
>>> bugreport: https://bugs.freedesktop.org/show_bug.cgi?id=77009
>>>
>>> You might also want to try my branch with 3.15 fixes which includes
>>> the necessary patch for this: http://cgit.freedesktop.org/~deathsimple/linux/log/?h=drm-fixes-3.15-wip
>>>
>>> Let me know if that branch works for you or not.
>> so I went and merged your branch as you suggested. Btw, on its tip it
>> has:
>>
>> commit ec02666dd0791312b5820e1a9a023681d99d07ec
>> Author: Quentin Casasnovas <quentin.casasnovas@oracle.com>
>> Date:   Tue Mar 18 17:16:52 2014 +0100
>>
>>      drm/radeon: memory leak on bo reservation failure. v2
>>
>> (just checking whether I got the right one)
>>
>> and, unfortunately, no change - same problem. Let me know if I should
>> bisect the subset of 59 radeon patches which went in during the merge
>> window...
>>
>> Btw, just in case, I went and updated radeon firmware in
>> /lib/firmware/radeon/ from upstream but it didn't change anything.
> Does reverting:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=32167016076f714f0e35e287fbead7de0f1fb179
> fix the issue?  We may need to tweak the pll parameters for older asics.
>
> Alex
>
>> Thanks.
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel

