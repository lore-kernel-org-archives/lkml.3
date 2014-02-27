Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaB0Jke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:40:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:27724 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaB0Jka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:40:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,553,1389772800"; 
   d="scan'208";a="490792986"
Date: Thu, 27 Feb 2014 11:48:02 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] gpiolib: Allow GPIO chips to request their own GPIOs
Message-ID: <20140227094802.GI5018@intel.com>
References: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com>
 <1491992.y6nTRlJ009@vostro.rjw.lan>
 <20140226090542.GT5018@intel.com>
 <1566118.4zS0BNjL3A@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566118.4zS0BNjL3A@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 02:47:58PM +0100, Rafael J. Wysocki wrote:
> > Sounds good. Only thing I'm not sure about is the fact that
> > __gpiod_request() releases the lock when it calls chip driver callbacks
> > (and takes it back of course). Is that acceptable practice to take the lock
> > outside of a function and release it inside for a while?
> 
> Yes, you can do that.
> 
> There even are sparse annotations for that: __releases() and __acquires()
> (__rpm_callback() in drivers/base/power/runtime.c uses them among other things).

Ah, good to know. Thanks!
