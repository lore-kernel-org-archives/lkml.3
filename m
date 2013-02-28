Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568Ab3B1VNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:13:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab3B1VNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:13:34 -0500
Message-ID: <512FC845.9080209@redhat.com>
Date: Thu, 28 Feb 2013 14:12:37 -0700
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Hu Tao <hutao@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v13 1/8] save/load cpu runstate
References: <cover.1362051581.git.hutao@cn.fujitsu.com> <df20999140db716e8b1ccd57a7cbcb0fa343a78c.1362051582.git.hutao@cn.fujitsu.com>
In-Reply-To: <df20999140db716e8b1ccd57a7cbcb0fa343a78c.1362051582.git.hutao@cn.fujitsu.com>
X-Enigmail-Version: 1.5.1
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="----enig2KGFPHESTKVMQPNTPCTHU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2KGFPHESTKVMQPNTPCTHU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 02/28/2013 05:13 AM, Hu Tao wrote:
> This patch enables preservation of cpu runstate during save/load vm.
> So when a vm is restored from snapshot, the cpu runstate is restored,
> too.

What happens if a management app wants to override the runstate when
restoring the domain?  I can think of several useful scenarios:

1. management app pauses the guest, then saves domain state and other
things (management state, or disk clones), then resumes the guest.
Later, the management wants to revert to the saved state, but have the
guest running right away.  I guess here, knowing that the guest was
saved in a paused state doesn't hurt, since the management app can
resume it right away.

2. management app saves domain state of a live guest, then copies that
state elsewhere.  In its new location, the management app wants to
investigate the state for forensic analysis - so even though the guest
remembers that it was running, management wants to start it paused.
Here, it is important that there must not be a window of time where the
guest can run, otherwise, the results are not reproducible.

--=20
Eric Blake   eblake redhat com    +1-919-301-3266
Libvirt virtualization library http://libvirt.org


------enig2KGFPHESTKVMQPNTPCTHU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCAAGBQJRL8hFAAoJEKeha0olJ0NqiqIH/jhEaYxoEOF5ai1k7Clr+gUZ
wxoQtCASSj4t4JsxpNjAWyDwePtM3lT+E1tiVsgsoCJgc1XcPrYFrLU80NXPo+6u
1BgkqAHsxbRNybLBN458jkWgN/d2ZAplyLbAgCeVfmOTcbTwK3lAqI0rVu3Rh9OQ
6MfagF2WQc/pTqdc90TadtDq3CSQmt5QoW1anzXy8f9NSdUO69w/ZCjbMPm8PMfR
wg++5FavuFQoa/MqUWnK9U/igAww7Qloru13Lp3EV3rMxySSJyu4OaZPcNg7390T
WKheOYEn/W1DC17aTqEmoN3+Tq34FZUln0rv42176Z+foc4x2Qcim2hIPLSI39E=
=+51e
-----END PGP SIGNATURE-----

------enig2KGFPHESTKVMQPNTPCTHU--
