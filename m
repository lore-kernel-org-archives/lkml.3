Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3CRN7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:59:31 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:59598 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3CRN7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:59:30 -0400
Message-ID: <51471DBE.1030209@acm.org>
Date: Mon, 18 Mar 2013 08:59:26 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: char: ipmi: Replaced kmalloc and strcpy with
 kstrdup
References: <1363443413-21937-1-git-send-email-gheorghiuandru@gmail.com>
In-Reply-To: <1363443413-21937-1-git-send-email-gheorghiuandru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2013 09:16 AM, Alexandru Gheorghiu wrote:
> Replaced calls to kmalloc followed by strcpy with a sincle call to kstrdup.
> Patch found using coccinelle.
>
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>   drivers/char/ipmi/ipmi_msghandler.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
> index 053201b..617b443 100644
> --- a/drivers/char/ipmi/ipmi_msghandler.c
> +++ b/drivers/char/ipmi/ipmi_msghandler.c
> @@ -2037,12 +2037,11 @@ int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
>   	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
>   	if (!entry)
>   		return -ENOMEM;
> -	entry->name = kmalloc(strlen(name)+1, GFP_KERNEL);
> +	entry->name = kstrdup(name, GFP_KERNEL);
>   	if (!entry->name) {
>   		kfree(entry);
>   		return -ENOMEM;
>   	}
> -	strcpy(entry->name, name);
>   
>   	file = proc_create_data(name, 0, smi->proc_dir, proc_ops, data);
>   	if (!file) {
Actually, I should say that I've pulled this into my tree.

Thanks,

-corey
