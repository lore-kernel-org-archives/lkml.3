Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbaHZNWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:22:53 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:40401 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757639AbaHZNWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:22:52 -0400
Message-ID: <1409059327.22232.0.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCHv2][input-led] Defer input led work to workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
        Sabrina Dubroca <sd@queasysnail.net>, Valdis.Kletnieks@vt.edu,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Tue, 26 Aug 2014 15:22:07 +0200
In-Reply-To: <20140826091725.GA23293@type.youpi.perso.aquilenet.fr> (sfid-20140826_111735_723896_6D594EC0)
References: <20140826015453.GA5235@type.youpi.perso.aquilenet.fr>
	 <20140826091725.GA23293@type.youpi.perso.aquilenet.fr>
	 (sfid-20140826_111735_723896_6D594EC0)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-26 at 11:17 +0200, Samuel Thibault wrote:

> -	led_trigger_event(&vt_led_triggers[led], !!brightness);
> +	vt_led_state[led] = !!brightness;
> +	schedule_work(&vt_led_work[led]);


> +static int __init input_led_init(void)
> +{
> +	unsigned i;
> +
> +	for (i = 0; i < LED_CNT; i++)
> +		INIT_WORK(&vt_led_work[i], vt_led_cb);
> +
> +	return 0;
> +}
> +
> +static void __exit input_led_exit(void)
> +{
> +}

Come to think of it - don't you need to cancel_work_sync() in exit so
the work struct can't be queued while the module is being unloaded?

johannes

