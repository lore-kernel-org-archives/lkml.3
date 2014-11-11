Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaKKCHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 21:07:53 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56807 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaKKCHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 21:07:51 -0500
Message-ID: <54616F74.5010408@codeaurora.org>
Date: Mon, 10 Nov 2014 18:07:48 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: frowand.list@gmail.com
CC: Kevin Hilman <khilman@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Tyler Baker <tyler.baker@linaro.org>
Subject: Re: [PATCH] tty: serial: msm_serial: Use DT aliases
References: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org> <CAMAWPa_f1K1qUG_UTmM0w8Sz8wed7+CQkK9tc8t1W=CTJvdjyw@mail.gmail.com> <5461150B.2010907@codeaurora.org> <54616CB3.5000405@gmail.com>
In-Reply-To: <54616CB3.5000405@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 05:56 PM, Frank Rowand wrote:
> On 11/10/2014 11:42 AM, Stephen Boyd wrote:
>> diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
>> index 09364dd8cf3a..d1bc6b6cbc70 100644
>> --- a/drivers/tty/serial/msm_serial.c
>> +++ b/drivers/tty/serial/msm_serial.c
>> @@ -1046,14 +1046,14 @@ static int msm_serial_probe(struct platform_device *pdev)
>>  	const struct of_device_id *id;
>>  	int irq, line;
>>  
>> -	if (pdev->id == -1)
>> -		pdev->id = atomic_inc_return(&msm_uart_next_id) - 1;
>> -
>>  	if (pdev->dev.of_node)
>>  		line = of_alias_get_id(pdev->dev.of_node, "serial");
>>  	else
>>  		line = pdev->id;
>>  
>> +	if (line < 0)
>> +		line = atomic_inc_return(&msm_uart_next_id) - 1;
>> +
>>  	if (unlikely(line < 0 || line >= UART_NR))
> Then this original check for "line < 0" can also be removed.
>
>

Well this matches what was there before. It would do atomic_inc_return
if the line was negative and then still check for a negative value. I
don't mind removing it though. Perhaps we should use an ida?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

