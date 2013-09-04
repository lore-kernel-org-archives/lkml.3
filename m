Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935388Ab3IDQeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:34:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40399 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799Ab3IDQeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:34:03 -0400
Message-ID: <522760C9.8040201@ti.com>
Date: Wed, 4 Sep 2013 11:33:13 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>, <gg@slimlogic.co.uk>,
        <yong.shen@linaro.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        <marek.vasut@gmail.com>, <Nancy.Chen@freescale.com>
Subject: Re: [PATCH 7/7] regulator: ti-abb: Use devm_regulator_register
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org> <1378276263-10735-7-git-send-email-sachin.kamat@linaro.org> <5227355C.1020205@ti.com> <CAK9yfHxyyZ8WGL8Q4cJ7Y=LcJ2dkeZamXydnMYS4uOj-cmU_Dg@mail.gmail.com>
In-Reply-To: <CAK9yfHxyyZ8WGL8Q4cJ7Y=LcJ2dkeZamXydnMYS4uOj-cmU_Dg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 11:26 AM, Sachin Kamat wrote:
> Hi  Nishanth,
> 
> On 4 September 2013 18:57, Nishanth Menon <nm@ti.com> wrote:
>> On 09/04/2013 01:31 AM, Sachin Kamat wrote:
>>> -err:
>>> -     dev_err(dev, "%s: Failed to initialize(%d)\n", __func__, ret);
>>> -     return ret;
>> here -> with this, the lazy non detailed prints end with a generic
>> fail case.
> 
> Generally when a driver is converted to use devm_* APIs, the error
> handling code gets
> refactored and simplified as several unwinding calls get removed. The
> above print was similarly removed as part
> of the cleanup and refactoring as it did not add any extra value.
> Probe failure is reported even without this error
> message.
> 

the cleanups here do not have anything to do with devm optimization.
in fact, if we stick with what we have stated to do in this patch,
-	rdev = regulator_register(desc, &config);
+	rdev = devm_regulator_register(dev, desc, &config);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
 		dev_err(dev, "%s: failed to register regulator(%d)\n",
 			__func__, ret);
-		goto err;
+		return ret;
 	}

is all we got to do in the probe path.

I accept that probe failure gives me the required info for fail, and
the cleanup of log prints also make sense, just that the log refactor
seems out of context to the specific change.

-- 
Regards,
Nishanth Menon
