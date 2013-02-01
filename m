Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab3BAVgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 16:36:41 -0500
Received: from mail.active-venture.com ([67.228.131.205]:62649 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227Ab3BAVgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 16:36:39 -0500
X-Originating-IP: 108.223.40.66
Date: Fri, 1 Feb 2013 13:36:40 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Vincent Palatin <vpalatin@chromium.org>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Olof Johansson <olofj@chromium.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] hwmon: (lm90) Add device tree support
Message-ID: <20130201213640.GA1606@roeck-us.net>
References: <1359753502-13240-1-git-send-email-vpalatin@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359753502-13240-1-git-send-email-vpalatin@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 01:18:22PM -0800, Vincent Palatin wrote:
> Add support to instantiate LM90-compatible sensors from a device-tree
> configuration.
> When the kernel has device tree support, we avoid doing the auto-detection
> as probing the busses might mess-up sensitive I2C devices or trigger long
> timeouts on non-functional busses.
> 
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>

Hi Vincent,

OF support for I2C devices should already work through the I2C subsystem,
without explicit driver patch.

As for the detect function, I am not entirely sure if we want or should get
rid of it just because OF is configured. That may have unintended side effects.
Either case, I would argue that if we do want to do that, it should be done
for _all_ I2C devices and not just for the lm90 driver. In other words, it
should be done in the I2C subsystem, maybe with a separate configuration option.

Thanks,
Guenter
