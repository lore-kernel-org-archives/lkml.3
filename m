Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493AbaFLOCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:02:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47208 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaFLOCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:02:44 -0400
Message-ID: <5399B301.9030108@canonical.com>
Date: Thu, 12 Jun 2014 16:02:41 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: fs/stat: Reduce memory requirements for stat_open
References: <1402578017-16637-1-git-send-email-stefan.bader@canonical.com> <20140612134149.GC4296@osiris>
In-Reply-To: <20140612134149.GC4296@osiris>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="CIBbaF6hj1LNNEU1ePMHJDH5H7HOGfPkG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CIBbaF6hj1LNNEU1ePMHJDH5H7HOGfPkG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12.06.2014 15:41, Heiko Carstens wrote:
> On Thu, Jun 12, 2014 at 03:00:17PM +0200, Stefan Bader wrote:
>> When reading from /proc/stat we allocate a large buffer to maximise
>> the chances of the results being from a single run and thus internally=

>> consistent.  This currently is sized at 128 * num_possible_cpus() whic=
h,
>> in the face of kernels sized to handle large configurations (256 cpus
>> plus), results in the buffer being an order-4 allocation or more.
>> When system memory becomes fragmented these cannot be guarenteed, lead=
ing
>> to read failures due to allocation failures.
>>
>> There seem to be two issues in play here.  Firstly the allocation is
>> going to be vastly over sized in the common case, as we only consume t=
he
>> buffer based on the num_online_cpus().  Secondly, regardless of size w=
e
>> should not be requiring allocations greater than PAGE_ALLOC_COSTLY_ORD=
ER
>> as allocations above this order are significantly more likely to fail.=

>>
>> The following patch addesses both of these issues.  Does that make sen=
se
>> generally? It seemed to stop top complaining wildly for the reporter
>> at least.
>=20
> Hi Stefan,
>=20
> see also https://lkml.org/lkml/2014/5/21/341

Hi Heiko,

doh, so you guys have been hit by that before. And I have missed the fact=
 that
single_open is special. Which makes the change for the upper limit do the=
 wrong
thing. While long-term it sounds like changing it to vmalloc or iterative=
 reads
sounds better, maybe the change from possible to online cpus might be som=
ething
that is better acceptable as a quick fix... Not sure. At least this givin=
g back
a bit of attention to the matter and it is not only affecting zSeries. x8=
6
starts to see hw that requires a similar high possible cpus... :)

-Stefan

>=20
> and one possible solution:
>=20
> https://lkml.org/lkml/2014/5/30/191
>=20
> and the other one:
>=20
> https://lkml.org/lkml/2014/6/12/92
> https://lkml.org/lkml/2014/6/12/107
>=20
> Thanks,
> Heiko
>=20



--CIBbaF6hj1LNNEU1ePMHJDH5H7HOGfPkG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTmbMBAAoJEOhnXe7L7s6jf/IQAICSCaKpIyk6pqXhTQFJzhwc
40/DWNSp6kxCzZPhhhFyp3AZW4jb/SQYP3Xr+j8DMWt0TzJ+wtlZSFVaEwL6dIZr
Ck6BJdpxwtYOfdUrZSCthAVVP8g9B1nE0N17lwV+hJfEZq0KT8EGabrKSimWuNjn
Ktj7jLze07GknH3AhIN+MTuUC9nEHswDZRPXZTGHyo+vx8z8ep04Se/mS4KN8+y9
luo69zRFn7uAVRl5QkzVbGN4ZJcIGEfr/eXAaAP/ugeXpMFNQLUQzQQoJ2yCdZ0j
N1Achm3M/NcgDJyex21I0+uc5z+rnYD7zLj2hK167sFu1L08ZpYMtyR/xCHK48iW
tdZREk6LsThfaudmhN7RnRRZ179F1GgelgwlQxaiZVm04pefgmcW1xJ304pA4VFv
b6IxtKD92+gbiH7Rpj6W/T1akwEyt03KIX4JkRO66QwOzMqVRHzmxtIADiKFl8b4
mjGg1qDLUe6UvyT7u78Y4I3XcBNeK10CjxR0Oo9sc0xcwuHpjoeLY4seRCKrjVJ4
feXYOHlko9KZwmE7q9t+xLiaBep10zURBsWlaaJQVoXRNHCV1zEXIZirIutdNHQr
rq8pDfPJGZWsDKirPuvRTiBNMLDeibKS6v38yMXSvxodrBL4hDU2JmrEDKmLj40x
7C8R1YZMc3JxowTvHTew
=KAXx
-----END PGP SIGNATURE-----

--CIBbaF6hj1LNNEU1ePMHJDH5H7HOGfPkG--
