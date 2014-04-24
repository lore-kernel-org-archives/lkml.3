Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaDXG2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:28:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:54695 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbaDXG2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:28:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,917,1389772800"; 
   d="scan'208";a="518576195"
Date: Thu, 24 Apr 2014 09:35:46 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: Timur Tabi <timur@codeaurora.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
Message-ID: <20140424063546.GA30677@intel.com>
References: <1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com>
 <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com>
 <534B93BA.6020406@linux.intel.com>
 <534BFAAF.3070805@codeaurora.org>
 <534D0370.50108@linux.intel.com>
 <535005BA.1040405@codeaurora.org>
 <5357A80B.8030701@linux.intel.com>
 <5357ACF1.9070206@codeaurora.org>
 <20140423135915.GY30677@intel.com>
 <5357D8CC.3080501@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5357D8CC.3080501@codeaurora.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 10:14:20AM -0500, Timur Tabi wrote:
> Westerberg, Mika wrote:
> >It doesn't do any pin control nor muxing and I'm not sure if it is
> >required. Can you elaborate why you think pin muxing is required with
> >GpioIo/GpioInt resources?
> 
> How are the pin muxes normally configured in ACPI?  All of our GPIOs
> have a pinmux on them, and so if you want to use the pin for the
> non-default functionality, you need to configure the mux.  Isn't
> that supposed to happen with the through the pinctrl driver?

It's the BIOS that handles all this even though there are several
"alternate functions" in the GPIO hardware. BIOS goes and configures those
according what the platform needs and those that are GPIOs/IRQs it will
create corresponding GpioIo/GpioInt along with the device that uses them.

Of course if you have a custom board and your BIOS doesn't handle this, you
are going to need some sort of pinctrl driver.

> That is, when the kernel parses the ASL, and it seems a command to
> configure pin #3 to function #4, it calls the local pinctrl driver to do
> that?

I'm not aware of ASL code that allows you to do that. Do you have examples?
