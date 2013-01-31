Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab3AaEOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 23:14:45 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:55798 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3AaEOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 23:14:43 -0500
MIME-Version: 1.0
In-Reply-To: <51098229.7080508@wwwdotorg.org>
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
 <1359514939-15653-2-git-send-email-acourbot@nvidia.com> <51098229.7080508@wwwdotorg.org>
From: Alexandre Courbot <acourbot@nvidia.com>
Date: Thu, 31 Jan 2013 13:14:21 +0900
X-Google-Sender-Auth: MNegYsAzZCj24IUF1H7eTDYqIr0
Message-ID: <CAAVeFuJkJ4cftWvSvt1YJa6c48JyJPVTu=i18yMHptZMi3DAzg@mail.gmail.com>
Subject: Re: [RFC 1/4] video: panel: add CLAA101WA01A panel support
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 5:27 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> So this looks like a reasonable binding to me. The one issue is that
> it's very generic, and if we go this route, we'll probably end up with
> tens or hundreds of identical or extremely similar simple bindings, and
> associated drivers.
>
> We can avoid this instead by defining something like a "simple-lcd"
> binding, and associated driver, that will work for perhaps 90%, 95%,
> 99%, even 100%(?) of panels.

That seems totally doable indeed. Actually the right way to do this
might be by extending the simple DPI panel driver Laurent included in
his patchset.

> Just like the above, but with:
>
> compatible="simple-panel", "chunghwa,claa101wa01a"
>
> instead, and the driver binding to "simple-panel" rather than
> "chunghwa,claa101wa01a".

Just out of curiosity, why don't we rather define

compatible="chunghwa,claa101wa01a", "simple-panel"

in that order? I thought DT compatible strings should go from more to
less specific. The device would still bind to "simple-panel" if no
more specific driver exists.

> The driver can assume that a specific set of supplies (and perhaps
> GPIOs) is always present, and that the /sequence/ of manipulating those
> is fixed. This will avoid the need for anything like the power sequences
> code. If a particular panel doesn't fit those assumptions, including the
> exact sequence of manipulations for each state transition (which should
> be documented in the binding) then it can get a custom driver, this also
> avoiding having to define custom sequences in DT.
>
> Things that might be parameterized/optional:
>
> * Perhaps some GPIOs aren't always present.
> * If some regulators aren't SW-controllable, DT should still provide a
> fixed/dummy regulator so the driver doesn't care.

How about making all regulators and GPIO optional in the driver?

> * Wait times between regulator/GPIO/... manipulation could be specified
> in DT.
> * For panels without EDID, CDF DT bindings can provide the list of
> supported modes, otherwise we assume that the display controller that
> drives the panel has been told how to access the EDID, just like it
> would for an "external" display.

Excellent. Thanks for the feedback.

Alex.
