Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaDRJRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:17:55 -0400
Received: from mail.ovgu.de ([141.44.1.66]:57449 "EHLO mail.ovgu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaDRJRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:17:50 -0400
Message-ID: <5350EDAE.8020101@st.ovgu.de>
Date: Fri, 18 Apr 2014 11:17:34 +0200
From: Matthias Graf <matthias.graf@st.ovgu.de>
Organization: student.uni-magdeburg.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        alexander.deucher@amd.com
Subject: Re: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
References: <532C727F.1080803@st.ovgu.de> <20140321172742.GA2846@pd.tnic> <532C97DF.9010201@st.ovgu.de> <20140321201352.GC1338@pd.tnic> <533069E4.10002@st.ovgu.de> <533C1B47.8080709@st.ovgu.de> <20140416142232.GF16741@pd.tnic> <534F73F6.7050804@st.ovgu.de> <20140417130207.GB4321@pd.tnic>
In-Reply-To: <20140417130207.GB4321@pd.tnic>
X-Enigmail-Version: 1.6
OpenPGP: id=BE42F9BD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="GLUCqh46KIgQuQpC9c7djaIAQP8ExxDgQ"
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, RDNS_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_SPECIFIC 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTYPE_HAS_BOUNDARY 0, __CTYPE_MULTIPART 0, __FORWARDED_MSG 0, __FRAUD_REFNUM 0, __HAS_FROM 0, __HAS_MSGID 0, __IN_REP_TO 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __MULTIPLE_RCPTS_CC_X2 0, __RDNS_POOLED_10 0, __SANE_MSGID 0, __STOCK_PHRASE_6 0, __SUBJ_ALPHA_NEGATE 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0'
X-Spam-Score: Gauge=IIIIIIII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GLUCqh46KIgQuQpC9c7djaIAQP8ExxDgQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Fine-grained bisection result:


ab70b1dde73ff4525c3cd51090c233482c50f217 is the first bad commit
commit ab70b1dde73ff4525c3cd51090c233482c50f217
Author: Alex Deucher <alexander.deucher@amd.com>
Date:   Fri Nov 1 15:16:02 2013 -0400

    drm/radeon: enable DPM by default on r7xx asics

    Seems to be stable on them.

    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

:040000 040000 f3262029b868df4d882f64b4deba6b9230e307ea
1f1dfca42763703a56e3cc82bb103608a24be94e M	drivers


Result is reasonable: I have a RV770 chip.

(Additional) Bug Report for Reference:
https://bugzilla.redhat.com/show_bug.cgi?id=3D1085785

Thanks for the instructions Borislav! At first, I was not completely
sure what you expected me to do (this is my first kernel bug report :)).
If there is anymore more I can help you with, let me know.

Kind regards
Matthias


Am 17.04.2014 15:02, schrieb Borislav Petkov:
> On Thu, Apr 17, 2014 at 08:25:58AM +0200, Matthias Graf wrote:
>> Ok. I tried:
>>
>> 3.15-rc1 (16. April)
>> failed.
>>
>> Bisecting turned out:
>> last working: 3.12.17
>> first failing: 3.13
>=20
> Ok, next steps would then be:
>=20
> * test stock 3.12.
>  -> if it works, bisect between 3.12 and 3.13.
>  -> if not, bisect between 3.12 and 3.12.17
>=20
> If all works out correctly, the bisection result will give us the patch=

> which broke things on your machine and which is still unfixed upstream.=

>=20
> Thanks.
>=20


--GLUCqh46KIgQuQpC9c7djaIAQP8ExxDgQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTUO2uAAoJELO00SK+Qvm9UYUH/0EA1sfhd/SHzm/61Z8XFZBU
7to0A5wkPOkuazN2kaPYmCdvymH1zjpGN9muVRfUMvJmKzHR1VNViLvj9KCCvIbp
sgYVpvpzTb551sWsTcouLfAfOnXBkuiJ71k1jXCylLPh/xw8qQTwfE0HmwNeNYXw
hnVlpRJQ6GYN7QlZmKxiEcDd4jkmz62ATkiXPh1x3sqwl4Eo0HFA2G7DupSAioqV
grn23sxHdf+OhUgog49MkbbRePHFl1uDNO11MVmJQSpWWB0cehIS12k0Yf05DrWR
7sUcc+NFh/frtZceZ57HjwTSwCi1gF4yq5I7lnfjvxCGa5dZzL59Y+y+VtDTdLY=
=WJhW
-----END PGP SIGNATURE-----

--GLUCqh46KIgQuQpC9c7djaIAQP8ExxDgQ--
