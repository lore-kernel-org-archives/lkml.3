Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819Ab3BYC61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 21:58:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:13527 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759512Ab3BYC60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 21:58:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,730,1355126400"; 
   d="scan'208";a="260908178"
Message-ID: <1361761101.2303.5.camel@rzhang1-mobl4>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
From: Zhang Rui <rui.zhang@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Durgadoss R <durgadoss.r@intel.com>,
        Borislav Petkov <bp@suse.de>, Peter Feuerer <peter@piie.net>,
        Andreas Mohr <andi@lisas.de>, Alexander Lam <azl@andrew.cmu.edu>
Date: Mon, 25 Feb 2013 10:58:21 +0800
In-Reply-To: <20130224112851.GA19609@pd.tnic>
References: <20130222111521.GA25473@pd.tnic>
	 <1361647210-12983-1-git-send-email-bp@alien8.de>
	 <20130224112851.GA19609@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-24 at 12:28 +0100, Borislav Petkov wrote:
> On Sat, Feb 23, 2013 at 08:20:10PM +0100, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > The new step_wise thermal governor wasn't able to handle the one-trip
> > point design of acerhdf where we want to turn off the fan if we go under
> > the 'fanoff' temperature and to turn it on only after exceeding the
> > 'fanon' temperature.
> > 
> > Do that by looking at the current fan state and return the temperature
> > accordingly.
> > 
> > Suggested-by: Zhang Rui <rui.zhang@intel.com>
> > Cc: Peter Feuerer <peter@piie.net>
> > Cc: Andreas Mohr <andi@lisas.de>
> > Cc: Alexander Lam <azl@andrew.cmu.edu>
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> 
> Ok, ignore this one for now - the suspend/resume path doesn't pan out
> somehow, need to do some more handholding here.
> 
hmm,
this reminds me that we should do a thermal_zone_device_update() for
each registered thermal zone when resuming from system suspend.

thanks,
rui

