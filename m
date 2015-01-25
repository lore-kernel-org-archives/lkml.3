Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbbAYBC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 20:02:56 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56696 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbbAYBCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 20:02:54 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Thierry Reding <thierry.reding@gmail.com>,
        "Stephen Boyd" <sboyd@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20150123093409.GC3835@ulmo>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Russell King" <linux@arm.linux.org.uk>,
        "Tomeu Vizoso" <tomeu.vizoso@collabora.com>
References: <1421750935-4023-2-git-send-email-thierry.reding@gmail.com>
 <1421856780-32103-1-git-send-email-thierry.reding@gmail.com>
 <54C04145.1010906@codeaurora.org> <20150122073707.GA427@ulmo>
 <20150122202546.GO27202@codeaurora.org> <20150123093409.GC3835@ulmo>
Message-ID: <20150125010241.22722.75005@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2] clk: Introduce clk_has_parent()
Date: Sat, 24 Jan 2015 17:02:41 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Thierry Reding (2015-01-23 01:34:10)
> On Thu, Jan 22, 2015 at 12:25:46PM -0800, Stephen Boyd wrote:
> > On 01/22, Thierry Reding wrote:
> > > On Wed, Jan 21, 2015 at 04:16:05PM -0800, Stephen Boyd wrote:
> > > > On 01/21/2015 08:13 AM, Thierry Reding wrote:
> > > > > From: Thierry Reding <treding@nvidia.com>
> > > > >
> > > > > This new function is similar to clk_set_parent(), except that it doesn't
> > > > > actually change the parent. It merely checks that the given parent clock
> > > > > can be a parent for the given clock.
> > > > >
> > > > > A situation where this is useful is to check that a particular setup is
> > > > > valid before switching to it. One specific use-case for this is atomic
> > > > > modesetting in the DRM framework where setting a mode is divided into a
> > > > > check phase where a given configuration is validated before applying
> > > > > changes to the hardware.
> > > > >
> > > > > Cc: Russell King <linux@arm.linux.org.uk>
> > > > > Cc: Mike Turquette <mturquette@linaro.org>
> > > > > Cc: Stephen Boyd <sboyd@codeaurora.org>
> > > > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > > > ---
> > > > 
> > > > Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> > > > 
> > > > This will slightly conflict with Tomeu's  patches for per-user clock
> > > > constraints. It would be best if we can take this through the clk tree
> > > > to fix up any conflicts
> > > 
> > > I had hoped to take this through the drm tree to resolve the build-time.
> > > Another possibility would be for me to include the clk tree (or a subset
> > > thereof) in my pull-request. That way you can still fix things up in the
> > > clock tree if there are any conflicts with other work. We could make
> > > that work two ways: this patch gets applied to the clk tree and I pull
> > > it, or I provide a stable branch that I base my pull request on and that
> > > branch can be pulled into the clk tree.
> > > 
> > > Yet another alternative would be to split out the clk_has_parent()
> > > change from the series and not use it for now. That way we're going to
> > > miss this check, but we do that anyway currently and it will only be
> > > temporary until v3.21.
> > > 
> > > Perhaps given where we are in the release cycle the latter would make
> > > the most sense for now.
> > 
> > Ok well let's see what Mike wants to do given that he's doing all
> > the patch applying right now. I'd think that we could put this
> > one patch on a different branch that we can merge into clk-next
> > and you can merge into the drm tree. At least that's the typical
> > workflow that usually works for everyone.
> 
> I will be sending out a pull request today, so I'm not going to include
> this patch or the dependent patch. I'll pick it up again after the merge
> window and see if I need to rebase it on top of Tomeu's work.

I've created an immutable branch based on 3.19-rc1 with only this patch
on it and I've merged that branch into the clk tree. Immutable branch:

git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git clk-has-parent

You can see it merged into the clk tree here:

https://git.kernel.org/cgit/linux/kernel/git/clk/linux.git/commit/?h=clk-next&id=57386798f7db7f09d69f3b44fc66570e6db91bba

Regards,
Mike

> 
> Thierry
