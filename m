Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3H0XgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:36:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab3H0XgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:36:14 -0400
Date: Tue, 27 Aug 2013 16:38:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: pavel@ucw.cz, justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/24] Staging: winbond: reg: changed sleep function from
 msleep to usleep
Message-ID: <20130827233832.GA25985@kroah.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
 <1377529823-5116-9-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377529823-5116-9-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 05:10:07PM +0200, Iker Pedrosa wrote:
> According to the documentation it is not recommended to use msleep for 1ms - 20ms because it may sleep longer than 20ms. So, it is recommended to use usleep instead.
> 
> Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
> ---
>  drivers/staging/winbond/reg.c | 52 +++++++++++++++++++++----------------------
>  1 file changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
> index 80b4b34..61916f5 100644
> --- a/drivers/staging/winbond/reg.c
> +++ b/drivers/staging/winbond/reg.c
> @@ -890,9 +890,9 @@ void Uxx_power_on_procedure(struct hw_data *pHwData)
>  	else {
>  		Wb35Reg_WriteSync(pHwData, 0x03f4, 0xFF5807FF);
>  		Wb35Reg_WriteSync(pHwData, 0x03d4, 0x80); /* regulator on only */
> -		msleep(10);
> +		usleep(10000);

This breaks the build :(

