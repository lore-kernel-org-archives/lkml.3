Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbaGXNrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:47:55 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:24560
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758781AbaGXNrx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:47:53 -0400
X-WSS-ID: 0N97YBM-07-2QD-02
X-M-MSG: 
Message-ID: <53D10E7E.20501@amd.com>
Date: Thu, 24 Jul 2014 15:47:42 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
CC: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        "Thomas Hellstrom" <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser>
	<53CF63C2.7070407@vodafone.de>
	<CAKMK7uGJj+UwcnnzA+fj_=uWPN3i0sneWkoD+wfPJ_8Q6Y-DQg@mail.gmail.com>
	<53CF6622.6060803@amd.com>	<53CF699D.9070902@canonical.com>
	<53CF6B18.5070107@vodafone.de>
	<CAKMK7uGd65HR11thcv8KjDw-RnTa7W-QGOzFGFd+oO_hp8wyHA@mail.gmail.com>
	<53CF7035.2060808@amd.com>	<53CF7191.2090008@canonical.com>
	<CAKMK7uGLqzePAREsWhX0D1oN4FdqKwPgAL6x8sULpJSqYH5LwA@mail.gmail.com>
	<53CF765E.7020802@vodafone.de>
	<CAKMK7uE1G-EjbJ2RAXC3ZfkaCo=Gber5PJuRG623Yoz9D=FmGw@mail.gmail.com>
	<53CF8010.9060809@amd.com>
	<CAKMK7uEowhvc+4Jc6t2NAeE1joFaohJ6cP7sU-Akut6b3ta=1g@mail.gmail.com>
	<53CF822E.7050601@amd.com>
	<CAKMK7uG85KV94PTqkzvY8RPxg6ApRKHVZrD20e48GHZM=s06=w@mail.gmail.com>
	<53CF84C7.2020507@vodafone.de>	<53CF8693.1040006@canonical.com>
	<53CF8AB1.2000009@amd.com>
 <CAKMK7uEgGzKb3Vsnz0FCgFCcSM39QntEisg0JMg=HOvnwLCZgw@mail.gmail.com>
 <53CFAC38.9050501@amd.com> <53CFB5C2.7060207@canonical.com>
 <53CFC121.6040109@canonical.com>
In-Reply-To: <53CFC121.6040109@canonical.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.155.209]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(377454003)(51704005)(377424004)(24454002)(199002)(189002)(19580405001)(101416001)(83072002)(20776003)(19580395003)(95666004)(102836001)(76482001)(80022001)(4396001)(68736004)(107046002)(83506001)(65816999)(50466002)(74662001)(46102001)(84676001)(85306003)(76176999)(79102001)(31966008)(92566001)(99396002)(105586002)(23676002)(81342001)(65956001)(47776003)(74502001)(87936001)(83322001)(92726001)(21056001)(97736001)(36756003)(65806001)(77982001)(64126003)(64706001)(85182001)(86362001)(85852003)(33656002)(44976005)(106466001)(81542001)(54356999)(93886003)(50986999);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB041;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maarten,

try to implement this as a replacement for specifying the 
RADEON_FENCE_JIFFIES_TIMEOUT on wait_event_*. And reset the timeout 
every time radeon_fence_process is called and not only when any of the 
sequences increment.

I don't have the time right now to look deeper into it or help with the 
patch, but the general approach sounds valid to me.

Regards,
Christian.

Am 23.07.2014 16:05, schrieb Maarten Lankhorst:
> op 23-07-14 15:16, Maarten Lankhorst schreef:
>> op 23-07-14 14:36, Christian König schreef:
>>> Am 23.07.2014 12:52, schrieb Daniel Vetter:
>>>> On Wed, Jul 23, 2014 at 12:13 PM, Christian König
>>>> <christian.koenig@amd.com> wrote:
>>>>>> And the dma-buf would still have fences belonging to both drivers, and it
>>>>>> would still call from outside the driver.
>>>>> Calling from outside the driver is fine as long as the driver can do
>>>>> everything necessary to complete it's work and isn't forced into any ugly
>>>>> hacks and things that are not 100% reliable.
>>>>>
>>>>> So I don't see much other approach as integrating recovery code for not
>>>>> firing interrupts and some kind of lockup handling into the fence code as
>>>>> well.
>>>> That approach doesn't really work at that well since every driver has
>>>> it's own reset semantics. And we're trying to move away from global
>>>> reset to fine-grained reset. So stop-the-world reset is out of
>>>> fashion, at least for i915. As you said, reset is normal in gpus and
>>>> we're trying to make reset less invasive. I really don't see a point
>>>> in imposing a reset scheme upon all drivers and I think you have about
>>>> as much motivation to convert radeon to the scheme used by i915 as
>>>> I'll have for converting to the one used by radeon. If it would fit at
>>>> all.
>>> Oh my! No, I didn't wanted to suggest any global reset infrastructure.
>>>
>>> My idea was more that the fence framework provides a fence->process_signaling callback that is periodically called after enable_signaling is called to trigger manual signal processing in the driver.
>>>
>>> This would both be suitable as a fallback in case of not working interrupts as well as a chance for any driver to do necessary lockup handling.
>> I managed to do it without needing it to be part of the interface? I'm not sure whether radeon_fence_driver_recheck needs exclusive_lock, but if so it's a small change..
>>
>> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
>> index 7fbfd41479f1..51b646b9c8bb 100644
>> --- a/drivers/gpu/drm/radeon/radeon.h
>> +++ b/drivers/gpu/drm/radeon/radeon.h
>> @@ -345,6 +345,9 @@ struct radeon_fence_driver {
>>   	uint64_t			sync_seq[RADEON_NUM_RINGS];
>>   	atomic64_t			last_seq;
>>   	bool				initialized;
>> +	struct delayed_work		work;
>> +	struct radeon_device *rdev;
>> +	unsigned ring;
>>   };
>>   
>>   struct radeon_fence_cb {
>> diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
>> index da83f36dd708..955c825946ad 100644
>> --- a/drivers/gpu/drm/radeon/radeon_fence.c
>> +++ b/drivers/gpu/drm/radeon/radeon_fence.c
>> @@ -231,6 +231,9 @@ static bool __radeon_fence_process(struct radeon_device *rdev, int ring)
>>   		}
>>   	} while (atomic64_xchg(&rdev->fence_drv[ring].last_seq, seq) > seq);
>>   
>> +	if (!wake && last_seq < last_emitted)
>> +		schedule_delayed_work(&rdev->fence_drv[ring].work, jiffies_to_msecs(10));
>> +
>>
> When trying this: if (seq < last_emitted) is probably a better check.
>
> ~Maarten
>

