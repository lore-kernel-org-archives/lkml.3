Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3H0XgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:36:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab3H0XgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:36:19 -0400
Date: Tue, 27 Aug 2013 16:38:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, harsh1kumar@gmail.com,
        linux-kernel@vger.kernel.org, mujeeb.adil@gmail.com,
        justinmattock@gmail.com, dan.carpenter@oracle.com
Subject: Re: [PATCH 20/24] Staging: winbond: wb35tx: changed sleep function
 from msleep to usleep
Message-ID: <20130827233838.GA21170@kroah.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
 <1377529823-5116-21-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377529823-5116-21-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 05:10:19PM +0200, Iker Pedrosa wrote:
> According to the documentation it is not recommended to use msleep for 1ms - 20ms because it may sleep longer than 20ms. So, it is recommended to use usleep instead.
> 
> Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
> ---
>  drivers/staging/winbond/wb35tx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
> index 30a77cc..8c25cbd 100644
> --- a/drivers/staging/winbond/wb35tx.c
> +++ b/drivers/staging/winbond/wb35tx.c
> @@ -166,9 +166,9 @@ void Wb35Tx_destroy(struct hw_data *pHwData)
>  
>  	/* Wait for VM stop */
>  	do {
> -		msleep(10); /* Delay for waiting function enter 940623.1.a */
> +		usleep(10000); /* Delay for waiting function enter 940623.1.a */

It looks like you didn't try to build this patch, as it breaks the build
for me here :(

greg k-h
