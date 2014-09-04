Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaIDLYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 07:24:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36192 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaIDLYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 07:24:43 -0400
Message-ID: <54084BF7.8090900@canonical.com>
Date: Thu, 04 Sep 2014 13:24:39 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC: Matt Fleming <matt@console-pimps.org>, Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
References: <5405E186.2080406@canonical.com> <20140902192941.GB3001@console-pimps.org> <CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com> <5406D0DB.90401@canonical.com> <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com> <54073409.6030004@canonical.com> <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com> <20140903175948.GH3001@console-pimps.org> <CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com> <54084376.8090002@canonical.com> <BA3DE6F4-93D9-4CDE-90D7-280360929ABD@linaro.org>
In-Reply-To: <BA3DE6F4-93D9-4CDE-90D7-280360929ABD@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 04-09-14 om 13:19 schreef Ard Biesheuvel:
>
>> On 4 sep. 2014, at 12:48, Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
>>
>> Op 03-09-14 om 21:57 schreef Ard Biesheuvel:
>>> On 3 September 2014 19:59, Matt Fleming <matt@console-pimps.org> wrote:
>>>> On Wed, 03 Sep, at 05:37:26PM, Ard Biesheuvel wrote:
>>>>> Will do, thanks.
>>>>>
>>>>> @Matt: so there is two ways to fix this, the patch above addressing
>>>>> this single instance, and alternatively, adding a #pragma GCC
>>>>> visiblilty push(hidden) to all .c files under libstub/, *before* the
>>>>> #includes. The latter would catch future problems regarding newly
>>>>> introduced global variables, but it may be a bit overkill in this
>>>>> case, as libstub is not expected to be in flux in the foreseeable
>>>>> future.
>>>>>
>>>>> Any preferences?
>>>> Any reason we can't reuse the existing GOT fixup code in the early x86
>>>> boot code? We're not executing it before the EFI boot stub atm, which is
>>>> the reason Maarten is hitting these difficulties.
>>> I guess that is likely to work, I just wasn't aware it existed :-)
>>> I think adding another visibility(hidden) attribute or 2 would
>>> complete eliminate the need for GOT fixups, but I guess that is more
>>> sensitive to compiler versions being recent enough etc.
>>> The attached (build tested only) patch eliminates all GOT relocations
>>> under boot/compressed for a 64-bit EFI stub build.
>>>
>>>> Maarten, does the following help?
>>>>
>>>> If not, Ard please go ahead with option #2 above. Overkill yes, but I've
>>>> done the single __attribute__() hacks in other projects and someone
>>>> (usually me) always eventually forgets to tag some instance.
>>> It appears we just got lucky on arm64, since we don't have any global
>>> variables, but the issue does exist there as well.
>> FWIW, visibility pushing doesn't seem to work for functions declared with extern.
> Are you sure you are seeing GOT entries being generated for functions? Normally, these are resolved via PLT entries, and those usually don't result in GOT entries to be allocated unless the branch target is unknown at link time.
>
No not really, I was just looking at GOTPCREL for the .o files, no idea if they resulted in any actual relocations or not.

~Maarten

