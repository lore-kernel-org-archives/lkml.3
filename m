Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbaHZNYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:24:14 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:23089
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754695AbaHZNYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:24:13 -0400
X-IronPort-AV: E=Sophos;i="5.04,404,1406584800"; 
   d="scan'208";a="76693771"
Date: Tue, 26 Aug 2014 15:24:10 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
        Sabrina Dubroca <sd@queasysnail.net>, Valdis.Kletnieks@vt.edu,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2][input-led] Defer input led work to workqueue
Message-ID: <20140826132410.GD3186@type.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
	Sabrina Dubroca <sd@queasysnail.net>, Valdis.Kletnieks@vt.edu,
	Vincent Donnefort <vdonnefort@gmail.com>,
	Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20140826015453.GA5235@type.youpi.perso.aquilenet.fr>
 <20140826091725.GA23293@type.youpi.perso.aquilenet.fr>
 <1409059327.22232.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409059327.22232.0.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg, le Tue 26 Aug 2014 15:22:07 +0200, a écrit :
> On Tue, 2014-08-26 at 11:17 +0200, Samuel Thibault wrote:
> 
> > -	led_trigger_event(&vt_led_triggers[led], !!brightness);
> > +	vt_led_state[led] = !!brightness;
> > +	schedule_work(&vt_led_work[led]);
> 
> 
> > +static int __init input_led_init(void)
> > +{
> > +	unsigned i;
> > +
> > +	for (i = 0; i < LED_CNT; i++)
> > +		INIT_WORK(&vt_led_work[i], vt_led_cb);
> > +
> > +	return 0;
> > +}
> > +
> > +static void __exit input_led_exit(void)
> > +{
> > +}
> 
> Come to think of it - don't you need to cancel_work_sync() in exit so
> the work struct can't be queued while the module is being unloaded?

Well, this is never built as a module ATM, so it's not a problem.

Samuel
