Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3JIHzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:55:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:28855 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab3JIHzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:55:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1062,1371106800"; 
   d="scan'208";a="372238702"
Date: Wed, 9 Oct 2013 11:01:09 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        rjw@rjwysocki.net, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] gpiolib / ACPI: convert to gpiod interfaces
Message-ID: <20131009080109.GT3521@intel.com>
References: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
 <1380639537-23406-3-git-send-email-mika.westerberg@linux.intel.com>
 <CAAVeFuJZ3TwozZzpuHcYPDLjEsb2D_qvQADf85s3-eywYYHs8A@mail.gmail.com>
 <20131008084508.GI3521@intel.com>
 <20131008103625.GK3521@intel.com>
 <CAAVeFuJLyqHO+uNm-ehLm4QQU-ZyxsZ0KUG4uYSLvBtbvGQeeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFuJLyqHO+uNm-ehLm4QQU-ZyxsZ0KUG4uYSLvBtbvGQeeQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 09:26:14AM -0700, Alexandre Courbot wrote:
> On Tue, Oct 8, 2013 at 3:36 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Tue, Oct 08, 2013 at 11:45:08AM +0300, Mika Westerberg wrote:
> >> > I also wonder whether you could also avoid exporting acpi_get_gpiod*
> >> > (which allow GPIO consumers to shortcut gpiolib) by implementing
> >> > acpi_get_gpio* into the C file (maybe even using gpiod_get()). I see a
> >> > "char *path" parameter though, so maybe that would not be possible at
> >> > the moment.
> >>
> >> Good point, I'll check if we can do that.
> >
> > Looks like we can get rid of acpi_get_gpio() and acpi_get_gpiod() as there
> > are no users for those outside gpiolib-acpi. I'm going to do that in the
> > next revision.
> 
> That's good news. If you can make it such that ACPI GPIO consumers
> don't need to include acpi_gpio.h anymore, then this would make my
> day. :)

We can get rid of the whole apci_gpio.h eventually. But before doing that I
would like to have something that supports both the ACPI way and gpiod way
in v3.13 if possible.

Once we have gpiod_get_index() in mainline, we can convert the existing
user to it and drop acpi_gpio.h completely.
