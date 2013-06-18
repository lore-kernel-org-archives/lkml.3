Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3FRPjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:39:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58388 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3FRPjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:39:37 -0400
Message-ID: <51C07F35.8070805@wwwdotorg.org>
Date: Tue, 18 Jun 2013 09:39:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 1/2] mfd: tps65910: Fix crash in i2c_driver .probe
References: <1371550481-28126-1-git-send-email-ttynkkynen@nvidia.com> <1371550481-28126-2-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1371550481-28126-2-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 04:14 AM, Tuomas Tynkkynen wrote:
> Commit "i2c: core: make it possible to match a pure device tree driver"
> changed semantics of the i2c probing for device tree devices.
> Device tree probed devices now get a NULL i2c_device_id pointer.
> This caused kernel panics due to NULL dereference.
> 
> Moves the of_match_device call from tps65910_parse_dt to .probe to
> allow the chip type to be detected from device tree but with the
> device parameters coming from platform data.

Reviewed-by: Stephen Warren <swaren@nvidia.com>

It's a pity that every driver that supports DT is going to need this
boiler-plate though. Perhaps the I2C core can acquire a follow-on patch
that does this for drivers in the future.
