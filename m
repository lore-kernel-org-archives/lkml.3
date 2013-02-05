Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3BEQxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:53:11 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:37588 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3BEQxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:53:07 -0500
MIME-Version: 1.0
In-Reply-To: <20130205122432.GE21455@gmail.com>
References: <20130204110304.GD24173@gmail.com>
	<1360009767-3633-1-git-send-email-yinghai@kernel.org>
	<20130205122432.GE21455@gmail.com>
Date: Tue, 5 Feb 2013 08:53:05 -0800
X-Google-Sender-Auth: iopSzBrw3pRNW6SOuqzLfGPbcdg
Message-ID: <CAE9FiQXn1P0RGD-O3jeFNgAdsfv4EQyH8g7r0x3KBFfh20fF=Q@mail.gmail.com>
Subject: Re: [PATCH] x86, apic: Check fadt x2apic phys in x2apic_phys_probe()
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Stoney Wang <song-bo.wang@hp.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 4:24 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> From: Stoney Wang <song-bo.wang@hp.com>
>>
>> When HP ProLiant DL980 G7 Server boot without x2apic_phys, there will be
>> intermittent lost interrupts and could result in a hang or data loss.
>
> What does 'boot without x2apic_phys' mean?
>
> Does it mean x2apic_phys=0 boot command line? Or, because
> x2apic_phys is off by default, does it simply mean that if it's
> booted with a default kernel, without any workaround specified
> on the boot command line?

means that user does not append "x2apic_phys" in boot command line.

current we have:

        x2apic_phys     [X86-64,APIC] Use x2apic physical mode instead of
                        default x2apic cluster mode on platforms
                        supporting x2apic.

int x2apic_phys;

static int set_x2apic_phys_mode(char *arg)
{
        x2apic_phys = 1;
        return 0;
}
early_param("x2apic_phys", set_x2apic_phys_mode);

if the user specify "x2apic_phys=0", kernel still enable x2apic_phys.

Now because system could enable x2apic phys mode via fadt, do we
need to make "x2apic_phys=0" works as disabling x2apic_phys and
overriding FADT ?

Thanks

Yinghai
