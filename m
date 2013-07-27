Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab3G0Pdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 11:33:33 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:47942 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3G0Pdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 11:33:32 -0400
X-IronPort-AV: E=Sophos;i="4.89,757,1367971200"; 
   d="scan'208";a="37790581"
From: Ben Guthro <Ben.Guthro@citrix.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ben Guthro <Ben.Guthro@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Gang Wei <gang.wei@intel.com>, Shane Wang <shane.wang@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "tboot-devel@lists.sourceforge.net" 
	<tboot-devel@lists.sourceforge.net>
Subject: Re: [PATCH v4 0/5] Xen/ACPI: support sleep state entering on
 hardware reduced systems
Thread-Topic: [PATCH v4 0/5] Xen/ACPI: support sleep state entering on
 hardware reduced systems
Thread-Index: AQHOc0dQyh5+xchj8UCPGVjB0/UMk5l5AB8A///Wnc4=
Date: Sat, 27 Jul 2013 15:33:31 +0000
Message-ID: <2A50FCBD-CD54-4C8D-A780-1CA7ACBC4E0B@citrix.com>
References: <1372345323-9266-1-git-send-email-benjamin.guthro@citrix.com>,<2455068.P7gO5JL6M7@vostro.rjw.lan>
In-Reply-To: <2455068.P7gO5JL6M7@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Jul 27, 2013, at 9:51 AM, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday, June 27, 2013 11:01:58 AM Ben Guthro wrote:
>> In version 3.4 acpi_os_prepare_sleep() got introduced in parallel with
>> reduced hardware sleep support, and the two changes didn't get
>> synchronized: The new code doesn't call the hook function (if so
>> requested). Fix this, requiring a boolean parameter to be added to the
>> hook function to distinguish "extended" from "legacy" sleep.
>> 
>> This requires adjusting TXT, but the adjustments only go as far as
>> failing the extended mode call (since, looking at the TXT interface,
>> there doesn't even appear to be precautions to deal with that
>> alternative interface).
>> 
>> The hypervisor change underlying this is commit 62d1a69 ("ACPI: support
>> v5 (reduced HW) sleep interface") on the master branch of
>> git://xenbits.xen.org/xen.git.
>> 
>> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> Cc: Richard L Maliszewski <richard.l.maliszewski@intel.com>
>> Cc: Gang Wei <gang.wei@intel.com>
>> Cc: Shane Wang <shane.wang@intel.com>
>> Cc: Bob Moore <robert.moore@intel.com>
>> Cc: Rafaell J. Wysocki <rjw@sisk.pl>
>> Cc: linux-acpi@vger.kernel.org
>> Cc: tboot-devel@lists.sourceforge.net 
>> 
>> v2: Extend description to include reference to hypervisor side change
>> v3: Split into multiple patches, separating subsystems
>>    Remove bool parameters, in favor of u8
>> v4: Remove linux/acpi.h dependencies
>>    Further patch split to break out acpica from OSL
>>    More bool vs u8 fixes
>> 
>> Ben Guthro (5):
>>  acpi: Remove need to include linux/acpi.h in common acpica code
>>  acpi: Call acpi_os_prepare_sleep hook in reduced hardware sleep path
>>  acpi: Adjust linux acpi OS functions to new extended parameter
>>  x86/tboot: Fail extended mode reduced hardware sleep
>>  xen/acpi: notify xen when reduced hardware sleep is available
> 
> The ongoing discussion means to me that the ACPICA maintainers don't want
> acpi_os_prepare_sleep() and quite frankly I understand them, because ACPICA
> is about implementing the spec and not about things beyond it.
> 
> This means that patch [1/5] goes away.
> 
> That said, at the same time we need to address the problem at hand, which
> is to make Xen work with the reduced HW sleep.
> 
> For that, I don't honestly think that modifying acpi_os_prepare_sleep() the
> way the patchset is doing it is appropriate and the change of the meaning of
> the arguments is simply disgusting.
> 
> To me, it would be much cleaner to add acpi_os_prepare_extended_sleep()
> specifically to be called by acpi_hw_extended_sleep() and make tboot and Xen
> use that.
> 
> This way or another, we'll need to live with one more divergence between the
> upstream ACPICA and the Linux ACPICA code because of that, but that'd be just
> a few added lines in acpi_hw_extended_sleep(), so I suppose it wouldn't be
> such a big deal.
> 

Ok, thank you for the review, and being open to addressing the problem at hand, without a full architecture rework (not to say that that discussion is not also needed)

I will try to make some time next week to rework the patch set to address these concerns, and submit a new series. 

Thanks
Ben



> Thanks,
> Rafael
> 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
