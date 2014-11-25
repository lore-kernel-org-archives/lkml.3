Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaKYKeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:34:11 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:55267 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaKYKeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:34:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kevin Hilman <khilman@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>, ssantosh@kernel.org
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
Date: Tue, 25 Nov 2014 11:33:57 +0100
Message-ID: <15074721.IbfeeI3ajE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141125064406.12298.57929@quantum>
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <2997659.fTX2lvxXfH@wuerfel> <20141125064406.12298.57929@quantum>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:TqYkmSUpr+YqNjliMFyq1NZlgppnprSycrAcuXyu8hM
 F7zYmvXLG8auvsliYq54AswlDuoC99IsVGYTwb77FOxEtJJ7P1
 Wz2PXFP3AeuUTycQHQ1GS0dYYwYVDPrquLiUC7lg2XDEpvQacH
 yJiyYKbltFiH3cn64xvfPeGIEDN23li09Hp+5RPPjMyjMDZd06
 LNPW+I1UUC4GinyrhBkQKT18Z5llWyl+FdNSfrlqwrpzo0TD2F
 4BDzboMJ7MIx74qGf7a9npk1qBsbCWWKvHi7hjC137rExhONDg
 XI8pj9nR7umXozc/wJNftP9h2evGYTRLUSLNKp6AgstNYmR+O3
 ua16b58xrTkK1R2rB8AI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 November 2014 22:44:06 Mike Turquette wrote:
> Quoting Arnd Bergmann (2014-11-24 02:50:28)
> > 
> > Could the driver maybe identify the clocks that it wants to manage itself
> > to the pm-domain code? If it's safe for a device to have the clock turned
> > on at the default rate before loading the driver, any device that is connected
> > to the simple clk-pm-domain code could have all its clocks start out as
> > owned by the pm-domain, but then claim the clocks it needs to reprogram for
> > itself and take them out of the pmdomain.
> 
> I was thinking along similar lines. The functional versus optional stuff
> is really a property of the consuming device, not the clock signal
> itself.
> 
> Instead of adding a new property to the clock binding (e.g. fck-clocks
> or optional-clocks), could we simply wrap those lists of clocks in
> another node? E.g:
> 
> mandatory-clocks {
>        clocks = <&papllclk>, <&clkcpgmac>;
>        clock-names = "clk_pa", "clk_cpgmac";
> }
> 
> clocks = <&papllclk>, <&clkcpgmac>, <&chipclk12>;
>        clocks = <&clkcpgmac>;
>        clock-names = "cpsw_cpts_rft_clk";
> }
> 
> I'm showing my DT ignorance on this one. I haven't really thought
> through how these sub-nodes would work with of_clk_* handlers in
> drivers/clk/clkdev.c.

I'm not sure I even understand what you intended the example to look
like, it does't parse ;-)

My point above was completely different, the suggestion I made was
to not classify the clocks in DT at all, but to leave it all in
the client driver.

	Arnd
