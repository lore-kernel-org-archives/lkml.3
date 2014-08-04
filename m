Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaHDPVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:21:24 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:33662 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaHDPVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:21:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] of/clk: use "clkops-clocks" to specify clocks handled by clock_ops domain
Date: Mon, 04 Aug 2014 17:21:49 +0200
Message-ID: <1616494.8YxGyrZW3V@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdVKDQz8q0b2UA7=1K8Qw4n3U0=M+mJyi5UQP7QZdC-JiQ@mail.gmail.com>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be> <2717555.fiA6A86F65@avalon> <CAMuHMdVKDQz8q0b2UA7=1K8Qw4n3U0=M+mJyi5UQP7QZdC-JiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Monday 04 August 2014 13:28:32 Geert Uytterhoeven wrote:
> On Wed, Jul 30, 2014 at 2:06 AM, Laurent Pinchart wrote:
> > The third option would require storing the clocks lists in device drivers.
> > I believe this is our best option, as a trade-off between simplicity and
> > versatility. Drivers that use runtime PM already need to enable it
> > explicitly when probing devices. Passing a list of clock names to runtime
> > PM at that point wouldn't complicate drivers much. When the clocks list
> > isn't SoC- dependent it could be stored as static information. Otherwise
> > it could be derived from DT (or any other source of hardware description)
> > using C code, offering all the versatility we need.
> > 
> > The only drawback of this solution I can think of right now is that the
> > runtime PM core couldn't manage device clocks before probing the device.
> > Specifically device clocks couldn't be managed if no driver is loaded for
> > that device. I somehow recall that someone raised this as being a
> > problem, but I can't remember why.
> 
> Perhaps you're thinking of clocks that were enabled (by the boot loader or
> implicit reset state) before running Linux, and aren't disabled?

That wasn't the reason, I know that clk_disable_unused() takes care of that 
problem (provided the clock drivers behave correctly, the commit you mention 
below shows that's not always the case, but that's an unrelated issue).

> That was fixed by commit bb178da701382a230e26d90cf94e8a24b280e0d9
> ("clk: shmobile: mstp: Fix the is_enabled() operation").

-- 
Regards,

Laurent Pinchart

