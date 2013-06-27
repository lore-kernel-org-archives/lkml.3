Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3F0UKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:10:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28439 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab3F0UKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:10:42 -0400
Message-ID: <51CC9C35.6090901@oracle.com>
Date: Thu, 27 Jun 2013 16:10:29 -0400
From: konrad wilk <konrad.wilk@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, stefano.stabellini@citrix.com,
        xen-devel@lists.xen.org
Subject: Re: [PATCH] xen: ifdef CONFIG_HIBERNATE_CALLBACKS xen_*_suspend
References: <1372339718-12102-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1372339718-12102-1-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/27/2013 9:28 AM, Stefano Stabellini wrote:
> xen_hvm_post_suspend, xen_pre_suspend, xen_post_suspend are only used if
> CONFIG_HIBERNATE_CALLBACKS is defined, resulting in:
>
> drivers/xen/manage.c:46:13: warning: ‘xen_hvm_post_suspend’ defined but not used [-Wunused-function]
> drivers/xen/manage.c:52:13: warning: ‘xen_pre_suspend’ defined but not used [-Wunused-function]
> drivers/xen/manage.c:59:13: warning: ‘xen_post_suspend’ defined but not used [-Wunused-function]
>
> If the kernel config is missing CONFIG_HIBERNATE_CALLBACKS.
>
> Simply ifdef CONFIG_HIBERNATE_CALLBACKS the three functions.
>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>   drivers/xen/manage.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index 412b96c..b1005d4 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -43,6 +43,7 @@ struct suspend_info {
>   	void (*post)(int cancelled);
>   };
>   
> +#ifdef CONFIG_HIBERNATE_CALLBACKS
>   static void xen_hvm_post_suspend(int cancelled)
>   {
>   	xen_arch_hvm_post_suspend(cancelled);
> @@ -63,7 +64,6 @@ static void xen_post_suspend(int cancelled)
>   	xen_mm_unpin_all();
>   }
>   
> -#ifdef CONFIG_HIBERNATE_CALLBACKS
>   static int xen_suspend(void *data)
>   {
>   	struct suspend_info *si = data;
Looks ok. Will queue it up for 3.11

