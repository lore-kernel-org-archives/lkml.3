Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaHDGh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 02:37:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44429 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbaHDGh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 02:37:27 -0400
Message-ID: <53DF2A05.3060207@ti.com>
Date: Mon, 4 Aug 2014 09:36:53 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dexuan Cui <decui@microsoft.com>
CC: <gregkh@linuxfoundation.org>, <plagnioj@jcrosoft.com>,
        <dan.carpenter@oracle.com>, <linux-kernel@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>,
        <linux-fbdev@vger.kernel.org>, <olaf@aepfle.de>, <apw@canonical.com>,
        <jasowang@redhat.com>, <kys@microsoft.com>, <haiyangz@microsoft.com>
Subject: Re: [PATCH v4] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
References: <1406892474-6548-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1406892474-6548-1-git-send-email-decui@microsoft.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="87h5WCtpSfgrwPTiokn44Ut1araeajKNn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--87h5WCtpSfgrwPTiokn44Ut1araeajKNn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/08/14 14:27, Dexuan Cui wrote:
> Currently the VSC has no chance to notify the VSP of the dirty rectangl=
e on VM
> panic because the notification work is done in a workqueue, and in pani=
c() the
> kernel typically ends up in an infinite loop, and a typical kernel conf=
ig has
> CONFIG_PREEMPT_VOLUNTARY=3Dy and CONFIG_PREEMPT is not set, so a contex=
t switch
> can't happen in panic() and the workqueue won't have a chance to run. A=
s a
> result, the VM Connection window can't refresh until it's closed and we=

> re-connect to the VM.
>=20
> We can register a handler on panic_notifier_list: the handler can notif=
y
> the VSC and switch the framebuffer driver to a "synchronous mode", mean=
ing
> the VSC flushes any future framebuffer change to the VSP immediately.
>=20
> v2: removed the MS-TFS line in the commit message
> v3: remove some 'unlikely' markings
> v4: avoid global variables as Tomi Valkeinen suggested
>=20
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/video/fbdev/hyperv_fb.c | 62 +++++++++++++++++++++++++++++++++=
++++++--
>  1 file changed, 59 insertions(+), 3 deletions(-)

Thanks, looks fine to me. Queuing for 3.17.

 Tomi




--87h5WCtpSfgrwPTiokn44Ut1araeajKNn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT3yoJAAoJEPo9qoy8lh71IzMP/2iwStdsFdIrQHpt2SBSFL0J
Y9n1/4lPdP6ONkjEeUJHnWabcu5phEi6gfcI9+OiRGsABrDpzEckX9sg1F1LuKJW
ByDNx1v3g+Tk3gq6/ea3OmLVBXSGZrFOgzmQmpvTSwBHA9lHAGwz+PZ4CDtXn0GW
gHK6rnKisJUWStWy55XSZFMV52944M9hLriWP5aM44cJz06HAIdvT8UZalEYdBnn
IxlurE2PP9aVEj0DcWAJs+uSeeCuiLwhLfNH54rfK3BwOmnWjsj7Oj1mn4Vfhztn
ZzehAIv4OcI0MBtu/YCiHbd+40ulq1CDr3R6zZdm4338w8N7GRU9AXj2WpY5ZO3I
s+x+98kLX4W5RwISOXBhdWphtcpqKdrfitOS9rBTxDl3VV2tv4Zs+WEQWmKzzZyL
aFVMVsPmiKLYYMmvCayd+s9CuKma7Q8vK1JdI5OPNMNObaVODZylweddnGVOLSNT
dk7hg0TeZV50wPgZOvdOrM7z0duZ2HLA76KnhYBaKnku596GQu1Oyfz2/xKGdM7L
T2vOr8lqZ/VQNUxyj/92o3/6S4ExKkVUsJ/D7MuS5+zEjVNOr/oKLrbY40ldDipz
Q/S8OlFTejbQbHiiTDWPFBWcjyL20SCx6BQh6ltYnNUTj3FzBLHn/BeZUEiGUN7p
xYxt/rQKH+Rq+EwbHrGw
=Y9f3
-----END PGP SIGNATURE-----

--87h5WCtpSfgrwPTiokn44Ut1araeajKNn--
