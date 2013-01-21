Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3AUX5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:57:23 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:32990 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3AUX5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:57:21 -0500
Date: Mon, 21 Jan 2013 15:57:18 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        NeilBrown <neilb@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [RFC PATCH] Input: gpio_keys: Fix suspend/resume press event lost
Message-ID: <20130121235718.GB16638@core.coreip.homeip.net>
References: <1358774114-8281-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358774114-8281-1-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,

On Mon, Jan 21, 2013 at 03:15:14PM +0200, Ivan Khoronzhuk wrote:
> Rebased on linux_omap/master.
> 
> During suspend/resume the key press can be lost if time of resume
> sequence is significant.
> 
> If press event cannot be remembered then the driver can read the
> current button state only in time of interrupt handling. But in some
> cases when time between IRQ and IRQ handler is significant we can
> read incorrect state. As a particular case, when device is in suspend
> we press wakupable key and up it back in a jiffy, the interrupt
> handler read the state of up but the interrupt source is press indeed.
> As a result, in a OS like android, we resume then suspend right away
> because the key state is not changed.
> 
> This patch add to gpio_keys framework opportunity to recover lost of
> press key event at resuming. The variable "key_pressed" from
> gpio_button_data structure is not used for gpio keys, it is only used
> for gpio irq keys, so it is logically used to remember press lost
> while resuming.

The same could happen if you delay processing of interrupt long enough
during normal operation. If key is released by the time you get around
to reading it you will not see a key press.

To me this sounds like you need to speed up your resume process so that
you can start serving interrupts quicker.

Thanks.

-- 
Dmitry
