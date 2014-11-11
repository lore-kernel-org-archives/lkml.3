Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaKKQUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:20:41 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:53277
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbaKKQUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:20:40 -0500
X-IronPort-AV: E=Sophos;i="5.07,362,1413237600"; 
   d="scan'208";a="87512341"
Date: Tue, 11 Nov 2014 17:20:37 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Octavian Purdila <octavian.purdila@intel.com>
cc: Johan Hovold <johan@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Julia Lawall <julia.lawall@lip6.fr>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] i2c: dln2: simplify return flow for
 dln2_i2c_enable
In-Reply-To: <CAE1zotKi+kpv6a9xM=-qkpo3K9R5xKjrf2RZgDV7advXFS92FA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1411111718460.2047@localhost6.localdomain6>
References: <1415708457-18798-1-git-send-email-octavian.purdila@intel.com> <1415708457-18798-3-git-send-email-octavian.purdila@intel.com> <20141111122636.GF29789@localhost> <CAE1zotKi+kpv6a9xM=-qkpo3K9R5xKjrf2RZgDV7advXFS92FA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014, Octavian Purdila wrote:

> On Tue, Nov 11, 2014 at 2:26 PM, Johan Hovold <johan@kernel.org> wrote:
> > On Tue, Nov 11, 2014 at 02:20:57PM +0200, Octavian Purdila wrote:
> >> This fixes the following kbuild test robot warning:
> >>
> >> >> drivers/i2c/busses/i2c-dln2.c:70:1-4: WARNING: end returns can be simplified if negative or 0 value
> >>
> >> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> >> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> >>
> >> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> >> ---
> >>  drivers/i2c/busses/i2c-dln2.c | 7 +------
> >>  1 file changed, 1 insertion(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/i2c/busses/i2c-dln2.c b/drivers/i2c/busses/i2c-dln2.c
> >> index 010a5fa..b3fb86a 100644
> >> --- a/drivers/i2c/busses/i2c-dln2.c
> >> +++ b/drivers/i2c/busses/i2c-dln2.c
> >> @@ -54,7 +54,6 @@ struct dln2_i2c {
> >>
> >>  static int dln2_i2c_enable(struct dln2_i2c *dln2, bool enable)
> >>  {
> >> -     int ret;
> >>       u16 cmd;
> >>       struct {
> >>               u8 port;
> >> @@ -67,11 +66,7 @@ static int dln2_i2c_enable(struct dln2_i2c *dln2, bool enable)
> >>       else
> >>               cmd = DLN2_I2C_DISABLE;
> >>
> >> -     ret = dln2_transfer_tx(dln2->pdev, cmd, &tx, sizeof(tx));
> >> -     if (ret < 0)
> >> -             return ret;
> >> -
> >> -     return 0;
> >> +     return dln2_transfer_tx(dln2->pdev, cmd, &tx, sizeof(tx));
> >
> > This looks like a bogus warning. It's not generally equivalent (ret > 0)
> > and is not mandated by any style guide lines.
> >
> 
> In this particular it should be equivalent (with the previous fix) and
> it saves 5 lines, so I think its worth it.

It's marked as a warning because it is not generally equivalent.  But 
there may be many cases where it is equivalent, and in this case the 
documentation for the function said that it should have been.  So I think 
that the warning is useful.

julia
