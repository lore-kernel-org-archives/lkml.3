Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaF0SKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:10:11 -0400
Received: from mx02.posteo.de ([89.146.194.165]:45177 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750862AbaF0SKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:10:08 -0400
Message-ID: <53ADB359.4010401@posteo.de>
Date: Fri, 27 Jun 2014 20:09:29 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [BUG] rc1 and rc2: Laptop unusable: on boot,screen black instead
 of native resolution
References: <53A6E72A.9090000@posteo.de>		 <744357E9AAD1214791ACBA4B0B90926301379B97@SHSMSX101.ccr.corp.intel.com>		 <53A81BF7.3030207@posteo.de> <1403529246.4686.6.camel@rzhang1-toshiba>	 <53A83DC7.1010606@posteo.de> <1403882067.16305.124.camel@rzhang1-toshiba>
In-Reply-To: <1403882067.16305.124.camel@rzhang1-toshiba>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-06-27 17:14, schrieb Zhang Rui:
> On Mon, 2014-06-23 at 16:46 +0200, Martin Kepplinger wrote:
>> Am 2014-06-23 15:14, schrieb Zhang Rui:
>>> On Mon, 2014-06-23 at 14:22 +0200, Martin Kepplinger wrote:
>>>> Am 2014-06-23 03:10, schrieb Zhang, Rui:
>>>>>
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Martin Kepplinger [mailto:martink@posteo.de]
>>>>>> Sent: Sunday, June 22, 2014 10:25 PM
>>>>>> To: Zhang, Rui
>>>>>> Cc: rjw@rjwysocki.net; lenb@kernel.org; linux-acpi@vger.kernel.org;
>>>>>> linux-kernel@vger.kernel.org
>>>>>> Subject: [BUG] rc1 and rc2: Laptop unusable: on boot,screen black
>>>>>> instead of native resolution
>>>>>> Importance: High
>>>>>>
>>>>>> Since 3.16-rc1 my laptop's just goes black while booting, instead of
>>>>>> switching to native screen resolution and showing me the starting
>>>>>> system there. It's an Acer TravelMate B113 with i915 driver and
>>>>>> acer_wmi. It stays black and is unusable.
>>>>>>
>>> This looks like a duplicate of
>>> https://bugzilla.kernel.org/show_bug.cgi?id=78601
>>>
>>> thanks,
>>> rui
>> I'm not sure about that. I have no problem with v3.15 and the screen
>> goes black way before a display manager is started. It's right after the
>> kernel loaded and usually the screen is set to native resolution.
>>
>> Bisect told me aaeb2554337217dfa4eac2fcc90da7be540b9a73 as the first bad
>> one. Although, checking that out and running it, works good. not sure if
>> that makes sense.
>>
> could you please check if the comment in
> https://bugzilla.kernel.org/show_bug.cgi?id=78601#c5 solves your problem
> or not?
> 
> thanks,
> rui

thanks for checking. This does not change anything though. I tested the
following on top of v3.16-rc2 and linus's tree as of today, almost -rc3.

---
 drivers/gpu/drm/i915/intel_fbdev.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_fbdev.c
b/drivers/gpu/drm/i915/intel_fbdev.c
index 088fe93..1e2f9ae 100644
--- a/drivers/gpu/drm/i915/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/intel_fbdev.c
@@ -453,7 +453,6 @@ out:
 }

 static struct drm_fb_helper_funcs intel_fb_helper_funcs = {
-       .initial_config = intel_fb_initial_config,
        .gamma_set = intel_crtc_fb_gamma_set,
        .gamma_get = intel_crtc_fb_gamma_get,
        .fb_probe = intelfb_create,
-- 
1.7.10.4



>>>>>> Do you have other people complain about that? Bisecting didn't lead to
>>>>>> a good result. I could be wrong but I somehow suspect the mistake to be
>>>>>> somewhere in commit 99678ed73a50d2df8b5f3c801e29e9b7a3e5aa85
>>>>>>
>>>>> In order to confirm if the problem is introduced by the above commit,
>>>>> why not checkout the kernel just before and after this commit and see if the problem exists?
>>>>>
>>>>> Thanks,
>>>>> rui
>>>>>
>>>> So maybe I was wrong. d27050641e9bc056446deb0814e7ba1aa7911f5a is still
>>>> good and aaeb2554337217dfa4eac2fcc90da7be540b9a73 is the fist bad one.
>>>> This is a big v4l merge. I added the linux-media list in cc now.
>>>>
>>>> What could be the problem here?
>>>>
>>>>>
>>>>>> There is nothing unusual in the kernel log.
>>>>>>
>>>>>> This is quite unusual for an -rc2. Hence my question. I'm happy to test
>>>>>> changes.
>>>>>>
>>>>>>                                      martin
>>>>>> --
>>>>>> Martin Kepplinger
>>>>>> e-mail        martink AT posteo DOT at
>>>>>> chat (XMPP)   martink AT jabber DOT at
>>>>
>>>
>>>
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

