Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3JDMGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:06:43 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:56415
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036Ab3JDMGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:06:41 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzbb2dI98dI9371I1432I1418I4015Ide40hzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2fh95h839hd24hf0ah119dh1288h12a5h12bdh137ah1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1bceh1be0h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh20f0h34h19b6n1155h192ch)
Date: Fri, 4 Oct 2013 14:04:06 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        <linux-kernel@vger.kernel.org>,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] i2c: xilinx: Use devm_* functions
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1380550490.git.michal.simek@xilinx.com> <83ec9558211389896f21d9682e9824cd7979466c.1380550490.git.michal.simek@xilinx.com> <20131004053323.GB3194@katana> <524E8764.4030704@monstr.eu> <20131004115840.GB2994@katana>
In-Reply-To: <20131004115840.GB2994@katana>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="hoEOJgBKvn1SWB1wqjvd0xDJq7UWwe4U4"
X-RCIS-Action: ALLOW
Message-ID: <9b5a6672-2fd9-4900-b018-f044dee60646@VA3EHSMHS021.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hoEOJgBKvn1SWB1wqjvd0xDJq7UWwe4U4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/04/2013 01:58 PM, Wolfram Sang wrote:
> On Fri, Oct 04, 2013 at 11:16:20AM +0200, Michal Simek wrote:
>> On 10/04/2013 07:33 AM, Wolfram Sang wrote:
>>>
>>>> +	i2c->base =3D devm_ioremap_resource(&pdev->dev, res);
>>>> +	if (IS_ERR(i2c->base)) {
>>>> +		dev_err(&pdev->dev, "Could not allocate iomem\n");
>>>
>>> devm_ioremap_resource already prints error messages.
>>
>> you are right.
>>
>>>
>>>> +	ret =3D devm_request_irq(&pdev->dev, irq, xiic_isr, 0, pdev->name, i=
2c);
>>>
>>> This is too early. Can you find out why?
>>
>> Why do you think that it is too early?
> =

> The ISR uses spinlocks which are not initialized by then.

And waitqueue too.  Ok I will keep that request irq in current location
and I will add xiic_reinit() below this code.

>> I am looking at origin code again and I think that the code
>> is also problematic because in xiic_reinit() interrupts are enabled
>> but they are requested later.
>> Shouldn't be there a logic that interrupts should be enabled when
>> interrupts are registered by the kernel?
> =

> First register the handler, then activate interrupts. You are right,
> this needs to be fixed, too.

Do you want me to create separate patch just about moving request irq in fr=
ont of
xiic_reinit()? And then devm_ conversion?

Thanks,
Michal


--hoEOJgBKvn1SWB1wqjvd0xDJq7UWwe4U4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJOrrcACgkQykllyylKDCEpCgCfQx6rbawV6CipaHhOJ4Dm/mQW
qwwAn3IpG6Gm+tuEG6XgZSlsTNMy8iII
=Htag
-----END PGP SIGNATURE-----


--hoEOJgBKvn1SWB1wqjvd0xDJq7UWwe4U4--
