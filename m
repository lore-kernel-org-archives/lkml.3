Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaDYE6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 00:58:15 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62622 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaDYE6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 00:58:12 -0400
Message-ID: <5359EB5E.7010800@linaro.org>
Date: Fri, 25 Apr 2014 10:28:06 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: linux-i2c@vger.kernel.org, naveenkrishna.ch@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, sjg@chromium.org,
        grundler@chromium.org, linux-kernel@vger.kernel.org, wsa@the-dreams.de,
        cpgs@samsung.com
Subject: Re: [PATCH] i2c: exynos5: Initialise Samsung High Speed I2C controller
 early
References: <1398350916-885-1-git-send-email-ch.naveen@samsung.com> <20140424162558.GB12304@sirena.org.uk>
In-Reply-To: <20140424162558.GB12304@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 09:55 PM, Mark Brown wrote:
> On Thu, Apr 24, 2014 at 08:18:36PM +0530, Naveen Krishna Chatradhi wrote:
>> This patch moves initialization code to subsys_initcall() to ensure
>> that the i2c bus is available early so the regulators can be quickly
>> probed and available for other devices on their probe() call.
> 
>> Such solution has been proposed by Mark Brown to fix the problem of
>> the regulators not beeing available on the peripheral device probe():
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2010-March/011971.html
> 
> What specifically is this needed for?  We *should* be able to use
> deferred probe for most things, but I know that not all subsystems are
> able to yet.
> 

DRM-Exynos is one such sub-system right now that doesn't handle deferred
probe well. That is one of the reasons for this patch.

-- 
Tushar Behera
