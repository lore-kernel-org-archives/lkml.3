Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab3CKVpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:45:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27985 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3CKVpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:45:05 -0400
Date: Tue, 12 Mar 2013 00:44:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mirsal Ennaime <mirsal@mirsal.fr>
Cc: Greg Kroah-Hartman <greg@kroah.com>, devel@driverdev.osuosl.org,
        Brian Swetland <swetland@google.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Subject: Re: [PATCH 4/4] drivers: android: binder: Fix compiler warning
Message-ID: <20130311214447.GB9138@mwanda>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
 <1363030315-10229-5-git-send-email-mirsal@mirsal.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363030315-10229-5-git-send-email-mirsal@mirsal.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 08:31:55PM +0100, Mirsal Ennaime wrote:
> Fix an instance of -Wdeclaration-after-statement
> 

That's a compiler warning you introduced yourself on the previous
patch.  Obviously, we're not going to accept the original patch. :P

> Signed-off-by: Mirsal Ennaime <mirsal@mirsal.fr>
> ---
>  drivers/staging/android/binder.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index 18a83e2..c833b53 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -3001,11 +3001,12 @@ static void binder_deferred_release(struct binder_proc *proc)
>  	page_count = 0;
>  	if (proc->pages) {
>  		int i;
> +		void *page_addr;

Put a blank line after the variable declaration section.  Really
the "int i" should go at the start of the function and the page_addr
should go inside the for loop.

regards,
dan carpenter


