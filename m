Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3LSKBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:01:47 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:50376 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3LSKBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:01:42 -0500
Message-ID: <1387447296.31516.37.camel@host5.omatika.ru>
Subject: Re: [PATCH v3 01/21 resend] serial: rewrite pxa2xx-uart to use
 8250_core
From: Sergei Ianovich <ynvich@gmail.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
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
Date: Thu, 19 Dec 2013 14:01:36 +0400
In-Reply-To: <1387445713.31516.30.camel@host5.omatika.ru>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
	 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
	 <1387309071-22382-2-git-send-email-ynvich@gmail.com>
	 <20131219085145.GB20686@xps8300>
	 <1387445713.31516.30.camel@host5.omatika.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 13:35 +0400, Sergei Ianovich wrote:
> Hi Heikki,
> 
> On Thu, 2013-12-19 at 10:51 +0200, Heikki Krogerus wrote:
> > I noticed one more thing. I'm sorry about commenting this late.
> > 
> > Since you set the type PORT_XSCALE, don's you want to use
> > UPF_FIXED_TYPE flag instead of the UPF_SKIP_TEST here? Otherwise the
> > type will just get overridden and autoconfig() will be executed.
> 
> UPF_FIXED_PORT was my first guess. However, it didn't work.
> 
> I've also tried to do ioremap in serial_pxa_probe instead of using
> UPF_IOREMAP. This didn't work as well.

I didn't clarify properly.

UPF_SKIP_TEST skips only the loopback test. This test could work on PXA,
but requires PXA-specific pre-initialization. There are more test after
the loopback one, which will fail if we are not on PXA. So I decided
that skipping it is easier than tricky rewriting of autoconfig().

