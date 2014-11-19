Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbaKSQKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:10:45 -0500
Received: from sauhun.de ([89.238.76.85]:55435 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756653AbaKSQEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:04:43 -0500
Date: Wed, 19 Nov 2014 17:05:47 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, lenb@kernel.org, robert.moore@intel.com,
        lv.zheng@intel.com, shigorin@gmail.com, adamw@happyassassin.net,
        jan.brummer@tabos.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devel@acpica.org
Subject: Re: [PATCH] ACPI: Add _DEP(Operation Region Dependencies) support to
 fix battery issue on the Asus T100TA
Message-ID: <20141119160547.GA8557@katana>
References: <1416410441-14425-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <1416410441-14425-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2014 at 11:20:41PM +0800, Lan Tianyu wrote:
> ACPI 5.0 introduces _DEP to designate device objects that OSPM should
> assign a higher priority in start ordering due to future operation region
> accesses.
>=20
> On Asus T100TA, ACPI battery info are read from a I2C slave device via
> I2C operation region. Before I2C operation region handler is installed,
> battery _STA always returns 0. There is a _DEP method of designating
> start order under battery device node.
>=20
> This patch is to implement _DEP feature to fix battery issue on the Asus =
T100TA.
> Introducing acpi_dep_list and adding dep_unmet count in the struct
> acpi_device. During ACPI namespace scan, create struct acpi_dep_data for a
> valid pair of master (device pointed to by _DEP)/slave(device with _DEP),=
 record
> master's and slave's ACPI handle in it and put it into acpi_dep_list. The=
 dep_unmet
> count will increase by one if there is a device under its _DEP. Driver's =
probe() should
> return EPROBE_DEFER when find dep_unmet larger than 0. When I2C operation
> region handler is installed, remove all struct acpi_dep_data on the acpi_=
dep_list
> whose master is pointed to I2C host controller and decrease slave's dep_u=
nmet.
> When dep_unmet decreases to 0, all _DEP conditions are met and then do ac=
pi_bus_attach()
> for the device in order to resolve battery _STA issue on the Asus T100TA.
>=20
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=3D69011=20
> Tested-by: Jan-Michael Brummer <jan.brummer@tabos.org>
> Tested-by: Adam Williamson <adamw@happyassassin.net>
> Tested-by: Michael Shigorin <shigorin@gmail.com>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

As long as the I2C related changes are that minimal:

Acked-by: Wolfram Sang <wsa@the-dreams.de> for the I2C part


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbL/bAAoJEBQN5MwUoCm2JogQAIK28lczikHK/Ukm3thl2JbC
JM8eud+VMxQDfAtarZyh8awYTsNatThy13vLlp0+ufdOeoauhNUyy64ai++eBA98
1EFFKGO9qoNtv+fL2KVf3YtJXcSD8oRpzXjstDHEfQppshrkgsaXzFnWK1KCQTl1
DJFgxlnpZ5gQDyJq3Wfm/R8LpvWkNgLPfYW94xvM6SFGejtnuEBcJo34XpXEPWLg
CCXr/zYTonqiGuuhyNemYAk9U8aHVcfbNhrU70UzKzEI15a30s3GM2Acsg50mw5c
4JBWWeb3EIjCv0JVfPANvDWIbEzPYmLtk/xaa2kulg07LfvpKJrkhVMxYE/yFqyI
EWJypXqq8zB9UP/bw3YtZd5ZN9FC4045kQsxJSr7qWQk3goc5oSX7W6Yp7IziAbf
f02r3XZPJC/b4ZBik/kGhql7873qaPT1rxxOMWcXFIyGbcOCSC+5Q00aaD9SaJ57
loIKfe2TRSiYdC/vIk2dm3Vng/+rE5PyNb1LbNoXXTTLAPZvjGM+P/scdoNtmTRB
H9VcQkbeamei3UXaH3i4kRBWpQmMxsbBjBQcq/toYauhiKPH6O2SMaOHpwzhx3l5
laOjTEQBIztiB5KA2EkEAO9DWEwLz+9CoukYz2cEmVEPVbp6E2WserO8QWinWghh
SiUjh8SzJkVCuu2bdxhF
=mm43
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
