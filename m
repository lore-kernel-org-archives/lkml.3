Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaKQUiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:38:11 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:59917 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaKQUiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:38:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Hilman <khilman@kernel.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>, ssantosh@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
Date: Mon, 17 Nov 2014 21:37:37 +0100
Message-ID: <1618855.DXsjWXLqau@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7h389h3aif.fsf@deeprootsystems.com>
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <1600093.60yAP0Qpua@wuerfel> <7h389h3aif.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:w4iglx4AJcthbla14Ox5bjqGitYFXGO2Ouma9pns5RP
 kS28HnOE0FOutcM9dpiKbogbow+7MknoC3WmVtmDXBusFXFiZm
 e8tmV5OF6b7dnnU+I2PUX4Zcba3ov0FazAnsybxWmn1+C6f32e
 iux/uGljUYxULIYdfxJ7HHhzTxSDsPpbJq5svJA8D5/Xr+Od98
 MN8iERSXoDlRScDVek0mZ+wQpy9rbfVooR+xfxMHheDPZRgV6e
 +UGc7rZV0IXsWhXbT3v64ZyVHkii1C4X6IlQI3MqcucR3S/S/J
 sdhTmFitOKSZt9icJokA3BfEt9FL502WhpRJcHaTvDraAUfeqJ
 0cRdiW0foVckZaAUl7ew=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2014 11:14:16 Kevin Hilman wrote:
> >> 
> >> So, The Keystone 2 Generic PM Controller is just a proxy PM layer here between
> >> device and Generic clock manipulation PM callbacks.
> >> It fills per-device clock list when device is attached to GPD and
> >> ensures that all clocks from that list enabled/disabled when device is
> >> started/stopped.
> >
> > The idea of such a generic power domain implementation sounds useful, but
> > it has absolutely no business in platform specific code.
> 
> Yes it does.  This isn't a generic power domain implementation, but
> rather just the platform-specific glue that hooks up the clocks to the
> right devices and power-domains so that the generic power-domain and
> generic pm_clocks code does the right thing.

How would you do this on an arm64 version of keystone then? With
the current approach, you'd need to add a machine specific directory,
and that seems completely pointless since this is not even about
a hardware requirement.

> > I suggest you either remove the power domain proxy from your drivers
> > and use the clocks directly, 
> 
> No.  That's a step in the wrong direction.  This change isn't affecting
> drivers directly.  It's the runtime PM and generic power domain layers
> that handle this, and runtime PM adapted drivers don't need any changes.
>  
> > or come up with an implementation that can be used across other
> > platforms and CPU architectures.
> 
> We already have those in the generic power domain and the pm_clock
> layers.  This series is just hooking those up for Keystone.

Then why not add the missing piece to the generic power domain
code to avoid having to add infrastructure to the platform
for it?

	Arnd
