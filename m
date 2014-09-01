Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaIAJYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:24:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:13013 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbaIAJYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:24:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,441,1406617200"; 
   d="scan'208";a="592754622"
Date: Mon, 1 Sep 2014 12:24:32 +0300
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] iio: accel: BMC150: fix issues when
 CONFIG_PM_RUNTIME is not set
Message-ID: <20140901092431.GA12606@lpalcu-linux>
References: <1409301488-22166-1-git-send-email-laurentiu.palcu@intel.com>
 <1409301488-22166-3-git-send-email-laurentiu.palcu@intel.com>
 <5401AB4D.4000103@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5401AB4D.4000103@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 11:45:33AM +0100, Jonathan Cameron wrote:
> On 29/08/14 09:38, Laurentiu Palcu wrote:
> > When CONFIG_PM_RUNTIME is not set, the following issues are seen:
> >  * warning message at compilation time:
> >     warning: 'bmc150_accel_get_startup_times' defined but not used [-Wunused-function]
> >  * bmc150_accel_set_power_state() will always fail and reading the
> >    accelerometer data is impossible;
> Why? Would be good to have an explanation here...
> 
> If on is true then it will call pm_runtime_get_sync which calls __pm_runtime_resume
> which when CONFIG_PM_RUNTIME is not defined returns 1 which is not an error.
> 
> In the on = false case it calls pm_runtime_put_autosuspend which calls __pm_runtime_suspend
> which returns -ENOSYS and gives our error.
> 
> I'll add something to the patch description to this effect.
Thank you! I'll try to better describe my changes next time.

laurentiu
