Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaJOMSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:18:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44942 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaJOMSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:18:44 -0400
Date: Wed, 15 Oct 2014 14:18:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 0/7] power_supply: Decrement the device reference counter
Message-ID: <20141015121841.GA26579@amd>
References: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The reference counter of device allocated for power supply was
> incremented with each call to power_supply_get_by_name() and
> power_supply_get_by_phandle().
> 
> Add a symmetric 'put' operation so the device could be released after
> final put_device() call during supply unregistering.
> 
> 
> Rebased on next-20141007 + mine [1] patchset.
> Tested on Trats2 board (max77693 + charger manager).
> 
> Kindly asking for reviewing/testing other drivers.

I'm not sure if we should support power_supply_put(NULL), but
otherwise the series looks ok to me.

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
