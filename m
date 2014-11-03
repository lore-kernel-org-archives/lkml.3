Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaKCRRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:17:18 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47464 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaKCRRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:17:13 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Jonathan Corbet <corbet@lwn.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v8 3/5] amba: Don't unprepare the clocks if device driver wants IRQ safe runtime PM
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
	<1413795888-18559-4-git-send-email-k.kozlowski@samsung.com>
	<1479283.dvHduzBoyf@vostro.rjw.lan>
	<20141101005514.GY27405@n2100.arm.linux.org.uk>
	<20141101010113.GA3831@n2100.arm.linux.org.uk>
Date: Mon, 03 Nov 2014 09:17:08 -0800
In-Reply-To: <20141101010113.GA3831@n2100.arm.linux.org.uk> (Russell King's
	message of "Sat, 1 Nov 2014 01:01:13 +0000")
Message-ID: <7hoasoi4q3.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

[...]

> Would another possible solution be to remember the irq-safeness in the
> suspend handler, and use that in the resume handler?  Resume should
> /always/ undo what the suspend handler previously did wrt clk API stuff.

This seems more reasonable to me.

Currently, the setting of irq_safe-ness is permanent (there's no exposed
API to unset it after you set it.) so assuming it to be the same across
suspend resume is a safe assumption.

Kevin
