Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3CLHWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 03:22:55 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:49469 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3CLHWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 03:22:53 -0400
Date: Tue, 12 Mar 2013 08:22:48 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux390@de.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/18] driver: s390: block: remove cast for kzalloc
 return value
Message-ID: <20130312072248.GC4148@osiris>
References: <513EB23D.7020303@cn.fujitsu.com>
 <513EBAB7.1030606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513EBAB7.1030606@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031207-2966-0000-0000-000006F5BFA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 01:18:47PM +0800, Zhang Yanfei wrote:
> remove cast for kzalloc return value.

[...]
> diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
> index c196827..a71bb8a 100644
> --- a/drivers/s390/block/dasd_devmap.c
> +++ b/drivers/s390/block/dasd_devmap.c
> @@ -410,8 +410,7 @@ dasd_add_busid(const char *bus_id, int features)
>  	struct dasd_devmap *devmap, *new, *tmp;
>  	int hash;
>  
> -	new = (struct dasd_devmap *)
> -		kzalloc(sizeof(struct dasd_devmap), GFP_KERNEL);
> +	new = kzalloc(sizeof(struct dasd_devmap), GFP_KERNEL);

Applied, thanks.

