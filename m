Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaJRLuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 07:50:21 -0400
Received: from smtp-out-118.synserver.de ([212.40.185.118]:1053 "EHLO
	smtp-out-118.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaJRLuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 07:50:17 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3023
Message-ID: <544253F3.9060002@metafoo.de>
Date: Sat, 18 Oct 2014 13:50:11 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>, "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Sachin Kamat <sachin.kamat@linaro.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>, linux-iio@vger.kernel.org,
        svarbanov@mm-sol.com, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] iio: inkern: Add of_xlate function to struct iio_dev
References: <1412253128-32165-1-git-send-email-iivanov@mm-sol.com> <5442522D.40203@kernel.org>
In-Reply-To: <5442522D.40203@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2014 01:42 PM, Jonathan Cameron wrote:
> On 02/10/14 13:32, Ivan T. Ivanov wrote:
>> When #iio-cells is greater than '0', the driver could provide
>> a custom of_xlate function that reads the *args* and returns
>> the appropriate index in registered IIO channels array.
>>
>> Add simple translation function, suitable for the most 1:1
>> mapped channels in IIO chips, and use it when driver did not
>> provide custom implementation.
>>
>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Any more comments on this?  Been sat a while and the discussions seems
> to have died out.
>
> As Ivan has pointed out, very similar approaches are used
> elsewhere (gpio for example).

Looks good to me:

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>

When we initially added the DT support to IIO I was hoping that we can get 
away with just using the simple and generic xlate function for all devices. 
But it looks as if some more complex devices need to overwrite it. We should 
be careful about adding new driver specific xlate implementations and make 
sure that it is actually needed.

One thing we might want to consider though is instead of adding the xlate 
callback to the iio_dev struct add it to the iio_info struct since it should 
be the same for different device instances of the same driver. And this is 
also where all the other callbacks are.

- Lars
