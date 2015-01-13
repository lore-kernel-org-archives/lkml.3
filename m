Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbbAMSiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:38:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40237 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbbAMSiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:38:20 -0500
Date: Tue, 13 Jan 2015 12:38:10 -0600
From: Benoit Parrot <bparrot@ti.com>
To: Alexandre Courbot <gnurou@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Arend van Spriel <arend@broadcom.com>
Subject: Re: [Patch v5 2/2] gpio: Document GPIO hogging mechanism
Message-ID: <20150113183810.GG5834@ti.com>
References: <1419019671-25377-1-git-send-email-bparrot@ti.com>
 <1419019671-25377-3-git-send-email-bparrot@ti.com>
 <CACRpkdb7Wq7-rBypqPkefejY5Qfq_KKx91H+DxKWv-TM2y04bg@mail.gmail.com>
 <20150112163902.GE5834@ti.com>
 <CAAVeFuLF7EVR-Xta=eNegmGWX9AFu9xmyhXisGCTwc1ds3t1cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAAVeFuLF7EVR-Xta=eNegmGWX9AFu9xmyhXisGCTwc1ds3t1cA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Courbot <gnurou@gmail.com> wrote on Tue [2015-Jan-13 06:43:33 +0900]:
> On Tue, Jan 13, 2015 at 1:39 AM, Benoit Parrot <bparrot@ti.com> wrote:
> > Linus Walleij <linus.walleij@linaro.org> wrote on Mon [2015-Jan-12 11:20:14 +0100]:
> >> On Fri, Dec 19, 2014 at 9:07 PM, Benoit Parrot <bparrot@ti.com> wrote:
> >>
> >> > Add GPIO hogging documentation to gpio.txt
> >> >
> >> > Signed-off-by: Benoit Parrot <bparrot@ti.com>
> >> > Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> >>
> >> This is starting to look good ...
> >>
> >> > +               line_b {
> >> > +                       gpio-hog;
> >> > +                       gpios = <6 0>;
> >> > +                       state = "output-low";
> >>
> >> I don't like the state string.
> >>
> >> Instead have boolean properties for all states.
> >>
> >> line_b {
> >>     gpio-hog;
> >>     gpios = <6 0>;
> >>     output-low;
> >>     line-name = "foo-bar-gpio";
> >> }
> >>
> >> Then use of_property_read_bool() in the code to check which
> >> state is to be selected intially. You can check that no mutually
> >> exclusive state are selected, I don't like that an arbitrary string
> >> select the state like that, if we do it that way an enumerator would
> >> be better, I prefer bools.
> >
> > I am sorry but that is how it was originally in the first patch.
> > Alexandre's review comment suggested this method in [1] and [2] (below).
> >
> > Alexandre, any comments?
> >
> > [1] http://marc.info/?l=linux-gpio&m=141456662426151&w=2
> >
> > [2] http://marc.info/?l=linux-gpio&m=141715982424744&w=2
> 
> When Linus and I are in conflict, follow Linus. Arnd's suggestion of
> having enums defined in (IIUC) include/dt-bindings/gpio and using them
> sounds good to me too and might make everyone happy (no possibility of
> conflicting definitions + no strings). Linus, could you comment on it?

Understood.
Now given Linus prefers the bools that is the direction I am going to follow.
