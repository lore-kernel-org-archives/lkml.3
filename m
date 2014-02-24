Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaBXSn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:43:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55353 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaBXSn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:43:56 -0500
Date: Mon, 24 Feb 2014 12:41:20 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Randy Dunlap <rdunlap@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 17 (pinctrl-msm)
Message-ID: <20140224184120.GB18563@joshc.qualcomm.com>
References: <20140217172329.2c61499f57842ec2ed177bc5@canb.auug.org.au>
 <530247FC.90606@infradead.org>
 <CACRpkdamW1-CxZV65at3PaPhY5nANRDd=SY=FsNPVnrPxyD81w@mail.gmail.com>
 <20140224174646.GA32621@sonymobile.com>
 <530B8C15.50100@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <530B8C15.50100@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 10:14:45AM -0800, Randy Dunlap wrote:
> On 02/24/2014 09:46 AM, Bjorn Andersson wrote:
> > On Mon 24 Feb 06:46 PST 2014, Linus Walleij wrote:
> >> On Mon, Feb 17, 2014 at 6:33 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> >>> On 02/16/2014 10:23 PM, Stephen Rothwell wrote:
> >>> ERROR: "handle_bad_irq" [drivers/pinctrl/pinctrl-msm.ko] undefined!
> >>
> >> Weird, Björn do you know what may be causing this?
> > 
> > I include linux/irq.h to get hold of handle_bad_irq() and as far as I can see
> > there are no changes related to that in linux-next.
> > 
> > Do we know if the build still fails? Or if something changed?
> > 
> > 
> > Please let me know if I should pull down the -next tree and try to reproduce
> > this.
> 
> I guess that you get off free on this one since I didn't post the failing
> .config file and I have already deleted it.
> 
> I'm trying to reproduce it now but it's slow going.  I'll let you know if
> I get it to fail again.

Without too much effort, I can get this to fail just by making
CONFIG_PINCTRL_MSM=m.  handle_bad_irq isn't marked EXPORT_SYMBOL*, so
hence the warning.

Whether or not this is intentional is not clear.  Do we support modules
installing chained irq handlers?

For now, the patch below just makes this driver 'bool' instead of
'tristate'.

  Josh

--8<--
Subject: [PATCH] pinctrl: msm: make PINCTRL_MSM bool instead of tristate

Modular builds of pinctrl-msm break due to handle_bad_irq being
unexported for module use.  For now, make PINCTRL_MSM 'bool'.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/pinctrl/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index be361b7..1e4e693 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -217,7 +217,7 @@ config PINCTRL_IMX28
 	select PINCTRL_MXS
 
 config PINCTRL_MSM
-	tristate
+	bool
 	select PINMUX
 	select PINCONF
 	select GENERIC_PINCONF
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
