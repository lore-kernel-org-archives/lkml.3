Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaLNWla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:41:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaLNWlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:41:24 -0500
Date: Sun, 14 Dec 2014 14:41:23 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>, Ken Cox <jkc@redhat.com>,
        Erik Arfvidson <erik.arfvidson@unisys.com>,
        Silvio F <silvio.fricke@gmail.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: unisys: virtpci: virtpci.c:  Fix for possible
 null pointer dereference
Message-ID: <20141214224123.GA4288@kroah.com>
References: <1418596871-24827-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418596871-24827-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 11:41:11PM +0100, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/unisys/virtpci/virtpci.c |   23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/unisys/virtpci/virtpci.c b/drivers/staging/unisys/virtpci/virtpci.c
> index ee9f826..d818eda 100644
> --- a/drivers/staging/unisys/virtpci/virtpci.c
> +++ b/drivers/staging/unisys/virtpci/virtpci.c
> @@ -1314,15 +1314,13 @@ static ssize_t virtpci_driver_attr_show(struct kobject *kobj,
>  	ssize_t ret = 0;
>  
>  	struct driver_private *dprivate = to_driver(kobj);
> -	struct device_driver *driver;
>  
> -	if (dprivate != NULL)
> -		driver = dprivate->driver;
> -	else
> -		driver = NULL;
> +	if (dprivate) {

It is impossible for dprivate to ever be NULL, someone doesn't
understand how kobjects work :(

So just remove the check please, don't add more logic that will never
run.

thanks,

greg k-h
