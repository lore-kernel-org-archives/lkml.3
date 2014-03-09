Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaCIXlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 19:41:55 -0400
Received: from ring0.de ([5.45.105.125]:60679 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbaCIXlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 19:41:53 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	*  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	* -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Mon, 10 Mar 2014 00:41:44 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Sebastian Reichel <sre@ring0.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Carlos Chinea <cch.devel@gmail.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        Pawel Szyszuk <pawel.szyszuk@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Generic HSI client DT bindings
Message-ID: <20140309234143.GA19034@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I'm currently working on Device Tree support for the HSI subsystem
to get the Nokia N900 modem working in the mainline kernel. I guess
the key question for the binding has been asked by Mark:

Mark Rutland <mark.rutland@arm.com> wrote [0]:
> Does HSI have an addressing scheme, or does each port
> have a single device?

It's easy to answer the question in an abstract way: A HSI link
connects two processors with each other providing multiple logical
channels. The problem is, that only the physical layer is specified
AFAIK (I do not have access to HSI specification, so I do not know
for sure). Thus the exact usage of the channels is vendor specific.

For the Nokia N900 modem the following one of the following bindings
seem senseful to me:

========= Variant A =========
hsi-port {
	/* some nodes describing the port */

	n900_modem: client-device {
		compatible = "nokia,n900-modem";
		reg = <0>, <1>, <2>, <3>;
		reg-names = "mcsaab-control",
			    "speech-control",
			    "mcsaab-data",
			    "speech-data";
		hsi-mode = "stream";
		hsi-speed-kbps = <55000>;
		hsi-flow = "synchronized";
		hsi-arb-mode = "round-robin";
	};
};
#############################

========= Variant B =========
hsi-port {
	/* some nodes describing the port */

	cmt_mcsaab: client-device@0 {
		compatible = "nokia,mcsaab-protocol";
		reg = <0>, <2>;
		reg-names = "mcsaab-control",
			    "mcsaab-data";
		hsi-mode = "stream";
		hsi-channels = <4>;
		hsi-speed-kbps = <55000>;
		hsi-flow = "synchronized";
		hsi-arb-mode = "round-robin";
	};

	cmt_speech: client-device@1 {
		compatible = "nokia,cmt-speech";
		reg = <1>, <4>;
		reg-names = "speech-control",
			    "speech-data";
		hsi-mode = "stream";
		hsi-channels = <4>;
		hsi-speed-kbps = <55000>;
		hsi-flow = "synchronized";
		hsi-arb-mode = "round-robin";
	};
};
#############################

Both bindings are simplified and do not map all of the hardware's
capabilities: Some settings can be configured differently for RX and
TX. It should be easy to extend the support for e.g. hsi-mode-rx
and hsi-mode-tx once this is needed. For devices configuring them
the same having just one node seems better to me (I assume almost
all devices want them to be the same).

As far as I can see only ST-Erricson has also HSI clients prepared
for the mainline kernel. It would be nice to get some feedback from
you. If you know more HSI users, which are not yet Cc'd please feel
free to point them here.

[0] http://article.gmane.org/gmane.linux.kernel/1654456

-- Sebastian

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTHPw3AAoJENju1/PIO/qaeXwP/3Azj3pMd0U94lvvZN1Xcbgg
aeYenK1aQDKI34JVPQmYj0XSA6/uz2kCu942neSpbS5LQA9zZd3XotFQDCNsa4Xd
0dnCN7hxluV010FzrjDI20MN4nXt8f3dgQzBz5CmQjYa9rsVsVeFoEfghLaxuI5B
/w2jVgtKkkEE08FfL0C8gNGnEdnpbA8SbIyXr1+uLMUYUM9KSbz3eZfPM0hnadnI
MT7/l5enCkSRZRs0+AferCUxegJByFyGERgfwK9dDTPk8h+q8Ap4J9fBcuW3ytDe
fIA3EcIleX+NUHzixM80OXYM5dBHd6aPZSrfbLlrGWfViAfLH1q+LQJNrcTL1q3c
I5HT4lcjwDJtMLs9rlPbxaDelfALDvXod8L5ZQ2UGvbaiHjUaaOC2IOsZ++FqbDi
J9trkVEaUH+sYI420Y+A/1lMHbTFN89eHVc5+O3LB2SjcmIZma04fHh1w1qrkj6u
en9H6UBTLjGC0nOBT92rdUAd324fjjsHmAMSJfWeTpBr4WiZeyZIa/j9WToX57/a
ZRPdvYUtuXVAaLSYHztLrCZqc+pwuIYZbADBTLPmaRgGc3MG6TthcNanaxF+5djW
IbklrTvWyLTx9CGRgnYS6CpDW8zI0SlfSIGr3KPBMGd0vz6WSOMns2uvhSB/6m7p
Ixm0ywnM4OXIUXgnYhRZ
=2wzm
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
