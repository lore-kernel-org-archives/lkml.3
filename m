Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3CAQai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:30:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab3CAQag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:30:36 -0500
Message-ID: <5130D760.70908@redhat.com>
Date: Fri, 01 Mar 2013 09:29:20 -0700
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
References: <cover.1362051581.git.hutao@cn.fujitsu.com> <df20999140db716e8b1ccd57a7cbcb0fa343a78c.1362051582.git.hutao@cn.fujitsu.com> <512FC845.9080209@redhat.com> <20130301073648.GD16362@localhost.localdomain>
In-Reply-To: <20130301073648.GD16362@localhost.localdomain>
X-Enigmail-Version: 1.5.1
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="----enig2IQQMSOUPJIDWITKASEXF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2IQQMSOUPJIDWITKASEXF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03/01/2013 12:36 AM, Hu Tao wrote:
> On Thu, Feb 28, 2013 at 02:12:37PM -0700, Eric Blake wrote:
>> On 02/28/2013 05:13 AM, Hu Tao wrote:
>>> This patch enables preservation of cpu runstate during save/load vm.
>>> So when a vm is restored from snapshot, the cpu runstate is restored,=

>>> too.
>>
>> What happens if a management app wants to override the runstate when
>> restoring the domain?  I can think of several useful scenarios:
>>
>> 1. management app pauses the guest, then saves domain state and other
>> things (management state, or disk clones), then resumes the guest.
>> Later, the management wants to revert to the saved state, but have the=

>> guest running right away.  I guess here, knowing that the guest was
>> saved in a paused state doesn't hurt, since the management app can
>> resume it right away.
>>
>> 2. management app saves domain state of a live guest, then copies that=

>> state elsewhere.  In its new location, the management app wants to
>> investigate the state for forensic analysis - so even though the guest=

>> remembers that it was running, management wants to start it paused.
>> Here, it is important that there must not be a window of time where th=
e
>> guest can run, otherwise, the results are not reproducible.
>=20
> -S takes precedence in the case. But for in-migration, runstate is
> loaded from src.

Given your answer, I think we're okay from the libvirt perspective.  My
biggest worry about a window where the guest runs unchecked is not a
problem, given that libvirt always uses -S on incoming migration.  In
turn, libvirt has its own mechanisms for tracking whether the outgoing
migration was started from a running state, along with API overrides to
let a user override whether libvirt will resume the guest on the
incoming migration side.

--=20
Eric Blake   eblake redhat com    +1-919-301-3266
Libvirt virtualization library http://libvirt.org


------enig2IQQMSOUPJIDWITKASEXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCAAGBQJRMNdgAAoJEKeha0olJ0Nq0kEH/1SbK8p7fVUNjgKkqfpK8gb1
x/VQR88hsWDEeYO9wzaWjUIlS081QVm39kcGyeuYQFqtKA3ixUvIIuEDbtyzOS37
IQWQpwU0C/ILluJrQaqEFD77HwJAMi86SNVuQA2KvYOYXZrJIzKn5Q5ads1vDnPy
pCv9nbwmu2kWc1rcXa9MPXqYq1yowsW5AWW0VM3m8tFIgc8VJbiSH/Ulku7KpzEu
u0Xqun7tKOsF29l5TxMWwDPuSi/iPTovwpngz00VPQiMt5vrgj0rhA7Uj7xlWxyW
DDT7Lf8OLlGbLEBsDAMDz0uwV5gZjl0ewaa5WIfGq+sYlfu0Lt1mzE+Ovq7R9r0=
=F9rp
-----END PGP SIGNATURE-----

------enig2IQQMSOUPJIDWITKASEXF--
