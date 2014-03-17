Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaCQWzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:55:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaCQWzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:55:07 -0400
Date: Tue, 18 Mar 2014 09:54:56 +1100
From: NeilBrown <neilb@suse.de>
To: Ralph Mueck <linux-kernel@rmueck.de>
Cc: i4passt@lists.cs.fau.de, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthias Oefelein <ma.oefelein@arcor.de>
Subject: Re: [PATCH 1/2] md: Add configurability for consistency check
 feature
Message-ID: <20140318095456.53e2b5cf@notabene.brown>
In-Reply-To: <1395068405-13860-2-git-send-email-linux-kernel@rmueck.de>
References: <1395068405-13860-1-git-send-email-linux-kernel@rmueck.de>
	<1395068405-13860-2-git-send-email-linux-kernel@rmueck.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/b1/uXr_wRHTdqgWSUIGh+Ba"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/b1/uXr_wRHTdqgWSUIGh+Ba
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Mar 2014 16:00:04 +0100 Ralph Mueck <linux-kernel@rmueck.de> wro=
te:

> This patch adds sysfs configurability for the md level-1 RAID
> consistency check.
> The feature introduces a new attribute in sysfs named "safe_read".
> To toggle consistency checks on/off, simply echo safe_read in
> /sys/block/md*/md/safe_read.
>=20
> Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>
> Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>
>=20
> ---
>  drivers/md/md.c | 27 +++++++++++++++++++++++++++
>  drivers/md/md.h |  3 +++
>  2 files changed, 30 insertions(+)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4ad5cc4..5cc9a00 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4652,6 +4652,32 @@ static struct md_sysfs_entry md_array_size =3D
>  __ATTR(array_size, S_IRUGO|S_IWUSR, array_size_show,
>         array_size_store);
> =20
> +static ssize_t
> +safe_read_show(struct mddev *mddev, char *page)
> +{
> +	if(mddev->safe_read)
> +		return sprintf(page, "enabled\n");
> +	else
> +		return sprintf(page, "disabled\n");
> +}
> +
> +static ssize_t
> +safe_read_store(struct mddev *mddev, const char *buf, size_t len)
> +{
> +	if(mddev->pers->level !=3D 1) {
> +		printk(KERN_NOTICE "RAID level not supported!\n");
> +		return len;
> +	}
> +	if (strncmp(buf, "safe_read", 9) =3D=3D 0) {
> +		mddev->safe_read =3D !mddev->safe_read;
> +	}
> +	return len;
> +}
> +

So let me get this straight....

There is a sysfs file called "safe_read".
When you read from that file it reports either "enabled" or "disabled".

However you cannot write "enabled" or "disabled" to the file.  Rather you
write "safe_read".  And when you do, it toggles the status.

Seriously?

Any chance you could use device_show_bool / device_store_bool ??

NeilBrown



--Sig_/b1/uXr_wRHTdqgWSUIGh+Ba
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUyd9QDnsnt1WYoG5AQL3vA/9Fgu7lYGkUxzwvADF7JB8uuQ95ae9yUKJ
FlQaNY4ec67ALa2E9z+aeX+qt8Xi7JgPsPnQ4+pb3wqLUscMEq2EpxFaeYlJfOYZ
ntBCq+uYdSQZI2MLsFVA7An7sDuQhDatGVArNO41pwLe4l6ry17ChOMtCfmfE0fP
D/6f8iL0doCjVcZO5wuvx8iFvlMXENTTNWNiPHpKGi2cBW8YRHZdGzFYVDcSENFD
HsX6p0nREXPSPYrN8E9SVHEE9SHmRy5U2ZYzNmkw3SAljjS8WuYecxumJY89Atzo
n1vVb8GMMxie0fSKietGv1pEexthg9wSWAEFjDr7AtgBo8XjHGgIUPucxZDkI/Uc
fIDMCjB4h1RsEOAVI+sqpWzWWpQcR1PfJbag8N+uobzMpNNRbtZQa+QNlgtxvI6x
RyIRJSK87clyAxzQyw3EzzbQnwlGWjIhxaGhjqTFkFCrFIfWILDTzxn3+eQeNg34
UYMPUb3qeH1cts9C9Nrcum776z1cwWFYHV67X23fBbPxcd3WR1VA9jf8hB/mttvt
XSQD9K2oFEaOCEPf0jcgRoA6kG1/740pg0yPvBKgGq+BeiVm1wtP0OTMw4b6ePSj
5a6EnbPXNF4yYZnbDwNQdfq7AiDz4a0uJ9dRG0w57OHVzMXdAoAsVubqwfXR5jV7
KPiFME3XJpI=
=WXkq
-----END PGP SIGNATURE-----

--Sig_/b1/uXr_wRHTdqgWSUIGh+Ba--
