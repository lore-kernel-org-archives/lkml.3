Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab3EODHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 23:07:30 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:40994 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab3EODH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 23:07:28 -0400
Message-ID: <1368587420.9012.36.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] vhost-scsi: Depend on NET for memcpy_fromiovec
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Asias He <asias@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        target-devel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 14 May 2013 20:10:20 -0700
In-Reply-To: <1368579583-13097-1-git-send-email-asias@redhat.com>
References: <20130515095558.918f2b29ba318a477eb5dde2@canb.auug.org.au>
	 <1368579583-13097-1-git-send-email-asias@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 08:59 +0800, Asias He wrote:
> scsi.c includes vhost.c which uses memcpy_fromiovec.
> 
> This patch fixes this build failure.
> 
>    From Randy Dunlap:
>    '''
>    on x86_64:
> 
>    ERROR: "memcpy_fromiovec" [drivers/vhost/vhost_scsi.ko] undefined!
> 
>    It needs to depend on NET since net/core/ provides that function.
>    '''
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Asias He <asias@redhat.com>

Hey Asias & MST,

FYI, I'll be sending a PULL request to Linus in the next couple of days
for -rc2.

Let me know if you'd like this to be picked up.

--nab

> ---
>  drivers/vhost/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 8b9226d..0403323 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -12,7 +12,7 @@ config VHOST_NET
>  
>  config VHOST_SCSI
>  	tristate "VHOST_SCSI TCM fabric driver"
> -	depends on TARGET_CORE && EVENTFD && m
> +	depends on NET && TARGET_CORE && EVENTFD && m
>  	select VHOST_RING
>  	default n
>  	---help---


