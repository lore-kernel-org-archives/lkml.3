Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaBFAkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:40:04 -0500
Received: from ring0.de ([5.45.105.125]:33474 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbaBFAkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:40:02 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Thu, 6 Feb 2014 01:39:58 +0100
From: Sebastian Reichel <sre@debian.org>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, freemangordon@abv.bg
Subject: Re: Re: [PATCH] ARM: OMAP2+: Add support for thumb mode on DT booted
 N900
Message-ID: <20140206003958.GB654@earth.universe>
References: <1391603582-11371-1-git-send-email-sre@debian.org>
 <CAHYPw2Ep9VP6Tem979ewcztdxkHkG8eR_U31U=f5ibsVa5AS4Q@mail.gmail.com>
 <20140205163117.GA15996@earth.universe>
 <CAHYPw2HX478ZZPfDTKCKSGhVdFc1-G5DszUR4vG+WRgZx=8+dQ@mail.gmail.com>
 <20140205171729.GA17974@earth.universe>
 <52F29F7C.4080502@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <52F29F7C.4080502@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Wed, Feb 05, 2014 at 10:30:52PM +0200, Ivaylo Dimitrov wrote:
> In theory having that workaround disabled might be a security
> problem, but honestly, knowing its nature I don't think it is easily
> exploitable, if at all. The final result when bitten by it is a
> SIGILL, but in userspace, not in the kernel(assuming the kernel is
> ARM), and userspace runs in totally different mode (nonsecure,
> nonprivileged) compared to the kernel(nonsecure, privileged) and
> IIRC every mode has its own set of stack, registers etc. BTW I don't
> think the kernel itself can be thumb2-compiled for cores with that
> errata, but I might wrong. Also, as Pali noted, the problem appears
> if and only if there is an userspace binary containing thumb2 code.
> If all of the userspace is pure ARM, there is no problem.

Ok. I assumed, that a single thumb2-compiled binary can potentially
trigger problems for the whole system. Basically because the ERRATA
helptext in KConfig is:

[...], Cortex-A8 does not recover from the stale interworking branch
prediction.

> And as the errata workaround has its drawbacks (BTB is cleared on
> every context switch which affects performance), one might want to
> not have it enabled.

I guess the workaround would be persistently enabled if there were
no drawbacks.

> Maybe that warning should be spit only if CONFIG_THUMB2_KERNEL (or
> whatever the option was) is enabled. Though if that option is
> enabled I'd rather #error during compile time if errata workaround
> is not enabled, instead of printing a warning while booting a
> system that will crash in a matter of seconds.

THUMB2 userland code is supported by the kernel by default, so that
does not work. (Enabling CONFIG_THUMB2_KERNEL will result in a
thumb2-compiled kernel.)

-- Sebastian

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJS8tneAAoJENju1/PIO/qaYoUQAICZlh8msZ+RAtLA2DnZkOgJ
peOVIH6yCySpMEE+5LUGCRWl4HL9kteOtgzhHDuItfGYRr1kRzBVtmKDCwSOuAT8
fK94ZUKU10XQ6V3j+l30zR11SdX9C8kksK1dcvGMW0xno9WQeSfWbwzpt75xqHZu
gJ7iComkTJCqCKeEk8au+F/5vDEmUJIaPLiW98GgzWsSUgPVn+7UCFY+rO/AIbMd
FWK9m1UGAOHf6t5KqQ00XO/+oaJCV64dl5XQswsuaOD4MFdNTQ1N+48BG+5H/tOy
PWsL+sRYtsduqNCGVFn28tHJ/hepVI9jE3Dad+G4fOxw8YgkkRhtlYVlL4V+uxj9
5kBG9dB+PlRdzBL3lXj+8MHcPa+qqYa6mq7/Akfm76JklGNlyzckP1XQxFh77/tk
4jGrBayCTkjt1YKx1tvXkqRTwZl+UI9tutWKk/zy5NHzwrVuI5enciP8EAye/w8r
MBFasrNts5BWn7R+i0HaGdFhT+0noVULRTVGUi2qwwnCYKosfW+5Nxz4mcijtjIo
JPByFXkdOpek1gK5B/ImNr+EZmFNLnSFEVbBiSQ92RW1qn9B52tQLROX70dH+WNZ
ATo3cqklhAbxhsscRjhkd8bIZ7j6/fk/qEGOr/NB/scv9v4/QxD5QhXcGS21qroe
UmwLzapFJShSlBzMDZhT
=znoC
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
