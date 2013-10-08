Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3JHKbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:31:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:18963 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab3JHKa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:30:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1056,1371106800"; 
   d="scan'208";a="407139565"
Date: Tue, 8 Oct 2013 13:36:25 +0300
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
Message-ID: <20131008103625.GK3521@intel.com>
References: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
 <1380639537-23406-3-git-send-email-mika.westerberg@linux.intel.com>
 <CAAVeFuJZ3TwozZzpuHcYPDLjEsb2D_qvQADf85s3-eywYYHs8A@mail.gmail.com>
 <20131008084508.GI3521@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008084508.GI3521@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 11:45:08AM +0300, Mika Westerberg wrote:
> > I also wonder whether you could also avoid exporting acpi_get_gpiod*
> > (which allow GPIO consumers to shortcut gpiolib) by implementing
> > acpi_get_gpio* into the C file (maybe even using gpiod_get()). I see a
> > "char *path" parameter though, so maybe that would not be possible at
> > the moment.
> 
> Good point, I'll check if we can do that.

Looks like we can get rid of acpi_get_gpio() and acpi_get_gpiod() as there
are no users for those outside gpiolib-acpi. I'm going to do that in the
next revision.
