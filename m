Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3ARETg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 23:19:36 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35693 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3ARETf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 23:19:35 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH v2] pwm: pwm-tiehrpwm: Update the clock handling of
 pwm-tiehrpwm driver
Thread-Topic: [PATCH v2] pwm: pwm-tiehrpwm: Update the clock handling of
 pwm-tiehrpwm driver
Thread-Index: AQHN7zMUDYV34A58i0S9SWF5CQhqQJhNWqcAgAEqcFA=
Date: Fri, 18 Jan 2013 04:18:27 +0000
Deferred-Delivery: Fri, 18 Jan 2013 04:18:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA5F43D@DBDE01.ent.ti.com>
References: <1357823126-19333-1-git-send-email-avinashphilip@ti.com>
 <20130117155218.GA23117@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130117155218.GA23117@avionic-0098.adnet.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 21:22:18, Thierry Reding wrote:
> On Thu, Jan 10, 2013 at 06:35:26PM +0530, Philip Avinash wrote:
> > From: "Philip, Avinash" <avinashphilip@ti.com>
> > 
> > The clock framework has changed and it's now better to invoke
> > clock_prepare_enable() and clk_disable_unprepare() rather than the
> > legacy clk_enable() and clk_disable() calls. This patch converts the
> > pwm-tiehrpwm driver to the new framework.
> > 
> > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> > ---
> > Changes Since v1:
> > 	- Check the return value of TBCLK enable in .pwm_enable()
> > 
> > In 3.8-rc1, common clock frame work support added to AM335x.
> > 
> >  drivers/pwm/pwm-tiehrpwm.c |   10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> I had applied this to my for-next branch, but reading the commit message
> again it would seem that this should actually go into 3.8, right?

Common clock framework support added for am335x in 3.8 only, still EHRPWM
tbclk not present in clock tree. I expect this to be in 3.9. So this patch
also requires to be in 3.9 only.

Thanks
Avinash

> 
> Thierry
> 

