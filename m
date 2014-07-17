Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbaGQOP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:15:58 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:9488
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932139AbaGQOPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:15:55 -0400
X-WSS-ID: 0N8V0Y6-07-FLM-02
X-M-MSG: 
Message-ID: <53C7DA82.7000502@amd.com>
Date: Thu, 17 Jul 2014 17:15:30 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        =?ISO-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>,
        <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v2 01/25] mm: Add kfd_process pointer to mm_struct
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <53C7D666.6000405@amd.com> <20140717141216.GA1963@gmail.com>
In-Reply-To: <20140717141216.GA1963@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(24454002)(479174003)(55674003)(51704005)(106466001)(81342001)(81542001)(86362001)(76482001)(102836001)(97736001)(74662001)(21056001)(101416001)(4396001)(36756003)(46102001)(107046002)(74502001)(105586002)(83506001)(44976005)(77982001)(83322001)(54356999)(59896001)(64126003)(76176999)(23756003)(65816999)(19580405001)(99396002)(87266999)(68736004)(95666004)(19580395003)(50986999)(31966008)(85306003)(33656002)(65806001)(50466002)(80022001)(79102001)(84676001)(110136001)(92726001)(64706001)(20776003)(47776003)(85852003)(65956001)(83072002)(87936001)(92566001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB044;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/14 17:12, Jerome Glisse wrote:
> On Thu, Jul 17, 2014 at 04:57:58PM +0300, Oded Gabbay wrote:
>> Forgot to add mm mailing list. Sorry.
>>
>> This patch enables the amdkfd driver to retrieve the kfd_process
>> object from the process's mm_struct. This is needed because kfd_process
>> lifespan is bound to the process's mm_struct lifespan.
>>
>> When amdkfd is notified about an mm_struct tear-down, it checks if the
>> kfd_process pointer is valid. If so, it releases the kfd_process object
>> and all relevant resources.
>>
>> In v3 of the patchset I will update the binding to match the final discussions
>> on [PATCH 1/8] mmput: use notifier chain to call subsystem exit handler.
>> In the meantime, I'm going to try and see if I can drop the kfd_process
>> in mm_struct and remove the use of the new notification chain in mmput.
>> Instead, I will try to use the mmu release notifier.
>
> So the mmput notifier chain will not happen. I did a patch with call_srcu
> and adding couple more helper to mmu_notifier. I will send that today for
> review.
>
> That being said, adding a device driver specific to mm_struct will most
> likely be a big no. I am myself gonna remove hmm from mm_struct as people
> are reluctant to see such change.
>
> Cheers,
> Jérôme
>
Yes, I followed that email thread and you can see that in the commit message I 
referred to it (saying that in v3 of the patchset I'm also going to use 
mmu_notifier). I will take your patch once you publish it and use it to change 
amdkfd behavior.

	Oded
>
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> ---
>>   include/linux/mm_types.h | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>> index 678097c..ff71496 100644
>> --- a/include/linux/mm_types.h
>> +++ b/include/linux/mm_types.h
>> @@ -20,6 +20,10 @@
>>   struct hmm;
>>   #endif
>>   +#if defined(CONFIG_HSA_RADEON) || defined(CONFIG_HSA_RADEON_MODULE)
>> +struct kfd_process;
>> +#endif
>> +
>>   #ifndef AT_VECTOR_SIZE_ARCH
>>   #define AT_VECTOR_SIZE_ARCH 0
>>   #endif
>> @@ -439,6 +443,16 @@ struct mm_struct {
>>   	 */
>>   	struct hmm *hmm;
>>   #endif
>> +#if defined(CONFIG_HSA_RADEON) || defined(CONFIG_HSA_RADEON_MODULE)
>> +	/*
>> +	 * kfd always register an mmu_notifier we rely on mmu notifier to keep
>> +	 * refcount on mm struct as well as forbiding registering kfd on a
>> +	 * dying mm
>> +	 *
>> +	 * This field is set with mmap_sem old in write mode.
>> +	 */
>> +	struct kfd_process *kfd_process;
>> +#endif
>>   #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
>>   	pgtable_t pmd_huge_pte; /* protected by page_table_lock */
>>   #endif
>> --
>> 1.9.1
>>

