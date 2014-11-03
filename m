Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaKCJYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:24:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:13617 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaKCJYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:24:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,305,1413270000"; 
   d="scan'208";a="600976124"
Date: Mon, 3 Nov 2014 11:24:02 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>, mathias.nyman@linux.intel.com
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141103092402.GA1304@lahna.fi.intel.com>
References: <20141013191405.GB29810@saruman>
 <20141013192404.GB4034@psi-dev26.jf.intel.com>
 <20141013192632.GC29810@saruman>
 <20141013193618.GD29810@saruman>
 <CACRpkdYDiFvwsPwqACXS2bZU9peUyJEn-fpzVqZKYXseuEFGGA@mail.gmail.com>
 <20141028144249.GD8123@saruman>
 <CACRpkdaN5hNWFUOFbHLm8HgZEKVSETUgVF4Cn4UbMQxNEg46Vw@mail.gmail.com>
 <20141031132005.GB1273@saruman>
 <20141031162339.GA7136@psi-dev26.jf.intel.com>
 <20141031184509.GA2224@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031184509.GA2224@psi-dev26.jf.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 11:45:09AM -0700, David Cohen wrote:
> > I think adding the module exit + allowing this driver to be a module
> > would be a good approach. Then we don't need to force generic x86 kernel
> > binaries to always have this driver. Unless Mathias or Mika knows a
> > constraint to force this driver to be builtin only.
> 
> It helps if I CC them when asking for feedback :)
> 
> Mathias, Mika, do you know any constraint that forces pinctrl-baytrail
> to be bool?

The only constraint that has been keeping this driver as bool is that
some machines like, Asus T100, uses ACPI GPIO operation regions for
toggling GPIOs to get things like sensor hub powered on. The GPIO
operation region code does not yet handle -EPROBE_DEFER so only way to
ensure that the operation region is there is to have the driver compiled
in to the kernel.
