Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952Ab3B1WFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:05:03 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56357 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab3B1WE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:04:59 -0500
Message-ID: <512FD486.6030804@suse.cz>
Date: Thu, 28 Feb 2013 23:04:54 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: stable@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>,
        Gaohuai Han <hangaohuai@huawei.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: Re: [ 47/53] dca: check against empty dca_domains list before unregister
 provider
References: <20130226235619.844721947@linuxfoundation.org> <20130226235624.751198592@linuxfoundation.org>
In-Reply-To: <20130226235624.751198592@linuxfoundation.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 12:58 AM, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Maciej Sosnowski <maciej.sosnowski@intel.com>
> 
> commit c419fcfd071cf34ba00f9f65282583772d2655e7 upstream.
> 
> When providers get blocked unregister_dca_providers() is called ending up
> with dca_providers and dca_domain lists emptied. Dca should be prevented from
> trying to unregister any provider if dca_domain list is found empty.
> 
> Reported-by: Jiang Liu <jiang.liu@huawei.com>
> Tested-by: Gaohuai Han <hangaohuai@huawei.com>
> Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
> Signed-off-by: Dan Williams <djbw@fb.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/dca/dca-core.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- a/drivers/dca/dca-core.c
> +++ b/drivers/dca/dca-core.c
> @@ -409,6 +409,11 @@ void unregister_dca_provider(struct dca_
>  
>  	spin_lock_irqsave(&dca_lock, flags);
>  
> +	if (list_empty(&dca_domains)) {
> +		raw_spin_unlock_irqrestore(&dca_lock, flags);

Hi, this is an incorrect backport. It should be spin_unlock_irqrestore
obviously...



-- 
js
suse labs
