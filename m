Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaHAN2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:28:41 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:47334 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbaHAN2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:28:37 -0400
MIME-Version: 1.0
In-Reply-To: <1406899019.11706.9.camel@intelbox>
References: <1406158393.13064.1.camel@gmail.com> <1406280517.17325.3.camel@intelbox>
 <1406753579.31042.1.camel@gmail.com> <1406806772.18327.14.camel@intelbox>
 <1406843268.6143.1.camel@gmail.com> <1406899019.11706.9.camel@intelbox>
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Fri, 1 Aug 2014 15:28:16 +0200
Message-ID: <CAA85sZu7PB0hH7mS+ojnnqEK+VALa=9Zc4N2nOYoxpD+q4jtOg@mail.gmail.com>
Subject: Re: [Intel-gfx] [BUG?] 3.16-rc6 ... at drivers/gpu/drm/i915/intel_pm.c:5997
 intel_display_power_put+0x12d/0x160()
To: imre.deak@intel.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 3:16 PM, Imre Deak <imre.deak@intel.com> wrote:

[--8<--]

> Ok, I see the trace of suspend/resume now, but the bug has vanished.. I
> can't see the WARN backtrace in your original report, nor the debug
> message from the above fix, that would indicate that it had fixed
> anything ("VDD left on by BIOS, adjusting state tracking"). So I'm a bit
> lost, I would need a full dmesg with either the WARN or this debug
> message.

Well the bug seemed to be a unbalanced _put _get thing.

At least that's the impression i got when reading the code, so what i
did, which is part of the original patch, is to make sure that the
_put happens so that the "mode" isn't '0' and thus triggers a warn_on.

What we can say is that due to the patch you sent these are now
balanced in that code...

Actually reading the patches again i can't see how that happened, esp
without the debug message... I think I'll have to play some more with
this and get back to you when $clue has increased by at least one....
=)
