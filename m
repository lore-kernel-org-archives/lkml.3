Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbaILNuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:50:12 -0400
Received: from sauhun.de ([89.238.76.85]:33730 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbaILNuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:50:10 -0400
Date: Fri, 12 Sep 2014 15:50:24 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH 6/8] i2c: Provide a temporary .probe2() call-back type
Message-ID: <20140912135023.GG1930@katana>
References: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
 <1409236538-21274-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UTZ8bGhNySVQ9LYl"
Content-Disposition: inline
In-Reply-To: <1409236538-21274-7-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UTZ8bGhNySVQ9LYl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index 79b674d..c8240e5 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -125,7 +125,8 @@ extern s32 i2c_smbus_write_i2c_block_data(const struc=
t i2c_client *client,
>   * struct i2c_driver - represent an I2C device driver
>   * @class: What kind of i2c device we instantiate (for detect)
>   * @attach_adapter: Callback for bus addition (deprecated)
> - * @probe: Callback for device binding
> + * @probe: Callback for device binding - soon to be deprecated
> + * @probe2: New callback for device binding

I don't like the naming. What about 'simplified_probe' instead of
'probe2'? The old 'probe' would be deprecated immediately, I guess.

Also, this needs more information in the kernel docs. Come to think of
it, I'd like to see some more documentation in general. A document in
Documentation/i2c should explain the differences between the
probe-functions, the reason why they are there, the intended path to
migrate over and examples how to convert drivers and what to keep in
mind doing so.

>   * @remove: Callback for device unbinding
>   * @shutdown: Callback for device shutdown
>   * @suspend: Callback for device suspend
> @@ -170,6 +171,11 @@ struct i2c_driver {
>  	int (*probe)(struct i2c_client *, const struct i2c_device_id *);
>  	int (*remove)(struct i2c_client *);
> =20
> +	/* New driver model interface to aid the seamless removal of the
> +	 * current probe()'s, more commonly unused than used second parameter.

"largely unused second parameter"? Maybe more readable? At least, I
needed to read this sentence more than once to get it. BTW have you
measured how often it was used/unused?

> +	 */
> +	int (*probe2)(struct i2c_client *);
> +
>  	/* driver model interfaces that don't relate to enumeration  */
>  	void (*shutdown)(struct i2c_client *);
>  	int (*suspend)(struct i2c_client *, pm_message_t mesg);

What I like in general: After your series I2C does more like what other
subsystems (especially SPI) do.

What I dislike about this in general: Putting to the drivers that they
should find out about the matching. I mean the core already did the
matching, so why should a driver do that again? Especially since it can
get very cumbersome to do so with platform_data, DT and ACPI around
which need to be checked. This is why I stopped my implementation to
fix this issue. I felt the need for a helper function to assist the
drivers how they were matched. Ideally by just retrieving the
information which the subsystem cores already gathered. Making such a
thing generic was where I stopped working on that.

Has this been discussed somewhere already?


--UTZ8bGhNySVQ9LYl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEvofAAoJEBQN5MwUoCm2UpsQAIVSA5gQVQdOWgc0mtc+wmTC
Cn1z7wKish11QU60TYYo5H8lcwsvw2SabPmljM6doP6BOdsSe9vuYXgXHEERf+ev
MxdvPwAzf0kqFFKBX13KyI1Xe+MQ2mZlOE0pJ3H7Ar/qsBo4jOQIpMBTSj7VfHIw
XnYuTKJ7MdU6RSZhmXBl35iYcItdBI6NIXLjtirdf1LB4mweHP+VuoirkfwGwDmq
AXO/GcqxeeYYooAPi31sOBYP+51ROvN5o3SdxbpPKVYkN0rPJZbqwzKl27YGrrIk
88++aalootvegASjApp7YJU5wGL1AoiAkoib/JG2ScTvwlh1bqsOzrlrQsFdUOXq
95dUFZSRwWpMxRNEC9K1Nl4NUQ6AqPHyUZwHFzce7rMAmIzY1VhYAkgDiPmu3Nur
ovG7ju8n/9zffp97Ww96b8kZh7T6LEVAQp+/sqqJxbiRlK8vpSjOM/5O/+4lB3hk
A8L6K9dHArdQmiNMlSZu6lCNcjZbbqMuj5ypfIkVNjZ4H2k6T+QjBUemb+TkzBJ4
rkBkqf60EedR5zdLhVnfzdosRQoS1vEq5BT41bD4z+GRMYBO5zUd19JKxeL5wEyE
oG2YeS4O/A1VD63LPPAYC3M4SFkHl+IAflciGr5VShpLaZRZprvbrcxE8WIz/xox
KQGMqueIgSpC9ARltD1A
=+NVU
-----END PGP SIGNATURE-----

--UTZ8bGhNySVQ9LYl--
