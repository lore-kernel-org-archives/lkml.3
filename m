Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3HFOFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:05:03 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58000 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab3HFOFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:05:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nishanth Menon <nm@ti.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, pavel@ucw.cz,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: OPP: rename functions? (was [PATCH] OPP: Export opp_add())
Date: Tue, 06 Aug 2013 16:15:17 +0200
Message-ID: <1611420.5h2rr9N0mt@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130806130820.GA6035@kahuna>
References: <58acb4a8a4e98089078de3ed71999730b6d97b4b.1375521724.git.viresh.kumar@linaro.org> <5200F1B4.6050004@infradead.org> <20130806130820.GA6035@kahuna>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 06, 2013 08:08:20 AM Nishanth Menon wrote:
> change in subject to reflect new discussion.
> 
> On 05:53-20130806, Randy Dunlap wrote:
> > On 08/03/2013 02:25 AM, Viresh Kumar wrote:
> > >Export opp_add() so that modules can use it.
> > >
> > >Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > >---
> > >  drivers/base/power/opp.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > >diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> > >index c8ec186..ef89897 100644
> > >--- a/drivers/base/power/opp.c
> > >+++ b/drivers/base/power/opp.c
> > >@@ -460,6 +460,7 @@ int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
> > >  	srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_ADD, new_opp);
> > >  	return 0;
> > >  }
> > >+EXPORT_SYMBOL_GPL(opp_add);
> > 
> > Could it be renamed to pm_opp_add() or power_opp_add() ?
> > The name is a bit too unspecific IMO.
> Though this has nothing specific with this patch, an interesting point.
> 
> git grep -w opp . showed drivers/tty/n_tty.c,
> drivers/sbus/char/openprom.c and arch/powerpc/kvm/mpic.c using
> variables named opp to mean what ever they had in context. rest(around
> 40 odd files) seem to use opp as in Documentation/power/opp.txt..
> 
> We could go with a pm_ prefix or even dev_pm_opp_ prefix to be more
> specific, though I prefer just pm_. If Rafael and others are ok, I can
> post a series out.

Yup, that would be useful.  I'm for dev_pm_opp_ if that matters.

Thanks,
Rafael

