Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaELXhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 19:37:06 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55766 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751681AbaELXhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 19:37:03 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Aubrey Li <aubrey.li@intel.com>
Subject: Re: [PATCH] PM / suspend: Always use deepest C-state in the "freeze" sleep state
Date: Tue, 13 May 2014 01:53:49 +0200
Message-ID: <1675732.Zj8pe2mRTV@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5370E026.5040105@linaro.org>
References: <2548502.zJ1no3NhRc@vostro.rjw.lan> <5370D85C.3090505@linux.intel.com> <5370E026.5040105@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 12, 2014 04:52:22 PM Daniel Lezcano wrote:
> On 05/12/2014 04:19 PM, Li, Aubrey wrote:
> > On 2014/5/12 22:08, Daniel Lezcano wrote:
> >> On 05/05/2014 12:51 AM, Rafael J. Wysocki wrote:
> >>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>>
> >>> If freeze_enter() is called, we want to bypass the current cpuidle
> >>> governor and always use the deepest available (that is, not disabled)
> >>> C-state, because we want to save as much energy as reasonably possible
> >>> then and runtime latency constraints don't matter at that point, since
> >>> the system is in a sleep state anyway.
> >>>
> >>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>> ---
> >>>
> >>> This is on top of https://patchwork.kernel.org/patch/4071541/ .
> >>>
> >>
> >> Wouldn't make sense to revisit play_dead instead ?
> >>
> > play_dead() is broken.
> >
> > Even if it works, we still should rely on cpuidle driver to place the
> > CPUs into the deepest c-state, because there is no architectural way to
> > enter deepest c-state and what play_dead() does is a bad assumption.
> 
> Ok, let me rephrase it. Why not revisiting cpuidle_play_dead instead ?

Many drivers don't implement the ->enter_dead() callback.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
