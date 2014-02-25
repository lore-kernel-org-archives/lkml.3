Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaBYSBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:01:14 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37632 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaBYSBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:01:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH 2/2] pinctrl: sh-pfc: r8a7791: Add alternative MSIOF pin groups
Date: Tue, 25 Feb 2014 19:02:29 +0100
Message-ID: <1907403.Lds1hseITe@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdWt2OZaLT3Z9KODkxcAqtqS27BpOaKFmLDKdxk68KW2Zg@mail.gmail.com>
References: <1392926021-19526-1-git-send-email-geert@linux-m68k.org> <1907400.ponjrTNCdS@avalon> <CAMuHMdWt2OZaLT3Z9KODkxcAqtqS27BpOaKFmLDKdxk68KW2Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Tuesday 25 February 2014 18:50:21 Geert Uytterhoeven wrote:
> On Tue, Feb 25, 2014 at 6:19 PM, Laurent Pinchart wrote:
> >> +static const unsigned int msiof1_rx_d_pins[] = {
> >> +     /* RXD */
> >> +     RCAR_GP_PIN(0, 26),
> > 
> > This should be (0, 27).
> 
> Wow, nice catch. Thanks a lot!

You're welcome. This is why I dislike reviewing PFC patches though, it's lots 
of small numbers that need to be checked.

> >> +static const unsigned int msiof2_ss2_d_pins[] = {
> >> +     /* SS2 */
> >> +     RCAR_GP_PIN(2, 18),
> > 
> > This should be (2, 19).
> 
> p. 4-16 of Rev. 0.31 of the R-Car M2 datasheet states that GP2_18 can be
> both MSIOF2_SS2_D (function 3) and MSIOF2_RXD_D (function 5),
> but p. 5-37 disagrees?
> It seems the whole function 3 column on p. 4-16 is offset by one,
> compared to p. 5-37.
> 
> Well, (2, 19) sounds more logical, so let's assume p. 5-37 is correct for
> now.

Sounds good to me.

> > > +};
> > > +static const unsigned int msiof2_ss2_d_mux[] = {
> > > +     MSIOF2_SS2_D_MARK,
> > > +};
> > > +static const unsigned int msiof2_rx_d_pins[] = {
> > > +     /* RXD */
> > > +     RCAR_GP_PIN(2, 18),
> > > +};

-- 
Regards,

Laurent Pinchart

