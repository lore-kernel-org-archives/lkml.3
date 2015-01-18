Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbbARIbi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 03:31:38 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38728 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbARIbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 03:31:35 -0500
Date: Sun, 18 Jan 2015 00:31:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dudley Du <dudl@cypress.com>
Cc: jmmahler@gmail.com, rydberg@euromail.se, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 04/12] input: cyapa: add runtime power management
 interfaces support for the device
Message-ID: <20150118083131.GE15720@dtor-ws>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
 <1421390055-32760-5-git-send-email-dudl@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421390055-32760-5-git-send-email-dudl@cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dudley,

On Fri, Jan 16, 2015 at 02:34:07PM +0800, Dudley Du wrote:
  
> +#ifdef CONFIG_PM_RUNTIME
> +static ssize_t cyapa_show_rt_suspend_scanrate(struct device *dev,
> +					      struct device_attribute *attr,
> +					      char *buf)

The runtime PM was switched to just CONFIG_PM in mainline and
CONFIG_PM_RUNTIME was dropped. I adjusted the patch accordingly.

...

> -static SIMPLE_DEV_PM_OPS(cyapa_pm_ops, cyapa_suspend, cyapa_resume);
> +#ifdef CONFIG_PM_RUNTIME
> +static int cyapa_runtime_suspend(struct device *dev)

I switched both cyapa_runtme_suspend and resume to __maybe_unused and
dropped #ifdef guards.

Thanks.

-- 
Dmitry
