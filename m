Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaHZUCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 16:02:21 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:54842 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbaHZUCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 16:02:19 -0400
Date: Tue, 26 Aug 2014 22:02:08 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
To: Valdis.Kletnieks@vt.edu
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH][input-led] Defer input led work to workqueue
Message-ID: <20140826200208.GA11247@kria>
References: <20140826015453.GA5235@type.youpi.perso.aquilenet.fr>
 <3942.1409078958@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3942.1409078958@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-26, 14:49:18 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 26 Aug 2014 03:54:53 +0200, Samuel Thibault said:
> > This changeset defers the second led_trigger_event call into a
> > workqueue, which avoids the nested locking altogether.  This does
> > not prevent the user from shooting himself in the foot by creating a
> > vt::capsl <-> vt-capsl loop, but the only consequence is the workqueue
> > threads eating some CPU until the user breaks the loop, which is not too
> > bad.
> >
> > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> >
> > --- a/drivers/input/leds.c
> > +++ b/drivers/input/leds.c
> > @@ -100,13 +100,25 @@ static unsigned long vt_led_registered[B
> 
> I admit having zero understanding of the code, but I can confirm that
> next-20140825 still throws the lockdep whine I was seeing, but the same
> tree with this patch on top of it boots without warning. Soo...
> 
> Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Same for me.

Tested-by: Sabrina Dubroca <sd@queasysnail.net>


Thanks,

-- 
Sabrina
