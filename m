Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaCJViX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:38:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51520 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaCJViU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:38:20 -0400
Date: Mon, 10 Mar 2014 16:35:24 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-arm-msm@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 2/6] rtc: pm8xxx: use regmap API for register accesses
Message-ID: <20140310213524.GL18529@joshc.qualcomm.com>
References: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
 <1394477089-3996-3-git-send-email-joshc@codeaurora.org>
 <20140310134741.e5b97d12d47e1b990501f8bc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310134741.e5b97d12d47e1b990501f8bc@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 01:47:41PM -0700, Andrew Morton wrote:
> On Mon, 10 Mar 2014 13:44:45 -0500 Josh Cartwright <joshc@codeaurora.org> wrote:
> > Now that the parent mfd driver has been made to work again, and has been
> > reworked to create a regmap instance intended for it's children to use,
> > rework the pm8xxx driver to use the regmap API for it's register
> > accesses.
> 
> Do we need a 
> 
> 	depends on REGMAP
> 
> in Kconfig?

Good question.  This driver already gets the REGMAP dependency through
it's parent (MFD_PM8XXX), which does 'select REGMAP'.

I recall there being some history as to why individual drivers shouldn't
explicitly depend on REGMAP, as it's the parent drivers/subsystem
responsibility to select it when needed, however I can't recall details.
Perhaps it's due to REGMAP not being a user-selectable option.

(FWIW, I did force a build of this driver with !REGMAP, and it builds
just fine with the regmap_write()/_read() stubs, but of course it
wouldn't do anything meaningful at runtime)

Thanks,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
