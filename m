Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161552Ab3DGD12 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 23:27:28 -0400
Received: from intranet.asianux.com ([58.214.24.6]:63129 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161347Ab3DGD11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 23:27:27 -0400
X-Spam-Score: -100.8
Message-ID: <5160E782.4050400@asianux.com>
Date: Sun, 07 Apr 2013 11:26:58 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Drivers: Misc: fix warnings, unsigned long will never
 < 0
References: <5160E37C.3020007@asianux.com>
In-Reply-To: <5160E37C.3020007@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  also has another 'unsigned long val' warnings, I will send patch v2 to
merge them together.


On 2013年04月07日 11:09, Chen Gang wrote:
> 
>   val is unsigned long which never < 0
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/misc/tsl2550.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/tsl2550.c b/drivers/misc/tsl2550.c
> index 1e7bc0e..558dd20 100644
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
> 


-- 
Chen Gang

Asianux Corporation
