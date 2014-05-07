Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbaEGJs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:48:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:11280 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbaEGJs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:48:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1001,1389772800"; 
   d="scan'208";a="507545194"
Message-ID: <1399456133.2458.52.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [PATCH] [linux-next] pwm: lpss: fix const qualifier discard
 warning
From: Alan Cox <alan@linux.intel.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Jan Moskyto Matejka <mq@suse.cz>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 07 May 2014 10:48:53 +0100
In-Reply-To: <20140507084137.GD6362@ulmo>
References: <1399044179-17912-1-git-send-email-mq@suse.cz>
	 <20140507084137.GD6362@ulmo>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-07 at 10:41 +0200, Thierry Reding wrote:
> On Fri, May 02, 2014 at 05:22:59PM +0200, Jan Moskyto Matejka wrote:
> > Fixing this warning:
> > drivers/pwm/pwm-lpss.c: In function ‘pwm_lpss_probe_pci’:
> > drivers/pwm/pwm-lpss.c:192:2: warning: passing argument 3 of ‘pwm_lpss_probe’ discards ‘const’ qualifier from pointer target type [enabled by default]
> >   lpwm = pwm_lpss_probe(&pdev->dev, &pdev->resource[0], info);
> >   ^
> > drivers/pwm/pwm-lpss.c:130:30: note: expected ‘struct pwm_lpss_boardinfo *’ but argument is of type ‘const struct pwm_lpss_boardinfo *’
> >  static struct pwm_lpss_chip *pwm_lpss_probe(struct device *dev,
> > 
> > That warning was introduced in commit 093e00bb3f82f3c67e2d1682e316fc012bcd0d92
> > ("pwm: lpss: Add support for PCI devices").
> > 
> > Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
> > ---
> >  drivers/pwm/pwm-lpss.c | 1 +
> >  1 file changed, 1 insertion(+)
> 
> This was reported over a week ago by the kbuild test robot and I've had
> fixes for this (and an additional sparse warning) in my tree for a while
> now. Interestingly everybody at Intel seems to have forgotten about this
> driver after their patches got merged since nobody cared to respond.

No - like everyone else we're all juggling multiple things. Also
remember there have just been a bunch of public holidays on large parts
of the planet.

I did see Jan's email but I didn't realise it needed a response, it was
clearly and obviously correct.

Alan


