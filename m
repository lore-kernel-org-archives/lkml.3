Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaEWSuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:50:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaEWSuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:50:51 -0400
Date: Sat, 24 May 2014 01:53:35 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Luis Ortega <luiorpe1@gmail.com>
Cc: pe1dnn@amsat.org, devel@driverdev.osuosl.org, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org, monamagarwal123@gmail.com,
        paulmck@linux.vnet.ibm.com, archanakumari959@gmail.com
Subject: Re: [PATCH] staging: wlags49_h2: fix sparse warning "should it be
 static"
Message-ID: <20140523165335.GA6883@kroah.com>
References: <1399480308-15869-1-git-send-email-luiorpe1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399480308-15869-1-git-send-email-luiorpe1@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 06:31:48PM +0200, Luis Ortega wrote:
> Fixes the following warning:
> drivers/staging/wlags49_h2/sta_h2.c:4471:10: warning: symbol 'fw_image' was not declared. Should it be static?
> 
> Signed-off-by: Luis Ortega <luiorpe1@gmail.com>
> ---
>  drivers/staging/wlags49_h2/sta_h2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wlags49_h2/sta_h2.c b/drivers/staging/wlags49_h2/sta_h2.c
> index 0ba8def..2838faa 100644
> --- a/drivers/staging/wlags49_h2/sta_h2.c
> +++ b/drivers/staging/wlags49_h2/sta_h2.c
> @@ -4468,7 +4468,7 @@ static const CFG_RANGE20_STRCT fw_image_infocompat[] = {
>  	{ 0000, 0000, 0000, 0000, { { 0000, 0000, 0000 } } }	/* endsentinel */
>  };
> 
> -memimage fw_image = {
> +static memimage fw_image = {
>  	"FUPU7D37dhfwci\001C",			/* signature, <format number>, C/Bin type */
>  	(CFG_PROG_STRCT *) fw_image_code,
>  	0x000F368E,

ALWAYS test build your patches.  This patch breaks the build :(

greg k-h
