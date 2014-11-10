Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaKJJgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:36:45 -0500
Received: from mout.web.de ([212.227.15.3]:60179 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaKJJgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:36:44 -0500
Message-ID: <5460870C.9010109@web.de>
Date: Mon, 10 Nov 2014 10:36:12 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: AMR: sun7i: CPU hotplug support?
References: <545FC215.7010802@web.de> <20141109231744.GC2989@lukather> <5460554A.1060701@web.de> <5460766B.8070000@web.de> <546082A8.60401@arm.com>
In-Reply-To: <546082A8.60401@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="7iFXEwL2CGUWMbS4UcVh9JmihJNKHqOVq"
X-Provags-ID: V03:K0:qHIblZ2DNXt2vbnE+JXTrrjJ9n8VYS9xZdYgjFAu0hHpK7u2tkZ
 e7/yTuPzOR9sJ5ZdOOKhoPRrHDlV286IFVF6hcJGCJvDshI8q5z3iuezCcKJl3n6cMloTro
 2UCAXZTMJDKVJDQbArxpoKDlGazof4okut3lLXy9xUB13tvZdfHW98RhLusuAvVMqYj8nSm
 koRS0B8mXifum2vY83QVQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7iFXEwL2CGUWMbS4UcVh9JmihJNKHqOVq
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2014-11-10 10:17, Marc Zyngier wrote:
> On 10/11/14 08:25, Jan Kiszka wrote:
>> On 2014-11-10 07:03, Jan Kiszka wrote:
>>> On 2014-11-10 00:17, Maxime Ripard wrote:
>>>> Hi Jan,
>>>>
>>>> On Sun, Nov 09, 2014 at 08:35:49PM +0100, Jan Kiszka wrote:
>>>>> did anyone already happen to look into enabling CPU hotplug
>>>>> for the Allwinner A20 in upstream? I'm currently running the
>>>>> sunxi-next branch on Banana Pi, and echo 0 > .../cpu1/online
>>>>> just hangs the system. The old 3.4 LeMaker kernel works fine
>>>>> in this regard. I can try to look into details and port
>>>>> things over, just want to avoid duplicate efforts.
>>>>
>>>> Having hotplug support would indeed be very welcome.
>>>>
>>>> However, it should be done in u-boot, through PSCI, and not in
>>>> the kernel itself.
>>>>
>>>> As far as I'm aware, no one worked actively on it, beside some
>>>> WIP commit from Marc a while ago:=20
>>>> https://git.kernel.org/cgit/linux/kernel/git/maz/u-boot.git/commit/?=
h=3Dwip/psci&id=3D45379c0f9cf812f0f62722f4015ec907fa5dc144
>>>
>>>
>>>>
> OK - I guess I will need a little guidance in then: Is there a good
>>> reference board to study and to derive from? And maybe also: What
>>> is missing or not working in that u-boot branch? If I get this
>>> interface right, I just takes some device tree bits to enable
>>> this for the kernel afterward, correct?
>>
>> Started to play with that patch in naive ways: CPU0 locks up when=20
>> offlining CPU1 - unless I disable the FIQ signal from CPU1. Then
>> it "works", both offlining and onlining again. However, I suspect
>> that this only parks CPU1 in wfi and does not do anything
>> interesting to it.
>=20
> Here's how this is supposed to work:
> - CPU1 sends a FIQ to CPU0, bringing it into secure mode.
> - CPU0 then kills CPU1 by doing the magic incantations on the power
> controller
>=20
> What is missing here is all the cache cleaning before signalling CPU0.
> If you add that, things should look a lot better (patches welcome).

Unsure about this, or maybe this was too simplistic: I added calls to
u-boot's flush_dcache_all and invalidate_icache_all (right after
disabling the cache, just like the vendor kernel does), but CPU0 still
locks up. I suspect there is still a bug in the FIQ handling. There is
also a suspicious single "@" printed on the console. I'll play with the
FIQ handler a bit.

Jan



--7iFXEwL2CGUWMbS4UcVh9JmihJNKHqOVq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlRghw0ACgkQitSsb3rl5xSXHwCeNscZ5LsgcfKmZO7cNtNXDjUW
AncAnif0LKcQ+2ChXFcqgS3YswZwkn63
=p8rb
-----END PGP SIGNATURE-----

--7iFXEwL2CGUWMbS4UcVh9JmihJNKHqOVq--
