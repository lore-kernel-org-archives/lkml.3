Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaEANlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:41:14 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:64070 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbaEANlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:41:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140501080331.D3CFAC409DA@trevor.secretlab.ca>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
	<1398334403-26181-4-git-send-email-geert+renesas@glider.be>
	<7hoazpdldx.fsf@paris.lan>
	<20140429131610.29859C4094A@trevor.secretlab.ca>
	<CAMuHMdUdnoah1uZbMn_xONXZ2i8wG5kY7msMzCdBwS+xt9tmDA@mail.gmail.com>
	<20140501080331.D3CFAC409DA@trevor.secretlab.ca>
Date: Thu, 1 May 2014 15:41:11 +0200
X-Google-Sender-Auth: hqr3bdfbs0Qhg7lkIMfQAgVXVVQ
Message-ID: <CAMuHMdXbJrnNPyPmD-rcGN-M4ybFtrS3FCuvegJue1Pe-ae8SQ@mail.gmail.com>
Subject: Re: [PATCH/RFC 3/4] of/clk: Register clocks suitable for Runtime PM
 with the PM core
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Thu, May 1, 2014 at 10:03 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, 30 Apr 2014 23:54:37 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Tue, Apr 29, 2014 at 3:16 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> > I also don't like that it tries to set up every clock, but there is no
>> > guarantee that the driver will even use it. I would rather see this
>> > behaviour linked into the function that obtains the clock at driver
>> > .probe() time. That way it can handle deferred probe correctly and it
>> > only sets up clocks that are actually used by the driver.
>>
>> Not every clock. Only the clocks that are advertised by the clock driver as
>> being suitable for runtime_pm management. These are typically module
>> clocks, that must be enabled for the module to work. The driver doesn't
>> always want to handle these explicitly.
>
> Help me out here becasue I don't understand how that works with this
> patch set. From my, admittedly naive, reading it looks like the setup is
> being done at device creation time, but if the driver (or module) gets
> to declare which clocks need to be enabled in order to work, then that
> information is not available at device creation time.

Setup is indeed done at registration time. Note the check calling
clk_may_runtime_pm(), which is introduced in "[PATCH/RFC 1/4] clk: Add
CLK_RUNTIME_PM and clk_may_runtime_pm()".

Clock drivers are initialized much earlier, so they can set the CLK_RUNTIME_PM
flag for suitable clocks before platform devices are created from DT, cfr. the
example for shmobile MSTP clocks in "[PATCH/RFC 4/4] clk: shmobile: mstp:
Set CLK_RUNTIME_PM flag".

I hope this makes it clear.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
