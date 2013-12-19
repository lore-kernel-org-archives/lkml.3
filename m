Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3LSLFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:05:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:63661 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab3LSLFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:05:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,512,1384329600"; 
   d="scan'208";a="452559431"
Date: Thu, 19 Dec 2013 13:05:02 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        James Cameron <quozl@laptop.org>, Zhou Zhu <zzhu3@marvell.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 01/21 resend] serial: rewrite pxa2xx-uart to use
 8250_core
Message-ID: <20131219110502.GC20686@xps8300>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-2-git-send-email-ynvich@gmail.com>
 <20131219085145.GB20686@xps8300>
 <1387445713.31516.30.camel@host5.omatika.ru>
 <1387447296.31516.37.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387447296.31516.37.camel@host5.omatika.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 02:01:36PM +0400, Sergei Ianovich wrote:
> On Thu, 2013-12-19 at 13:35 +0400, Sergei Ianovich wrote:
> > On Thu, 2013-12-19 at 10:51 +0200, Heikki Krogerus wrote:
> > > I noticed one more thing. I'm sorry about commenting this late.
> > > 
> > > Since you set the type PORT_XSCALE, don's you want to use
> > > UPF_FIXED_TYPE flag instead of the UPF_SKIP_TEST here? Otherwise the
> > > type will just get overridden and autoconfig() will be executed.
> > 
> > UPF_FIXED_PORT was my first guess. However, it didn't work.
> > 
> > I've also tried to do ioremap in serial_pxa_probe instead of using
> > UPF_IOREMAP. This didn't work as well.
> 
> I didn't clarify properly.
> 
> UPF_SKIP_TEST skips only the loopback test. This test could work on PXA,
> but requires PXA-specific pre-initialization. There are more test after
> the loopback one, which will fail if we are not on PXA. So I decided
> that skipping it is easier than tricky rewriting of autoconfig().

OK. So there is no problem here. Sorry about the noise.

Thanks,

-- 
heikki
