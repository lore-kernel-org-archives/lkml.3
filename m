Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760484AbaEMLXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:23:09 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:26779
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753130AbaEMLXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:23:06 -0400
X-WSS-ID: 0N5IFM8-08-P5P-02
X-M-MSG: 
Message-ID: <53720091.5020302@amd.com>
Date: Tue, 13 May 2014 13:22:57 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ken Moffat <zarniwhoop@ntlworld.com>
CC: Alex Deucher <alexdeucher@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: More breakage on HD7480D [ Aruba ]
References: <20140512003405.GA3386@milliways>
 <20140512010310.GA4370@milliways> <53707926.5090609@amd.com>
 <20140512163207.GA23680@milliways>
In-Reply-To: <20140512163207.GA23680@milliways>
Content-Type: multipart/mixed;
	boundary="------------010005010800010502090905"
X-Originating-IP: [10.224.154.99]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(51704005)(24454002)(51874003)(81542001)(68736004)(83322001)(99396002)(85182001)(76482001)(46102001)(77096999)(87936001)(77982001)(71186001)(59896001)(85202002)(87266999)(512874002)(83506001)(64706001)(65816999)(84326002)(36756003)(65806001)(64126003)(20776003)(2009001)(81342001)(86362001)(79102001)(84676001)(21056001)(19580395003)(76176999)(54356999)(74662001)(4396001)(44976005)(568964001)(101416001)(83072002)(65956001)(85852003)(80022001)(575784001)(50986999)(92726001)(102836001)(99136001)(74502001)(62816006);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR02MB119;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0210479ED8
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------010005010800010502090905
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable

Please try the attached patch it should fix your problem.

Thanks allot for this bug report, that was just a stupid typo in the=20
original patch which would probably went unnoticed for years otherwise.

Christian.

Am 12.05.2014 18:32, schrieb Ken Moffat:
> On Mon, May 12, 2014 at 09:32:54AM +0200, Christian K=C3=B6nig wrote:
>> Hi Ken,
>>
>> *sigh* did I already mentioned that I hate PLLs? As soon as you fix
>> something another use case immediately starts to break.
>>
>> Please provide dmesg output created with drm.debug=3D0xe with and with=
out the
>> patch breaking it.
>>
>> Thanks in advance,
>> Christian.
>>
>   The reverted version is from linus's tree after -rc5 with the patch
> reverted, I assume the version -00010-gc9a25d0fc393 will NOT match
> any public tree because I used git revert in a local branch.  That
> one works fine.
>
>   The bad version is from a random kernel which showed the problem
> while I was bisecting, in this case rc2-00086.  I first tried
> booting vanilla rc5, but for some reason my blind attempt to login
> and run 'dmesg >dmesg.bad' failed.
>
>   Thanks.  Sorry you are having to deal with PLLs.
>
> =C4=B8en


--------------010005010800010502090905
Content-Type: text/x-diff;
	name="0001-drm-radeon-fix-typo-in-finding-PLL-params.patch"
Content-Disposition: attachment;
	filename="0001-drm-radeon-fix-typo-in-finding-PLL-params.patch"
Content-Transfer-Encoding: quoted-printable

>From 8b5c70b48d73b533f0003639cdb68bcffe7c1293 Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Christian=3D20K=3DC3=3DB6nig?=3D <christian.koenig@amd.=
com>
Date: Tue, 13 May 2014 12:50:54 +0200
Subject: [PATCH] drm/radeon: fix typo in finding PLL params
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Otherwise the limit is raised to high.

Signed-off-by: Christian K=C3=B6nig <christian.koenig@amd.com>
---
 drivers/gpu/drm/radeon/radeon_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/ra=
deon/radeon_display.c
index 408b6ac..f00dbbf 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -999,7 +999,7 @@ void radeon_compute_pll_avivo(struct radeon_pll *pll,
=20
 	/* avoid high jitter with small fractional dividers */
 	if (pll->flags & RADEON_PLL_USE_FRAC_FB_DIV && (fb_div % 10)) {
-		fb_div_min =3D max(fb_div_min, (9 - (fb_div % 10)) * 20 + 60);
+		fb_div_min =3D max(fb_div_min, (9 - (fb_div % 10)) * 20 + 50);
 		if (fb_div < fb_div_min) {
 			unsigned tmp =3D DIV_ROUND_UP(fb_div_min, fb_div);
 			fb_div *=3D tmp;
--=20
1.9.1


--------------010005010800010502090905--
