Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105AbaDOXeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:34:08 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:50425 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDOXeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:34:06 -0400
MIME-Version: 1.0
In-Reply-To: <1397591989.2715.18.camel@ideak-mobl>
References: <20140414164010.GA1019@falcon>
	<867g6ryd2e.fsf@hiro.keithp.com>
	<20140414185602.GA892@falcon>
	<20140415194303.GH1023@phenom.ffwll.local>
	<1397591989.2715.18.camel@ideak-mobl>
Date: Tue, 15 Apr 2014 16:34:04 -0700
Message-ID: <CAKbGBLhHJqgAGsYxVi85xBv+WZo+TiWPskxmU67S01t2hQmErA@mail.gmail.com>
Subject: Re: [Intel-gfx] REGRESSION 3.14 i915 warning & mouse cursor vanishing
From: Steven Noonan <steven@uplinklabs.net>
To: imre.deak@intel.com
Cc: Daniel Vetter <daniel@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:59 PM, Imre Deak <imre.deak@intel.com> wrote:
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
>
> For HSW the rc6 kernel option shouldn't make a difference.

Correct, it's Haswell.
