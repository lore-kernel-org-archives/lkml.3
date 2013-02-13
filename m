Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967Ab3BMVmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:42:21 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:33220 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab3BMVmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:42:19 -0500
Date: Wed, 13 Feb 2013 13:42:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Henrik Rydberg <rydberg@euromail.se>, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org
Subject: Re: [PATCH 02/10] Input: atmel_mxt_ts - register input device before
 request_irq
Message-ID: <20130213214214.GB23390@core.coreip.homeip.net>
References: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
 <1359706312-24642-3-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359706312-24642-3-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Fri, Feb 01, 2013 at 04:11:44PM +0800, Daniel Kurtz wrote:
> As soon as the irq is request, input event interrupts could occur that
> the isr should handle.  Similarly, if there are input events queued up
> in the device output buffer, it will send them immediately when we
> drain the message buffer with mxt_handle_messages.
> 
> Therefore, register the input device before enabling the irq (or handling
> messages).

I do not see the point. The allocated device can withstand
input_events() calls even without being registered and I am not sure why
anyone would be particularly interested in events that happened before
or during device registration, espceially for a touchscreen device.

Thanks.

-- 
Dmitry
