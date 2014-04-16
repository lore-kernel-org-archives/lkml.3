Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbaDPVqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:46:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:17059 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789AbaDPVqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:46:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,874,1389772800"; 
   d="scan'208";a="494404870"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: imre.deak@intel.com, Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] REGRESSION 3.14 i915 warning & mouse cursor vanishing
In-Reply-To: <1397591989.2715.18.camel@ideak-mobl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20140414164010.GA1019@falcon> <867g6ryd2e.fsf@hiro.keithp.com> <20140414185602.GA892@falcon> <20140415194303.GH1023@phenom.ffwll.local> <1397591989.2715.18.camel@ideak-mobl>
User-Agent: Notmuch/0.17+162~g34940eaa1d37 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 17 Apr 2014 00:46:00 +0300
Message-ID: <87ppkhaqxz.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Imre Deak <imre.deak@intel.com> wrote:
> On Tue, 2014-04-15 at 21:43 +0200, Daniel Vetter wrote:
>> On Mon, Apr 14, 2014 at 11:56:03AM -0700, Steven Noonan wrote:
>> > On Mon, Apr 14, 2014 at 11:35:05AM -0700, Keith Packard wrote:
>> > > Steven Noonan <steven@uplinklabs.net> writes:
>> > > 
>> > > > Was using my machine normally, then my mouse cursor vanished. After switching
>> > > > to a VT and back to X11, my cursor came back. But I did notice a nasty trace in
>> > > > dmesg (below).
>> > > 
>> > > I don't think the trace below is related to the cursor disappearing.
>> > 
>> > Any idea what the trace is all about then? Seems it has something to do
>> > with runtime power management (maybe my aggressive kernel command-line
>> > options are triggering it).
>> 
>> Please test without them. Currently runtime pm should be disabled still on
>> vlv (since it's incomplete in 3.14). If you've force-enabled that then you
>> get to keep all pieces ;-)
>> 
>> In general don't set any i915 options if you're not a developer or someone
>> else who _really_ knows what's going on.
>
> Note that the lspci output and the
>
> [ 1795.275026] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed
> register before writing to 70084
>
> line suggests HSW and the specs for ThinkPad Yoga suggests the same. But
> I don't know how the vlv_* functions can possible end up in those traces
> then, perhaps just a coincidence, random data on stack?

I'm wondering the same. Perhaps double check your kernel build and
modules are all right and matching?

BR,
Jani.


>
> For HSW the rc6 kernel option shouldn't make a difference.
>
> --Imre  
>
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Jani Nikula, Intel Open Source Technology Center
