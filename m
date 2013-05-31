Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3EaM6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:58:44 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:36178 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3EaM63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:58:29 -0400
Message-ID: <51A89E70.3010703@acm.org>
Date: Fri, 31 May 2013 07:58:24 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] ipmi: info leak in compat_ipmi_ioctl()
References: <20130531124658.GU23987@mwanda>
In-Reply-To: <20130531124658.GU23987@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 07:46 AM, Dan Carpenter wrote:
> On x86_64 there is a 4 byte hole between ->recv_type and ->addr.

Got it, in my tree now.  Thanks.

>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: fixed the changelog a little.  Also added LKML because the
> openipmi is a moderated list (and the moderator thought my email was
> spam).

I apologize, the list gets a lot of spam, and I must have made a mistake.

-corey

>
> diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
> index 9eb360f..8e306ac 100644
> --- a/drivers/char/ipmi/ipmi_devintf.c
> +++ b/drivers/char/ipmi/ipmi_devintf.c
> @@ -810,6 +810,7 @@ static long compat_ipmi_ioctl(struct file *filep, unsigned int cmd,
>   		struct ipmi_recv   __user *precv64;
>   		struct ipmi_recv   recv64;
>   
> +		memset(&recv64, 0, sizeof(recv64));
>   		if (get_compat_ipmi_recv(&recv64, compat_ptr(arg)))
>   			return -EFAULT;
>   

