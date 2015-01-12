Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbbALMfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:35:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60526 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbbALMfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:35:00 -0500
Message-ID: <54B3BF6C.4000004@pengutronix.de>
Date: Mon, 12 Jan 2015 13:34:52 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
CC: Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] can: kvaser_usb: Add support for the Usbcan-II
 family
References: <20141223154654.GB6460@vivalin-002> <20150105174910.GA6304@linux> <20150105175206.GB6304@linux> <20150105175713.GC6304@linux> <20150105183131.GD6304@linux> <54AE6FC1.6050007@pengutronix.de> <20150108151901.GA11398@vivalin-002> <54B3B555.5010804@pengutronix.de> <20150112122619.GD9213@linux>
In-Reply-To: <20150112122619.GD9213@linux>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="T0LURvIkHTpnhlvomdKmUGfCCmAGA2loP"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T0LURvIkHTpnhlvomdKmUGfCCmAGA2loP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/12/2015 01:26 PM, Ahmed S. Darwish wrote:
> On Mon, Jan 12, 2015 at 12:51:49PM +0100, Marc Kleine-Budde wrote:
>> On 01/08/2015 04:19 PM, Ahmed S. Darwish wrote:
>>
>> [...]
>>
>>>>>  MODULE_DEVICE_TABLE(usb, kvaser_usb_table);
>>>>> @@ -463,7 +631,18 @@ static int kvaser_usb_get_software_info(struct=
 kvaser_usb *dev)
>>>>>  	if (err)
>>>>>  		return err;
>>>>> =20
>>>>> -	dev->fw_version =3D le32_to_cpu(msg.u.softinfo.fw_version);
>>>>> +	switch (dev->family) {
>>>>> +	case KVASER_LEAF:
>>>>> +		dev->fw_version =3D le32_to_cpu(msg.u.leaf.softinfo.fw_version);=

>>>>> +		break;
>>>>> +	case KVASER_USBCAN:
>>>>> +		dev->fw_version =3D le32_to_cpu(msg.u.usbcan.softinfo.fw_version=
);
>>>>> +		break;
>>>>> +	default:
>>>>> +		dev_err(dev->udev->dev.parent,
>>>>> +			"Invalid device family (%d)\n", dev->family);
>>>>> +		return -EINVAL;
>>>>
>>>> The default case should not happen. I think you can remove it.
>>
>>> It's true, it _should_ never happen. But I only add such checks if
>>> the follow-up code critically depends on a certain `dev->family`
>>> behavior. So it's kind of a defensive check against any possible
>>> bug in driver or memory.
>>>
>>> What do you think?
>>
>> The kernel is full of callback functions, if you have a bit flip there=

>> you're in trouble anyways. A bug in the driver (or other parts of the
>> kernel) might overwrite the memory of dev->family, but if this happens=
,
>> more things will break.
>>
>=20
> I see. Thanks for the explanation.
>=20
> Most of them are now removed in latest submission, except two to
> avoid GCC warnings of variables that "may be used uninitialized".

Thanks, I'll look at the code later and try to figure out what gcc's
problem might be.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--T0LURvIkHTpnhlvomdKmUGfCCmAGA2loP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUs79sAAoJECte4hHFiupUfqIQAJxCHPt1UzhgEQVZNt0ONQY/
0PKUDb3ekgok4PyTJk5YZvwbAksKUqXithIcjognePZeKyPcPJkslEjoDp0lmtt4
OBumJIHzlm38Udop7d8wSZBatVr0CkkkBvI/xWEy0kKOj6aQ9sQqTbDkQ86ZjRFs
qi6X8qpfUzOH5ZSqR80VBw41bBDiqdzuQ+tKAxUK5+5ZtubkBKrXSic6COavYP30
AV8xXWWt9u3+1OM/Exdjd6tUs1W/7zUJxjK8idYkcsn7TKD+RBJVL7e2XSWmolAq
k1bW+aIo2oMRDxiVFwCkBR49s0LgN9QGQ6BIEAwLid3WWGYKcluFMaRD4WfvaCwI
vfuFL7mXjz16e8Wi4ntzjYp9hjJR1aBKznU28QkXXjJeG4LMVL2I+MRQiawInjKT
KPXR9M1lh+nL33OV14wIe62/bC8tzOpqzVdmasUyQ1STsDNIOR9xaAsj66t0NH1l
io+CwdnCpxVaL6c4uvwfa0WV4Yd1dwR08TYS8e8JSikKX+vHYNstTruG9JNAq0Pl
X8xBdnu2HsYuBtrM0azHp4KsKmLYSAj/2to3nbdmrk400JuVd0YqAx1IjFrbOz9u
aPuu58UBKxm6YrH+tk48M6xqD4S7YmqbLKyyk2zbxeSlkNXL6fRmjo2mFEuXyhSV
itmnu+CZF1XI1858+j4F
=M+PH
-----END PGP SIGNATURE-----

--T0LURvIkHTpnhlvomdKmUGfCCmAGA2loP--
