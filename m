Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab3JOAWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 20:22:09 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:63248 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3JOAWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 20:22:07 -0400
MIME-Version: 1.0
In-Reply-To: <20131014233416.GA29878@srcf.ucam.org>
References: <1381236524-19633-1-git-send-email-felipe.contreras@gmail.com>
	<CAHR064ge8zew7uMeD+_LXR3ju5ARGG1y8utLOFzOLexny_DPLA@mail.gmail.com>
	<1381421199.4248.2.camel@x230.lan>
	<CAMP44s04+_aP7KpVMTUjdNcRWMg6PC6HBaNhF_uhAHm=fhmTcw@mail.gmail.com>
	<20131013151729.GA4028@srcf.ucam.org>
	<CAMP44s0utW0ABWgFicDH=vDMxZbQudeM6D13RL8BfPnr55hR8Q@mail.gmail.com>
	<20131014155254.GB20187@srcf.ucam.org>
	<CAMP44s3O6z6-gVCqhCps7fKSKMbL9JSakZLfBUxqUYytrWFWKw@mail.gmail.com>
	<20131014232239.GA29716@srcf.ucam.org>
	<CAMP44s0vo+XAF_6Q9S2KGNyuEEPtn99qynuqcbE_=RYe3xM71g@mail.gmail.com>
	<20131014233416.GA29878@srcf.ucam.org>
Date: Mon, 14 Oct 2013 19:22:04 -0500
Message-ID: <CAMP44s0Whsmg_8EK9kpsHDGtCM8NkwCSK-mQ68r2re8Vfis8ig@mail.gmail.com>
Subject: Re: [PATCH v2] platform: x86: asus-wmi: add fan control
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "corentin.chary@gmail.com" <corentin.chary@gmail.com>,
        "acpi4asus-user@lists.sourceforge.net" 
	<acpi4asus-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 6:34 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Oct 14, 2013 at 06:27:33PM -0500, Felipe Contreras wrote:
>> On Mon, Oct 14, 2013 at 6:22 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > The easiest is to just do it from userspace. I think Intel have some
>> > code for doing this, but I haven't looked at the thermal code for years.
>>
>> That defeats the purpose of the whole thermal binding infrastructure.
>
> Not really, but I agree it's not ideal.

So what's the point of thermal_zone_bind_cooling_device?

>> >> > I don't think you can easily register multiple drivers for the same WMI
>> >> > device.
>> >>
>> >> I don't mean this one, I mean the standalone one. Actually, the first
>> >> one I sent doesn't require all this system memory stuff.
>> >
>> > Banging EC registers directly is the wrong thing to do. Going via WMI is
>> > correct.
>>
>> I'm not going to bother arguing against your absolutist rhetoric. The
>> fact is one patch can be applied, the other can't. Besides, nobody
>> said anything about banging EC registers directly.
>
> I'm sorry, you're right - you're calling ACPI methods directly instead.
> This is still incorrect. The platform provides an exported interface,
> and you should use that exported interface.

Maybe, but I can call those same methods outside asus-wmi.

> As long as Corentin doesn't object, I'm happy to merge this driver in
> its current form (including virt_to_phys()) providing that it's wrapped
> in CONFIG_STAGING, and assuming that you'll do the supporting work in
> acpica. I'll pull it out again in 6 months or so if that hasn't been
> fixed up. Fair?

That's fair, I'll give that a try soon.

-- 
Felipe Contreras
