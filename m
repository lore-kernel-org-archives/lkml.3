Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbaALPdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 10:33:55 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:44954 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaALPdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 10:33:51 -0500
MIME-Version: 1.0
In-Reply-To: <1389536074-17145-1-git-send-email-cyborg101010@gmail.com>
References: <1389536074-17145-1-git-send-email-cyborg101010@gmail.com>
Date: Sun, 12 Jan 2014 16:33:51 +0100
X-Google-Sender-Auth: K47nwe4ERR8W2PO9Y05qDFI0Dbk
Message-ID: <CAAsK9AEQiAZ+X83x9cnoxKTnsFZvZdg8CQNzd=+UQO_4AZTABQ@mail.gmail.com>
Subject: Re: [PATCH] AlarmDev: Changing is_wakeup() to be a function to pass checkpatch
From: Levente Kurusa <levex@linux.com>
To: Joe <cyborg101010@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, john.stultz@linaro.org,
        dan.carpenter@oracle.com, cruzjbishop@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2014/1/12 Joe <cyborg101010@gmail.com>:
> ---
>  drivers/staging/android/alarm-dev.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

You are missing a commit message. Your subject as well looks a bit weird.

>
> diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
> index 647694f..87f2a02 100644
> --- a/drivers/staging/android/alarm-dev.c
> +++ b/drivers/staging/android/alarm-dev.c
> @@ -66,13 +66,15 @@ static struct devalarm alarms[ANDROID_ALARM_TYPE_COUNT];
>   *
>   * Return: 1 if this is a wakeup alarm, otherwise 0
>   */
> -static int is_wakeup(enum android_alarm_type type)
> +static int is_wakeup(enum andriod_alarm_type type)

What is this? andriod? Did it compile?

>  {
> -       return (type == ANDROID_ALARM_RTC_WAKEUP ||
> -               type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP);
> +       if (type == ANDROID_ALARM_RTC_WAKEUP ||
> +           type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP)
> +               return 1;
> +       else
> +               return 0;

While this is correct, the better fix would be to remove the parentheses..

Also, I think a similar patch was already applied, not sure though.

> [...]

--
Regards,
Levente Kurusa
