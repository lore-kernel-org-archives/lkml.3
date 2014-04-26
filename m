Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaDZMvu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 08:51:50 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55691 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaDZMvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 08:51:47 -0400
Message-ID: <535BAC3A.1010202@kernel.org>
Date: Sat, 26 Apr 2014 13:53:14 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, "cpgs ." <cpgs@samsung.com>,
        Grant Grundler <grundler@chromium.org>
Subject: Re: [PATCH 1/5] iio: exynos_adc: use indio_dev->dev structure to
 handle child nodes
References: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>	<1398420888-5506-2-git-send-email-ch.naveen@samsung.com> <CAD=FV=V28_iDiNWeX6bXLzMW5kWygJz-YAExJkETJKgTDicHQg@mail.gmail.com>
In-Reply-To: <CAD=FV=V28_iDiNWeX6bXLzMW5kWygJz-YAExJkETJKgTDicHQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/14 16:46, Doug Anderson wrote:
> Naveen,
>
> Thanks for sending this.  Given that Jonathan Cameron was involved in
> the previous discussion, it probably would have been wise to include
> him on the CC list.
In my case, don't worry too much as I have linux-iio coming into exactly
the same place in my inbox. Doug is correct that it is generally a good
idea unless someone has asked you not to.
>
> On Fri, Apr 25, 2014 at 3:14 AM, Naveen Krishna Chatradhi
> <ch.naveen@samsung.com> wrote:
>> From: Naveen Krishna Ch <ch.naveen@samsung.com>
>>
>> Using pdev->dev with device_for_each_child() would iterate over all
>> of the children of the platform device and delete them.
>> Thus, causing crashes during module unload.
>>
>> We should be using the indio_dev->dev structure for
>> registering/unregistering child nodes.
>>
>> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
>> ---
>> This change was tested on top of
>>     https://lkml.org/lkml/2014/4/21/481 from Doug.
>>
>>   drivers/iio/adc/exynos_adc.c |    6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> Reported-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>
Applied to the fixes-togreg branch of iio.git

Thanks,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

