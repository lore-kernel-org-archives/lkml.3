Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaJMRnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 13:43:25 -0400
Received: from mail-bl2on0110.outbound.protection.outlook.com ([65.55.169.110]:34816
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754168AbaJMRnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 13:43:24 -0400
X-Greylist: delayed 5572 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2014 13:43:24 EDT
X-WSS-ID: 0NDE4TJ-07-55O-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Henning Schild <henning@hennsch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: =?iso-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Subject: RE: [PATCH] drm/radeon: remove code that can never get executed
Thread-Topic: [PATCH] drm/radeon: remove code that can never get executed
Thread-Index: AQHP5VIUaFaOpezjEUmURsXUUFNglJwuMRBQ
Date: Mon, 13 Oct 2014 16:08:06 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D05993B4D5@satlexdag05.amd.com>
References: <1413031067-26961-1-git-send-email-henning@hennsch.de>
 <1413031875-28053-1-git-send-email-henning@hennsch.de>
In-Reply-To: <1413031875-28053-1-git-send-email-henning@hennsch.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: multipart/mixed;
	boundary="_002_A3397C8B8B789E45844E7EC5DEAD89D05993B4D5satlexdag05amdc_"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(377454003)(189002)(199003)(13464003)(51704005)(85306004)(85852003)(87936001)(92726001)(105586002)(86362001)(77096002)(2656002)(99936001)(92566001)(106466001)(50986999)(95666004)(4396001)(55846006)(80022003)(46102003)(21056001)(33656002)(120916001)(568964001)(44976005)(76176999)(106116001)(71186001)(53416004)(19580405001)(54356999)(97736003)(84676001)(76482002)(20776003)(31966008)(64706001)(68736004)(101416001)(19580395003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03630A6A4A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Alexander.Deucher@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_A3397C8B8B789E45844E7EC5DEAD89D05993B4D5satlexdag05amdc_
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Henning Schild [mailto:henning@hennsch.de]
> Sent: Saturday, October 11, 2014 8:51 AM
> To: linux-kernel@vger.kernel.org
> Cc: Henning Schild; Deucher, Alexander; Rafa=B3 Mi=B3ecki
> Subject: [PATCH] drm/radeon: remove code that can never get executed
>=20
> Removing a code-path that can never be executed ... and its copies. If
> drm_edid_to_speaker_allocation returns 0 the callers return. There is no
> need to check that condition again.

I think we actually want to set the speaker allocation setup to stereo if t=
he speaker allocation block is not present so I think the attached patch is=
 probably the proper fix.

Alex

>=20
> Signed-off-by: Henning Schild <henning@hennsch.de>
> ---
>  drivers/gpu/drm/radeon/dce3_1_afmt.c    | 5 +----
>  drivers/gpu/drm/radeon/dce6_afmt.c      | 5 +----
>  drivers/gpu/drm/radeon/evergreen_hdmi.c | 5 +----
>  3 files changed, 3 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/radeon/dce3_1_afmt.c
> b/drivers/gpu/drm/radeon/dce3_1_afmt.c
> index cb76074..6d31ed8 100644
> --- a/drivers/gpu/drm/radeon/dce3_1_afmt.c
> +++ b/drivers/gpu/drm/radeon/dce3_1_afmt.c
> @@ -58,10 +58,7 @@ static void
> dce3_2_afmt_write_speaker_allocation(struct drm_encoder *encoder)
>  	tmp &=3D ~(DP_CONNECTION | SPEAKER_ALLOCATION_MASK);
>  	/* set HDMI mode */
>  	tmp |=3D HDMI_CONNECTION;
> -	if (sad_count)
> -		tmp |=3D SPEAKER_ALLOCATION(sadb[0]);
> -	else
> -		tmp |=3D SPEAKER_ALLOCATION(5); /* stereo */
> +	tmp |=3D SPEAKER_ALLOCATION(sadb[0]);
>  	WREG32(AZ_F0_CODEC_PIN0_CONTROL_CHANNEL_SPEAKER, tmp);
>=20
>  	kfree(sadb);
> diff --git a/drivers/gpu/drm/radeon/dce6_afmt.c
> b/drivers/gpu/drm/radeon/dce6_afmt.c
> index ab29f95..e6b2750 100644
> --- a/drivers/gpu/drm/radeon/dce6_afmt.c
> +++ b/drivers/gpu/drm/radeon/dce6_afmt.c
> @@ -186,10 +186,7 @@ void dce6_afmt_write_speaker_allocation(struct
> drm_encoder *encoder)
>  	tmp &=3D ~(DP_CONNECTION | SPEAKER_ALLOCATION_MASK);
>  	/* set HDMI mode */
>  	tmp |=3D HDMI_CONNECTION;
> -	if (sad_count)
> -		tmp |=3D SPEAKER_ALLOCATION(sadb[0]);
> -	else
> -		tmp |=3D SPEAKER_ALLOCATION(5); /* stereo */
> +	tmp |=3D SPEAKER_ALLOCATION(sadb[0]);
>  	WREG32_ENDPOINT(offset,
> AZ_F0_CODEC_PIN_CONTROL_CHANNEL_SPEAKER, tmp);
>=20
>  	kfree(sadb);
> diff --git a/drivers/gpu/drm/radeon/evergreen_hdmi.c
> b/drivers/gpu/drm/radeon/evergreen_hdmi.c
> index 278c7a1..11a6b65 100644
> --- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
> +++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
> @@ -128,10 +128,7 @@ static void
> dce4_afmt_write_speaker_allocation(struct drm_encoder *encoder)
>  	tmp &=3D ~(DP_CONNECTION | SPEAKER_ALLOCATION_MASK);
>  	/* set HDMI mode */
>  	tmp |=3D HDMI_CONNECTION;
> -	if (sad_count)
> -		tmp |=3D SPEAKER_ALLOCATION(sadb[0]);
> -	else
> -		tmp |=3D SPEAKER_ALLOCATION(5); /* stereo */
> +	tmp |=3D SPEAKER_ALLOCATION(sadb[0]);
>  	WREG32(AZ_F0_CODEC_PIN0_CONTROL_CHANNEL_SPEAKER, tmp);
>=20
>  	kfree(sadb);
> --
> 2.0.4


--_002_A3397C8B8B789E45844E7EC5DEAD89D05993B4D5satlexdag05amdc_
Content-Type: application/octet-stream;
	name="0001-drm-radeon-fix-speaker-allocation-setup.patch"
Content-Description: 0001-drm-radeon-fix-speaker-allocation-setup.patch
Content-Disposition: attachment;
	filename="0001-drm-radeon-fix-speaker-allocation-setup.patch"; size=2636;
	creation-date="Mon, 13 Oct 2014 16:06:07 GMT";
	modification-date="Mon, 13 Oct 2014 15:53:27 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhYjhkMGFkZDQ0MmJiZDdkOWI5NmEwNDkwOWM4YTIzMzYyOGNlZjJmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IE1vbiwgMTMgT2N0IDIwMTQgMTE6NTE6NTAgLTA0MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uOiBmaXggc3BlYWtlciBhbGxvY2F0aW9uIHNldHVwCgpJZiB0aGUgc2FkX2Nv
dW50IGlzIDAsIHNldCB0aGUgaHcgdG8gc3RlcmVvIGFuZCBjaGFuZ2UKdGhlIGVycm9yIG1lc3Nh
Z2UgdG8gYSB3YXJuLiAgQSBsb3Qgb2YgbW9uaXRvcnMgZG9uJ3QKc2V0IHRoZSBzcGVha2VyIGFs
bG9jYXRpb24gYmxvY2suCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5k
ZXVjaGVyQGFtZC5jb20+CkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCi0tLQogZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9kY2UzXzFfYWZtdC5jICAgIHwgNCArKy0tCiBkcml2ZXJzL2dwdS9kcm0v
cmFkZW9uL2RjZTZfYWZtdC5jICAgICAgfCA2ICsrKy0tLQogZHJpdmVycy9ncHUvZHJtL3JhZGVv
bi9ldmVyZ3JlZW5faGRtaS5jIHwgNiArKystLS0KIDMgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRp
b25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRl
b24vZGNlM18xX2FmbXQuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vZGNlM18xX2FmbXQuYwpp
bmRleCA5NTBhZjE1Li5hZGY2NWMwIDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L2RjZTNfMV9hZm10LmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9kY2UzXzFfYWZtdC5j
CkBAIC00OSw4ICs0OSw4IEBAIHN0YXRpYyB2b2lkIGRjZTNfMl9hZm10X3dyaXRlX3NwZWFrZXJf
YWxsb2NhdGlvbihzdHJ1Y3QgZHJtX2VuY29kZXIgKmVuY29kZXIpCiAKIAlzYWRfY291bnQgPSBk
cm1fZWRpZF90b19zcGVha2VyX2FsbG9jYXRpb24ocmFkZW9uX2Nvbm5lY3Rvci0+ZWRpZCwgJnNh
ZGIpOwogCWlmIChzYWRfY291bnQgPCAwKSB7Ci0JCURSTV9FUlJPUigiQ291bGRuJ3QgcmVhZCBT
cGVha2VyIEFsbG9jYXRpb24gRGF0YSBCbG9jazogJWRcbiIsIHNhZF9jb3VudCk7Ci0JCXJldHVy
bjsKKwkJRFJNX0RFQlVHKCJDb3VsZG4ndCByZWFkIFNwZWFrZXIgQWxsb2NhdGlvbiBEYXRhIEJs
b2NrOiAlZFxuIiwgc2FkX2NvdW50KTsKKwkJc2FkX2NvdW50ID0gMDsKIAl9CiAKIAkvKiBwcm9n
cmFtIHRoZSBzcGVha2VyIGFsbG9jYXRpb24gKi8KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2Ry
bS9yYWRlb24vZGNlNl9hZm10LmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2RjZTZfYWZtdC5j
CmluZGV4IGMwYmJmNjguLmJkYzMzMzMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRl
b24vZGNlNl9hZm10LmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9kY2U2X2FmbXQuYwpA
QCAtMTc2LDkgKzE3Niw5IEBAIHZvaWQgZGNlNl9hZm10X3dyaXRlX3NwZWFrZXJfYWxsb2NhdGlv
bihzdHJ1Y3QgZHJtX2VuY29kZXIgKmVuY29kZXIpCiAJfQogCiAJc2FkX2NvdW50ID0gZHJtX2Vk
aWRfdG9fc3BlYWtlcl9hbGxvY2F0aW9uKHJhZGVvbl9jb25uZWN0b3JfZWRpZChjb25uZWN0b3Ip
LCAmc2FkYik7Ci0JaWYgKHNhZF9jb3VudCA8PSAwKSB7Ci0JCURSTV9FUlJPUigiQ291bGRuJ3Qg
cmVhZCBTcGVha2VyIEFsbG9jYXRpb24gRGF0YSBCbG9jazogJWRcbiIsIHNhZF9jb3VudCk7Ci0J
CXJldHVybjsKKwlpZiAoc2FkX2NvdW50IDwgMCkgeworCQlEUk1fREVCVUcoIkNvdWxkbid0IHJl
YWQgU3BlYWtlciBBbGxvY2F0aW9uIERhdGEgQmxvY2s6ICVkXG4iLCBzYWRfY291bnQpOworCQlz
YWRfY291bnQgPSAwOwogCX0KIAogCS8qIHByb2dyYW0gdGhlIHNwZWFrZXIgYWxsb2NhdGlvbiAq
LwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW5faGRtaS5jIGIv
ZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ldmVyZ3JlZW5faGRtaS5jCmluZGV4IDI1MTRkNjUuLmJh
OTQyYjAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vZXZlcmdyZWVuX2hkbWku
YworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2V2ZXJncmVlbl9oZG1pLmMKQEAgLTE0OSw5
ICsxNDksOSBAQCBzdGF0aWMgdm9pZCBkY2U0X2FmbXRfd3JpdGVfc3BlYWtlcl9hbGxvY2F0aW9u
KHN0cnVjdCBkcm1fZW5jb2RlciAqZW5jb2RlcikKIAl9CiAKIAlzYWRfY291bnQgPSBkcm1fZWRp
ZF90b19zcGVha2VyX2FsbG9jYXRpb24ocmFkZW9uX2Nvbm5lY3Rvcl9lZGlkKGNvbm5lY3Rvciks
ICZzYWRiKTsKLQlpZiAoc2FkX2NvdW50IDw9IDApIHsKLQkJRFJNX0VSUk9SKCJDb3VsZG4ndCBy
ZWFkIFNwZWFrZXIgQWxsb2NhdGlvbiBEYXRhIEJsb2NrOiAlZFxuIiwgc2FkX2NvdW50KTsKLQkJ
cmV0dXJuOworCWlmIChzYWRfY291bnQgPCAwKSB7CisJCURSTV9ERUJVRygiQ291bGRuJ3QgcmVh
ZCBTcGVha2VyIEFsbG9jYXRpb24gRGF0YSBCbG9jazogJWRcbiIsIHNhZF9jb3VudCk7CisJCXNh
ZF9jb3VudCA9IDA7CiAJfQogCiAJLyogcHJvZ3JhbSB0aGUgc3BlYWtlciBhbGxvY2F0aW9uICov
Ci0tIAoxLjguMy4xCgo=

--_002_A3397C8B8B789E45844E7EC5DEAD89D05993B4D5satlexdag05amdc_--
