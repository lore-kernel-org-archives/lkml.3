Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab3BYDCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 22:02:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:58231 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759600Ab3BYDCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 22:02:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,730,1355126400"; 
   d="scan'208";a="260909110"
Message-ID: <1361761314.2303.9.camel@rzhang1-mobl4>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
From: Zhang Rui <rui.zhang@intel.com>
To: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Durgadoss R <durgadoss.r@intel.com>, Borislav Petkov <bp@suse.de>,
        Andreas Mohr <andi@lisas.de>, Alexander Lam <azl@andrew.cmu.edu>
Date: Mon, 25 Feb 2013 11:01:54 +0800
In-Reply-To: <cone.1361706175.908398.1806.1000@galar>
References: <20130222111521.GA25473@pd.tnic>
	 <1361647210-12983-1-git-send-email-bp@alien8.de>
	 <20130224112851.GA19609@pd.tnic> <cone.1361706175.908398.1806.1000@galar>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-24 at 12:42 +0100, Peter Feuerer wrote:
> Hi Boris,
> 
> thanks for your best wishes in the last mail, I'm feeling little better now.
> 
> Borislav Petkov writes:
> 
> > On Sat, Feb 23, 2013 at 08:20:10PM +0100, Borislav Petkov wrote:
> >> From: Borislav Petkov <bp@suse.de>
> >> 
> >> The new step_wise thermal governor wasn't able to handle the one-trip
> >> point design of acerhdf where we want to turn off the fan if we go under
> >> the 'fanoff' temperature and to turn it on only after exceeding the
> >> 'fanon' temperature.
> >> 
> >> Do that by looking at the current fan state and return the temperature
> >> accordingly.
> >> 
> >> Suggested-by: Zhang Rui <rui.zhang@intel.com>
> >> Cc: Peter Feuerer <peter@piie.net>
> >> Cc: Andreas Mohr <andi@lisas.de>
> >> Cc: Alexander Lam <azl@andrew.cmu.edu>
> >> Signed-off-by: Borislav Petkov <bp@suse.de>
> > 
> > Ok, ignore this one for now - the suspend/resume path doesn't pan out
> > somehow, need to do some more handholding here.
> 
> Please test my last patch with the 4 trip points ;) - even if you don't 
> really like it, it is working great! - And to be honest, I still prefer this 
> solution!
> 
well, the 4 trip points do not make sense, at least the passive trip
point is a no op as we have no passive cooling device binded with it.

thanks,
rui

