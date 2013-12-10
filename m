Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab3LJWY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:24:58 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:54412 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3LJWYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:24:53 -0500
MIME-Version: 1.0
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D030A9EC63@satlexdag05.amd.com>
References: <CA+5PVA747A4283Rz-_udrFZqihgYo3_YYKw4n8Qqv5oUNQfz1w@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D030A9EC63@satlexdag05.amd.com>
Date: Tue, 10 Dec 2013 17:24:53 -0500
X-Google-Sender-Auth: MgAPvhDjyXnZdP3T_BZBcieR_5g
Message-ID: <CA+5PVA432hZ4GSxTxBg4zQ9QMqKCSMK95bHbXaZ+XoPE=P_76g@mail.gmail.com>
Subject: Re: Radeon crash with v3.13-rc3-157-g17b2112
From: Josh Boyer <jwboyer@fedoraproject.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Dave Airlie <airlied@redhat.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 5:07 PM, Deucher, Alexander
<Alexander.Deucher@amd.com> wrote:
>> -----Original Message-----
>> From: jwboyer@gmail.com [mailto:jwboyer@gmail.com] On Behalf Of Josh
>> Boyer
>> Sent: Tuesday, December 10, 2013 5:04 PM
>> To: Deucher, Alexander; Guenter Roeck; Dave Airlie
>> Cc: Linux-Kernel@Vger. Kernel. Org; DRI mailing list; Linus Torvalds
>> Subject: Radeon crash with v3.13-rc3-157-g17b2112
>>
>> Hi All,
>>
>> Booting today's rawhide kernel fails on my Dell XPS 8300 machine.  I
>> added nomodeset to the command line because it seemed to glitch out
>> when doing the handoff to the radeon driver and that let me boot far
>> enough to start networking.  I then loaded the radeon driver with:
>> modprobe radeon modeset=1 and was greeted with the backtrace below.
>>
>> I haven't done a bisect yet, but I can if needs be.  I was hoping this
>> would trigger someone's memory.  Plain 3.13-rc3 works, so it's
>> something in the DRM merge that Linus did after -rc3.  Given the
>> backtrace, this one might be suspect:
>>
>> commit ec39f64bba3421c2060fcbd1aeb6eec81fe0a42d
>> Author: Guenter Roeck <linux@roeck-us.net>
>> Date:   Fri Nov 22 21:52:00 2013 -0800
>>
>>     drm/radeon/dpm: Convert to use devm_hwmon_register_with_groups
>>
>
> Should be fixed by the patch in:
> https://bugs.freedesktop.org/show_bug.cgi?id=72457

OK.  I'll give that a spin soon.  Thanks for the quick reply!

josh
