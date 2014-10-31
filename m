Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbaJaXFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 19:05:10 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:51843 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752779AbaJaXFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 19:05:08 -0400
Date: Fri, 31 Oct 2014 23:04:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH v8 1/5] PM / Runtime: Add getter for querying the IRQ
 safe option
Message-ID: <20141031230452.GX27405@n2100.arm.linux.org.uk>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
 <1413795888-18559-2-git-send-email-k.kozlowski@samsung.com>
 <32933431.rIxraemF7M@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32933431.rIxraemF7M@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 12:11:05AM +0100, Rafael J. Wysocki wrote:
> [CC list trimmed + added Kevin Hilman]
> 
> On Monday, October 20, 2014 11:04:44 AM Krzysztof Kozlowski wrote:
> > Add a simple getter pm_runtime_is_irq_safe() for querying whether runtime
> > PM IRQ safe was set or not.
> > 
> > Various bus drivers implementing runtime PM may use choose to suspend
> > differently based on IRQ safeness status of child driver (e.g. do not
> > unprepare the clock if IRQ safe is not set).
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> 
> So why do we need to add the wrapper?
> 
> And it goes kind of against the intention which was to set irq_safe when
> we knew that the callbacks were safe to be executed from interrupt context
> and not when we wished that to be the case.

This was provided in the covering email - I quote:

This patchset adds runtime and system PM to the pl330 driver.

The runtime PM of pl330 driver requires interrupt safe suspend/resume
callbacks which is in conflict with current amba bus driver.
The latter also unprepares and prepares the AMBA bus clock which
is not safe for atomic context.

The patchset solves this in patch 3/5 by handling clocks in different
way if device driver set interrupt safe runtime PM.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
