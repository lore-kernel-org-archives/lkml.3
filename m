Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3EIAYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 20:24:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:18561 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab3EIAX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 20:23:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,638,1363158000"; 
   d="scan'208";a="238830210"
Message-ID: <518AEC98.4070507@intel.com>
Date: Thu, 09 May 2013 02:23:52 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@alien8.de>, toshi.kani@hp.com, prarit@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        fenghua.yu@intel.com, xen-devel@lists.xensource.com,
        linux-acpi@vger.kernel.org
Subject: Re: v3.9 - CPU hotplug and microcode earlier loading hits a mutex
 deadlock (x86_cpu_hotplug_driver_mutex)
References: <20130506125937.GA14036@phenom.dumpdata.com> <20130507190024.GA4303@phenom.dumpdata.com> <20130508125414.GB30955@pd.tnic> <20130508140342.GA8152@phenom.dumpdata.com> <20130508142949.GC30955@pd.tnic> <20130508163249.GB369@phenom.dumpdata.com>
In-Reply-To: <20130508163249.GB369@phenom.dumpdata.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r490OEqo012725

On 5/8/2013 6:32 PM, Konrad Rzeszutek Wilk wrote:
> On Wed, May 08, 2013 at 04:29:49PM +0200, Borislav Petkov wrote:
>> On Wed, May 08, 2013 at 10:03:42AM -0400, Konrad Rzeszutek Wilk wrote:
>>
>> [ â€¦ snip some funky BIOS code ]
>>
>>> [here it shifts and continues on testing each CPU bit]
>>>
>>>> Questions over questions...?
>>> I probably went overboard with my answers :-)
>> Konrad, you're killing me! :-) You actually went and looked at the
>> BIOS disassembly voluntarily. You must be insane, I think you should
>> immediately go to the doctor now for a thorough checkup. :-)
>>
>> I think I know who I can sling BIOS issues now to.
> Great .. :-)
>>>> Looks like save_mc_for_early would need another, local mutex to fix that.
>>> Let me try that. Thanks for the suggestion.
>> Ok, seriously now: yeah, this was just an idea, it should at least get
>> the nesting out of the way.
>>
>> About the BIOS deal: you're probably staring at some BIOS out there
>> but is this the way that it is actually going to be implemented on
>> the physical hotplug BIOS? I mean, I've only heard rumors about IVB
>> supporting physical hotplug but do you even have access to such BIOS to
>> verify?
> Unfortunatly not. I am getting an IvyTown box so hopefully that has this
> support. But I thought that Fenghua did since he mentioned in the patch.
>
> Besides that I think this can also appear on VMWare if one is doing
> CPU hotplug and on some HP machines - let me CC the relevant people
> extracted from drivers/acpi/processor_driver.c.
> (see  https://lkml.org/lkml/2013/5/7/588 for the thread)
>
> Rafael, do you know of any specific Intel hardware that has this implemented?

No, I don't have this information.

By the way, here's a general request.

Please CC any messages having the word "ACPI" anywhere in the body or 
subject to linux-acpi@vger.kernel.org.  I'm really tired of chasing 
ACPI-related threads on the LKML just because people don't care about 
CCing relevant lists and I'm going to NAK all patches touching ACPI in 
any way if they haven't been CCed to the ACPI list.  Seriously.

This particular item may or may not conflict with some ongoing work 
taking place in there (and patches present in my tree).

And you've already had problems with ACPI-related code conflicts, so 
that's not like it's never happened.

Thanks,
Rafael

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
