Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3LEQSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:18:53 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35395 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3LEQSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:18:50 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-7b-52a0a7675f84
From: Tomasz Figa <t.figa@samsung.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Leela Krishna Amudala <l.krishna@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Doug Anderson <dianders@chromium.org>,
        Wim Van Sebroeck <wim@iguana.be>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog: s3c2410_wdt: Report when the watchdog reset the
 system
Date: Thu, 05 Dec 2013 17:18:39 +0100
Message-id: <7223693.Usv1CTSMc0@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <20131205160027.GA13200@roeck-us.net>
References: <1386008082-28740-1-git-send-email-dianders@chromium.org>
 <CAL1wa8cQcvRzXgaEP3kzkvzogqyeM2eJt_oRZfu6NbWxfP3zAg@mail.gmail.com>
 <20131205160027.GA13200@roeck-us.net>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xq7rpyxcEGexo1LOYtO4Ak8XZZQfZ
	LHoXXGWz2LnlBpvFpsfXWC0u75rDZjHj/D4mixvr9rFbPFl4hsni1PXPbBardv1htLg14wWr
	A4/H7IaLLB5/V71g9tg56y67x7XNYh6bl9R7XDnRxOqx83sDu0ffllWMHp83yQVwRnHZpKTm
	ZJalFunbJXBlPGi9y1jQJVnxYvZKpgbGVuEuRk4OCQETiSPvnjBD2GISF+6tZ+ti5OIQEljK
	KLF490xGCKeLSWL9qyY2kCo2ATWJzw2PwGwRILv5VAtYB7PAWhaJ8zvXAXVwcAgLhEs07HAC
	qWERUJXoWLSHFcTmFdCU2PVwOdg2fgF1iXfbnjKB2KICbhIv9m1hB7E5BYwkvk2axwSxeAuj
	xNRHJ9ggmgUlfky+xwJiMwvIS+zbP5UVwtaSWL/zONMERsFZSMpmISmbhaRsASPzKkbR1NLk
	guKk9FwjveLE3OLSvHS95PzcTYyQuPq6g3HpMatDjAIcjEo8vI4p84OEWBPLiitzDzFKcDAr
	ifDeX7AgSIg3JbGyKrUoP76oNCe1+BAjEwenVAPj1CCJbex5pyYdm3Hxs2bfZfEtKUUsj5Ln
	bzBbYOEi9zr3c1t8b6JLnZbP7pfLpzMq/NY43+/2ZcmX0D/f7/RtUVupOef4zd0HjooH/lav
	zPP2mvXwp+ADtajFLp83zT0+U3/bFh7tepOj2ay/lh/9/na2SyFDkvSGI6L7Oo7PnHqPozfn
	8D9/ISWW4oxEQy3mouJEAL+vICCJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 of December 2013 08:00:27 Guenter Roeck wrote:
> On Thu, Dec 05, 2013 at 01:27:13PM +0530, Leela Krishna Amudala wrote:
> > Hi Guenter Roeck,
> > 
> > On Tue, Dec 3, 2013 at 3:06 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> > >
> > > On Mon, Dec 02, 2013 at 12:47:53PM -0800, Olof Johansson wrote:
> > > > On Mon, Dec 2, 2013 at 12:21 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > > > > On Mon, Dec 02, 2013 at 10:14:41AM -0800, Doug Anderson wrote:
> > > > >> A good watchdog driver is supposed to report when it was responsible
> > > > >> for resetting the system.  Implement this for the s3c2410, at least on
> > > > >> exynos5250 and exynos5420 where we already have a pointer to the PMU
> > > > >> registers to read the information.
> > > > >>
> > > > >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> > > > >> ---
> > > > >> This patch is based atop Leela Krishna's recent series that ends with
> > > > >> (ARM: dts: update watchdog device nodes for Exynos5250 and Exynos5420)
> > > > >> AKA <https://patchwork.kernel.org/patch/3251861/>.
> > > > >>
> > > > >>  drivers/watchdog/s3c2410_wdt.c | 42 +++++++++++++++++++++++++++++++++++++++---
> > > > >>  1 file changed, 39 insertions(+), 3 deletions(-)
> > > > >>
> > > > >> diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
> > > > >> index 47f4dcf..2c87d37 100644
> > > > >> --- a/drivers/watchdog/s3c2410_wdt.c
> > > > >> +++ b/drivers/watchdog/s3c2410_wdt.c
> > > > >> @@ -62,9 +62,13 @@
> > > > >>  #define CONFIG_S3C2410_WATCHDOG_ATBOOT               (0)
> > > > >>  #define CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME (15)
> > > > >>
> > > > >> +#define RST_STAT_REG_OFFSET          0x0404
> > > > >>  #define WDT_DISABLE_REG_OFFSET               0x0408
> > > > >>  #define WDT_MASK_RESET_REG_OFFSET    0x040c
> > > > >>  #define QUIRK_NEEDS_PMU_CONFIG               (1 << 0)
> > > > >> +#define QUIRK_HAS_RST_STAT           (1 << 1)
> > > > >> +#define QUIRKS_NEED_PMUREG           (QUIRK_NEEDS_PMU_CONFIG | \
> > > > >> +                                      QUIRK_HAS_RST_STAT)
> > > > >>
> > > > > I am not really happy about the NEED (both of them, really) here.
> > > > > How about HAS instead ?
> > > >
> > > > Ah, I just commented on these things on our internal review site too
> > > > on this patch. I don't even think a quirk is needed -- just use the
> > > > presence of a non-0 rst_stat_reg to tell if you need to use regmap.
> > > >
> > > Agreed; same is true for the QUIRK_NEEDS_PMU_CONFIG related registers
> > > as well.
> > >
> > 
> > As Tomasz Figa suggested I introduced quirks,
> > 
> 'quirk' implies a workaround for non-standard or broken hardware,
> not a flag indicating device specific functionality.

I wouldn't limit meaning of "quirk" to only this. The word has been widely
used around the kernel as a name for differences between hardware
variants.

As for the original issue itself, IMHO Doug's original solution is the
most practical, as 0 can be a valid register offset and RST_STAT register
could be used for other purposes as well in future, depending on other
quirk flag.

Best regards,
Tomasz

