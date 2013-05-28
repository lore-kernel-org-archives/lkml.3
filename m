Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430Ab3E1Ox0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:53:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50053 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3E1OxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:53:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Pawel Moll <pawel.moll@arm.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Daniel Tang <dt.tangr@gmail.com>,
        Lionel Debroux <lionel_debroux@yahoo.fr>
Subject: Re: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
Date: Tue, 28 May 2013 16:52:55 +0200
Message-ID: <3950519.8yj1SQodNQ@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1369750864.2939.1.camel@hornet>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <CACRpkdaQfaPQdJ1SDN--JDqcrXs8p6=FaDN+4KtKZF6nLtOvvw@mail.gmail.com> <1369750864.2939.1.camel@hornet>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:iQDcw5Nk9ohOHkKG3bWzGoVXE5nyuBt/QYhqlL68knx
 qKTMFuhwgVxO4WksSkfLi05wlcij6vU5GD4pv+/CtvE77mZhIf
 zzN1EhTWYSHJDOx/G69ZtGqh1PFszDTuiCx+UchwKSPJyGDNyE
 H2BBWgsHxSkf8GI4FT/NUKkN6pdEYiotrLBdwef49Tj9LZCArY
 oWXeatHGTJKBzaoFYUH3ljfxEyiAjW6DzQT3VEnOveJD4KcKuo
 GwRpZPae6UZBewmUgsu5vksoUgh04U37umCPwjzBh80MF8bnGD
 x/8fRWOl8mkXc6rMQTiLIr4A+Uu6C5Zy0OamybZlBWzkutLe65
 2rULg+dDJM2IWwZlRRCE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 May 2013 15:21:04 Pawel Moll wrote:
> On Tue, 2013-05-28 at 15:16 +0100, Linus Walleij wrote:
> > On Tue, May 28, 2013 at 12:54 PM, Pawel Moll <pawel.moll@arm.com> wrote:
> > > On Mon, 2013-05-27 at 11:32 +0100, Arnd Bergmann wrote:
> > >> b) add a new KMS driver for this hardware that can be used as an
> > >> alternative to the existing one and that works with DT.
> > >
> > > There are people working on this, just trying to jump through some legal
> > > hoops to post a RFC. Once this is done we'll be in an interesting
> > > position of two amba_bus drivers "competing" for the same amba_bus
> > > device, which I'm not sure how to deal with right now...
> > 
> > Make them mutually exclusive in Kconfig?
> 
> Certainly an option.
> 
> I wouldn't mind having both compiled as modules and loading one or the
> other, but it wouldn't fly with "=y"...

It's a bit ugly but I think you can express that in Kconfig like this:

config FB_ARMCLCD
        tristate "ARM PrimeCell PL110 support"
        depends on FB && ARM && ARM_AMBA
	depends on KMS_ARMCLCD != 'y'
	depends on 'm' if KMS_ARMCLCD

	Arnd
