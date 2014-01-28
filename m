Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaA1Jfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:35:46 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:64304 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaA1Jfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:35:42 -0500
Subject: Re: [BISECTED] OMAP: DSS: clk rate mismatch
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        Tero Kristo <t-kristo@ti.com>, Nishanth Menon <nm@ti.com>
In-Reply-To: <52E772A3.4090401@ti.com>
References: <52E697C0.6000202@gmail.com> <1390848104.4936.62.camel@mars>
	 <52E772A3.4090401@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jan 2014 10:35:35 +0100
Message-ID: <1390901735.2963.8.camel@lovely>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 11:04 +0200, Tomi Valkeinen wrote:
> On 2014-01-27 20:41, Christoph Fritz wrote:
> > On Mon, 2014-01-27 at 19:30 +0200, Ivaylo Dimitrov wrote:
> >> linux-next-20140124 DSS is broken on N900  - display stays black (there 
> >> is some noise though). I booted the kernel with qemu and it gives the 
> >> following warning:
> >>
> >> [    0.623779] DSS: set fck to 172800000
> >> [    0.624237] ------------[ cut here ]------------
> >> [    0.624298] WARNING: CPU: 0 PID: 1 at 
> >> drivers/video/omap2/dss/dss.c:497 dss_set_fck_rate+0x68/0x8c()
> >> [    0.624359] clk rate mismatch: 288000000 != 172800000
> > 
> > Here are also clock regressions since next-20140122 regarding
> > dss_set_fck_rate() and sys_clkout2 occuring in my current patchset for a
> > dm37xx100 board. Please see here:
> 
> I presume you get a similar warning on your board? What rates does it
> report?

None, dss_set_fck_rate() just fails so omapdss_dss exits with error -22.

To quote the cover-letter[1] of my board-support patch series here:

Due to a regression since next-20140122 the following errors are present:

 - pin sys_clkout2, which gets configured to 24 Mhz by the fourth patch
   in this set, erroneously outputs only 12 Mhz.
   Just out of curiosity, configuring it to 48 Mhz puts out desired 24 Mhz.

 - omap_dss, which gets configured by the third patch in this set, fails
   to do 'dss_set_fck_rate(fck);' in
   drivers/video/omap2/dss/dss.c:dss_setup_default_clock() which leads to:

    | omapdss_dss: probe of omapdss_dss failed with error -22
    | omapdss CORE error: Failed to initialize DSS platform driver
    | panel-dpi panel-dpi.0: failed to find video source 'dpi.0

  Both regressions seem to have something to do with the clock framework. 
  Could this be related to the DT clock conversion patches?

[1]: http://thread.gmane.org/gmane.linux.ports.arm.omap/110095

