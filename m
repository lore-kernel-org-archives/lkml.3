Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147AbaGXSFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:05:23 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45430 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154AbaGXSFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:05:21 -0400
Date: Thu, 24 Jul 2014 11:05:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Duson Lin <dusonlin@emc.com.tw>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        bleung@chromium.org, agnescheng@chromium.org, phoenix@emc.com.tw,
        jeff.chuang@emc.com.tw
Subject: Re: [PATCH v2] Input: add i2c/smbus driver for elan touchpad
Message-ID: <20140724180516.GA26752@core.coreip.homeip.net>
References: <1389064083-11018-1-git-send-email-dusonlin@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389064083-11018-1-git-send-email-dusonlin@emc.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 07, 2014 at 11:08:03AM +0800, Duson Lin wrote:
> +/*
> + ******************************************************************
> + * General functions
> + ******************************************************************
> + */
> +/*
> + * (value from firmware) * 10 + 790 = dpi
> + * we also have to convert dpi to dots/mm (*10/254 to avoid floating point)
> + */
> +static unsigned int elan_convert_res(char val)
> +{
> +	int res;
> +	if (val & 0x80) {
> +		val = ~val + 1;
> +		res = (790 - val * 10) * 10 / 254;
> +	} else
> +		res = (val * 10 + 790) * 10 / 254;
> +	return res;
> +}

Why isn't this simply:

	res = ((int)val * 10 + 790) * 10 / 254;

?

If high bit is 1 you basically do the 2 complement by hand to get to
positive and then subtract. Which shoudl be the same as adding positive
value.

Thanks.

-- 
Dmitry
