Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3KULJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:09:56 -0500
Received: from smtp.citrix.com ([66.165.176.89]:25785 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab3KULJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:09:55 -0500
X-IronPort-AV: E=Sophos;i="4.93,743,1378857600"; 
   d="scan'208";a="76742784"
Message-ID: <528DEA00.7070505@citrix.com>
Date: Thu, 21 Nov 2013 11:09:52 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <Ian.Campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <JBeulich@suse.com>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 3/4] xen/manage: Guard against user-space initiated poweroff
 and XenBus.
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com> <1383932286-25080-4-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1383932286-25080-4-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> There is a race case where the user does 'poweroff'
> and at the same time the system admin does 'xl shutdown'.

This isn't a Xen-specific problem is it?  Wouldn't it be better to fix
this in generic code?

Especially since I don't think this patch actually fixes the race
completely.

> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
[...]
> @@ -222,7 +230,7 @@ static void shutdown_handler(struct xenbus_watch *watch,
>  	};
>  	static struct shutdown_handler *handler;
>  
> -	if (shutting_down != SHUTDOWN_INVALID)
> +	if (atomic_read(&shutting_down) != SHUTDOWN_INVALID)
>  		return;

In guest initiated poweroff at this time will still race with this
toolstack initiated poweroff.

David
