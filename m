Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482Ab3CLUUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:20:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab3CLUUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:20:09 -0400
Date: Tue, 12 Mar 2013 13:20:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Olof Johansson <olof@lixom.net>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the akpm tree with the arm-soc tree
Message-Id: <20130312132007.d1336d28311d3fbda324942d@linux-foundation.org>
In-Reply-To: <20130312115339.GF12700@titan.lakedaemon.net>
References: <20130312144714.39749c5b0bd1aea14c4d2ff8@canb.auug.org.au>
	<20130312062509.GQ21478@lunn.ch>
	<20130312111246.GD12700@titan.lakedaemon.net>
	<CAOesGMgSzn+uCVEMKZgtorcNkdzzvntmnfoej5vN-AjF43pnyQ@mail.gmail.com>
	<20130312115339.GF12700@titan.lakedaemon.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Mar 2013 07:53:39 -0400 Jason Cooper <jason@lakedaemon.net> wrote:

> On Tue, Mar 12, 2013 at 04:37:39AM -0700, Olof Johansson wrote:
> > On Tue, Mar 12, 2013 at 4:12 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > > On Tue, Mar 12, 2013 at 07:25:09AM +0100, Andrew Lunn wrote:
> > >> On Tue, Mar 12, 2013 at 02:47:14PM +1100, Stephen Rothwell wrote:
> > >> > Hi Andrew,
> > >> >
> > >> > Today's linux-next merge of the akpm tree got a conflict in
> > >> > drivers/rtc/rtc-mv.c between commit 89c58c198b25 ("rtc: rtc-mv: Add
> > >> > support for clk to avoid lockups") from the arm-soc tree and commit "rtc:
> > >> > rtc-mv: use devm_rtc_device_register()" from the akpm tree.
> > >> >
> > >> > I fixed it up (I think - see below) and can carry the fix as necessary
> > >> > (no action is required).
> > >>
> > >> Hi Stephan
> > >>
> > >> Looks O.K. to me.
> > >>
> > >> Acked-by: Andrew Lunn <andrew@lunn.ch>
> > >
> > > Same here,
> > >
> > > Acked-by: Jason Cooper <jason@lakedaemon.net>
> > 
> > We should make sure that future RTC changes get queued through AKPM
> > and not through us to avoid these kind of conflicts. Same as other
> > driver subsystems..
> 
> I agree, however, this patch is part of a four patch series fixing a
> single problem reported by Simon Baatz:
> 
>   89c58c1 rtc: rtc-mv: Add support for clk to avoid lockups
>   de88747 gpio: mvebu: Add clk support to prevent lockup
>   7bf5b40 ARM: kirkwood: fix to retain gbe MAC addresses for DT kernels
>   93fff4c ARM: kirkwood: of_serial: fix clock gating by removing clock-frequency

Yep, don't go out of your way to avoid the cross-tree conflicts - we
fix those up all the time.  It's best to keep a patch series like this
all in one place.
