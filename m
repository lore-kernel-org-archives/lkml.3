Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbbAVDij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:38:39 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55304 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbbAVDi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:38:28 -0500
Message-ID: <54C070B8.2040301@gmail.com>
Date: Thu, 22 Jan 2015 11:38:32 +0800
From: Peter Hung <hpeter@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: johan@kernel.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom_tsai@fintek.com.tw,
        peter_hong@fintek.com.tw, Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: Re: [PATCH v2 3/4] usb: serial: implement function for F81232
References: <1421836214-25582-1-git-send-email-hpeter+linux_kernel@gmail.com> <20150121144136.31f328cf@lxorguk.ukuu.org.uk>
In-Reply-To: <20150121144136.31f328cf@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'll do it later depend on this series patchs to be accpeted or rejected.

Thanks for your advice

One Thousand Gnomes 於 2015/1/21 下午 10:41 寫道:
>
>> +	if (cflag & PARENB) {
>> +		if (cflag & PARODD)
>> +			new_lcr |= UART_LCR_PARITY; /* odd */
>> +		else
>> +			new_lcr |= SERIAL_EVEN_PARITY; /* even */
>> +	}
>
> If you don't support mark/space also clear CMSPAR in the passed termios
>
>> -	if (old_termios)
>> -		tty_termios_copy_hw(&tty->termios, old_termios);
>
> Also when you set the baud rate compute the resulting actual baud rate
> you generated and set it with
>
> 	/* Don't rewrite B0 */
> 	if (tty_termios_baud_rate(termios))
> 		tty_termios_encode_baud_rate(termios, baud, baud);
>
> so that the application gets told the baud rate it actually got if it
> isn't close to the one they requested.
>
> Alan
>
