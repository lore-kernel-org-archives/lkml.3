Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063Ab3JPSlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:41:39 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:32930 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761398Ab3JPSli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:41:38 -0400
Date: Wed, 16 Oct 2013 11:41:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: dudl@cypress.com, kamal@canonical.com, mario_limonciello@dell.com,
        git@status.e4ward.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-br@googlegroups.com
Subject: Re: [PATCH] drivers: input: mouse: Remove useless casting in
 cypress_ps2.c
Message-ID: <20131016184133.GB21932@core.coreip.homeip.net>
References: <1381939512-28534-1-git-send-email-geyslan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381939512-28534-1-git-send-email-geyslan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geyslan,

On Wed, Oct 16, 2013 at 01:05:12PM -0300, Geyslan G. Bem wrote:
> Casting (void *) value returned by kzalloc is useless
> as mentioned in Documentation/CodingStyle, Chap 14.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  drivers/input/mouse/cypress_ps2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
> index f51765f..ef651cc 100644
> --- a/drivers/input/mouse/cypress_ps2.c
> +++ b/drivers/input/mouse/cypress_ps2.c
> @@ -679,7 +679,7 @@ int cypress_init(struct psmouse *psmouse)
>  {
>  	struct cytp_data *cytp;
>  
> -	cytp = (struct cytp_data *)kzalloc(sizeof(struct cytp_data), GFP_KERNEL);
> +	cytp = kzalloc(sizeof(struct cytp_data), GFP_KERNEL);

I already have a patch for this from Jingoo Han in my queue.

>  	psmouse->private = (void *)cytp;

But this cast is also not needed, so if you could send me a patch for it
I'd appreciate that.

>  	if (cytp == NULL)
>  		return -ENOMEM;
> -- 
> 1.8.4
> 

Thanks.

-- 
Dmitry
