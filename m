Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaDXBSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:18:09 -0400
Received: from ozlabs.org ([103.22.144.67]:50007 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaDXBSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:18:07 -0400
Date: Thu, 24 Apr 2014 11:17:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kefeng Wang <kefeng.wang@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: linux-next: build failure after merge of the libata tree
Message-Id: <20140424111754.45e9672e06c362945d111b6e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Apr_2014_11_17_54_+1000_JmDUxZv/5R8zACYz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Apr_2014_11_17_54_+1000_JmDUxZv/5R8zACYz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

After merging the libata tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/ata/libahci_platform.c: In function 'ahci_platform_init_host':
drivers/ata/libahci_platform.c:317:20: warning: cast to pointer from intege=
r of different size [-Wint-to-pointer-cast]
  pi.private_data =3D (void *)host_flags
                    ^
drivers/ata/libahci_platform.c:318:2: error: expected ';' before 'hpriv'
  hpriv->flags |=3D host_flags;
  ^

Please test build this stuff ...

Caused by commit ac795a7ec2d2 ("libahci_platform: add host_flags parameter
in ahci_platform_init_host()").

I have used the libata tree from next-20140423 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__24_Apr_2014_11_17_54_+1000_JmDUxZv/5R8zACYz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTWGZNAAoJEMDTa8Ir7ZwVkY8P/jO2v1f6OcHqCcEMgdHuNa80
J52bQhns1gf95omr84+c8Z89KlL0Qpy6jPk7zzPYLXT18+I5TKad9QC84mQ7wg7b
pfbhHe1f9UAOIF+dr3GTYXE723E/REixf5iEjcgNo3k10fVFeXhG9RjX7upZnQLa
z1WgPzBkFe/tlT8qGe1MawEI4Pnymi9FxAreKa57jrzPwk+kxlrwRtEY9PvczekV
gKt0lDG4K+Bbybxr2E7v9Aj+wpjpxPtROsDb7Io5j62Mz/E1L1Hag7hKNtwKNy2p
wkSGV6YdZtJ3uxf5hq3rCfjHlObNYNpUPsv7LveBH5Man3RjXaSRNb+tHqZCqsvu
iZRJaUbdg8WVQB7xW9l1PHnZ5Na1O8fh/hjiUiCWb8CqWPZwlvtG0+qSciwUGvFr
nCdhXv0qB3fL6INq4TQQB2hWwI2FAKh71zalRsxNDPfVMHdKWVR/a0QA4rxi896u
18pEX1YXdTQ6zmMZss8LaR/NaX66Em+buYXeP1lgCxofONk0zAKaGcNomo/QrZGP
OgIvnLlK10wt5/2QnXIhRMLcO9LDcbMLZ3k0eWCMKzzxz+cMcsfh7DCh4mmGsWTY
o4Hqcg2fKUAzVucxyj/cpQl35NbpOPawnEX1uRjf1lA9xV7EL9ZunkOpZSFOZ+zR
a5hTjP/sdDHB+2UTKkhQ
=Od2p
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Apr_2014_11_17_54_+1000_JmDUxZv/5R8zACYz--
