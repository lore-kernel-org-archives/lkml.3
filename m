Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaIHP1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:27:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:39812 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbaIHP1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:27:00 -0400
Date: Mon, 8 Sep 2014 17:26:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 06/22] perf: Redirect output from inherited events to
 parents
Message-ID: <20140908152655.GU19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-7-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RibZbuz5vRlk3cF0"
Content-Disposition: inline
In-Reply-To: <1408538179-792-7-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RibZbuz5vRlk3cF0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 03:36:03PM +0300, Alexander Shishkin wrote:
> In order to collect AUX data from an inherited event, we can redirect its
> output to parent's ring buffer if possible (they must be cpu affine). This
> patch adds set_output() to the inheritance path.
>=20
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> ---
>  kernel/events/core.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 67f857ab56..e36478564c 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -7962,6 +7962,12 @@ inherit_event(struct perf_event *parent_event,
>  		=3D parent_event->overflow_handler_context;
> =20
>  	/*
> +	 * Direct child's output to parent's ring buffer (if any)
> +	 */
> +	if (parent_event->cpu !=3D -1)
> +		(void)perf_event_set_output(child_event, parent_event);
> +
> +	/*
>  	 * Precalculate sample_data sizes
>  	 */
>  	perf_event__header_size(child_event);

Uhm, nope, see perf_output_begin(), it always redirects output to parent
events.

--RibZbuz5vRlk3cF0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDcq/AAoJEHZH4aRLwOS6eYYP/0aDXFyMDmTe5Ry6329bsTqO
zKhz727vnxqV1bEYCYj4MC4JQLh9cBOpRvZRKl1PuncmsoJe/7EdwvHVyVi440qS
qeaYJAQo5AaS6JBLboYwXF9tG2w4meBnXAriDnRy0dal9yRds2thfimo+tKFavjU
KNKEx2eBZvOqliacIvRkA0uBR/+3joRrfomYyI2AemrobrEK1DmuRwCrBMLcPBGb
xyqs21cNvVv6hpsGSS0FXhtfOPJ0zdV9wW/8YIY7TQ7SxOC/Ghd32lVHULEHP1ZE
jMTjKKbyhb8PLEtOhDrMZOmir+NlIqp/4tKE7zQYApTzHM5NMXJ8Z5Jv53SLMtfQ
pdwqq6sHMSTx+Rjf+jodTrT8Z+9dnqeeVO84W67hD1sB0uIjc7/tqfcl45cu3Zlv
F8Ctatzs7xl8QPNHGHd1FXSX6DIMcYiHhUEvi6cwE8fiwO6aaedFsi4kX0FlpojM
UcGFo+3bI9n1ataeSh7XCiyAD9Z4wfu5txzp79aPo4tnd+zWv84O7S4/FT6DRU6M
HqNCTkSw8jo4cPoKQ6ZXqFZwEeSb9R003Rh7+pbfcirOzLcEyJyTXRoqR1efBIzJ
mOnP1ZyTgAPoVy6y0Su80xgAK7k6u7Rbm2bh6rblA/aNC/xbky/j92nfv2bSRJgX
QqDlzxQTUR8y4J3dhg/A
=2Zks
-----END PGP SIGNATURE-----

--RibZbuz5vRlk3cF0--
