Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaIVIoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:44:15 -0400
Received: from mail-by2on0125.outbound.protection.outlook.com ([207.46.100.125]:57248
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751058AbaIVIoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:44:14 -0400
X-Greylist: delayed 992 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2014 04:44:14 EDT
Message-ID: <541FDD32.8020105@freescale.com>
Date: Mon, 22 Sep 2014 11:26:26 +0300
From: Laurentiu Tudor <b10716@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>, Michael Neuling <mikey@neuling.org>
CC: <greg@kroah.com>, <arnd@arndb.de>, <mpe@ellerman.id.au>,
        <benh@kernel.crashing.org>, <cbe-oss-dev@lists.ozlabs.org>,
        <imunsie@au.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>, <jk@ozlabs.org>, <anton@samba.org>,
        "Laurentiu Tudor" <Laurentiu.Tudor@freescale.com>
Subject: Re: [PATCH 03/15] powerpc/msi: Improve IRQ bitmap allocator
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>	 <1411028820-29933-4-git-send-email-mikey@neuling.org>	 <1411157769.13320.74.camel@snotra.buserror.net> <1411157986.13320.75.camel@snotra.buserror.net>
In-Reply-To: <1411157986.13320.75.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.166.1]
X-ClientProxiedBy: AM3PR01CA056.eurprd01.prod.exchangelabs.com (10.141.191.46)
 To BL2PR03MB305.namprd03.prod.outlook.com (10.141.68.13)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB305;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(479174003)(24454002)(51704005)(189002)(199003)(377424004)(99396002)(66066001)(65806001)(50986999)(107046002)(19580405001)(83322001)(83506001)(15975445006)(19580395003)(65956001)(120916001)(85306004)(93886004)(76482002)(95666004)(59896002)(31966008)(97736003)(90102001)(81542003)(77096002)(79102003)(80022003)(74502003)(74662003)(50466002)(46102003)(81342003)(77982003)(33656002)(101416001)(87266999)(54356999)(102836001)(65816999)(76176999)(87976001)(85852003)(83072002)(42186005)(92726001)(80316001)(92566001)(105586002)(106356001)(21056001)(47776003)(4396001)(36756003)(23676002)(15202345003)(20776003)(64706001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB305;H:[10.171.73.112];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 11:19 PM, Scott Wood wrote:
> On Fri, 2014-09-19 at 15:16 -0500, Scott Wood wrote:
>> On Thu, 2014-09-18 at 18:26 +1000, Michael Neuling wrote:
>>> From: Ian Munsie <imunsie@au1.ibm.com>
>>>
>>> Currently msi_bitmap_alloc_hwirqs() will round up any IRQ allocation requests
>>> to the nearest power of 2.  eg. ask for 5 IRQs and you'll get 8.  This wastes a
>>> lot of IRQs which can be a scarce resource.
>>>
>>> For cxl we can require multiple IRQs for every contexts that is attached to the
>>> accelerator.  For AFU directed accelerators, there may be 1000s of contexts
>>> attached, hence we can easily run out of IRQs, especially if we are needlessly
>>> wasting them.
>>>
>>> This changes the msi_bitmap_alloc_hwirqs() to allocate only the required number
>>> of IRQs, hence avoiding this wastage.
>>>
>>> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
>>> Signed-off-by: Michael Neuling <mikey@neuling.org>
>>> ---
>>>  arch/powerpc/sysdev/msi_bitmap.c | 18 +++++++++++++-----
>>>  1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> This conflicts with (and partially duplicates)
>> http://patchwork.ozlabs.org/patch/381892/
>> which I have in my tree.  How should we handle it?
>>
>> Laurentiu, from looking at the overlap between patches I see a problem
>> with your existing patch, regarding the out-of-irqs path and
>> msi_bitmap_free_hwirqs(), so one way or another that needs to get fixed
>> soon.
> 
> Given the problems with Laurentiu's patch, perhaps it'd be best for me
> to just revert that patch in my tree, and respin it after this patchset
> has been merged.

Let me know if you want me to rebase my stuff on top of Michael's patch.

---
Best Regards, Laurentiu

