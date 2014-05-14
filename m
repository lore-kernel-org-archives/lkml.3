Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaENSOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:14:09 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41057 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaENSOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:14:06 -0400
Date: Wed, 14 May 2014 11:14:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Michal =?iso-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        elias.vds@gmail.com, anssi.hannula@iki.fi, simon@mungewell.org
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
Message-ID: <20140514181402.GF30089@core.coreip.homeip.net>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
 <1398524543-15012-2-git-send-email-madcatxster@devoid-pointer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398524543-15012-2-git-send-email-madcatxster@devoid-pointer.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 05:02:00PM +0200, Michal Malý wrote:
> +
> +/** input_ff_create_mlnx() - Register a device within ff-memless-next and
> + *                           the kernel force feedback system
> + * @dev: Pointer to the struct input_dev associated with the device.
> + * @data: Any device-specific data that shall be passed to the callback.
> + *        function called by ff-memless-next when a force feedback action
> + *        shall be performed.
> + * @control_effect: Pointer to the callback function.
> + * @update_date: Delay in milliseconds between two recalculations of periodic
> + *               effects, ramp effects and envelopes. Note that this value will
> + *               never be lower than (CONFIG_HZ / 1000) + 1 regardless of the
> + *               value specified here. This is not a "hard" rate limiter.
> + *               Userspace still can submit effects at a rate faster than
> + *               this value.

The update rate change seems useful whether we use new ff implementation
or enhance the old one but I would prefer having a separate call to
control it.

Thanks.

-- 
Dmitry
