Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaBNOeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:34:50 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:41548 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaBNOes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:34:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 23/27] clocksource: sh_cmt: Add DT support
Date: Fri, 14 Feb 2014 15:35:54 +0100
Message-ID: <3333792.lJWG6KWxgS@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdUPJ_Wz85AJeYF8vnkOfjd8A7fHb45bL5-B0bAPqNHnhw@mail.gmail.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1392339605-20691-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CAMuHMdUPJ_Wz85AJeYF8vnkOfjd8A7fHb45bL5-B0bAPqNHnhw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the review.

On Friday 14 February 2014 10:18:58 Geert Uytterhoeven wrote:
> On Fri, Feb 14, 2014 at 2:00 AM, Laurent Pinchart wrote:
> > +++ b/Documentation/devicetree/bindings/timer/renesas,cmt.txt
> > @@ -0,0 +1,75 @@
> > +* Renesas R-Car Compare Match Timer (CMT)
> > +
> > +The CMT is a multi-channel 16/32/48-bit timer/counter with configurable
> > clock
> 16-bit is mentioned here ...
> 
> > +inputs and programmable compare match.
> > +
> > +Channels share hadware resources but their counter and compare match
> > value are
>
> hardware
> 
> > +independent. A particular CMT instance can implement only a subset of the
> > +channels supported by the CMT model. Channels indices start from 0 and
> > are
> 
> Channel indices
> 
> > +consecutive.
> > +
> > +Required Properties:
> > +
> > +  - compatible: must contain one of the following.
> 
> ... why not add "renesas,cmt-16" here (and one extra line in the actual
> driver), while you're at it?

Because the 16-bit variant is only used on SuperH SoCs, so there's not much 
point in adding DT bindings for it.

> > +    - "renesas,cmt-32" for the 32-bit CMT
> > +               (CMT0 on sh7372, sh73a0 and r8a7740)
> > +    - "renesas,cmt-32-fast" for the 32-bit CMT with fast clock support
> > +               (CMT[234] on sh7372, sh73a0 and r8a7740)
> > +    - "renasas,cmt-48" for the 48-bit CMT
> > +               (CMT1 on sh7372, sh73a0 and r8a7740)
> > +    - "renesas,cmt-48-gen2" for the second generation 48-bit CMT
> > +               (CMT[01] on r8a73a4, r8a7790 and r8a7791)

-- 
Regards,

Laurent Pinchart
