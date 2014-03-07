Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaCGWIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 17:08:21 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51500 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaCGWIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 17:08:20 -0500
MIME-Version: 1.0
In-Reply-To: <1394226207.7470.15.camel@x220>
References: <1391886379.2669.11.camel@x41> <CAKMK7uE6Gaq-ghgWJ+6Qyn7hrGzAMOHyGT9KQQJ+ij7omPV2Ew@mail.gmail.com>
 <1391890927.1882.5.camel@x41> <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
 <1391951759.6036.7.camel@artifact> <1391952344.25424.4.camel@x220>
 <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com>
 <1394185698.5608.5.camel@x41> <CAErSpo4jiq38P3TNuGLGS--nbV9NtUAmiuK=cwWyFAneY-=eOA@mail.gmail.com>
 <1394212609.1987.6.camel@x41> <20140307204021.GA9822@google.com> <1394226207.7470.15.camel@x220>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 7 Mar 2014 15:07:59 -0700
Message-ID: <CAErSpo6frh_2Yi4pFBEcvsyneUvJQy2V6WVnACP3iaRcF1MR-A@mail.gmail.com>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset flushing
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Steven Newbury <steve@snewbury.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 2:03 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Fri, 2014-03-07 at 13:40 -0700, Bjorn Helgaas wrote:
>> It seems quite possible that I broke pci_bus_alloc_resource(), which could
>> cause an allocation failure like this.
>>
>> If you have a chance to try it, here's a debug patch against v3.14-rc5.  It
>> should apply cleanly to 96702be56037.  If you can try it, please attach the
>> dmesg log to the bugzilla.
>
> That ThinkPad X41 is now building 96702be56037. Once that build is
> finished and tested I'll try your debug patch (on top of v3.14-rc5, see
> later). It might take some time to finish both builds and test boots.

> My v3.13 based builds don't have INTEL_GTT set! My v3.14-rcy based
> builds do. I have not yet investigated why that is.

I think that's OK.  CONFIG_INTEL_GTT was added after v3.13
(00fe639a56b4 "drm/i915: Make AGP support optional").  It looks like
in v3.13, intel-gtt.o was built if CONFIG_AGP_INTEL=y (or =m), which
you probably do have (see drivers/char/agp/Makefile).

> Too bad drivers/pci/bus.o is built in by definition. If only one could
> build a kernel without rebuilding all modules. Or is there some way to
> actually do that?

You should be able to "make bzImage" and get just the kernel.  But
there might be module loading issues if the modules don't exactly
match the kernel.  I think it's possible to turn that checking off,
but I don't do it often enough to remember details.

Bjorn
