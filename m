Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab3BKQCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:02:45 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53410 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757658Ab3BKQCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:02:44 -0500
Date: Mon, 11 Feb 2013 16:02:30 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Len Brown <lenb@kernel.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 06/16] ARM idle: delete pm_idle
Message-ID: <20130211160229.GB5676@MacBook-Pro.local>
References: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
 <9838a4aeee256adeaef90efe56df2c9988206982.1360475150.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9838a4aeee256adeaef90efe56df2c9988206982.1360475150.git.len.brown@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 05:58:13AM +0000, Len Brown wrote:
> pm_idle() on ARM was a synonym for default_idle(),
> so simply invoke default_idle() directly.

The clean-up looks fine as we already have an arm_pm_idle but longer
term I was thinking about having a common declaration similar to
pm_power_off that code under drivers/power/(reset/) can override (and
such driver may be shared by multiple architectures). OTOH, if you get
rid of the generic linux/pm.h declaration architectures can use a common
pm_idle name and type (though I think having it in the common header
would be better). For ARM this would mean s/arm_pm_idle/pm_idle/ on top
if your patch.

Do you have any plans with pm_power_off as well?

Thanks.

-- 
Catalin
