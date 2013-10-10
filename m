Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3JJF0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:26:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:11526 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab3JJF0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:26:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1069,1371106800"; 
   d="scan'208";a="408658506"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Aaron Lu <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Ben Jencks <ben@bjencks.net>, Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?utf-8?Q?J=C3=B6rg?= Otte <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>,
        platform-driver-x86@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH v4 1/4] backlight: introduce backlight_device_registered
In-Reply-To: <525632AE.2080909@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1381214401-24672-1-git-send-email-aaron.lu@intel.com> <1381214401-24672-2-git-send-email-aaron.lu@intel.com> <2202423.8QyNjoNEPr@vostro.rjw.lan> <5255FAC5.2090105@intel.com> <878uy1694u.fsf@intel.com> <525632AE.2080909@intel.com>
User-Agent: Notmuch/0.16+88~gce1bf71 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 10 Oct 2013 08:23:02 +0300
Message-ID: <874n8p66o9.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013, Aaron Lu <aaron.lu@intel.com> wrote:
> On 10/10/2013 12:29 PM, Jani Nikula wrote:
>> On Thu, 10 Oct 2013, Aaron Lu <aaron.lu@intel.com> wrote:
>>> On 10/10/2013 08:25 AM, Rafael J. Wysocki wrote:
>>>> On Tuesday, October 08, 2013 02:39:58 PM Aaron Lu wrote:
>>>>> +bool backlight_device_registered(enum backlight_type type)
>>>>> +{
>>>>> +	bool found = false;
>>>>> +	struct backlight_device *bd;
>>>>> +
>>>>> +	mutex_lock(&bd_list_mutex);
>>>>> +	list_for_each_entry(bd, &bd_list_head, entry) {
>>>>> +		if (bd->props.type == type) {
>>>>> +			found = true;
>>>>> +			break;
>>>>> +		}
>>>>> +	}
>>>>
>>>> Isn't it useful to be able to register more than one backlight device of the
>>>> same type sometimes?
>>>
>>> I think so for some kind of computers. OTOH, the above function should
>>> be enough for the problem we are solving here, if someday we need to
>>> differentiate, we can enhance the code then.
>> 
>> Since both Baytrail and Haswell already have two backlight PWMs, this
>> may be needed sooner than you think. But we shouldn't let that block
>
> Do we need to differentiate which backlight PWM is registered to decide
> if ACPI video backlight interface should be skipped? My understanding is
> no.

That's correct. If things change, we can fix it then.

Jani.


>
> Thanks,
> Aaron
>
>> fixing the more urgent issue we have now. So I'm fine with this. It
>> doesn't prevent one from registering more than one device of the same
>> type anyway.
>> 
>> BR,
>> Jani.
>> 
>> 
>> 
>

-- 
Jani Nikula, Intel Open Source Technology Center
