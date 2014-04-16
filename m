Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbaDPWDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 18:03:44 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:64504 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596AbaDPWDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 18:03:42 -0400
MIME-Version: 1.0
In-Reply-To: <87ppkhaqxz.fsf@intel.com>
References: <20140414164010.GA1019@falcon>
	<867g6ryd2e.fsf@hiro.keithp.com>
	<20140414185602.GA892@falcon>
	<20140415194303.GH1023@phenom.ffwll.local>
	<1397591989.2715.18.camel@ideak-mobl>
	<87ppkhaqxz.fsf@intel.com>
Date: Wed, 16 Apr 2014 15:03:40 -0700
Message-ID: <CAKbGBLj98TZGiLQTbhSPg6b74WdFALRu-qo3nxrNENNarMGQow@mail.gmail.com>
Subject: Re: [Intel-gfx] REGRESSION 3.14 i915 warning & mouse cursor vanishing
From: Steven Noonan <steven@uplinklabs.net>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: imre.deak@intel.com, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 2:46 PM, Jani Nikula
<jani.nikula@linux.intel.com> wrote:
> On Tue, 15 Apr 2014, Imre Deak <imre.deak@intel.com> wrote:
>> On Tue, 2014-04-15 at 21:43 +0200, Daniel Vetter wrote:
>>> On Mon, Apr 14, 2014 at 11:56:03AM -0700, Steven Noonan wrote:
>>> > On Mon, Apr 14, 2014 at 11:35:05AM -0700, Keith Packard wrote:
>>> > > Steven Noonan <steven@uplinklabs.net> writes:
>>> > >
>>> > > > Was using my machine normally, then my mouse cursor vanished. After switching
>>> > > > to a VT and back to X11, my cursor came back. But I did notice a nasty trace in
>>> > > > dmesg (below).
>>> > >
>>> > > I don't think the trace below is related to the cursor disappearing.
>>> >
>>> > Any idea what the trace is all about then? Seems it has something to do
>>> > with runtime power management (maybe my aggressive kernel command-line
>>> > options are triggering it).
>>>
>>> Please test without them. Currently runtime pm should be disabled still on
>>> vlv (since it's incomplete in 3.14). If you've force-enabled that then you
>>> get to keep all pieces ;-)
>>>
>>> In general don't set any i915 options if you're not a developer or someone
>>> else who _really_ knows what's going on.
>>
>> Note that the lspci output and the
>>
>> [ 1795.275026] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed
>> register before writing to 70084
>>
>> line suggests HSW and the specs for ThinkPad Yoga suggests the same. But
>> I don't know how the vlv_* functions can possible end up in those traces
>> then, perhaps just a coincidence, random data on stack?
>
> I'm wondering the same. Perhaps double check your kernel build and
> modules are all right and matching?
>

It was a clean build (built in a clean chroot, no ccache or anything
fancy), so those stack traces are as "right" as they could be under
those conditions.

The "good" news (or perhaps scary news) is that I've been running
3.14.1 for the past 36 hours and haven't been able to reproduce either
problem since then (warnings or ninja mouse cursor). Nothing in the
changelog for v3.14..v3.14.1 really stands out as a clear fix though.
The only changes that appear to directly affect my configuration would
be the futex changes, iwlwifi change, efi change, and ipv6 change.
