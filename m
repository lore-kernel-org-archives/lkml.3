Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3D0PhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 11:37:10 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:64723 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab3D0PhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 11:37:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAPnjgZ1P6dmRB0sO2qBUtd=WBiNcY339NAit2faaotAfEqQDeQ@mail.gmail.com>
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com> <CAPnjgZ1P6dmRB0sO2qBUtd=WBiNcY339NAit2faaotAfEqQDeQ@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 28 Apr 2013 00:36:45 +0900
Message-ID: <CAAVeFuLCoi07-9KWyi+iJ58Zb-aiQg1pgCvq1fmF+FKuzfCRiQ@mail.gmail.com>
Subject: Re: [PATCH v8 0/3] Runtime Interpreted Power Sequences
To: Simon Glass <sjg@chromium.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        lk <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Sat, Apr 27, 2013 at 3:55 AM, Simon Glass <sjg@chromium.org> wrote:
> Hi,
>
> On Thu, Nov 15, 2012 at 10:38 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> Hopefully the final series before the feature gets merged. Anton Vorontsov
>> kindly accepted to take it into his tree, so this series is mostly a call for
>> acks, tests and reviews notices before the merge window for 3.8 opens. If you
>> are interested in seeing this feature, please add your name.
>>
>> This series also adds an entry for the subsystem into MAINTAINERS, setting me as
>> the person in charge.
>>
>> Changes from v7:
>> - fix bug reported by Tony Prisk
>> - add MAINTAINERS entry
>>
>> Alexandre Courbot (3):
>>   Runtime Interpreted Power Sequences
>>   pwm_backlight: use power sequences
>>   Take maintainership of power sequences
>
> Did this actually land? I can't see it in linux-next.

It has not landed yet, and will not land in the form that I proposed
initially. There were some obvious issues with describing the
sequences in the device tree, and I decided to rethink the whole
thing, study the state of the art some more (especially ACPI) and
start again from a blank page.

The v2 idea is almost ready to be shared, but it needs a cleaner way
to manage GPIOs, which itself requires gpiolib to be refactored and
the GENERIC_GPIO option to be removed. These last two items will land
in 3.10, so I hope to have both the gpiod interface *and* the new
power seqs ready and approved for 3.11. Then my $@?*^! panel backlight
will maybe finally switch on (no kidding - that's really what this
whole thing is about).

The new power seqs will fundamentally work in a similar fashion to v1
(a simple bytecode that controls power-related items), but will not be
encoded through the DT. Instead, I'd like to have small power control
objects that can be referenced by the platform data of pseq-enabled
drivers, or fetched and associated to the driver through the
compatible property of the DT. These objects will have, as before,
power resources they need to request, and power methods that the
driver can call as needed.

I hate to give dates, but my wish is to come with a first version of
the code by the time the merge window closes. And yes, I still plan to
use Anton as a trojan horse to get this in. ;)

Thanks,
Alex.
