Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbaJaLlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:41:17 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42298 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbaJaLlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:41:15 -0400
Date: Fri, 31 Oct 2014 12:41:09 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mailbox: Don't unnecessarily re-arm the polling timer
Message-ID: <20141031114107.GE10778@ulmo.nvidia.com>
References: <1414699267-17970-1-git-send-email-abrestic@chromium.org>
 <1414699267-17970-2-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="maH1Gajj2nflutpK"
Content-Disposition: inline
In-Reply-To: <1414699267-17970-2-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--maH1Gajj2nflutpK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 01:01:07PM -0700, Andrew Bresticker wrote:
> poll_txdone() will unconditionally re-arm the polling timer if there was
> an active request, even if the active request completed and no other
> requests were submitted.  This is fixed by:
>  - only re-arming the timer if the controller reported that the current
>    transmission has not completed, and,
>  - moving the call to poll_txdone() into msg_submit() so that the
>    controller gets polled (and the timer re-armed, if necessary) whenever
>    a new message is submitted.
>=20
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>  drivers/mailbox/mailbox.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
> index 5008028..26f74ad 100644
> --- a/drivers/mailbox/mailbox.c
> +++ b/drivers/mailbox/mailbox.c
> @@ -28,6 +28,8 @@
>  static LIST_HEAD(mbox_cons);
>  static DEFINE_MUTEX(con_mutex);
> =20
> +static void poll_txdone(unsigned long data);

I think I'd rather move poll_txdone() here to avoid the forward
declaration, but either way:

Reviewed-by: Thierry Reding <treding@nvidia.com>

--maH1Gajj2nflutpK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUU3VTAAoJEN0jrNd/PrOhLVAP/jca6u+pEhVsfcpoMxEuLdjB
9xTgaDtM2eqOmfa+StIEp7gs5YEQQcgvDniwDoT3PIbpGqJu7l+x/2j6cqknujla
x3n98oJuxKXS/7CWxHtfJtvNbq++8MZzqpGMTbE/WXhEWNG3WKh6+FWI0XIM0P9M
Qkg5eKIh2wUzwV1FHPKIwaB0arE8YHbUfnbt1xNtN3UbX6v/sLDLif2cTdLWYhX4
VxK5DN0G0u+cLn11bdNup07YD7wbwUrTBSRX8DsiLTuFaVVT3dfddQ7bgxErsqs5
Ui/i1lNUtkNp3rAWMUiJriK+/vA0cfawbhrVGRanl6USevt8olqc6mnRA0i1Njsv
pWEqIFhdHDZxS5BZrZeciGro5kE3CsvshfF3S2nkMqH7oFpuxClYZCHWG07LUC7N
WC4ZsSDOf+71uLxz2ZCXzvwXz68/+BT7viI7QHMJ7NMPmweDS0/q+p1WjC/B1On5
BgNpfNxngtpljUY9DLhBgvMEXvOzzpxeMJy5yn9gst5kozxH1GDE20qsNMaKSquv
2+YrC3DMbbbinZCqNI0fEMBDDn8S1BKicf4SY4oaU33CIVJ+mtjm3sEis01Uzmiq
Z3PZSfDRFUI9mZfRFn42pHAs3olx9ZU6I0sYaUw7kd4i/c4+z9Gdtn9omWq/5cqo
32F7WBNKhZ+oD98yGZfw
=ZqFk
-----END PGP SIGNATURE-----

--maH1Gajj2nflutpK--
