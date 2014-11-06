Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbaKFGHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 01:07:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:21436 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbaKFGHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 01:07:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,324,1413270000"; 
   d="scan'208";a="627467238"
Date: Thu, 6 Nov 2014 08:07:13 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
Message-ID: <20141106060713.GB1618@lahna.fi.intel.com>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
 <CAOesGMheJzkQ9jEmDx9+hpjk0Scbnv_JiK1yH+7eoxY4PYUS4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMheJzkQ9jEmDx9+hpjk0Scbnv_JiK1yH+7eoxY4PYUS4A@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 01:44:24PM -0800, Olof Johansson wrote:
> Pinctrl setup has traditionally always been done by firmware on x86,
> and some ARM platforms are again moving back to that state (since
> reconfiguring pinctrl in the kernel is in some cases not safe).
> 
> What's the purpose of exposing this to the kernel on x86 now? I can
> see the need to expose GPIO, but not pinctrl? Having the pin control
> hidden away in firmware has been one of the benefits on x86, and
> you're now undoing it... :)

Well, the hardware is actually a pin controller so it can configure pins
in different way.

In addition to that we still do expect that the pins are configured by
the BIOS for the time being. The advantage of having pinctrl driver is
more like fixing things that the BIOS got wrong (like for example SPI
pins that were muxed as GPIOs), not to reconfigure everything.

Plus it has really nice debugfs interface :-)
