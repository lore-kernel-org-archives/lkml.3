Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbaE1Gzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:55:43 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:60248 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbaE1Gzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:55:41 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2014 02:55:40 EDT
Date: Wed, 28 May 2014 08:49:01 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        gregkh@linuxfoundation.org, speakup@braille.uwo.ca,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: speakup: don't die if accessing sysfs without
 synth
Message-ID: <20140528064901.GW6800@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Sasha Levin <sasha.levin@oracle.com>, w.d.hubbs@gmail.com,
	chris@the-brannons.com, kirk@reisers.ca, gregkh@linuxfoundation.org,
	speakup@braille.uwo.ca, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1401232116-31740-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401232116-31740-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin, le Tue 27 May 2014 19:08:36 -0400, a écrit :
> Setting a 'silent' parameter without a synth would crash the kernel.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Acked-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

> ---
>  drivers/staging/speakup/synth.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
> index 0b3549b..172cf62 100644
> --- a/drivers/staging/speakup/synth.c
> +++ b/drivers/staging/speakup/synth.c
> @@ -212,6 +212,9 @@ void synth_start(void)
>  
>  void spk_do_flush(void)
>  {
> +	if (!synth)
> +		return;
> +
>  	speakup_info.flushing = 1;
>  	synth_buffer_clear();
>  	if (synth->alive) {
> -- 
> 1.7.10.4
> 

-- 
Samuel
Now I know someone out there is going to claim, "Well then, UNIX is intuitive,
because you only need to learn 5000 commands, and then everything else follows
from that! Har har har!"
(Andy Bates in comp.os.linux.misc, on "intuitive interfaces", slightly
defending Macs.)
