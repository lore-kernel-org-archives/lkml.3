Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3EHCZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:25:38 -0400
Received: from intranet.asianux.com ([58.214.24.6]:52945 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3EHCZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:25:37 -0400
X-Spam-Score: -100.8
Message-ID: <5189B76C.9050606@asianux.com>
Date: Wed, 08 May 2013 10:24:44 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Drivers: Misc: fix warnings, unsigned long will never
 < 0
References: <5160E37C.3020007@asianux.com> <5160E7EA.3050406@asianux.com>
In-Reply-To: <5160E7EA.3050406@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Please help check, when you have time.

Thanks.

On 2013年04月07日 11:28, Chen Gang wrote:
> 
>   val is unsigned long which never < 0
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/misc/tsl2550.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/tsl2550.c b/drivers/misc/tsl2550.c
> index 1e7bc0e..5bf9448 100644
> --- a/drivers/misc/tsl2550.c
> +++ b/drivers/misc/tsl2550.c
> @@ -204,7 +204,7 @@ static ssize_t tsl2550_store_power_state(struct device *dev,
>  	unsigned long val = simple_strtoul(buf, NULL, 10);
>  	int ret;
>  
> -	if (val < 0 || val > 1)
> +	if (val > 1)
>  		return -EINVAL;
>  
>  	mutex_lock(&data->update_lock);
> @@ -236,7 +236,7 @@ static ssize_t tsl2550_store_operating_mode(struct device *dev,
>  	unsigned long val = simple_strtoul(buf, NULL, 10);
>  	int ret;
>  
> -	if (val < 0 || val > 1)
> +	if (val > 1)
>  		return -EINVAL;
>  
>  	if (data->power_state == 0)
> 


-- 
Chen Gang

Asianux Corporation
