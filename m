Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbbAGK0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:26:40 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:36394 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbAGK0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:26:37 -0500
Date: Wed, 7 Jan 2015 11:26:37 +0100
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: linus.walleij@linaro.org, lee.jones@linaro.org, johan@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mfd: dln2: add suspend/resume functionality
Message-ID: <20150107102637.GD22905@localhost>
References: <1418745435-2851-1-git-send-email-octavian.purdila@intel.com>
 <1418745435-2851-5-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418745435-2851-5-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 05:57:15PM +0200, Octavian Purdila wrote:
> Without suspend/resume functionality in the USB driver the USB core
> will disconnect and reconnect the DLN2 port and because the GPIO
> framework does not yet support removal of an in-use controller a
> suspend/resume operation will result in a crash.
> 
> This patch provides suspend and resume functions for the DLN2 driver
> so that the above scenario is avoided.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

This patch looks good now, but how did you say this device was powered?

If powered by vbus you cannot assume that the device maintains it's
state over a suspend cycle, something which would complicate matters
quite a bit...

Thanks,
Johan
