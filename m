Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbbALQmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:42:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39750 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbbALQmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:42:17 -0500
Date: Mon, 12 Jan 2015 10:39:02 -0600
From: Benoit Parrot <bparrot@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [Patch v5 2/2] gpio: Document GPIO hogging mechanism
Message-ID: <20150112163902.GE5834@ti.com>
References: <1419019671-25377-1-git-send-email-bparrot@ti.com>
 <1419019671-25377-3-git-send-email-bparrot@ti.com>
 <CACRpkdb7Wq7-rBypqPkefejY5Qfq_KKx91H+DxKWv-TM2y04bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACRpkdb7Wq7-rBypqPkefejY5Qfq_KKx91H+DxKWv-TM2y04bg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij <linus.walleij@linaro.org> wrote on Mon [2015-Jan-12 11:20:14 +0100]:
> On Fri, Dec 19, 2014 at 9:07 PM, Benoit Parrot <bparrot@ti.com> wrote:
> 
> > Add GPIO hogging documentation to gpio.txt
> >
> > Signed-off-by: Benoit Parrot <bparrot@ti.com>
> > Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> This is starting to look good ...
> 
> > +               line_b {
> > +                       gpio-hog;
> > +                       gpios = <6 0>;
> > +                       state = "output-low";
> 
> I don't like the state string.
> 
> Instead have boolean properties for all states.
> 
> line_b {
>     gpio-hog;
>     gpios = <6 0>;
>     output-low;
>     line-name = "foo-bar-gpio";
> }
> 
> Then use of_property_read_bool() in the code to check which
> state is to be selected intially. You can check that no mutually
> exclusive state are selected, I don't like that an arbitrary string
> select the state like that, if we do it that way an enumerator would
> be better, I prefer bools.

I am sorry but that is how it was originally in the first patch.
Alexandre's review comment suggested this method in [1] and [2] (below).

Alexandre, any comments?

[1] http://marc.info/?l=linux-gpio&m=141456662426151&w=2

[2] http://marc.info/?l=linux-gpio&m=141715982424744&w=2

> 
> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-gpio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
