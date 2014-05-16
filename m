Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992458AbaEPUHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:07:23 -0400
Received: from romulus.wittsend.com ([130.205.32.3]:52024 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992425AbaEPUHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:07:22 -0400
Message-ID: <1400270662.3540.32.camel@canyon.ip6.wittsend.com>
Subject: Re: [lxc-devel] Mount and other notifiers, was: [RFC PATCH 00/11]
 Add support for devtmpfs in user namespaces
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Michael H.Warfield" <mhw@WittsEnd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Pavel Emelianov <xemul@parallels.com>
Date: Fri, 16 May 2014 16:04:22 -0400
In-Reply-To: <1400269941.2221.98.camel@dabdike.int.hansenpartnership.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
	 <20140515013245.GA1764@kroah.com>
	 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
	 <20140515031527.GA146352@ubuntu-hedt> <20140515040032.GA6702@kroah.com>
	 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
	 <20140515140856.GA17453@kroah.com> <20140515174254.GM21073@ubuntumail>
	 <20140515221551.GB13306@kroah.com>
	 <1400204545.7699.128.camel@canyon.ip6.wittsend.com>
	 <1400268008.2221.84.camel@dabdike.int.hansenpartnership.com>
	 <1400269360.3540.26.camel@canyon.ip6.wittsend.com>
	 <1400269941.2221.98.camel@dabdike.int.hansenpartnership.com>
Organization: Thaumaturgy & Speculums Technology
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-VX5r4UZ06YIx3cTTNghC"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: s4GK4NaV019168
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-SpamScore: s
X-WittsEnd-MailScanner-From: mhw@wittsend.com
X-WittsEnd-MailScanner-Watermark: 1400875464.63557@zQTg6HLIlm1vQArJ5+Pk5Q
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VX5r4UZ06YIx3cTTNghC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-05-16 at 12:52 -0700, James Bottomley wrote:
> On Fri, 2014-05-16 at 15:42 -0400, Michael H. Warfield wrote:
> > > As an aside (probably requiring a new thread) we were wondering about
> > > some type of notifier on the mount call that we could vector into the
> > > host to perform the action.  The main issue for us is mount of procfs=
,
> > > which really needs to be a bind mount in a container.  All of this le=
d
> > > me to speculate that we could use some type of syscall notifier
> > > mechanism to manage capabilities in the host and even intercept and
> > > complete the syscall action within the host rather than having to kee=
p
> > > evolving more an more complex kernel drivers to do this.
> >=20
> > Interesting.  That could be very useful.  That might even help with the
> > loop device case where the mounts have to go through loop devices for
> > things like file system images and builds.  Very interesting...

> Right, it might even make the loop case go away because now we can
> present a dummy device in the container and when the host sees and
> attempted mount on this, it just projects a bind mount into the
> container and says I've *wink* mounted your "device" for you.

Nice.  That idea has prospects.  I like the concept.

> This idea is extremely rough, it came from a conversation I had with
> Pavel (cc'd) just before OpenStack about how we might go about
> eliminating our OpenVZ interception of the mount system call which
> currently does all of this in kernel, so we have no code and no proof
> that it's actually feasible (yet).

K.  I look forward to hearing more.

I switched from OpenVZ years ago to LXC because OpenVZ was falling too
far behind in kernel support and patches for the leading edge kernels.
At the time, I was working on the MD5 signature code for the Quagga
routing suite for BGP and couldn't maintain my hosts with OpenVZ and
maintain my BGP connections (I have a public ASN and peer on both IPv4
and IPv6) with MD5 signatures at the same time.  At the time LXC had
just matured enough to serve my needs.  That's interesting to note that
OpenVZ did this by intercepting the mount call.  Very interesting...

> James

Regards,
Mike
--=20
Michael H. Warfield (AI4NB) | (770) 978-7061 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!


--=-VX5r4UZ06YIx3cTTNghC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU3ZvRsDrlnVnRif/AQiwyQf/bPiEeIxwGSsYNgR24FDa8YRffwZuwuz1
arINyMtsnjopgQ6Oi+xndfhx20KKcX1MJ3izqIZ2+DXafeMMLNzI1wZFXp+K7a2X
9W4KujphufUuTyjD21ezSm69lMEHFvmEWE9UVodth32sSkcQZ1Rvpoe+o8hl15Qe
EgVCRwTurpaDvrq6DKvs1jOXRaF/RDLnwjUXep74h7OyHhQGtnOjH31nmeGaKw43
v9/n6DG7nu8tj+qPWGX3zvvquF5sxx1FyCTRB7NVdW88htIHrZyHWtS57jcj7EFJ
wJFNbm/nTS32PG7TK4/TqjYOXQcqbyc5y7tnQqZ35TfNP4JC4iyYzg==
=qkVs
-----END PGP SIGNATURE-----

--=-VX5r4UZ06YIx3cTTNghC--

