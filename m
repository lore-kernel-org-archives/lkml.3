Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaCNLEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:04:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:29125 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbaCNLEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:04:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,654,1389772800"; 
   d="scan'208";a="499791275"
Date: Fri, 14 Mar 2014 13:11:51 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] gpio / ACPI: Add support for ACPI GPIO operation
 regions
Message-ID: <20140314111151.GH5018@intel.com>
References: <1394456094-21671-1-git-send-email-mika.westerberg@linux.intel.com>
 <1394456094-21671-6-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdY3z-XGHwn5sQKM-8cKYHzr3_40h53032ETN6PaDW779w@mail.gmail.com>
 <20140313151816.GR5018@intel.com>
 <CACRpkdZfeGkHp8kc-Uv+5Q6xRN1NwiZD-kLWS93x0jV=kn30MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZfeGkHp8kc-Uv+5Q6xRN1NwiZD-kLWS93x0jV=kn30MA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 11:53:30AM +0100, Linus Walleij wrote:
> On Thu, Mar 13, 2014 at 4:18 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Thu, Mar 13, 2014 at 03:32:01PM +0100, Linus Walleij wrote:
> 
> >> > +                       case ACPI_IO_RESTRICT_OUTPUT:
> >> > +                               gpiod_direction_output(desc, pull);
> >>
> >> Can you explain why the fact that the line is pulled down affects the
> >> default output value like this? I don't get it.
> >
> > That's the thing - ACPI doesn't tell us what is the initial value of the
> > pin. There is no such field in GpioIo() resource.
> >
> > So I'm assuming here that if it says that the pin is pulled up, the default
> > value will be high.
> 
> OK! So exactly that statement is what I want to see as a comment
> in this switch case.

Sure. I'll add that comment to the next version of this patch.
