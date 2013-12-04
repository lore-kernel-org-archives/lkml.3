Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3LDCGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:06:34 -0500
Received: from ozlabs.org ([203.10.76.45]:47359 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab3LDCG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:06:29 -0500
Date: Wed, 4 Dec 2013 13:06:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-Id: <20131204130622.6146e3a3742f42e8013a9846@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__4_Dec_2013_13_06_22_+1100_/P7nygVUxZd2X1Zv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Dec_2013_13_06_22_+1100_/P7nygVUxZd2X1Zv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
include/linux/hid-sensor-ids.h between commit 751d17e23a9f ("iio:
hid-sensors: Fix power and report state") from the staging.current tree
and commit 64528d03d723 ("iio: hid-sensors: accelerometer: Add
sensitivity") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/hid-sensor-ids.h
index 8323775ac21d,4cc165887b09..000000000000
--- a/include/linux/hid-sensor-ids.h
+++ b/include/linux/hid-sensor-ids.h
@@@ -117,16 -121,8 +121,20 @@@
  #define HID_USAGE_SENSOR_PROP_REPORT_STATE			0x200316
  #define HID_USAGE_SENSOR_PROY_POWER_STATE			0x200319
 =20
 +/* Power state enumerations */
 +#define HID_USAGE_SENSOR_PROP_POWER_STATE_UNDEFINED_ENUM		0x00
 +#define HID_USAGE_SENSOR_PROP_POWER_STATE_D0_FULL_POWER_ENUM		0x01
 +#define HID_USAGE_SENSOR_PROP_POWER_STATE_D1_LOW_POWER_ENUM		0x02
 +#define HID_USAGE_SENSOR_PROP_POWER_STATE_D2_STANDBY_WITH_WAKE_ENUM	0x03
 +#define HID_USAGE_SENSOR_PROP_POWER_STATE_D3_SLEEP_WITH_WAKE_ENUM	0x04
 +#define HID_USAGE_SENSOR_PROP_POWER_STATE_D4_POWER_OFF_ENUM		0x05
 +
 +/* Report State enumerations */
 +#define HID_USAGE_SENSOR_PROP_REPORTING_STATE_NO_EVENTS_ENUM		0x00
 +#define HID_USAGE_SENSOR_PROP_REPORTING_STATE_ALL_EVENTS_ENUM		0x01
 +
+ /* Per data field properties */
+ #define HID_USAGE_SENSOR_DATA_MOD_NONE					0x00
+ #define HID_USAGE_SENSOR_DATA_MOD_CHANGE_SENSITIVITY_ABS		0x1000
+=20
  #endif

--Signature=_Wed__4_Dec_2013_13_06_22_+1100_/P7nygVUxZd2X1Zv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSno4iAAoJEMDTa8Ir7ZwVP68P/0r1j7b/bkR+7w/e+bff0Db/
U/edjI1iUNjp89Ikqr8SjuUMGyJdJ+w+XkchTbnD1l9vcTD+d798LLGWsAGVdbHt
89/xgNapMOJFnct+B0SnxbUsgv+AZ1WGHai4UzMO/SPbooJH4eLIFeLY4D5ovOYf
zW5cLNNqtC9wGMSVJ7wx1fGz8IXKREQQTgybM1SSpLB/1WZDflMZUl/yAWAjt9eT
ma1aEqWW6Gt/deHoSyd0dHT6boP2oGpzjtKXYk91stIAckTBzrcWW5z1ddWMnZyy
ph/29i3A1keZUfulu7IyqiUOuzFY9dDgEhduBr19G+vJRFoahXPRlhq4HhEzF3Ho
mgxIPj2m2NOFyH/cMaNxRz3YBRT2sqS2K86i8PEieNIy9zwkS4v70EhlkaYGyCnQ
dC0G/WJf9VY6yZLAk5A7nEygYhAXvy1cIMfAl0Fzf6ylz4ywwODX+5dPHFoEUytG
Dq5pfpIrGrGW6CuofXPiNHw6xprdq0u19rLv/XeY37/HkRjyuknb9QwLuS1zcPuP
1jXMP4KkmPdk/0L0S5zPJO6haeQin8lve61NWVkUaNIXYoaqh2DLOjLyd4AKPuwh
AtI7lkAdRf8khJXNCw1MmZkexMaAK0j/LRu4NPRXvBKbd1OHL/AZjZU23S8zBP65
YhyWk0t71zqyUpVOLvrI
=w3Rb
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Dec_2013_13_06_22_+1100_/P7nygVUxZd2X1Zv--
