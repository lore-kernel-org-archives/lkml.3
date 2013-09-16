Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269Ab3IPPeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:34:21 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:63589 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3IPPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:34:19 -0400
Date: Mon, 16 Sep 2013 16:34:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mark Brown <broonie@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH 1/4 v2] mfd: add STw481x driver
Message-ID: <20130916153414.GN16984@lee--X1>
References: <1379094851-26385-1-git-send-email-linus.walleij@linaro.org>
 <20130916091956.GF3999@lee--X1>
 <20130916104009.GA29403@sirena.org.uk>
 <CACRpkdatiELF3WK9qE_Mgcq3iCgv5w3X22xp1=232JJq9sWggQ@mail.gmail.com>
 <20130916135118.GD29403@sirena.org.uk>
 <20130916152104.GA3909@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130916152104.GA3909@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013, Wolfram Sang wrote:

> 
> On Mon, Sep 16, 2013 at 02:51:18PM +0100, Mark Brown wrote:
> > On Mon, Sep 16, 2013 at 02:44:35PM +0200, Linus Walleij wrote:
> > 
> > > I've tried to fix this for DT-only I2C devices
> > > and this very driver was the reason.
> > 
> > > But a tiresome regression due to drivers relying on this
> > > i2c_device_id not being NULL and inability to remove it from the I2C
> > > core without refactoring the world ensued, see:
> > > commit c80f52847c50109ca248c22efbf71ff10553dca4
> > 
> > Oh, that was the change...
> > 
> > > Reverted in:
> > > commit 661f6c1cd926c6c973e03c6b5151d161f3a666ed
> > 
> > > For this reason I think:
> > > http://marc.info/?l=linux-next&m=137148411231784&w=2
> > 
> > > I have tentatively given up getting pure DT I2C drivers
> > > to probe, I don't think I have the whole picture, but
> > > Wolfram has serious doubts about this and say we have
> > > to be careful ....
> > 
> > > Wolfram, do you have some ideas on how we should
> > > proceed or ar you happy with merging this as-is?
> > 
> > I'd have expected that it should be possible to change things such that
> > the change in the core doesn't produce any change in behaviour for
> > existing drivers.  Can we not change the patch so that i2c_match_id()
> > copes with getting a NULL id_table?  Something like this:
> 
> I hacked something like this after Linus posted his approach. However, I
> found out that run time instanciating ('new_device' file) needs an
> id_table. I wasn't to keen on disabling the feature for dt-only drivers.
> That's where I stopped, due to lack of time.

So in the mean time are you happy with this "dummy" approach?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
