Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaIXRxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:53:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40715 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbaIXRxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:53:07 -0400
Date: Wed, 24 Sep 2014 19:53:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v7 1/5] PM / Runtime: Add getter for quering the IRQ safe
 option
Message-ID: <20140924175302.GB1231@amd>
References: <1411566612-32277-1-git-send-email-k.kozlowski@samsung.com>
 <1411566612-32277-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411566612-32277-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-09-24 15:50:08, Krzysztof Kozlowski wrote:
> Add a simple getter pm_runtime_is_irq_safe() for quering whether runtime
> PM IRQ safe was set or not.
> 
> Various bus drivers implementing runtime PM may use choose to suspend
> differently based on IRQ safeness status of child driver (e.g. do not
> unprepare the clock if IRQ safe is not set).
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Are you sure this is good interface?

"Tell me if another function works this or that way".

That's certainly not traditional interface, and it seems dangerous to
me. Callbacks now have different semantic requirements based on value
of some flag...

Would it be possible to have two sets of callbacks, one irq safe and
one not?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
