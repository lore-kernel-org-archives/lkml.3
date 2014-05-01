Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaEAN4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:56:32 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:65375 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaEAN43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:56:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXbJrnNPyPmD-rcGN-M4ybFtrS3FCuvegJue1Pe-ae8SQ@mail.gmail.com>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
 <1398334403-26181-4-git-send-email-geert+renesas@glider.be>
 <7hoazpdldx.fsf@paris.lan> <20140429131610.29859C4094A@trevor.secretlab.ca>
 <CAMuHMdUdnoah1uZbMn_xONXZ2i8wG5kY7msMzCdBwS+xt9tmDA@mail.gmail.com>
 <20140501080331.D3CFAC409DA@trevor.secretlab.ca> <CAMuHMdXbJrnNPyPmD-rcGN-M4ybFtrS3FCuvegJue1Pe-ae8SQ@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 1 May 2014 14:56:08 +0100
X-Google-Sender-Auth: J3YtbilsIXEafXdvC6ctkleDKhE
Message-ID: <CACxGe6sy-fumkNPRcQqB8G4so85dHW_5pZSv+cQDqzJfoneZ+A@mail.gmail.com>
Subject: Re: [PATCH/RFC 3/4] of/clk: Register clocks suitable for Runtime PM
 with the PM core
To: Geert Uytterhoeven <geert@linux-m68k.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 2:41 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Hi Grant,
>
> On Thu, May 1, 2014 at 10:03 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Wed, 30 Apr 2014 23:54:37 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>> On Tue, Apr 29, 2014 at 3:16 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>> > I also don't like that it tries to set up every clock, but there is no
>>> > guarantee that the driver will even use it. I would rather see this
>>> > behaviour linked into the function that obtains the clock at driver
>>> > .probe() time. That way it can handle deferred probe correctly and it
>>> > only sets up clocks that are actually used by the driver.
>>>
>>> Not every clock. Only the clocks that are advertised by the clock driver as
>>> being suitable for runtime_pm management. These are typically module
>>> clocks, that must be enabled for the module to work. The driver doesn't
>>> always want to handle these explicitly.
>>
>> Help me out here becasue I don't understand how that works with this
>> patch set. From my, admittedly naive, reading it looks like the setup is
>> being done at device creation time, but if the driver (or module) gets
>> to declare which clocks need to be enabled in order to work, then that
>> information is not available at device creation time.
>
> Setup is indeed done at registration time. Note the check calling
> clk_may_runtime_pm(), which is introduced in "[PATCH/RFC 1/4] clk: Add
> CLK_RUNTIME_PM and clk_may_runtime_pm()".
>
> Clock drivers are initialized much earlier, so they can set the CLK_RUNTIME_PM
> flag for suitable clocks before platform devices are created from DT, cfr. the
> example for shmobile MSTP clocks in "[PATCH/RFC 4/4] clk: shmobile: mstp:
> Set CLK_RUNTIME_PM flag".

This is where I have issue. You're *assuming* clock drivers are
initialized much earlier. That is not guaranteed. It is perfectly
valid for clocks to be set up by a normal device driver, just like for
interrupt controllers or gpio controllers.

g.
