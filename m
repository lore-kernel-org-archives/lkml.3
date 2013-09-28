Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab3I1FQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 01:16:27 -0400
Received: from mail.ispras.ru ([83.149.199.45]:40980 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3I1FQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 01:16:25 -0400
Message-ID: <52466624.4040106@ispras.ru>
Date: Sat, 28 Sep 2013 01:16:20 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] carl9170: fix leaks at failure path in carl9170_usb_probe()
References: <1380340311-4630-1-git-send-email-khoroshilov@ispras.ru> <CAOMZO5DE0OdXhWNEr2HAswvgryBqP8VNk3+vanwsi38L6pL9OA@mail.gmail.com>
In-Reply-To: <CAOMZO5DE0OdXhWNEr2HAswvgryBqP8VNk3+vanwsi38L6pL9OA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.09.2013 00:17, Fabio Estevam wrote:
> On Sat, Sep 28, 2013 at 12:51 AM, Alexey Khoroshilov
> <khoroshilov@ispras.ru> wrote:
>
>> -       return request_firmware_nowait(THIS_MODULE, 1, CARL9170FW_NAME,
>> +       err = request_firmware_nowait(THIS_MODULE, 1, CARL9170FW_NAME,
>>                  &ar->udev->dev, GFP_KERNEL, ar, carl9170_usb_firmware_step2);
>> +       if (err) {
>> +               usb_put_dev(udev);
>> +               usb_put_dev(udev);
> You are doing the same free twice.
Yes, because it was get twice.
> I guess you meant to also free: usb_put_dev(ar->udev)
udev and ar->udev are equal, so technically the patch is correct.

I agree that there is some inconsistency, but I would prefer to fix it 
at usb_get_dev() side with a comment about reasons for the double get.

--
Alexey

