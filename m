Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaB1XW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:22:28 -0500
Received: from ring0.de ([5.45.105.125]:42607 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbaB1XW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:22:27 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sat, 1 Mar 2014 00:22:23 +0100
From: Sebastian Reichel <sre@debian.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv1 1/2] rx51_battery: convert to iio consumer
Message-ID: <20140228232223.GB23878@earth.universe>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
 <1393375569-21751-2-git-send-email-sre@debian.org>
 <CAAfyv37B=xn3AktnUxPDpuey+5S73vW0PJnuUZtorP4rajPKiw@mail.gmail.com>
 <20140226215452.GA11468@earth.universe>
 <CAAfyv340pA2ihUAoFytBgevLtedvtj5Z0aw_=G9Rbx5occtyqw@mail.gmail.com>
 <20140228020536.GB5427@earth.universe>
 <CAAfyv36jJoMxZQ5e43pEC2rzNBHHW9Jt_4dg5O-fS8e+Aim7jA@mail.gmail.com>
 <20140228210857.GA17467@earth.universe>
 <CAAfyv34UB52FCDQGMWWgsdHH8ksTLmTg0iWQcC+dUbhk5nwuoQ@mail.gmail.com>
 <CAAfyv36RPCkUKLOC6yHRwaNjA16EeG_niyfZoaJ15LZ5_HdR7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <CAAfyv36RPCkUKLOC6yHRwaNjA16EeG_niyfZoaJ15LZ5_HdR7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Marek,

On Fri, Feb 28, 2014 at 11:32:22PM +0100, Belisko Marek wrote:
> Seems I found issue. I have missing property ti,system-uses-second-madc-irq
> as original twl4030_madc_battery used SW2 but this change doesn't fix completely
> the problem.

I remember adding this property because you requested it :) Good to
know, that its really needed.

> What it fixed completely is change:
> -       req.raw = !(mask == IIO_CHAN_INFO_PROCESSED);
> +       req.raw = 0;//!(mask == IIO_CHAN_INFO_PROCESSED);

ok, that figures it. Instead of changing the twl4030-madc driver
you should change the twl4030-madc-battery driver. You currently
call iio_read_channel_raw(), which gives you raw values. Your
driver wants processed data from twl4030-madc, so you should use
iio_read_channel_processed() instead.

-- Sebastian

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTERovAAoJENju1/PIO/qaDrsP/0VUtU5vcKmMlYofOGJQ1s8N
z+iyg3H1RlckfEvxyw7SE2aI+3INoAXEUuE4EPxj5/6AambuKzipEWWoRiaOHgQG
3Q1PGABdWq1CmPN84d7EHrjoIKkIOs689Fag1SKQKiO36PVdtwT0R+wFWN0r3TGH
JSFo5JgvUARDk2wYAW7/9//uSb8jxMha/CZOICPp64H2CRaqCcCv7OAOeeOypvgc
7gqzvIWiHYrQPFv4VHxZV4+sbbCiFQHrC4h+GxaKiUvu/ieyIk2fdgAn7bPSlcnB
T/h4KmspeondMO3Vdonqm09l9HHE1VmoCJzmkJmOeVtmI3pJqykg9zqzXd7PB8C9
ScimC93KZbVDxUjHlQvZpsYH7w2pUWGvYZzenBVlp9YIf6SwPCUOuOO1s/Ch9HgE
vaKmV/ai/9jl6l089JWrwu6JPNxIYueDQUDomqFth5pPOZJZxqBn2Mk54AKBG3dy
UTKfAGbuc9Lt0ix7Il6UIdx8WVJD9pu8t4JfrcnVHpcaTb4BG39g8II5FgFu/aYU
bxdPS+G4dR2kMZ2+ockYmAeBsRszAZHPocWlpXWlVIh6dyQxwWOr9XvDWP1FY05V
pL4If02JSMQAIPk0EdZ3CVbiXrGmIhyXnlgDi+7ZUTFcVhJOigiK2R2IO5MqCvgI
fhRnqydMIGuTit+ico3h
=AM15
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
