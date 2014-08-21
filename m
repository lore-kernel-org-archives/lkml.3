Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaHURFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:05:19 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63418 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbaHURFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:05:17 -0400
Date: Thu, 21 Aug 2014 10:05:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 2/2] Input: misc: introduce palmas-pwrbutton
Message-ID: <20140821170512.GA3796@core.coreip.homeip.net>
References: <1408392810-16011-1-git-send-email-nm@ti.com>
 <1408636935-29515-1-git-send-email-nm@ti.com>
 <1408636935-29515-3-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408636935-29515-3-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth,

On Thu, Aug 21, 2014 at 11:02:15AM -0500, Nishanth Menon wrote:
> +
> +	ret = input_register_device(input_dev);
> +	if (ret) {
> +		free_irq(irq, pwron);

You can not use free_irq with devm-managed resources. As I mentioned, since you
need manual unwinding, I'd rather you not use managed resources in the driver
at all.

> +		cancel_delayed_work_sync(&pwron->input_work);
> +		dev_dbg(dev, "Can't register power button: %d\n", ret);
> +		return ret;

Thanks.

-- 
Dmitry
