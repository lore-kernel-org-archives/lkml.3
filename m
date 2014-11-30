Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaK3MP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:15:26 -0500
Received: from sender1.zohomail.com ([74.201.84.155]:30156 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaK3MPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:15:23 -0500
Content-Type: multipart/signed; boundary="Apple-Mail=_8267B5A9-37FA-479F-9D68-638F2F432CBE"; protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC PATCH 0/3] Generic TrustZone Driver in Linux Kernel
From: =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>
In-Reply-To: <20141129181853.GR22670@titan.lakedaemon.net>
Date: Sun, 30 Nov 2014 13:14:59 +0100
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, joshc@codeaurora.org,
        johannes.thumshirn@men.de, kheitke@codeaurora.org,
        laurent.pinchart+renesas@ideasonboard.com, geert+renesas@glider.be,
        horms+renesas@verge.net.au, damm@opensource.se, tomi.valkeinen@ti.com,
        mbohan@codeaurora.org, michal.simek@xilinx.com, pawel.moll@arm.com,
        Andrew.Thoelke@arm.com
Message-Id: <F965244C-56B6-47AD-908D-CE392D3BDC8D@javigon.com>
References: <1417187016-7731-1-git-send-email-javier@javigon.com> <20141129181853.GR22670@titan.lakedaemon.net>
To: Jason Cooper <jason@lakedaemon.net>
X-Mailer: Apple Mail (2.1878.6)
X-Zoho-Virus-Status: 1
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_8267B5A9-37FA-479F-9D68-638F2F432CBE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

Jason,

On 29 Nov 2014, at 19:18, Jason Cooper <jason@lakedaemon.net> wrote:

> Javier,
>=20
> On Fri, Nov 28, 2014 at 04:03:33PM +0100, Javier Gonz=E1lez wrote:
>> Hi all,
>>=20
>> This set of patches is a first iteration to introduce a generic
>> TrustZone driver to the Linux Kernel. Since there is no place to add
>> drivers related to secure processors, a new subsystem for secure
>> hardware in general (drivers/sechw) is also introduced. TPM is a good
>> candidate to me moved here if this change is accepted.
>>=20
>> Today, TrustZone solutions are implementation specific. In user =
space,
>> mobile devices are normally compliant with Global Platform's API
>> <http://www.globalplatform.org>. However, there is no common =
TrustZone
>> interface for kernel space, as it exists for Trusted Computing Module
>> (TPM). As a result, different TrustZone frameworks use different =
kernel
>> loadable modules to provide the context to communicate with the =
Trusted
>> Execution Environment leveraged by TrustZone's secure world.
>>=20
>> Regarding use cases, TrustZone has traditionally been used for
>> offloading secure tasks to the secure world. Examples include banking
>> applications, Digital Rights Management (DRM), or specific secure
>> solutions. As more and more frameworks enabling TrustZone appear, new
>> use cases are starting to emerge: key management, encryption, =
integrity
>> checking, etc. Extreme cases today involve running a RTOS in the =
secure
>> world, or using the secure world toimplement usage control policies
>> governing the normal world. The advent of ARMv8 will only expand this
>> list.
>>=20
>> This set of patches introduce a generic TrustZone driver for kernel
>> space. The first design goal is to be flexible enough as to NOT
>> introduce policy regarding the TrustZone interface. In this way, we
>> introduce a session-based open/close read/write interface where
>> several TrustZone drivers can potentially be used. The design is
>> simple and it consist on an interface that different TrustZone =
drivers
>> can implement to communicate with the specific frameworks.
>>=20
>> Major TODO's:
>> * Patch has TODOs, FIXMEs and XXXs that need to be cleaned.
>> * Refactor part of Open Virtualization's driver. Some part are =
complex
>> * and can be simplified.
>> * Add support for different boards. At the moment only zynq-7000 =
ZC702
>> is supported. A sepparate patch containing the patch for ZC702 will =
be
>> sent sepparately - rebasing from 3.8 to 3.17 at the moment.
>>=20
>> Development is taking place at:
>> 	https://github.com/TrustZoneGenericDriver/linux-xlnx tz_driver
>> At 14.5_trd_tz_driver_generic it can be found the same driver =
together
>> with TEE support for Zynq ZC702 in 3.8
>>=20
>> Since all testing is being done in the Xilinx ZC702 board, using
>> Xilinx's Linux tree is convenient. Once the board rebasing to 3.17 is
>> completed, development will move to:
>> 	https://github.com/TrustZoneGenericDriver/linux
>>=20
>> Feedback regarding the code, the interface, or its placement in
>> drivers/sechw is more than welcome. The idea is to refine ths =
TrustZone
>> driver while working on supporting more targets.
>=20
> Please add me to the Cc: on future revisions.
>=20
Sure thing.

> You don't mention a mailinglist.  Is there one for this project?  =
Also,
> TrustZone is a specious marketing name. =20

There is no mailing list yet, but I will create one that I will share =
along with
the next patch revision. For now I rely on github=92s issue tracker as a =
meeting=20
point for people interested in the driver.=20

> For those of us not actively
> working with it, wtf is it in engineering terms?  Apparently it can do
> virtualization w/o virtualization extensions?

TrustZone is a set of security extensions present in Cortex-A ARM =
processors.
In general terms it provides an extra privilege mode, so you can think =
of a=20
TrustZone-enabled processor as having user space, kernel space, and =
secure
space. Normally the execution environment running in secure space is =
referred
to as secure world; the rest is referred to as normal world.

Today, there is a number of frameworks that leverage TrustZone (it has =
been
out for 10 years now=85). Some of these frameworks adhere to ARM mobile =
use=20
cases (e.g., banking, DRM), and implement Global Platform=92s API for =
user space=20
applications; others use TrustZone as a =93cheap=94 way of providing =
paravitualization.=20
For example, I know that some are using TrustZone to support a RTOS =
running=20
in the secure world, parallel to the normal world. Still, TrustZone =
*does not* provide
hardware virtualization, so in the latter case performance can become an =
issue.

Independently from the use case, each framework implements its own =
driver to
switch worlds. This is normally done as a loadable module. There are two =
issues
with the current situation:=20
(i) While user applications can be ported from one framework to another =
- as long=20
as both (apps and frameworks) support Global Platform=92s API-, kernel =
submodules=20
cannot, due to the lack of a common kernel interface. As a product, =
people using=20
TrustZone end up having to patch their kernels with specific interfaces =
for the=20
framework(s) they want to support. Apart from the engineering nightmare, =
this=20
prevents kernel submodules from providing generic secure services (e.g., =
secure
storage, key management, attestation) that could potentially be provided =
in ARM=20
processors. IMA is an example of a module that would benefit from this =
from day=20
one.
(ii) The lack of a kernel interface also prevents TrustZone adoption in =
the open=20
source community. I personally think this is a big issue. If we had such =
an interface=20
drivers for the few open source frameworks leveraging TrustZone will =
rapidly be=20
ported and most probably TrustZone=92s adoption would expand quickly. =
Hopefully=20
this would also mean that more secure/trusted services would appear and =
spread quickly.

Here, you need to understand that TrustZone *only* provides the secure =
world, it=20
does not provide any specification for the secure tasks. On the down =
side this
means that TrustZone cannot be used as a Trusted Platform Module (TPM) - =
which
does  provide an specification. On the good side, the possibilities are =
unlimited. I
think of the secure world as a way of providing =93secure system =
primitives=94 which
can be seen as secure system calls. These can evolve with time and =
provide new
secure services by simply providing software updates. Before we get =
there however,
we need a generic TrustZone driver interface as the one I propose.=20

=46rom an engineering perspective, the challenge is to provide an =
interface that does
not introduce policy for the TrustZone use cases. My proposal is a =
simple open/close
read/write interface where kernel submodules can open a connection to =
the secure=20
world and send commands to it. These commands respond to the secure =
system=20
primitives. User applications can also use this through a Global =
Platform=92s API exposed
to user space. I have implemented part of the API to test my driver. It =
works and
performs pretty good.

There is also an extra challenge that is not covered in these patches. =
In TrustZone,=20
any device can potentially be mapped to the secure world at boot time. =
This means=20
that the memory for each device needs to be mapped to a different =
address space=20
depending on the world the device belongs to. This is difficult to =
generalise since the=20
base addresses for each device are target-specific Here, the frameworks =
I know=20
directly hardcode addresses. I have approached this issue by adding a =
tag to each=20
device in the device tree where the world to which they are mapped to is =
specified.=20
Then, when the devices are given I/O memory at boot time this tag is =
used to assign=20
them to different base addresses, therefore allowing the secure world to =
control them.
I have it working on 3.8 for the Zynq ZC702. I am not porting it to =
3.17. This is a=20
different problem, and I will send these patches when they are ready. I =
mention it here=20
for completeness.

> Wouldn't a lot of the trustworthiness depend on the lack of
> vulnerabilities in this API or other communications interfaces?  Can =
end
> users choose to load a different binary (say, OpenVZ) than the DRM =
that
> came with the phone?  How is that handled?  How does this fit into a
> trusted boot sequence?

The API is definitely an attack vector, and it needs to be clean and =
well tested. However,
it all depends on the attack model. If we assume a malicious root, then =
the kernel can
be compromised even if the interface is bug-free. Here we enter in how =
to design the
secure world tasks and interfaces (in the secure side) so that it can =
detect malicious=20
behaviour and be resilient. My research is focused on how to approach =
these issues
using a usage control engine in the secure world to monitor the kernel=92s=
 activity (i.e,=20
memory, crypto operations, etc.). I attach a presentation where I =
describe these
issues [1].

Regarding using different binaries, the answer is not simple. Today, it =
is not very
probably since most phones are locked to specific first stage boot =
loaders. If we
assume that this is not an issue, not counting on a common interface =
from within the
kernel makes switching the framework leveraging TrustZone not viable. I =
attach also
an article where we describe how this can be done using TrustZone and a =
Secure
Element [2]. This is one of the use cases in which the TrustZone driver =
I am sending is
being used.=20


On 29 Nov 2014, at 19:48, Greg KH <gregkh@linuxfoundation.org> wrote:

> On Sat, Nov 29, 2014 at 01:18:53PM -0500, Jason Cooper wrote:
>>=20
>> And as GregKH mentioned, this definitely needs some cleanup before
>> expecting others to spend time reviewing.  If this code is working =
for
>> your usecase, perhaps the staging tree might be a better place to
>> start.
>=20
> No, it needs lots of work before the staging tree can accept it (hint,
> the FIXMEs are good places to start...)

It does. All the FIXMEs are however located in the driver I ported for =
Open Virtualization.
I will work on it from monday and hopefully submit a new version by the =
end of next week.
Getting a version of the driver in the staging tree would be a good =
start, also to get good
feedback from more experienced kernel people :)

I would however appreciate having early feedback on:=20
(i) The interface itself: drivers/sechw/trustzone/trustzone.c
(ii) Creating a new submodule for secure hardware, where TPM could =
potentially be moved.


>=20
> thx,
>=20
> Jason.

Attachements:
[1]  http://www.itu.dk/people/jgon/XSWG_runtime_security-Oct20.pdf
[2]  =
http://www.researchgate.net/publication/267039927_A_Practical_Hardware-Ass=
isted_Approach_to_Customize_Trusted_Boot_for_Mobile_Devices

Best,

p.s. Sorry for double sending. I answered from my personal laptop and =
forgot setting plain text...

Javier

> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




On 29 Nov 2014, at 19:18, Jason Cooper <jason@lakedaemon.net> wrote:

> Javier,
>=20
> On Fri, Nov 28, 2014 at 04:03:33PM +0100, Javier Gonz=E1lez wrote:
>> Hi all,
>>=20
>> This set of patches is a first iteration to introduce a generic
>> TrustZone driver to the Linux Kernel. Since there is no place to add
>> drivers related to secure processors, a new subsystem for secure
>> hardware in general (drivers/sechw) is also introduced. TPM is a good
>> candidate to me moved here if this change is accepted.
>>=20
>> Today, TrustZone solutions are implementation specific. In user =
space,
>> mobile devices are normally compliant with Global Platform's API
>> <http://www.globalplatform.org>. However, there is no common =
TrustZone
>> interface for kernel space, as it exists for Trusted Computing Module
>> (TPM). As a result, different TrustZone frameworks use different =
kernel
>> loadable modules to provide the context to communicate with the =
Trusted
>> Execution Environment leveraged by TrustZone's secure world.
>>=20
>> Regarding use cases, TrustZone has traditionally been used for
>> offloading secure tasks to the secure world. Examples include banking
>> applications, Digital Rights Management (DRM), or specific secure
>> solutions. As more and more frameworks enabling TrustZone appear, new
>> use cases are starting to emerge: key management, encryption, =
integrity
>> checking, etc. Extreme cases today involve running a RTOS in the =
secure
>> world, or using the secure world toimplement usage control policies
>> governing the normal world. The advent of ARMv8 will only expand this
>> list.
>>=20
>> This set of patches introduce a generic TrustZone driver for kernel
>> space. The first design goal is to be flexible enough as to NOT
>> introduce policy regarding the TrustZone interface. In this way, we
>> introduce a session-based open/close read/write interface where
>> several TrustZone drivers can potentially be used. The design is
>> simple and it consist on an interface that different TrustZone =
drivers
>> can implement to communicate with the specific frameworks.
>>=20
>> Major TODO's:
>> * Patch has TODOs, FIXMEs and XXXs that need to be cleaned.
>> * Refactor part of Open Virtualization's driver. Some part are =
complex
>> * and can be simplified.
>> * Add support for different boards. At the moment only zynq-7000 =
ZC702
>> is supported. A sepparate patch containing the patch for ZC702 will =
be
>> sent sepparately - rebasing from 3.8 to 3.17 at the moment.
>>=20
>> Development is taking place at:
>> 	https://github.com/TrustZoneGenericDriver/linux-xlnx tz_driver
>> At 14.5_trd_tz_driver_generic it can be found the same driver =
together
>> with TEE support for Zynq ZC702 in 3.8
>>=20
>> Since all testing is being done in the Xilinx ZC702 board, using
>> Xilinx's Linux tree is convenient. Once the board rebasing to 3.17 is
>> completed, development will move to:
>> 	https://github.com/TrustZoneGenericDriver/linux
>>=20
>> Feedback regarding the code, the interface, or its placement in
>> drivers/sechw is more than welcome. The idea is to refine ths =
TrustZone
>> driver while working on supporting more targets.
>=20
> Please add me to the Cc: on future revisions.
>=20
> You don't mention a mailinglist.  Is there one for this project?  =
Also,
> TrustZone is a specious marketing name.  For those of us not actively
> working with it, wtf is it in engineering terms?  Apparently it can do
> virtualization w/o virtualization extensions?
>=20
> Wouldn't a lot of the trustworthiness depend on the lack of
> vulnerabilities in this API or other communications interfaces?  Can =
end
> users choose to load a different binary (say, OpenVZ) than the DRM =
that
> came with the phone?  How is that handled?  How does this fit into a
> trusted boot sequence?
>=20
> And as GregKH mentioned, this definitely needs some cleanup before
> expecting others to spend time reviewing.  If this code is working for
> your usecase, perhaps the staging tree might be a better place to
> start.
>=20
> thx,
>=20
> Jason.
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Apple-Mail=_8267B5A9-37FA-479F-9D68-638F2F432CBE
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJUewpEAAoJEDxGAX0tJXjg4kwQALuUe2+oYrOkMVpl8R/6Ivng
QURhHKjM0au/0fYf+kmPXqF/V4qSQFHnROnruQ+9URjpEeTWvTzkazXpzDlGcURZ
04tQJtWWDjLOveHegiDCLe8UDv0IufR+FbHl3ZHxMPEgf+FOOOWe/lcTLmSu9oww
hs8JiHv3b4kRJRWR+KpHfPDVlDi+KZP0fGqenq1jOg//YQjfvwlA8Pn71j+ZC7+G
CnTFOay1G8nxMrkOhxXFKZXGBhJUGjUbs3oLjnyqCQt+24DuOkwCv1usdj53Z0gK
wec5pUm45g/Z8xP8kV+gJcJTd3ylBBZ+DmxU6yZ4ZodvwAnU41aTRjP9JSIdarY+
ktl/Xv+EB3jm3HsZNpTW4VvTHqAOSxhaCbXZP2xNv4pqHXGimkk24GWJH5fm1kV6
IW0WuuY3pqxAb/S9SdBLuVmY6DeXs9ZUALypfNKpuP02FgiJEX8byCQ/87/xDhMD
pWzcrlxvvBb8FqzqVmcI0aH++k931nTWLk66nwHcBHJkV5zt2pEKXTOYSa/lgs8j
1hVFWv1jFztJ8SLqirahgAVOntQO/MfhQBgHYHp2KlUIqCnpYjnC3jSUhhcTGmpJ
phcCQNWlXnN7nn2IPckEoKe8bmTSjeYkKwZTACKV7tX+XZmBWiBkyS45cmd+y9Qr
c1hRfy6swdbMg2NXHDDL
=MCQb
-----END PGP SIGNATURE-----

--Apple-Mail=_8267B5A9-37FA-479F-9D68-638F2F432CBE--

