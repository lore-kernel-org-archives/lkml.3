Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbaCKM7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:59:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55594 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbaCKM7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:59:48 -0400
Message-ID: <531F08A8.300@ti.com>
Date: Tue, 11 Mar 2014 14:59:20 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>, Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <4339286.FzhQ2m6hoA@avalon> <1394466030.7380.39.camel@paszta.hi.pengutronix.de> <139468148.3QhLg3QYq1@avalon>
In-Reply-To: <139468148.3QhLg3QYq1@avalon>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="uIoXKG4L0FGC5u25cX9N5vjOwtAIqXOPu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uIoXKG4L0FGC5u25cX9N5vjOwtAIqXOPu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/03/14 13:43, Laurent Pinchart wrote:

>> We could scan the whole tree for entities, ports and endpoints once, i=
n
>> the base oftree code, and put that into a graph structure, adding the
>> backlinks.
>> The of_graph_* helpers could then use that graph instead of the device=

>> tree.
>=20
> That could work. The complexity would still be quadratic, but we would =
parse=20
> the full device tree once only.
>=20
> The runtime complexity would still be increased, as the graph helpers w=
ould=20
> need to find the endpoint object in the parsed graph corresponding to t=
he DT=20
> node they get as an argument. That's proportional to the number of grap=
h=20
> elements, not the total number of DT nodes, so I suppose it's not too b=
ad.
>=20
> We also need to make sure this would work with insertion of DT fragment=
s at=20
> runtime. Probably not a big deal, but it has to be kept in mind.

About the endpoint linking direction... As I think was suggested, the
base logic would be to make endpoints point "outward" from the SoC, i.e.
a display controller would point to a panel, and a capture controller
would point to a sensor.

But how about this case:

I have a simple video pipeline with a display controller, an encoder and
a panel, as follows:

dispc -> encoder -> panel

Here the arrows show which way the remote-endpoint links point. So
looking at the encoder, the encoder's input port is pointed at by the
dispc, and the encoder's output port points at the panel.

Then, I have a capture pipeline, with a capture controller, an encoder
(the same one that was used for display above) and a sensor, as follows:

camc -> encoder -> sensor

Again the arrows show the links. Note that here the encoder's _output_
port is pointed at by the camc, and the encoder's _input_ port points at
the sensor.

So depending on the use case, the endpoints would point to opposite
direction from the encoder's point of view.

And if I gathered Grant's opinion correctly (correct me if I'm wrong),
he thinks things should be explicit, i.e. the bindings for, say, an
encoder should state that the encoder's output endpoint _must_ contain a
remote-endpoint property, whereas the encoder's input endpoint _must
not_ contain a remote-endpoint property.

 Tomi



--uIoXKG4L0FGC5u25cX9N5vjOwtAIqXOPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHwioAAoJEPo9qoy8lh713pAP/10AQg3PVnoeV4zrDxvgv5RR
GDd96Y2TI1zUW3lzKfkIlw2SlOZi+9KTBYPomsPHhzzltSI5InVt7rAbbxXO5nPI
IFDVOSZ2ZhoKgztGjB3RS8mnqh3dSzUl1DqBRpc7zh6WcLrcHeVlUA0Oi5ewJmcc
aeRhjZkB7hSyk30fq+PB1LcyNhYqbREPcKJhUfWltvQF/lJJAuU/IwE0zpUub3B6
THCUjW0jgp4znPlAUw0NcF5n8UpyEG82ykymv8PpZ9gEkdRrP6ZOnXz7qxgUFrsa
mRj57I4FTDde0jgHuxhLvrWTY84PeuKnwi4bMSm9do3u/A8OA8guo+tE/F7SihIK
JqxRxooKblSSbWCBxcqV7my7Gu0zIr1YaEeLEC+bpOZvZQG3R2TyjZ602KFZOmlu
XHJlfhp+SHuwn9qVKcnEhloQyL5XB+1q8r80du1B/NWZIzhFUe21htfpBwCQVzeB
nsql9iXKue+zvHM8RB+nD5MUAO1QYz86pctOl1WBu3OFbmBdJ5UzyeQQOHOKkNZs
n7JdtqvcxyAlHK6JlHpWqD0mchAP+CacgTyHrUxy9bxeN+s9ZtzSmaX5eoHnoz7I
3vKV2yomPfOCyVCcWVAG+TOy2v+/0m+Djm+ftAKlNEwknGgrSJo6DnFOkcQyMxSj
FL0Aakd1Zpwe4EsDL1NB
=Npn6
-----END PGP SIGNATURE-----

--uIoXKG4L0FGC5u25cX9N5vjOwtAIqXOPu--
