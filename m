Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaDYLdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:33:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:61956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaDYLdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:33:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,926,1389772800"; 
   d="scan'208";a="519652706"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@jikos.cz>
Subject: Re: [bisect result] Re: 3.15-rc2: i915 regression: only top 20% of screen works in X
In-Reply-To: <20140424220638.GA29385@atrey.karlin.mff.cuni.cz>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20140423202248.GA3621@amd.pavel.ucw.cz> <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com> <20140423220952.GA3627@amd.pavel.ucw.cz> <20140424055023.GA31221@nuc-i3427.alporthouse.com> <CAKMK7uFAgHJ-kYJEcDCvNm3B4ELKC8CFK8iP+-SL7bdT5-VQHA@mail.gmail.com> <20140424194037.GB30333@amd.pavel.ucw.cz> <20140424201521.GN31221@nuc-i3427.alporthouse.com> <20140424220638.GA29385@atrey.karlin.mff.cuni.cz>
User-Agent: Notmuch/0.18~rc0+1~g40dc79d6ac82 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 25 Apr 2014 14:33:14 +0300
Message-ID: <87eh0lve2t.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014, Pavel Machek <pavel@ucw.cz> wrote:
>> On Thu, Apr 24, 2014 at 09:40:38PM +0200, Pavel Machek wrote:
>> > Hi!
>> > 
>> > > And if you can indeed reliably reproduce this a bisect could be really useful.
>> > 
>> > And we have a winner here :-)
>> > 
>> > Ok, it was not as painfull as I feared.
>> > 
>> > It does not revert cleanly, but doing it by hand was not that bad.
>> 
>> Oh my. That is bizarre, can you check whether you have
>> 
>> commit 9991ae787a0c87fe7c783b4b6f4754c3cdbb6213
>
> Yes, with that commit, graphics is back to working state. Please push
> it to mainline soon -- it fixes a regression. Feel free  to add
>
> Tested-by: Pavel Machek <pavel@ucw.cz>

I cherry-picked and pushed

commit 9991ae787a0c87fe7c783b4b6f4754c3cdbb6213
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Apr 2 16:36:07 2014 +0100

    drm/i915: Move all ring resets before setting the HWS page

to -fixes. Thanks for testing.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
