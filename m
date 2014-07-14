Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaGNMsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:48:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:51890 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbaGNMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:48:21 -0400
Date: Mon, 14 Jul 2014 14:48:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kan.liang@intel.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH V5 1/2] perf ignore LBR and extra_regs
Message-ID: <20140714124812.GW9918@twins.programming.kicks-ass.net>
References: <1404989984-3068-1-git-send-email-kan.liang@intel.com>
 <53C3C517.4000500@redhat.com>
 <20140714120922.GV9918@twins.programming.kicks-ass.net>
 <53C3CFC1.9070800@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y5yQnZmVlpWlTeDv"
Content-Disposition: inline
In-Reply-To: <53C3CFC1.9070800@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y5yQnZmVlpWlTeDv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 02:40:33PM +0200, Paolo Bonzini wrote:
> Hmmm, I thought rdmsr_safe was going to return zero, but it just returns
> whatever happened to be in edx:eax which maybe should also be fixed.
>=20
> Kan Liang, what happens if CONFIG_PARAVIRT=3Dy?  Do you get garbage or ju=
st no
> events reported?

Either way; its not functioning according to 'spec'. Therefore we should
'disable' things.

> >>In fact there's no reason why LBR cannot be virtualized (though it does=
 need
> >>support from the processor), and it may even be possible to support
> >>OFFCORE_RSP_X in the KVM virtual PMU.
> >
> >But its not, so something needs to be done, right?
>=20
> A first thing that could be done, is to have a way for the kernel to dete=
ct
> absence of LBR

Which is exactly what this patch does, no?

> , for example an all-1s setting of the LBR format field of
> IA32_PERF_CAPABILITIES.  If Intel can tell us "all 1s will never be used",
> we can have KVM set the field that way.  The kernel then should disable L=
BR.

So what's wrong with testing if the MSRs that provide LBR actually work
or not? That doesn't require any magic co-operation of the host/vm
machinery and is therefore far more robust.

--y5yQnZmVlpWlTeDv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw9GMAAoJEHZH4aRLwOS6MCAP/AzkJVyfjN9+hNpa+U1KjUQL
c/X5cOHd5ULB1s6Ti+PJW94X84BTeaftEYBIG2+L06h5lMFQgKJLVnFclHlaXizj
PYxYL2zXwd1+ghe9yM8BtUqYUKyHpc5QGuVWuztopW/jA4wImv2wQ25GMAspNR9U
z8P6B8Z8YT/OHrQebQMbmIPqh00Bz+5uUPwBBZzPHZ+9b7bWOuy9ODoI2qQiz7XR
YM8Hvm63WlhDUX9ea8en/1Y7NHC7C3XiMPJIlqpuTMDCIsgAMBWCu9eFp9icNoHm
zUTjpuEdDBNfm7Hcv/DQdJ9DWORM4PMyrAYBJGs+g4qN6mPfjzkoI7oBWwqRj8wi
CNzamWLDtVN0nygfMpDcDju5A9l8GmIYVhjAX45kdDiqMcTt1leArp0dnRV/W2hK
UKKB4PcMJomAelTPUFNFtTiLvfvqDBcXh/CWNbflZS8NoW4MMUHgqbhGkyw1vg3Q
nc5D/yogDkCIKygxxjpmARC2OhQr/vgvphHMMNOI5wSiesqysRQybHMHzXiVevSF
F8JT73fUi4gPfl+txsiUn189/7w9oyNwt+ClzdkRjdwbxi34SPY5Q3nOHzayd/+j
swv13ZxTSGCMPK0Euz6li90CirzlftGogs4TxojV/3PcQNukEC5NCquvQ9m8MFXn
67/m8ViQeRlUWfNhQWEI
=77Wt
-----END PGP SIGNATURE-----

--y5yQnZmVlpWlTeDv--
