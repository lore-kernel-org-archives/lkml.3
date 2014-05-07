Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbaEGIc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:32:28 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:32871 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbaEGIcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:32:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140507082410.GC6362@ulmo>
References: <1399325340-20416-1-git-send-email-b.galvani@gmail.com>
	<CAOh2x=mWqa=p2d1kRjf0_37DiioJZOJm3Ewv2xpMrNjPy69rvA@mail.gmail.com>
	<20140507082410.GC6362@ulmo>
Date: Wed, 7 May 2014 14:02:24 +0530
Message-ID: <CAKohpomkrR715dhyZZQwu_-S6LHsYBOj9YsX9HR6PCMKkMdrVw@mail.gmail.com>
Subject: Re: [PATCH] pwm: spear: fix check on pwmchip_add() return value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Beniamino Galvani <b.galvani@gmail.com>, linux-pwm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2014 13:54, Thierry Reding <thierry.reding@gmail.com> wrote:
> So the current code would run clk_unprepare() on success, but not on
> failure. Does that cause any harm?

Yeah, that would make the device unusable  as clk_enable will always fail.

> Is the device still usable after this?

Yes, this will fix the bug.

> I'm asking because I'm not sure if this is linux-next material
> or should be a fix for 3.15 (and possibly backported to stable).

IMO, it should be sent for stable: v3.8+
