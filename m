Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaIYTKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:10:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57291 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIYTKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:10:09 -0400
Date: Thu, 25 Sep 2014 14:04:34 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] watchdog: qcom: register a restart notifier
Message-ID: <20140925190434.GL868@joshc.qualcomm.com>
References: <cover.1411667144.git.joshc@codeaurora.org>
 <2dc54244e755eeacf8265a484819e0c2e2393221.1411667144.git.joshc@codeaurora.org>
 <20140925184149.GB12340@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925184149.GB12340@roeck-us.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:41:49AM -0700, Guenter Roeck wrote:
> On Thu, Sep 25, 2014 at 12:48:53PM -0500, Josh Cartwright wrote:
> > The WDT's BITE_TIME warm-reset behavior can be leveraged as a last
> > resort mechanism for triggering chip reset.  Usually, other restart
> > methods (such as PS_HOLD) are preferrable for issuing a more complete
> > reset of the chip.  As such, keep the priority of the watchdog notifier
> > low.
> > 
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > ---
> >  drivers/watchdog/qcom-wdt.c | 38 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 38 insertions(+)
> > 
> > diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
> > index 0f56ca3..8ce339f 100644
> > --- a/drivers/watchdog/qcom-wdt.c
> > +++ b/drivers/watchdog/qcom-wdt.c
> > @@ -10,12 +10,14 @@
> >   * GNU General Public License for more details.
> >   *
> >   */
> > +#include <linux/delay.h>
> 
> Nitpick: Please keep alphabetical order of include files.
> That makes it easier to identify include files later on.

That was my intent, but apparently I fail at the alphabet :).  Normally
instead of thinking I pipe the #include list through 'sort'.  Not sure
why I didn't do so this time around.

Thanks,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
