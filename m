Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab3BTKnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:43:20 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47011 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759232Ab3BTKnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:43:16 -0500
Date: Wed, 20 Feb 2013 10:43:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Marcus Cooper <codekipper@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        linus.walleij@stericsson.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com
Subject: Re: [PATCH 06/35] mfd: ab8500-core: Sysfs chip id modification
Message-ID: <20130220104310.GA4417@gmail.com>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
 <1360933026-30325-7-git-send-email-lee.jones@linaro.org>
 <201302192204.45153.arnd@arndb.de>
 <20130220081311.GB3368@gmail.com>
 <CAEKpxBk=bgTx18A2J6mVT5RBBq3ZJAqswz-6NvNpTRP=u9pgwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEKpxBk=bgTx18A2J6mVT5RBBq3ZJAqswz-6NvNpTRP=u9pgwQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Marcus Cooper wrote:

> On 20 February 2013 09:13, Lee Jones <lee.jones@linaro.org> wrote:
> > On Tue, 19 Feb 2013, Arnd Bergmann wrote:
> >
> >> On Friday 15 February 2013, Lee Jones wrote:
> >> >         struct ab8500 *ab8500;
> >> > +       int chip_id = -EINVAL;
> >> >
> >> >         ab8500 = dev_get_drvdata(dev);
> >> > -       return sprintf(buf, "%#x\n", ab8500 ? ab8500->chip_id : -EINVAL);
> >> > +       if(ab8500) {
> >> > +               chip_id = ab8500->chip_id;
> >> > +               if((is_ab8505(ab8500) || is_ab9540(ab8500)) && ab8500->version != 0xFF)
> >> > +                       chip_id = (ab8500->version << 8) | chip_id;
> >> > +       }
> >> > +       return sprintf(buf, "%#x\n", chip_id);
> >> >  }
> >>
> >> What's the use of printing "ffffffea" for unknown versions here?
> >
> > You mean instead of -EINVAL? No idea, Marcus?
> >
> Looks like I'm guilty of just making the minimal changes. Arnd is
> right though, getting ffffffea(-EINVAL) back is pretty useless.
> I'll have to check user land to see what is using this.

Yes, it would be useful to know how it's parsed.

Thanks Marcus.

> Maybe not
> printing and returning 0 should be the correct behaviour
> when an unknown version is found.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
