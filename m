Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaGCGLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 02:11:18 -0400
Received: from mail.alumni.tu-berlin.de ([130.149.5.29]:33067 "EHLO
	mail-2.alumni.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754368AbaGCGLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 02:11:12 -0400
X-tubIT-Incoming-IP: 91.47.47.4
Message-ID: <53B4F3FB.6030108@math.tu-berlin.de>
Date: Thu, 03 Jul 2014 08:11:07 +0200
From: Thomas Richter <thor@math.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org,
        Ville Syrj?l? <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>, rjw@sisk.pl
Subject: Re: Kernel OOPS when reloading i915 after resume from suspend
References: <53B05033.7070709@math.tu-berlin.de> <13976_1404336180_53B47834_13976_165_1_20140702212219.GA2842@xo-6d-61-c0.localdomain>
In-Reply-To: <13976_1404336180_53B47834_13976_165_1_20140702212219.GA2842@xo-6d-61-c0.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.07.2014 23:22, schrieb Pavel Machek:
> Hi!
>
>> still experimenting with the resume from suspend on the Fujitsu
>> S6010. I can, however, still create a kernel oops. The kernel source
>> comes from alm_fixes5, kernel 3.15.0-rc7+. For that, do the
>> following:
>>
>> 1) Shut down X,
>> 2) Unbind the consoles:
>>
>> echo 0 > /sys/class/vtconsole/vtcon1/bind
>> echo 0 > /sys/class/vtconsole/vtcon0/bind
>>
>> 3) Remove the i915
>>
>> rmmod i915
>>
>> 4) Suspend the system
>>
>> pm-suspend
>
> Does it also break with plain echo mem > /sys/power/state?

No. If the modules stay resident, any user driven shutdown/resume events 
by writing into /sys/power/state work just fine.

> Does it break when you don't suspend at all?

No. Unloading and reloading i915 under normal conditions also works fine.

>> 5) Resume the system by pressing on the power-button.
>> 6) Reload the i915 module with
>>
>> modprobe i915.
>>
>> Result is a kernel-Oops:
>
> Sounds like problem in suspend/resume framework, actually :-(.

Good guess, but wrong. The BIOS leaves the 830GM in a state the i915 
does not seem to like.

Greetings,
	Thomas


