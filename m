Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaEBLy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 07:54:29 -0400
Received: from [217.156.133.130] ([217.156.133.130]:15883 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751733AbaEBLy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 07:54:27 -0400
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Fri, 02 May 2014 12:54:26 +0100
Message-ID: <5363876A.2030709@imgtec.com>
Date: Fri, 2 May 2014 12:54:18 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>
CC: <linux-kernel@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
        "John David Anglin" <dave.anglin@bell.net>,
        <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] parisc,metag: Do not hardcode maximum userspace stack
 size
References: <20140430212602.GA20601@p100.fritz.box>	 <53622DBA.807@imgtec.com> <1398966636.2174.21.camel@dabdike>
In-Reply-To: <1398966636.2174.21.camel@dabdike>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="77ThmoXPsbbBgfAgwStSbMTxrgArwQHle"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: 96d62635
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--77ThmoXPsbbBgfAgwStSbMTxrgArwQHle
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 01/05/14 18:50, James Bottomley wrote:
>=20
>> +
>> +config MAX_STACK_SIZE_MB
>> +	int "Maximum user stack size (MB)"
>> +	default 80
>> +	range 8 256 if METAG
>> +	range 8 2048
>> +	depends on STACK_GROWSUP
>> +	help
>> +	  This is the maximum stack size in Megabytes in the VM layout of us=
er
>> +	  processes when the stack grows upwards (currently only on parisc a=
nd
>> +	  metag arch). The stack will be located at the highest memory addre=
ss
>> +	  minus the given value, unless the RLIMIT_STACK hard limit is chang=
ed
>> +	  to a smaller value in which case that is used.
>> +
>> +	  A sane initial value is 80 MB.
>=20
> There's one final issue with this: placement of the stack only really
> matters on 32 bits.  We have three expanding memory areas: stack, heap
> and maps.  On 64 bits these are placed well separated from each other o=
n
> 64 bits, so an artificial limit like this doesn't matter.

Does the following fixup diff look reasonable? It forces
MAX_STACK_SIZE_MB to 1024 and hides the Kconfig option for 64BIT,
effectively leaving the behaviour unchanged in that case.

diff --git a/mm/Kconfig b/mm/Kconfig
index e80075979530..b0307f737bd7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -583,7 +583,8 @@ config GENERIC_EARLY_IOREMAP
 	bool

 config MAX_STACK_SIZE_MB
-	int "Maximum user stack size (MB)"
+	int "Maximum user stack size (MB)" if !64BIT
+	default 1024 if 64BIT
 	default 80
 	range 8 256 if METAG
 	range 8 2048

Thanks
James


--77ThmoXPsbbBgfAgwStSbMTxrgArwQHle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTY4dxAAoJEGwLaZPeOHZ6OBAP/j9rG9gFuaN/GZqef1m2Q3DS
qN9UJZl+DelG9LXEfOqnrcAvlBkzUYdfZ08+Hu7vktvmixc2t5wqCpANEo+7GNHo
NWz7zNynsbyp2BKvc4kBBnWd+FP+P2+ls5m/QMqFed1EYKPmnEyH22/pqNhCGeit
zcHix3VXEDtyHiAybVyB9zdk2RDoicoLps+xSH2Vha0ugKGSg3GntqPqvc9itzUn
aYmjRrcLDGHPs6H+2IdzzMGWfmOQTcsjmI9k7OtkqSoYuEl/fB6wUSNhJmZQlhss
MfRpg854RYcz4WV/6PplzNd1KNDoxSfA4hU/+2Ti4zFWpLkxQsVHev4K9HYLawH9
iGtrra4mjJR2iDED/1Ejkfz8HS+UOeSbjJ1ZIULSM3uosq2a7oyUNCExEEqKSIOG
yn8XOuCQL3nsjZkf7TecAuTMLzU9C67zDbYKvnZne3UjFj/6iLV1H3rut7HhZpRF
/glekIPxDeq+7AoJxxlf1ODWcEr07bI5Q/hRLezMsDpBSEpDkcIEyVEuz7G95/J4
1vtqk9vO2SK3siRzxvEm4PyqAVn/QXJar4V3qEaxeItJXJcSFDt+C8csu5vq8iex
LM8OTpZBApSPUowFUWBEJTj5gL0n3SMKxEQYBC9Gs+TEsSp0/RsWXWmOQqX81vYk
AuyFVwDfVHCJnYA0F5uK
=4DF5
-----END PGP SIGNATURE-----

--77ThmoXPsbbBgfAgwStSbMTxrgArwQHle--
