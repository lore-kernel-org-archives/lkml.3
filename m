Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab3IQLHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:07:43 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56606 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3IQLHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:07:41 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-f9-523837facdd3
Message-id: <523837F9.1020204@samsung.com>
Date: Tue, 17 Sep 2013 13:07:37 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Kevin Hilman <khilman@linaro.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client
 devices
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org> <20130913065434.GZ7393@intel.com>
 <52332BF0.4060605@samsung.com> <20130913154013.GD7393@intel.com>
 <5235BA9C.1090509@gmail.com> <20130916084708.GN7393@intel.com>
In-reply-to: <20130916084708.GN7393@intel.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t/xq7q/zS2CDFaZWWzq+81m8XfSMXaL
	qQ+fsFkcXvSC0aJ58Xo2i6+HVzBanG16w25x/+tRRotvVzqYLJbv62e02PT4GqtFx98vjBaX
	d81hs/i4dAOrxcV18hZTth9ht3i84i27xeluVot5n3cyWaw8MYvZQcTj969JjB47Z91l91i8
	5yWTx6ZVnWwed67tYfOYdzLQY//cNewem5fUe/RtWcXocfLUExaPz5vkArijuGxSUnMyy1KL
	9O0SuDKu7akseMxRcayngaWBsYG9i5GTQ0LARGLVm7lQtpjEhXvr2boYuTiEBJYySvTd6GQF
	SQgJfGKUmDrfFcTmFdCSWHpjByOIzSKgKtH7pAmsmU3AUKL3aB9YXFQgQGLxknPsEPWCEj8m
	32MBsUUETCXevpjNBLKAWeA+q8T3k0/BFggLhEgsf9bFDLH5OpPEzN2dzCAJTgE9iS2T9jGB
	2MwCOhL7W6exQdjyEpvXvGWewCgwC8mSWUjKZiEpW8DIvIpRNLU0uaA4KT3XSK84Mbe4NC9d
	Lzk/dxMjJDa/7mBceszqEKMAB6MSD+8PZfMgIdbEsuLK3EOMEhzMSiK8oSwWQUK8KYmVValF
	+fFFpTmpxYcYmTg4pRoYg37fTzNcdHfFsdS3ElUiKtUq1v+fMSeXH1ourhTXuLLUZOvZmJ0r
	ThVt6N2/KnxVqoqXR1L9npvuR32tChlPJqfLKiZxr3KcU6V99mOKeXe9EAML8/30Zrugz4nf
	WU2DVpSlrz14+UgXU3AM61KhgrWB/EdcL1/TXXAt3utRTtyc+Tnpd9YpsRRnJBpqMRcVJwIA
	1ntcRKsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 10:47 AM, Mika Westerberg wrote:
> I'm actually thinking that it is probably better now if we don't touch the
> client runtime PM at all in the I2C core.
> 
> I proposed a less intrusive solution in this same thread where we power the
> I2C controller briefly at the client ->probe() (In order to have all the
> ACPI power resources etc. and the controller on) and let the client driver
> handle their own runtime PM as they do currently.
> 
> Do you think that would work better wrt. fimc-isp-i2c driver?

That would be no different for this particular driver, as long as the 
I2C bus controller is activated right before the I2C client's probe().
 
In general I would expect such additional device activation not to be 
harmful. For that particular driver I'm going to prepare patches to 
ensure that the I2C bus controller device and its driver is registered 
only when a driver it depends on has initialized. This should have been 
ensured right from the beginning. So don't need to worry about this 
particular case. I'm just not sure what other devices could be similarly
affected.
