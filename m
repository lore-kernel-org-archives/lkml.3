Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3JKGwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:52:06 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:37340 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3JKGwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:52:01 -0400
MIME-Version: 1.0
In-Reply-To: <1381440651.5630.31.camel@pasglop>
References: <1381378788.4330.30.camel@pasglop>
	<20131010174457.GE13759@kroah.com>
	<1381435276.5630.6.camel@pasglop>
	<CAMuHMdW7RXjS3vvLUdTPCafNu_PcgDgbVbzVCHTOEeTsfHK90g@mail.gmail.com>
	<1381440651.5630.31.camel@pasglop>
Date: Fri, 11 Oct 2013 08:52:00 +0200
X-Google-Sender-Auth: KoHmY3c7Zn2Vo0d_8Phfn-8jCJE
Message-ID: <CAMuHMdU_90EhPng0NYPVmWAwDt2NOowB3thPB+jJarme-A7eew@mail.gmail.com>
Subject: Re: sysfs for my chips
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 11:30 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Thu, 2013-10-10 at 22:26 +0200, Geert Uytterhoeven wrote:
>> > This is not CPUs. CPUs are threads really. Even if they were cores,
>> that
>> > still wouldn't cut it. I'm looking at chips here and not all of them
>> > actually processor chips. The SCOM bus address space is global to a
>> > physical chip and allows to access various resources that are only
>> > remotely related to the cores on it.
>>
>> What about a "bus" for the sideband bus? That allows to decouple it
>> from cores, and allows to support non-processor chips, too?
>
> Not sure what you mean .... create a linux bus type with devices on
> it ?

Yes, that's what I meant.

>From the nodes on that bus you can have symlinks in sysfs to e.g. the CPUs
in the rest of the sysfs tree.

It's a bit like smbus/i2c connecting various peripherals that may also be
connected in some other way (e.g. media devices).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
