Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab3IUPso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 11:48:44 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:35813 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3IUPsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 11:48:43 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <alpine.SOC.1.00.1309211825490.9193@math.ut.ee>
References: <alpine.SOC.1.00.1308261610280.25531@math.ut.ee>
	<alpine.SOC.1.00.1309211825490.9193@math.ut.ee>
Date: Sat, 21 Sep 2013 17:48:42 +0200
Message-ID: <CAKMK7uHynzChMurTLAYMfeRF07aDJxes-6eSO1iDbrET8xD84Q@mail.gmail.com>
Subject: Re: i915 pipe A assertion failure (expected on, current off)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Meelis Roos <mroos@linux.ee>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 5:29 PM, Meelis Roos <mroos@linux.ee> wrote:
>> Tried 3.11-rc7 on Thinkpad X30 (first 3-11-rc tried on this hw). Works
>> but i915 gives strange assertion failure with WARNING stack trace. This
>> is new since 3.10.
>
> It is still there with 3.12-rc1 but now I git around to bisecting it.
> This is the commit that introduces the warning.
>
> commit 9f11a9e4e50006b615ba94722dfc33ced89664cf
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Thu Jun 13 00:54:58 2013 +0200
>
>     drm/i915: set up PIPECONF explicitly for i9xx/vlv platforms

My apologies for not responding to your first report, fell through the
cracks somehow. Can you please boot with drm.debug=0xe, reproduce the
WARN and grab the full dmesg (please make sure everything from boot-up
is in there). That's usually enough to figure out what's going wrong
here.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
