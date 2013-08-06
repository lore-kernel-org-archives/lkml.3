Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3HFNI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 09:08:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43334 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab3HFNI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 09:08:57 -0400
Date: Tue, 6 Aug 2013 08:08:20 -0500
From: Nishanth Menon <nm@ti.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: Viresh Kumar <viresh.kumar@linaro.org>, <rjw@sisk.pl>, <pavel@ucw.cz>,
        <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: OPP: rename functions? (was [PATCH] OPP: Export opp_add())
Message-ID: <20130806130820.GA6035@kahuna>
References: <58acb4a8a4e98089078de3ed71999730b6d97b4b.1375521724.git.viresh.kumar@linaro.org>
 <5200F1B4.6050004@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5200F1B4.6050004@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change in subject to reflect new discussion.

On 05:53-20130806, Randy Dunlap wrote:
> On 08/03/2013 02:25 AM, Viresh Kumar wrote:
> >Export opp_add() so that modules can use it.
> >
> >Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> >---
> >  drivers/base/power/opp.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> >diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> >index c8ec186..ef89897 100644
> >--- a/drivers/base/power/opp.c
> >+++ b/drivers/base/power/opp.c
> >@@ -460,6 +460,7 @@ int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
> >  	srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_ADD, new_opp);
> >  	return 0;
> >  }
> >+EXPORT_SYMBOL_GPL(opp_add);
> 
> Could it be renamed to pm_opp_add() or power_opp_add() ?
> The name is a bit too unspecific IMO.
Though this has nothing specific with this patch, an interesting point.

git grep -w opp . showed drivers/tty/n_tty.c,
drivers/sbus/char/openprom.c and arch/powerpc/kvm/mpic.c using
variables named opp to mean what ever they had in context. rest(around
40 odd files) seem to use opp as in Documentation/power/opp.txt..

We could go with a pm_ prefix or even dev_pm_opp_ prefix to be more
specific, though I prefer just pm_. If Rafael and others are ok, I can
post a series out.

-- 
Regards,
Nishanth Menon
