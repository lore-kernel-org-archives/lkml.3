Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3LRPVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:21:22 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16933 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3LRPVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:21:20 -0500
X-AuditID: cbfec7f4-b7fc96d000006cd4-49-52b1bd6e9e61
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        hs@denx.de, khali@linux-fr.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 2/2] i2c: exynos5: configure fifo_depth based on HSI2C
 module version
Date: Wed, 18 Dec 2013 16:21:02 +0100
Message-id: <2845697.u7ZX4ij9vS@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <CAHfPSqCQZiMuH3S1eK2gqKShVjc+-BFZ8kkigTRDQyyETiPkQA@mail.gmail.com>
References: <1385100851-32254-1-git-send-email-ch.naveen@samsung.com>
 <1739891.MYO4PRtJOt@amdc1227>
 <CAHfPSqCQZiMuH3S1eK2gqKShVjc+-BFZ8kkigTRDQyyETiPkQA@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xy7p5ezcGGSzpZ7aYtO4Ak8Xd54cZ
	LXbcuc9s0fg30qLj7xdGi8u75rBZzDi/j8li0bb/zA4cHvNmnWDx+LvqBbPHzll32T2uNJxk
	8+jbsorR4/MmuQC2KC6blNSczLLUIn27BK6Mp38msRWcVqx4+/sEewPjHYkuRk4OCQETicmv
	HrJA2GISF+6tZ+ti5OIQEljKKNF4cC87hNPFJDH1zw12kCo2ATWJzw2P2EBsEQEjiZkPFjKC
	FDEL/GWUmLfxKytIQlggWmLrnp1gRSwCqhLtrTuYQGxeAU2JDwv7GEFsfgF1iXfbnoLFRQXc
	JF7s2wK2gFMgWOL+p9XMEJvXMEos/b+fGaJZUOLH5HtgtzILyEvs2z+VFcLWkli/8zjTBEbB
	WUjKZiEpm4WkbAEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkKj4soNx8TGrQ4wCHIxK
	PLwLfDYGCbEmlhVX5h5ilOBgVhLhFdoKFOJNSaysSi3Kjy8qzUktPsTIxMEp1cAo8Ifv2p49
	7u+XeFyqTeUvjvnnek7i9kWGC9e/3pWea3EwoGnqej2ziJryUga7SavzUoLe++RrcsrZp0SF
	WZe8L7HlvvpyWdYaoRu/FYWrFKd8ZJpd+fPqz3YjxjNvW8w2M6g8mnZHVlY98a+PTZpac2lR
	ENub7/73GL5caLu8pfGwDsu1s5FKLMUZiYZazEXFiQCbLt/PaAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 of December 2013 10:26:40 Naveen Krishna Ch wrote:
> Hello Tomasz,
> 
> 
> On 9 December 2013 22:01, Tomasz Figa <t.figa@samsung.com> wrote:
> >
> > Hi Naveen,
> >
> > On Friday 22 of November 2013 11:44:11 Naveen Krishna Chatradhi wrote:
> > > fifo_depth of the HSI2C is not constant
> > > Exynos5420 and Exynos5250 supports fifo_depth of 64bytes
> > > Exynos5260 supports fifo_depth of 16bytes
> > >
> > > This patch configures the fifo_depth based on HSI2C modules version.
> > > Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> > > ---
> > >  drivers/i2c/busses/i2c-exynos5.c |   29 ++++++++++++++++++-----------
> > >  1 file changed, 18 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
> > > index cbb49e2..19277d8 100644
> > > --- a/drivers/i2c/busses/i2c-exynos5.c
> > > +++ b/drivers/i2c/busses/i2c-exynos5.c
> > > @@ -77,12 +77,6 @@
> > >  #define HSI2C_RXFIFO_TRIGGER_LEVEL(x)                ((x) << 4)
> > >  #define HSI2C_TXFIFO_TRIGGER_LEVEL(x)                ((x) << 16)
> > >
> > > -/* As per user manual FIFO max depth is 64bytes */
> > > -#define HSI2C_FIFO_MAX                               0x40
> > > -/* default trigger levels for Tx and Rx FIFOs */
> > > -#define HSI2C_DEF_TXFIFO_LVL                 (HSI2C_FIFO_MAX - 0x30)
> > > -#define HSI2C_DEF_RXFIFO_LVL                 (HSI2C_FIFO_MAX - 0x10)
> > > -
> > >  /* I2C_TRAILING_CTL Register bits */
> > >  #define HSI2C_TRAILING_COUNT                 (0xf)
> > >
> > > @@ -187,6 +181,9 @@ struct exynos5_i2c {
> > >
> > >       /* Version of HS-I2C Hardware */
> > >       unsigned int            version;
> > > +
> > > +     /* FIFO depth */
> > > +     unsigned int            fifo_depth;
> > >  };
> > >
> > >  enum hsi2c_version {
> > > @@ -437,7 +434,7 @@ static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
> > >               fifo_status = readl(i2c->regs + HSI2C_FIFO_STATUS);
> > >               fifo_level = HSI2C_TX_FIFO_LVL(fifo_status);
> > >
> > > -             len = HSI2C_FIFO_MAX - fifo_level;
> > > +             len = i2c->fifo_depth - fifo_level;
> > >               if (len > (i2c->msg->len - i2c->msg_ptr))
> > >                       len = i2c->msg->len - i2c->msg_ptr;
> > >
> > > @@ -505,6 +502,7 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
> > >       u32 i2c_auto_conf = 0;
> > >       u32 fifo_ctl;
> > >       unsigned long flags;
> > > +     unsigned short trig_lvl;
> > >
> > >       i2c_ctl = readl(i2c->regs + HSI2C_CTL);
> > >       i2c_ctl &= ~(HSI2C_TXCHON | HSI2C_RXCHON);
> > > @@ -515,13 +513,19 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
> > >
> > >               i2c_auto_conf = HSI2C_READ_WRITE;
> > >
> > > -             fifo_ctl |= HSI2C_RXFIFO_TRIGGER_LEVEL(HSI2C_DEF_TXFIFO_LVL);
> > > +             trig_lvl = (i2c->msg->len > i2c->fifo_depth) ?
> > > +                     (i2c->fifo_depth * 3/4) : i2c->msg->len;
> >
> > This patch changes the fifo trigger level calculation (it's dependent now
> > on message length), not just maximum fifo size, as the description says.
> Actually, message->length need not be involved in this calculation.
> Involving msg->len
> will raise another interrupt for every small transactions. It better be avoided.
> > It should be split into two separate patches, explaining why both changes
> > are necessary.
> I will split the fifo_depth configuration code along with comments addressed on
> https://lkml.org/lkml/2013/11/22/31

OK.

> 
> I can think of 3 ways to address the h/w version changes
> 1. Compatible string as i implemented
> 2. Varient struct
> 3. Passing the information via device tree
> How about passing fifo_depth from device tree information.

I believe a combination of 1 and 2 is the recommended option, which is
a variant struct pointed by an entry in OF match table.

> 
> Currently, HSI2C Module on Exynso5260 is not another H/W version.
> It only defer in fifo_depth and init sequence needs a reset.

Well, this implies that it's another H/W version from kernel point of
view, as it needs different handling.

Best regards,
Tomasz

