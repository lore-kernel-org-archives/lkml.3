Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3A0XxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:53:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:37170 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756963Ab3A0Xw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:52:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,547,1355126400"; 
   d="scan'208";a="279037732"
Date: Mon, 28 Jan 2013 00:52:59 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 09/26] mfd: ab8500-debugfs: Provide a means for a user
 subscribe to IRQs
Message-ID: <20130127235259.GO1174@sortiz-mobl>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-10-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358254566-12419-10-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Jan 15, 2013 at 12:55:49PM +0000, Lee Jones wrote:
> Allow users to subscribe to and view IRQ events live from debugfs.
I seem to remember that I got a similar patch some time ago for the same
purpose and my answer was: Please use a UIO driver for this. There already is
such driver, it's uio_pdrv_genirq. What your debugfs registration entry could
do is adding a platform device for the specific interrupt number. This would
avoid the irq handler registration and the sysfs entry creation, both things I
believe are not very elegant and open coded. It also gives you an IRQ count
implementation.
Ideally, the UIO framework could be improved to support IRQ ranges (through
IRQ domains) instead of the current single interrupt number.

Have you considered going through that path ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
