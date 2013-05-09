Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3EIRij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 13:38:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39709 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750877Ab3EIRih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 13:38:37 -0400
Date: Thu, 9 May 2013 13:38:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Guenter Roeck <linux@roeck-us.net>
cc: linux-pm@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, Jean Delvare <khali@linux-fr.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 0/3] pm: Introduce __pm to mark power management code
In-Reply-To: <1368119366-8716-1-git-send-email-linux@roeck-us.net>
Message-ID: <Pine.LNX.4.44L0.1305091337050.1796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 May 2013, Guenter Roeck wrote:

> The following patch series introduces a marker for power management functions
> and data. This this marker, #ifdef CONFIG_PM and #ifdef CONFIG_PM_SLEEP
> can be removed from most of the code. This ensures that the conditional code
> still compiles but is not included in the object file.
> 
> As a side effect, drivers declaring struct dev_pm_ops unconditionally
> get a bit smaller if CONFIG_PM_SLEEP is not configured.

What about code that depends on CONFIG_PM_RUNTIME?  Or code that 
depends on CONFIG_PM_SLEEP but not on CONFIG_PM_RUNTIME?

Alan Stern


