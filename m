Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965990Ab3HHRdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:33:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54798 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab3HHRdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:33:17 -0400
Message-ID: <5203D659.4050907@wwwdotorg.org>
Date: Thu, 08 Aug 2013 11:33:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Wei Ni <wni@nvidia.com>, "khali@linux-fr.org" <khali@linux-fr.org>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) Add power control
References: <1375944991-29182-1-git-send-email-wni@nvidia.com> <1375944991-29182-2-git-send-email-wni@nvidia.com> <520359E9.1000600@roeck-us.net> <52036920.4050808@nvidia.com> <52037F9A.7070802@roeck-us.net>
In-Reply-To: <52037F9A.7070802@roeck-us.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 05:23 AM, Guenter Roeck wrote:
> On 08/08/2013 02:47 AM, Wei Ni wrote:
...
>> I think get_regulator() will return error values, not only
>> -EPROBE_DEFER, so we should set data->lm90_reg to NULL to handle other
>> error values.
>>
> Matter of opinion if you want to check for IS_ERR or NULL later on.

No, if regulator returns either:

* Something valid
* Someting IS_ERR()

... then everywhere has to check the value using IS_ERR().

If regulator returns either:

* Something valid
* Someting NULL

... then everywhere has to check the value against NULL.

checking against both IS_ERR() and NULL shouldn't ever happen, and
likewise IS_ERR_OR_NULL() is deprecated.
