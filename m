Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab3GHNIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:08:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:49877 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab3GHNIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:08:11 -0400
X-IronPort-AV: E=Sophos;i="4.87,1020,1363132800"; 
   d="scan'208";a="35577518"
Message-ID: <51DAB9B8.7060303@citrix.com>
Date: Mon, 8 Jul 2013 09:08:08 -0400
From: Ben Guthro <Benjamin.Guthro@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bob Moore <robert.moore@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <xen-devel@lists.xen.org>,
        Shane Wang <shane.wang@intel.com>, <tboot-devel@lists.sourceforge.net>,
        Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Gang Wei <gang.wei@intel.com>
Subject: Re: [Xen-devel] [PATCH v6 0/5] Xen/ACPI: support sleep state entering
 on hardware reduced systems
References: <1372679333-8473-1-git-send-email-benjamin.guthro@citrix.com> <CAOvdn6XcEwFa2CRGqUhsaTeTMKHsQeFHJ-KmyCTBZRLbAoimmQ@mail.gmail.com> <2101936.oHXzxvYCX4@vostro.rjw.lan>
In-Reply-To: <2101936.oHXzxvYCX4@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/08/2013 09:10 AM, Rafael J. Wysocki wrote:
> On Sunday, July 07, 2013 08:13:15 PM Ben Guthro wrote:
>> On Mon, Jul 1, 2013 at 7:48 AM, Ben Guthro <benjamin.guthro@citrix.com> wrote:
>>> In version 3.4 acpi_os_prepare_sleep() got introduced in parallel with
>>> reduced hardware sleep support, and the two changes didn't get
>>> synchronized: The new code doesn't call the hook function (if so
>>> requested). Fix this, requiring a boolean parameter to be added to the
>>> hook function to distinguish "extended" from "legacy" sleep.
>>>
>>> This requires adjusting TXT, but the adjustments only go as far as
>>> failing the extended mode call (since, looking at the TXT interface,
>>> there doesn't even appear to be precautions to deal with that
>>> alternative interface).
>>>
>>> The hypervisor change underlying this is commit 62d1a69 ("ACPI: support
>>> v5 (reduced HW) sleep interface") on the master branch of
>>> git://xenbits.xen.org/xen.git.
>>>
>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
>>> Cc: Richard L Maliszewski <richard.l.maliszewski@intel.com>
>>> Cc: Gang Wei <gang.wei@intel.com>
>>> Cc: Shane Wang <shane.wang@intel.com>
>>> Cc: Bob Moore <robert.moore@intel.com>
>>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>>> Cc: linux-acpi@vger.kernel.org
>>> Cc: tboot-devel@lists.sourceforge.net
>>>
>>> v2: Extend description to include reference to hypervisor side change
>>> v3: Split into multiple patches, separating subsystems
>>>     Remove bool parameters, in favor of u8
>>> v4: Remove linux/acpi.h dependencies
>>>     Further patch split to break out acpica from OSL
>>>     More bool vs u8 fixes
>>> v5: Fix build of consumers of acpi_os_prepare_sleep() interface change,
>>>     so intermediate builds of partial patch series will not fail.
>>> v6: Rebased to linux-pm linux-next branch
>>>     Added warning in tboot early return code
>>>     Added Reviewed-by lines
>>>
>>> Ben Guthro (5):
>>>   acpi: Remove need to include linux/acpi.h in common acpica code
>>>   acpi: Call acpi_os_prepare_sleep hook in reduced hardware sleep path
>>>   acpi/xen/tboot: Adjust linux acpi OS functions to new extended
>>>     parameter
>>>   x86/tboot: Fail extended mode reduced hardware sleep
>>>   xen/acpi: notify xen when reduced hardware sleep is available
>>
>> Rafael, Bob -
>>
>> Is this version of the series something that you may consider taking?
>> If not - is there something specific you would like to see addressed?
> 
> Well, I'm afraid you need to give us some more time to process that,
> sorry.

My apologies - I know it is a busy time during the merge window. I did
not mean to seem impatient.

With the volume of things on the mailing list, I merely wanted to try to
avoid the series getting buried. If a week is too frequent to re-bump a
series, do you have a set of recommendations of how to best interact
with your workflow?

I'm just trying to balance people's time to review such things, with the
volume of the list.

Thanks for your time.

Ben
