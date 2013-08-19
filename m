Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab3HSNCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 09:02:05 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:38613 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3HSNCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 09:02:03 -0400
Message-ID: <521216E0.8000701@linaro.org>
Date: Mon, 19 Aug 2013 21:00:16 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Hanjun Guo <hanjun.guo@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] drivers / base: Fix sysfs_deprecated_setup() __init
 attribute location
References: <1376743346-9465-1-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1376743346-9465-1-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I sent [PATCH 3/3] twice because of my bad email client,
sorry for the noise, please ignore the duplicated [PATCH 3/3].

Thanks
Hanjun

On 2013-8-17 20:42, Hanjun Guo wrote:
> __init belongs after the return type on functions, not before it.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  drivers/base/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 8856d74..b9ccc5d 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -36,7 +36,7 @@ long sysfs_deprecated = 1;
>  #else
>  long sysfs_deprecated = 0;
>  #endif
> -static __init int sysfs_deprecated_setup(char *arg)
> +static int __init sysfs_deprecated_setup(char *arg)
>  {
>  	return strict_strtol(arg, 10, &sysfs_deprecated);
>  }
> 

