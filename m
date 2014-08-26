Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbaHZICx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:02:53 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:38703 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbaHZICs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:02:48 -0400
Message-ID: <1409040095.2489.3.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH][input-led] Defer input led work to workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
        Sabrina Dubroca <sd@queasysnail.net>, Valdis.Kletnieks@vt.edu,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Tue, 26 Aug 2014 10:01:35 +0200
In-Reply-To: <20140826015453.GA5235@type.youpi.perso.aquilenet.fr> (sfid-20140826_040254_816162_A52F1B31)
References: <20140826015453.GA5235@type.youpi.perso.aquilenet.fr>
	 (sfid-20140826_040254_816162_A52F1B31)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-26 at 03:54 +0200, Samuel Thibault wrote:

> +	vt_led_wq = alloc_workqueue("input_leds", WQ_UNBOUND, 0);
> +	if (!vt_led_wq)
> +		return -ENOMEM;

Does this really need a separate workqueue rather than just using
schedule_work()? There doesn't seem to be much point in having its own
workqueue really, to me.

johannes

