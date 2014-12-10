Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbaLJEFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 23:05:41 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42377 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbaLJEFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 23:05:39 -0500
Date: Tue, 9 Dec 2014 20:05:36 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 11/12] input: cyapa: add gen5 trackpad device force
 re-calibrate function support
Message-ID: <20141210040536.GC4173@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudley.dulixin@gmail.com>, dmitry.torokhov@gmail.com,
	rydberg@euromail.se, bleung@google.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
 <1418116304-11392-12-git-send-email-dudley.dulixin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418116304-11392-12-git-send-email-dudley.dulixin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Tue, Dec 09, 2014 at 05:11:43PM +0800, Dudley Du wrote:
> Add force re-calibrate function supported for gen5 trackpad device,
> it can be used through sysfs calibrate interface.
> TEST=test on Chromebooks.
> 
> Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
> ---
>  drivers/input/mouse/cyapa_gen5.c | 65 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
> 
> diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
> index 5bebee1..7d96904 100644
> --- a/drivers/input/mouse/cyapa_gen5.c
> +++ b/drivers/input/mouse/cyapa_gen5.c
> @@ -1581,6 +1581,70 @@ static int cyapa_gen5_suspend_scanning(struct cyapa *cyapa)
>  	return 0;
>  }
>  
> +static int cyapa_gen5_calibrate_pwcs(struct cyapa *cyapa,
> +		u8 calibrate_sensing_mode_type)
> +{
> +	u8 cmd[8];
> +	u8 resp_data[6];
> +	int resp_len;
> +	int error;
> +
> +	/* Try to dump all bufferred data before doing command. */
                       ^^^^^^^^^
					   buffered

[...]

-- 
- Jeremiah Mahler
