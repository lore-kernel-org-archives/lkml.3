Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3AOTgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:36:14 -0500
Received: from mail.active-venture.com ([67.228.131.205]:55469 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab3AOTgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:36:13 -0500
X-Originating-IP: 108.223.40.66
Date: Tue, 15 Jan 2013 11:36:11 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: Re: [PATCH v2] hwmon: (sht15) check GPIO directions
Message-ID: <20130115193611.GA22507@roeck-us.net>
References: <1358274786-30521-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358274786-30521-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 01:33:06PM -0500, Vivien Didelot wrote:
> Without this patch, the SHT15 driver may fail silently with a
> non-bidirectional data line and/or an input-only clock line.
> 
> This patch checks the return value of gpio_direction_* function calls
> and returns the error code (if any) to the caller. If an error occurs in
> the read work function (work_funct_t), we wake the queue up directly
> without updating the data->state flag, to notice the waiter of the I/O
> error.
> 
> The patch also makes minor cleanups: s/error_ret/unlock for some labels
> and uses devm_gpio_request_one() for the clock line.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Applied to -next.

Thanks,
Guenter
