Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab3JBLUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:20:46 -0400
Received: from gloria.sntech.de ([95.129.55.99]:33553 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab3JBLUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:20:44 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] pinctrl: palmas: do not abort pin configuration for BIAS_DEFAULT
Date: Wed, 2 Oct 2013 13:20:51 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com> <5245AD0C.7070206@wwwdotorg.org> <CACRpkdbuetPbxPzJTpKuM4O-mqpqjh7rgGoanfAwad4M2vbZTQ@mail.gmail.com>
In-Reply-To: <CACRpkdbuetPbxPzJTpKuM4O-mqpqjh7rgGoanfAwad4M2vbZTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201310021320.51544.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 2. Oktober 2013, 12:40:14 schrieb Linus Walleij:
> On Fri, Sep 27, 2013 at 6:06 PM, Stephen Warren <swarren@wwwdotorg.org> 
wrote:
> > [Laxman]
> > 
> >> Hmm.. When I added the PIN_DEFAULT, I just though that do not update
> >> anything in the register and implemented like that.
> >> There is nothing "default" option in HW.
> > 
> > The description of that pinconfig option is:
> >> 7970cb77 (Heiko Stübner    2013-06-06 16:44:25 +0200  43)  *
> >> @PIN_CONFIG_BIAS_PULL_PIN_DEFAULT: the pin will be pulled up or down
> >> based 70637a6d (Heiko Stübner    2013-06-25 14:55:42 +0200  44)  *   
> >> on embedded knowledge of the controller hardware, like current mux
> >> 70637a6d (Heiko Stübner    2013-06-25 14:55:42 +0200  45)  *   
> >> function. The pull direction and possibly strength too will normally
> >> 70637a6d (Heiko Stübner    2013-06-25 14:55:42 +0200  46)  *    be
> >> decided completely inside the hardware block and not be readable
> >> 70637a6d (Heiko Stübner    2013-06-25 14:55:42 +0200  47)  *    from
> >> the kernel side. 5ca3353b (Linus Walleij    2013-06-16 12:43:06 +0200 
> >> 48)  *    If the argument is != 0 pull up/down is enabled, if it is 0,
> >> the 5ca3353b (Linus Walleij    2013-06-16 12:43:06 +0200  49)  *   
> >> configuration is ignored. The proper way to disable it is to use
> >> 5ca3353b (Linus Walleij    2013-06-16 12:43:06 +0200  50)  *   
> >> @PIN_CONFIG_BIAS_DISABLE.
> > 
> > If the HW doesn't support any concept of a default pull, I think the
> > driver shouldn't support that option; it should return an error if asked
> > to program it.
> 
> Yes that's how I remember it and how we specified it.
> Correct Heiko?

Correct. The option was/is meant for hardware that sets pull settings without 
telling the kernel specifics and the kernel also not being able to influence 
them.


Heiko
