Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbaJBGd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 02:33:57 -0400
Received: from sauhun.de ([89.238.76.85]:55781 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbaJBGdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 02:33:54 -0400
Date: Thu, 2 Oct 2014 08:34:23 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Rajat Jain <rajatxjain@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>
Subject: Re: [PATCH 0/4] Driver for talking to PLX PEX8xxx PCIe switch over
 I2C
Message-ID: <20141002063423.GA1405@katana>
References: <542A3593.4020108@gmail.com>
 <CAErSpo7BkXDHOZwHzwEu2BN3=39xFwQOyrjgVo6afWKMsnYT=A@mail.gmail.com>
 <20140930211339.GA1264@katana>
 <CAA93t1out+gJO29_0tn1zLJv_MUwJ458XKNT3Lo6WW+mH9XeRQ@mail.gmail.com>
 <20141001072949.GA1322@katana>
 <CAA93t1qjzAWQqkZQcJYFZxvuhy6o1N2gJ+j=AKgcqE=zup=BJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <CAA93t1qjzAWQqkZQcJYFZxvuhy6o1N2gJ+j=AKgcqE=zup=BJw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> I understand and agree. In fact in the internal version of this driver
> (that I have not yet sent out for review), we do have APIs added
> similar to what you mention above. Currently I have APIs that:
> - Enable / Disable PCIe links.
> - Change the upstream port.
> - Enable / Disable Non-transparent mode etc.

Now, that sounds better to me...

> However, I did not send them all out for review because I don't have
> the hardware to try and test them out on ALL the supported devices
> (also would require considerable amount of time). I have tested those
> APIs on PEX8713 only, because for e.g.I only have PEX8713 in a HW that
> connects to 2 CPUs at the same time.

That is a common problem to not have enough hardware to test. You could
ask on the PCI mailing list for testers. The solution usually lies in
showing the code rather than not showing the code.

> the switch. Yes, I agree that we can have another layer of abstraction
> so that we have:
>=20
> - The Core logic code (that knows "How do we want the switch to behave")
> - A PEX8xxx driver (that knows "which registers to program")
> - A PEX8xxx I2C driver ("How to program those registers") - this driver.
>=20
> I do understand that your suggestion is to include and bundle the
> latter two into this same driver.

It definately should be this way. Nobody else than the PEX8xxx driver
should be able to send I2C messeges to the device! And this is
absolutely standard, the logic how to talk to a device knows also how to
prepare the I2C messages. One reason where it could be factored out is
if there are multiple ways of transportation possible, like I2C or SPI.

> However since the possibilities
> (about which APIs to provide) are too much and not enough hardware to
> test it, would it be acceptable if I include those APIs, but support
> them for only 1 device (and return error for others)?

Start with what YOU need and show us (all of it). From there, we can
decide: do we start with one driver and factor out later, do we start
with a sub-subsystem right away, etc... And there is still the question
what APIs you provide, how they are implemented and if we really should
have them in-kernel. I think that question will be more interesting for
Bjorn because I don't really know much about switches in the PCI world.

> with those APIs, I feel exposing the Read/Write APIs will be useful -
> because what core logic wants to achieve can be highly device and
> platform specific.

That could also be solved by fixup-callbacks, but we'd need to see the
core to tell, really.

> Also, a sysfs interface for this switch is proving
> to be a very helpful development aid :-) (personal experience :-))

Sure, but such development aids don't need to be upstream. Especially if
they create ABI such as sysfs-entries.

Thanks and regards,

   Wolfram

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULPHvAAoJEBQN5MwUoCm2AvEQALNdxeOaK75eMJ4CmFtDgC2Z
w6VttS2nU4LsgvyvhbaseTGxAGRPxee3kvNegG6s3yqf+U3F8yXs+JAiN+xV/QlK
jjqsWE6hS+0MN8BFSb10gWaxkfiJbQtQc6r4V3H4Ty9enx4pfhY2MLZ7VReZJspb
FnWmUFYv9YvCKibIn0G5sNNT/stuT/JXvlruHHh9Y67NPNYkQAyQsLj589ATfdd7
AOgy2eHOi4khWO2uaw1Zv7ePFY8G1xOaH+0PboLGmj+Hjc8VyZaqc9WEnfXaMYAX
eHW6e/tVQnTO9ANNctCka40V+wJuEmYJ8dIJW8M30zlPo6ZWsgeYVGsLDQBRUHds
7z+NvE3wuipRo1mZz7jnv4BxPqbgnjoM7+p0A0YHoSJL7wY1vJUVxctqSkRfpvxa
ros+J1LRORSkUMNiTN4KibRtGx+B7OUUCaRvF13nzg/ShLBURrVU0uzUOhyWOnTs
TTzqH+JsUShVQbGVzO6Q3Xx+4G1bNl7lgTDvN4U6aqx3jYiutH/WulHIcuVelWdi
DaRB5ZVS3xWiT3zeOLXdgFafCsBVyxJLNqUC5F1kSopwvjMjNdL0kByD92ln/OlL
y2LDpadOjUgO2sve/kQdP4PmK9XDAO+E+oearykXVhezhHk1N617W/W5C77WJo5q
9EVeALqmZbhgAeHFMic8
=AWkh
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
