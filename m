Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab3DAQXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:23:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55406 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3DAQXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:23:08 -0400
Message-ID: <5159B469.1000303@wwwdotorg.org>
Date: Mon, 01 Apr 2013 10:23:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Bibek Basu <bbasu@nvidia.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pritesh Raithatha <praithatha@nvidia.com>
Subject: Re: [PATCH] pinctrl: tegra: add suspend-resume support
References: <1364490685-21831-1-git-send-email-bbasu@nvidia.com> <5154827B.8010701@wwwdotorg.org> <77F7DB30C698A44DA22FB222C89DE941A668585708@BGMAIL01.nvidia.com>
In-Reply-To: <77F7DB30C698A44DA22FB222C89DE941A668585708@BGMAIL01.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2013 10:34 PM, Bibek Basu wrote:
> Hi Stephen,
> 
> My response inline.

Upstream, responses should always be inline, so there's no need to
mention that.

By the way, can you please configure your email client to:

a) Not re-wrap the email you're replying to; email should be wrapped to
about 74 characters.

b) Prefix all the lines you're quoting with "> " so that we can
differentiate the text you quoted from the text you wrote. If you need
to write "[BB]" to differentiate those pieces of text, something is
wrong. Thanks.

I've tried to fix these below in my reply.

> Stephen Warren wrote at Thursday, March 28, 2013 11:19 PM:
> > On 03/28/2013 11:11 AM, Bibek Basu wrote:
> >> This patch adds suspend and resume callbacks to the pinctrl-tegra driver.

> >> diff --git a/drivers/pinctrl/pinctrl-tegra.c 
> >> b/drivers/pinctrl/pinctrl-tegra.c
> > 
> >> +static struct tegra_pmx *pmx;
> > 
> > Isn't there any way to pass data into the suspend/resume functions so that this global isn't needed?
> > 
> > Why can't we just use the device suspend/resume functions rather than
> > global (syscore) suspend/resume functions? Presumably this is to
> > ensure that all other drivers suspend first, then the pinctrl driver
> > does, and the reverse for resume. Can't we rely on deferred probe to
> >  ensure that instead?
> > 
> > To make that work, we might need every affected driver to define a
> > dummy pinmux state in DT that references the pinctrl driver, to make
> > sure they all get probed after the pinctrl driver.
>
> [BB]: Before I add dummy pinmux state in DT of affected driver, I would
> like to know the following:
>
> 1> The usage of syscore api needs global data. So, are you suggesting
> that syscore APIs are not appropriate to be used or syscore
> implementation is not proper?

Yes. The code here is a driver, and drivers shouldn't be using global
data where possible.

> 2> Adding dummy DT states may give scope for BUGS. Reason being there
> must be someone checking that every time some new driver refrences
> pinmux driver, should put a dummy entry in device tree. Isnt it more
> time costing then having "static struct tegra_pmx *pmx;"?

The overhead isn't high, and fixing that particular bug is trivial. And
yes, sometimes doing things the right way is more work than a
quick-and-dirty solution.
