Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030549AbaGPHU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:20:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:33077 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904AbaGPHU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:20:26 -0400
Date: Wed, 16 Jul 2014 09:20:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [patch 14/55] timekeeping: Provide internal ktime_t based data
Message-ID: <20140716072017.GV6758@twins.programming.kicks-ass.net>
References: <20140711133623.530368377@linutronix.de>
 <20140711133706.426549845@linutronix.de>
 <CALAqxLUPjqCidKaXQowDw5L2WQnyZsozpjhwO0QQcXvpXBt5fg@mail.gmail.com>
 <alpine.DEB.2.10.1407160859110.24854@nanos>
 <alpine.DEB.2.10.1407160909310.24854@nanos>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xWrScvulqIuecunV"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1407160909310.24854@nanos>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xWrScvulqIuecunV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 16, 2014 at 09:12:52AM +0200, Thomas Gleixner wrote:
> Looking into it I think for now it's the least risky approach to keep
> the core logic based on the timespec stuff unmodified and update the
> ktime_t members in timekeeping_update(). Converting the whole thing to
> a pure nsec based mechanism and update the timespec stuff in
> timekeeping_update() needs a lot more thought and we should do that
> later on. It wont change any of the interfaces.

So I don't think you can only do nsec, seeing how the conversion from
nsec to timespec is expensive. So if we want to also avoid the timespec
-> nsec conversion we need to keep both, no two ways around it.

That said the timespec -> nsec conversion is heaps cheaper, although
still not what you call really sheep ;-)


--xWrScvulqIuecunV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxiexAAoJEHZH4aRLwOS6JgEQALN5QvJQ8Irocf8VbUSTBVnc
/CrW9qhwBfOUOnQ+2OkuEwT3Hei5a/FTctxaJCXoTQQpkAeNG2i32OBgCe4iKo6G
OT5UnJ4OKqq896uHUlx45aqlB73k/K2uinVdBC0Pq3O74JzcCfIgAe/bsOM8KNPh
UNIgDWNoMcu8NriYb11Aojy8HHIZcmZbOaz/zRiRGV4xyO2Rx2eiGVwe+qd58Zhc
V/JwKEoMcV4vhqS3pV6jbWjG1REvmFjOuPO+vFdraDPzdXGFQbBaDW/nzC4P1uyc
viOgNHgoQuJxayrys7D/4GeXK9ahDlQnavy0dvi/8KTKdUGd5yS2WqSNys/2oBBt
/59PDKGIKSJhDd78DjhzC2jQ4nPIABl+vtaVSy8ziLPuz22llSRwa2RvOBTCcoVE
LMal2zY4dFB8qPcJfr+c2T7CtiD2w88jCMJmtGtE0hzImIDG5lvAIeLJ05XpGAiP
2WXA3IXijLeeam/q0v2S6RCYxsbuCT+CDrA6/cZzJFUFPukbBCxN5RXdnerX6ePJ
/i+gsg/8K775ltrn4yCNuQFHxDwk/Z8HuDFnIfrtGynIi/g0pCc0TOlDB9gCMozw
vmd0C8dCCnYuvodS+CJYDA5Z4UjXuywMQp9byBRIZj5iJ9y0XsEuu/qBkqp7dQ7r
bfj1HHYIEOV6dt6HmGxe
=MLOh
-----END PGP SIGNATURE-----

--xWrScvulqIuecunV--
