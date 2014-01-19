Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaASNsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 08:48:30 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36139 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbaASNs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 08:48:26 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Jan 2014 08:48:26 EST
X-Sasl-enc: KLkC40m7xjBHmfCH2wJXYUmrCABpT+3T1BZDvHfV0CZT 1390138896
Message-ID: <52DBD610.7050907@imap.cc>
Date: Sun, 19 Jan 2014 14:41:36 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>
CC: davem@davemloft.net, hannes@stressinduktion.org, netdev@vger.kernel.org,
        Jakub Zawadzki <darkjames-ws@darkjames.pl>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] random32: add prandom_u32_max and convert
 open coded users
References: <1390088431-28657-1-git-send-email-dborkman@redhat.com> <1390088431-28657-2-git-send-email-dborkman@redhat.com>
In-Reply-To: <1390088431-28657-2-git-send-email-dborkman@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 19.01.2014 00:40, schrieb Daniel Borkmann:

> @@ -38,6 +37,23 @@ struct rnd_state { u32 prandom_u32_state(struct
> rnd_state *state); void prandom_bytes_state(struct rnd_state
> *state, void *buf, int nbytes);
> 
> +/** + * prandom_u32_max - returns a pseduo-random number in
> interval [0, ep_ro) + * @ep_ro: right open interval endpoint + * +
> * Returns a pseduo-random number that is in interval [0, ep_ro).
> Note + * that the result depends on PRNG being well distributed in
> [0, ~0U] + * u32 space. Here we use maximally equidistributed
> combined Tausworthe + * generator, that is, prandom_u32(). This is
> useful when requesting a + * random index of an array containing
> ep_ro elements, for example. + * + * Returns: pseduo-random number
> in interval [0, ep_ro) + */

The word "pseudo" is consistently mistyped as "pseduo" in this comment.
(Three occurrences.) You may want to correct this before it gets merged.

Thanks,
Tilman

- -- 
Tilman Schmidt                              E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLb1hAACgkQQ3+did9BuFt4gACeMe9m893fMIapXiZ/AC7BERai
E/cAmgI6r1Uf1EE8reLA6nqd3T/FGWt6
=5qOJ
-----END PGP SIGNATURE-----
