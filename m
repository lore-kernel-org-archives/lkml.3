Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab3BOXOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 18:14:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3BOXOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 18:14:32 -0500
Date: Fri, 15 Feb 2013 15:14:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: max77686: add missing variable initialization
Message-Id: <20130215151430.0cf4bfb2.akpm@linux-foundation.org>
In-Reply-To: <003601ce0b50$726cb860$57462920$%han@samsung.com>
References: <003601ce0b50$726cb860$57462920$%han@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013 16:45:38 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> Fixed build warning as below:
> 
> drivers/rtc/rtc-max77686.c: In function 'max77686_rtc_update':
> drivers/rtc/rtc-max77686.c:147:6: warning: 'data' may be used uninitialized in this function [-Wuninitialized]
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/rtc/rtc-max77686.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
> index abe27c0..2634fed 100644
> --- a/drivers/rtc/rtc-max77686.c
> +++ b/drivers/rtc/rtc-max77686.c
> @@ -133,7 +133,7 @@ static int max77686_rtc_update(struct max77686_rtc_info *info,
>  	enum MAX77686_RTC_OP op)
>  {
>  	int ret;
> -	unsigned int data;
> +	unsigned int data = 0;
>  
>  	switch (op) {
>  	case MAX77686_RTC_WRITE:

spose so.  But the end result is rather awkward-looking.

As `op' must be (and is) one of MAX77686_RTC_WRITE and
MAX77686_RTC_READ, the straightfoward implementation is


static int max77686_rtc_update(struct max77686_rtc_info *info,
	enum MAX77686_RTC_OP op)
{
	int ret;
	unsigned int data;

	if (op == MAX77686_RTC_WRITE)
		data = 1 << RTC_UDR_SHIFT;
	else
		data = 1 << RTC_RBUDR_SHIFT;


