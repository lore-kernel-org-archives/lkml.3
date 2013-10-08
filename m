Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab3JHQ0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:26:37 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:40862 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3JHQ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:26:35 -0400
MIME-Version: 1.0
In-Reply-To: <20131008103625.GK3521@intel.com>
References: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
 <1380639537-23406-3-git-send-email-mika.westerberg@linux.intel.com>
 <CAAVeFuJZ3TwozZzpuHcYPDLjEsb2D_qvQADf85s3-eywYYHs8A@mail.gmail.com>
 <20131008084508.GI3521@intel.com> <20131008103625.GK3521@intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 8 Oct 2013 09:26:14 -0700
Message-ID: <CAAVeFuJLyqHO+uNm-ehLm4QQU-ZyxsZ0KUG4uYSLvBtbvGQeeQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] gpiolib / ACPI: convert to gpiod interfaces
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        rjw@rjwysocki.net, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 3:36 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Tue, Oct 08, 2013 at 11:45:08AM +0300, Mika Westerberg wrote:
>> > I also wonder whether you could also avoid exporting acpi_get_gpiod*
>> > (which allow GPIO consumers to shortcut gpiolib) by implementing
>> > acpi_get_gpio* into the C file (maybe even using gpiod_get()). I see a
>> > "char *path" parameter though, so maybe that would not be possible at
>> > the moment.
>>
>> Good point, I'll check if we can do that.
>
> Looks like we can get rid of acpi_get_gpio() and acpi_get_gpiod() as there
> are no users for those outside gpiolib-acpi. I'm going to do that in the
> next revision.

That's good news. If you can make it such that ACPI GPIO consumers
don't need to include acpi_gpio.h anymore, then this would make my
day. :)

Alex.
