Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaIBHlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 03:41:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:45621 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaIBHlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 03:41:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,447,1406617200"; 
   d="scan'208";a="566985341"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        Tibor Billes <tbilles@gmx.com>
Subject: Re: [PATCH v2] drm/i915: Fix lock dropping in intel_tv_detect()
In-Reply-To: <20140901104356.GE11648@nuc-i3427.alporthouse.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20140901085022.GB11648@nuc-i3427.alporthouse.com> <1409566060-21337-1-git-send-email-ville.syrjala@linux.intel.com> <20140901102009.GD11648@nuc-i3427.alporthouse.com> <20140901103637.GB4193@intel.com> <20140901104356.GE11648@nuc-i3427.alporthouse.com>
User-Agent: Notmuch/0.18.1+84~g658a00e (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 02 Sep 2014 10:41:05 +0300
Message-ID: <87egvuii5q.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2014, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Mon, Sep 01, 2014 at 01:36:37PM +0300, Ville Syrjälä wrote:
>> On Mon, Sep 01, 2014 at 11:20:09AM +0100, Chris Wilson wrote:
>> > On Mon, Sep 01, 2014 at 01:07:40PM +0300, ville.syrjala@linux.intel.com wrote:
>> > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>> > > 
>> > > When intel_tv_detect() fails to do load detection it would forget to
>> > > drop the locks and clean up the acquire context. Fix it up.
>> > > 
>> > > This is a regression from:
>> > >  commit 208bf9fdcd3575aa4a5d48b3e0295f7cdaf6fc44
>> > >  Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
>> > >  Date:   Mon Aug 11 13:15:35 2014 +0300
>> > > 
>> > >     drm/i915: Fix locking for intel_enable_pipe_a()
>> > > 
>> > > v2: Make the code more readable (Chris)
>> > > 
>> > > Cc: Tibor Billes <tbilles@gmx.com>
>> > > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
>> > 
>> > Hmm, if we use WARN_ON() you should init type.
>> 
>> type is always set in the branch that sets status=connected.
>
> Back to thinking about readability and making sure that the WARN_ON
> never happens with just a glance. Otherwise, the WARN_ON would be better
> as WARN_ON(unsigned)type >= last_tv_type); Or something. Anway, take
> your pick and slap my r-b on it. :)

Ville?

J.


> -Chris
>
> -- 
> Chris Wilson, Intel Open Source Technology Centre

-- 
Jani Nikula, Intel Open Source Technology Center
