Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaAVJYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:24:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:60461 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbaAVJYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:24:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,698,1384329600"; 
   d="scan'208";a="442778097"
Date: Wed, 22 Jan 2014 11:31:16 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chew Kean Ho <kean.ho.chew@intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: Re: [PATCH] pwm: add support for Intel Low Power Subsystem PWM
Message-ID: <20140122093116.GR18029@intel.com>
References: <1390240808-18582-1-git-send-email-chiau.ee.chew@intel.com>
 <20140120132814.212929bd@alan.etchedpixels.co.uk>
 <20140121085236.GI18029@intel.com>
 <20140121194338.GA12085@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121194338.GA12085@ulmo.nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 08:43:39PM +0100, Thierry Reding wrote:
> The idea behind this is that only a single user can have access to a
> given PWM device at a time. The PWM device's PWMF_REQUESTED flag is set
> (and cleared) under the pwm_lock and any subsequent users will not be
> able to use that specific device (pwm_request() return -EBUSY).
> 
> There is obviously an assumption here that each user knows what they are
> doing and aren't calling any of the public pwm_*() functions
> concurrently. I haven't come across a situation where this is actually a
> problem because typically these functions are called either via sysfs or
> some other higher-level where synchronization is already properly
> handled.
> 
> So the only thing that drivers should be taking care of is synchronizing
> access to registers common to multiple PWM devices.

OK, and since LPSS PWM don't share registers we shouldn't need to do
anything here.

> Does that clarify things?

It does for me, thanks for the explanation.
