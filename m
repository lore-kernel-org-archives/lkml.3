Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbbARI2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 03:28:11 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34863 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbARI2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 03:28:08 -0500
Date: Sun, 18 Jan 2015 09:29:21 +0100
From: Robin Schroer <sulamiification@gmail.com>
To: Shirish Gajera <gajerashirish@gmail.com>
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, gregkh@linuxfoundation.org,
        domagoj.trsan@gmail.com, dan.carpenter@oracle.com,
        roxanagabriela10@gmail.com, dilekuzulmez@gmail.com,
        ben@decadent.org.uk, daeseok.youn@gmail.com,
        aysemelikeyurtoglu@gmail.com, rusty@rustcorp.com.au,
        tapaswenipathak@gmail.com, sasha.levin@oracle.com,
        speakup@linux-speakup.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: speakup: Fix warning of line over 80 characters.
Message-ID: <20150118082921.GB1150@shodan.fritz.box>
References: <20150118075753.GA2612@shirish-ThinkPad-Edge-E430>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150118075753.GA2612@shirish-ThinkPad-Edge-E430>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 11:57:53PM -0800, Shirish Gajera wrote:
> diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
> index e9f0c15..141abb7 100644
> --- a/drivers/staging/speakup/main.c
> +++ b/drivers/staging/speakup/main.c
> @@ -422,8 +422,10 @@ static void announce_edge(struct vc_data *vc, int msg_id)
>  {
>  	if (spk_bleeps & 1)
>  		bleep(spk_y);
> -	if ((spk_bleeps & 2) && (msg_id < edge_quiet))
> -		synth_printf("%s\n", spk_msg_get(MSG_EDGE_MSGS_START + msg_id - 1));
> +	if ((spk_bleeps & 2) && (msg_id < edge_quiet)) {
> +		synth_printf("%s\n",
> +		spk_msg_get(MSG_EDGE_MSGS_START + msg_id - 1));
> +	}
>  }
>  
You do not actually need to add the braces as this remains a single
statement (mnemonic: without braces the if ends at the first semicolon).

-- 

Robin Schroer

