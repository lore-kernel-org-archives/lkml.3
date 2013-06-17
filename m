Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3FQPaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:30:23 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42765 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3FQPaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:30:20 -0400
MIME-Version: 1.0
In-Reply-To: <1371094554.10688.42.camel@deadeye.wl.decadent.org.uk>
References: <1370610872-1309-1-git-send-email-lotfi.manseur@imag.fr>
	<1371094554.10688.42.camel@deadeye.wl.decadent.org.uk>
Date: Mon, 17 Jun 2013 17:30:19 +0200
X-Google-Sender-Auth: eiuCgz3OTSILyPgtREgJI3cuuzM
Message-ID: <CAAxaTiOO36zX6STUUihshZW8+=YE85T9tPryreaaB6ZpJWWQ6g@mail.gmail.com>
Subject: Re: [PATCH] USB: serial/ftdi_sio.c Fix kernel oops
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Lotfi Manseur <lotfi.manseur@gmail.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wojciech M Zabolotny <W.Zabolotny@elka.pw.edu.pl>,
        Lotfi Manseur <lotfi.manseur@imag.fr>, Willy Tarreau <w@1wt.eu>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 13, 2013 at 5:35 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Fri, 2013-06-07 at 15:14 +0200, Lotfi Manseur wrote:
>> Handle null termios in ftdi_set_termios(), introduced in
>> commit 552f6bf1bb0eda0011c0525dd587aa9e7ba5b846
>> This has been corrected in the mainline by
>> commits c515598e0f5769916c31c00392cc2bfe6af74e55 and
>> a816e3113b63753c330ca4751ea1d208e93e3015.
>>
>> This is to be fixed in longterm 2.6.32.60 and 3.4.47.
>> This bug has been found with coccinelle.
>>
>> Signed-off-by: Lotfi Manseur <lotfi.manseur@imag.fr>
>> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
>
> I've queued up those changes for 3.2.  This backported version seems
> nicer, but we generally prefer to use patches that are as close as
> possible to those in mainline.

Thank you all for your comments.
We will be more careful for upcoming reports and patches
about the stable branches, and we will privilege mainline
patches next time.

Regards.

>
> Ben.
>
>> ---
>>  drivers/usb/serial/ftdi_sio.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
>> index c374beb..615bd9e 100644
>> --- a/drivers/usb/serial/ftdi_sio.c
>> +++ b/drivers/usb/serial/ftdi_sio.c
>> @@ -2364,7 +2364,8 @@ static void ftdi_set_termios(struct tty_struct *tty,
>>
>>       cflag = termios->c_cflag;
>>
>> -     if (old_termios->c_cflag == termios->c_cflag
>> +     if (old_termios
>> +         && old_termios->c_cflag == termios->c_cflag
>>           && old_termios->c_ispeed == termios->c_ispeed
>>           && old_termios->c_ospeed == termios->c_ospeed)
>>               goto no_c_cflag_changes;
>> @@ -2373,7 +2374,8 @@ static void ftdi_set_termios(struct tty_struct *tty,
>>          ftdi_sio_read_bulk_callback  - need to examine what this means -
>>          don't see any problems yet */
>>
>> -     if ((old_termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)) ==
>> +     if (old_termios &&
>> +         (old_termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)) ==
>>           (termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)))
>>               goto no_data_parity_stop_changes;
>>
>
> --
> Ben Hutchings
> friends: People who know you well, but like you anyway.



--
Nicolas Palix
Tel: +33 4 76 51 46 27
http://membres-liglab.imag.fr/palix/
