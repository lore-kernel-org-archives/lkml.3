Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3JWLxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:53:16 -0400
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:46588 "HELO
	stec-inc.com.stec-inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753224Ab3JWLxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:53:15 -0400
X-ASG-Debug-ID: 1382529190-053ea958906b7f40001-xx1T2L
X-Barracuda-Envelope-From: Akhil.Bhansali@hgst.com
Content-Type: multipart/mixed;
	boundary="_000_87B0A48E21A1974AB4780BA3191524C210E71EMYMBX3stecincad_"
From: Akhil Bhansali <Akhil.Bhansali@hgst.com>
To: Jens Axboe <axboe@kernel.dk>, OS Engineering <osengineering@stec-inc.com>
CC: Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>,
        "'linux kernel (linux-kernel@vger.kernel.org)'" 
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] skd: Fix checkpatch ERRORS and removed unused functions.
Thread-Topic: [PATCH] skd: Fix checkpatch ERRORS and removed unused
 functions.
X-ASG-Orig-Subj: [PATCH] skd: Fix checkpatch ERRORS and removed unused functions.
Thread-Index: Ac7P5fQPR0Esw3SWTBGlMC+clXEKgQ==
Date: Wed, 23 Oct 2013 11:51:35 +0000
Message-ID: <87B0A48E21A1974AB4780BA3191524C210E71E@MYMBX3.stec-inc.ad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <87B0A48E21A1974AB4780BA3191524C210E71E@MYMBX3.stec-inc.ad>
x-originating-ip: [172.20.20.32]
MIME-Version: 1.0
X-Barracuda-Connect: mycas03.stec-inc.ad[172.30.8.21]
X-Barracuda-Start-Time: 1382529190
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.141724
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--_000_87B0A48E21A1974AB4780BA3191524C210E71EMYMBX3stecincad_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Jens,

I am sending patch which takes care of
- Removal of unused functions like readq / readl.
- Takes care of 3 errors messages shown by checkpatch.pl

Kindly please apply this patch to 3.13/drivers staging area.=20
Thank you.

---
=46rom dcd25c7128e14c90abb6a5d61e0a9ae9b26b6904 Mon Sep 17 00:00:00 2001
From: Akhil Bhansali <bhansaliakhil@gmail.com>
Date: Wed, 23 Oct 2013 14:45:34 +0530
Subject: [PATCH] [PATCH] Fix checkpatch ERRORS and removed unused functions.

This patch fixes checkpatch.pl errors for assignment in if condition.
It also removes unused readq / readl function calls.

As Andrew had disabled the compilation of drivers for 32 bit,
I have modified format specifiers in few VPRINTKs to avoid warnings
during 64 bit compilation.
Signed-off-by: Akhil Bhansali <abhansali@stec-inc.com>
Reviewed-by: Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>
---
 drivers/block/skd_main.c |   53 +++++++++++++++++++++++++++---------------=
----
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 3110f68..308bf47 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -420,14 +420,10 @@ static inline void skd_reg_write32(struct skd_device =
*skdev, u32 val,
 	if (likely(skdev->dbg_level < 2)) {
 		writel(val, skdev->mem_map[1] + offset);
 		barrier();
-		readl(skdev->mem_map[1] + offset);
-		barrier();
 	} else {
 		barrier();
 		writel(val, skdev->mem_map[1] + offset);
 		barrier();
-		readl(skdev->mem_map[1] + offset);
-		barrier();
 		VPRINTK(skdev, "offset %x =3D %x\n", offset, val);
 	}
 }
@@ -438,14 +434,10 @@ static inline void skd_reg_write64(struct skd_device =
*skdev, u64 val,
 	if (likely(skdev->dbg_level < 2)) {
 		writeq(val, skdev->mem_map[1] + offset);
 		barrier();
-		readq(skdev->mem_map[1] + offset);
-		barrier();
 	} else {
 		barrier();
 		writeq(val, skdev->mem_map[1] + offset);
 		barrier();
-		readq(skdev->mem_map[1] + offset);
-		barrier();
 		VPRINTK(skdev, "offset %x =3D %016llx\n", offset, val);
 	}
 }
@@ -1656,18 +1648,36 @@ static int skd_ioctl_sg_io(struct skd_device *skdev=
, fmode_t mode,
 		goto out;
 	}
=20
-	if ((rc =3D skd_sg_io_get_and_check_args(skdev, &sksgio)) ||
-	    (rc =3D skd_sg_io_obtain_skspcl(skdev, &sksgio)) ||
-	    (rc =3D skd_sg_io_prep_buffering(skdev, &sksgio)) ||
-	    (rc =3D skd_sg_io_copy_buffer(skdev, &sksgio, SG_DXFER_TO_DEV)))
+	rc =3D skd_sg_io_get_and_check_args(skdev, &sksgio);
+	if (rc)
+		goto out;
+
+	rc =3D skd_sg_io_obtain_skspcl(skdev, &sksgio);
+	if (rc)
+		goto out;
+
+	rc =3D skd_sg_io_prep_buffering(skdev, &sksgio);
+	if (rc)
+		goto out;
+
+	rc =3D skd_sg_io_copy_buffer(skdev, &sksgio, SG_DXFER_TO_DEV);
+	if (rc)
 		goto out;
=20
-	if ((rc =3D skd_sg_io_send_fitmsg(skdev, &sksgio)) ||
-	    (rc =3D skd_sg_io_await(skdev, &sksgio)))
+	rc =3D skd_sg_io_send_fitmsg(skdev, &sksgio);
+	if (rc)
 		goto out;
=20
-	if ((rc =3D skd_sg_io_copy_buffer(skdev, &sksgio, SG_DXFER_FROM_DEV)) ||
-	    (rc =3D skd_sg_io_put_status(skdev, &sksgio)))
+	rc =3D skd_sg_io_await(skdev, &sksgio);
+	if (rc)
+		goto out;
+
+	rc =3D skd_sg_io_copy_buffer(skdev, &sksgio, SG_DXFER_FROM_DEV);
+	if (rc)
+		goto out;
+
+	rc =3D skd_sg_io_put_status(skdev, &sksgio);
+	if (rc)
 		goto out;
=20
 	rc =3D 0;
@@ -4556,11 +4566,10 @@ static int skd_cons_skmsg(struct skd_device *skdev)
 	int rc =3D 0;
 	u32 i;
=20
-	VPRINTK(skdev, "skmsg_table kzalloc, struct %u, count %u total %lu\n",
+	VPRINTK(skdev, "skmsg_table kzalloc, struct %lu, count %u total %lu\n",
 		sizeof(struct skd_fitmsg_context),
 		skdev->num_fitmsg_context,
-		(unsigned long) sizeof(struct skd_fitmsg_context) *
-					skdev->num_fitmsg_context);
+		sizeof(struct skd_fitmsg_context) * skdev->num_fitmsg_context);
=20
 	skdev->skmsg_table =3D kzalloc(sizeof(struct skd_fitmsg_context)
 				     *skdev->num_fitmsg_context, GFP_KERNEL);
@@ -4611,7 +4620,7 @@ static int skd_cons_skreq(struct skd_device *skdev)
 	int rc =3D 0;
 	u32 i;
=20
-	VPRINTK(skdev, "skreq_table kzalloc, struct %u, count %u total %u\n",
+	VPRINTK(skdev, "skreq_table kzalloc, struct %lu, count %u total %lu\n",
 		sizeof(struct skd_request_context),
 		skdev->num_req_context,
 		sizeof(struct skd_request_context) * skdev->num_req_context);
@@ -4623,7 +4632,7 @@ static int skd_cons_skreq(struct skd_device *skdev)
 		goto err_out;
 	}
=20
-	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %u total %u\n",
+	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %lu total %lu\n",
 		skdev->sgs_per_request, sizeof(struct scatterlist),
 		skdev->sgs_per_request * sizeof(struct scatterlist));
=20
@@ -4668,7 +4677,7 @@ static int skd_cons_skspcl(struct skd_device *skdev)
 	int rc =3D 0;
 	u32 i, nbytes;
=20
-	VPRINTK(skdev, "skspcl_table kzalloc, struct %u, count %u total %u\n",
+	VPRINTK(skdev, "skspcl_table kzalloc, struct %lu, count %u total %lu\n",
 		sizeof(struct skd_special_context),
 		skdev->n_special,
 		sizeof(struct skd_special_context) * skdev->n_special);
--=20
1.7.9.5

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED=0D
=0D
This electronic transmission, and any documents attached hereto, may contai=
n confidential, proprietary and/or legally privileged information. The info=
rmation is intended only for use by the recipient named above. If you recei=
ved this electronic message in error, please notify the sender and delete t=
he electronic message. Any disclosure, copying, distribution, or use of the=
 contents of information received in error is strictly prohibited, and viol=
ators will be pursued legally.

--_000_87B0A48E21A1974AB4780BA3191524C210E71EMYMBX3stecincad_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+InhTAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEA
IQAAADI5QUQzQzU0NTBENDc4NERCQ0ExQTNGNjg2MkIwNjQzACkHAQ2ABAAC
AAAAAgACAAEFgAMADgAAAN0HCgAXAAsAMwAjAAMAaQEBIIADAA4AAADdBwoA
FwALADMAIwADAGkBAQiABwAYAAAASVBNLk1pY3Jvc29mdCBNYWlsLk5vdGUA
MQgBBIABAEEAAABbUEFUQ0hdIHNrZDogRml4IGNoZWNrcGF0Y2ggRVJST1JT
IGFuZCByZW1vdmVkIHVudXNlZCBmdW5jdGlvbnMuAHYWAQOQBgDcEgAAOQAA
AAIBfwABAAAAPAAAADw4N0IwQTQ4RTIxQTE5NzRBQjQ3ODBCQTMxOTE1MjRD
MjEwRTcxRUBNWU1CWDMuc3RlYy1pbmMuYWQ+AAsAHw4BAAAAAgEJEAEAAABB
CQAAPQkAADQaAABMWkZ1DJWxD2EACmZiaWQEAABjY8BwZzEyNTIA/gND8HRl
eHQB9wKkA+MCAARjaArAc2V0MCDvB20CgwBQEU0yCoAGtAKAln0KgAjIOwli
MTkOwL8JwxZyCjIWcQKAFWIqCbBzCfAEkGF0BbIOUANgc6JvAYAgRXgRwW4Y
MF0GUnYEkBe2AhByAMB0fQhQbhoxECAFwAWgG2RkmiADUiAQIheyXHYIkOR3
awuAZDUdUwTwB0ANF3AwCnEX8mJrbWsGcwGQACAgQk1fQuBFR0lOfQr8AfEL
8SAgSGkgSgnwcyw0XGwLgGUKgSI0SSCeYRywEgAdwAuAZyAKsOJ0EcAgd2gO
UCQQAZBuaweRHlAJcCAZMCIlLTUH8GUEYHYHQCUxIHUcbnUSABxhJqBjdGkv
AiAEICIwJLAgCXBhZEhxIC8n82wuJWdUcSSqIDMgBJADYBHwIBkHgXNhGDAE
IHNob1J3A6BieRvQaAWQa60j0y4LUCIsSx2xbCvgbwtQKBASACMQcAtQK+B0
HyRABCAj1BiQKkAuMTO8L2QFEBoxK1EBkGcjklklAWEuAzAiNFQZoWt8IHkI
YCjWJWYzcCIlRpEckmRjZA6gYzcOkEI4F3A0YzkwAaBiQDZhNWQ2MQpgYYA5
YWU5YjI2NYAdNUA0BdACIAZRcCAxVDcgHqA6N6MgAdAwwwBQM7g6IEFrJEAD
II5CGaErECIwIDxiObWzJKA5YUBnAMADEC4FoFRtPiIlRBiAZTkgV+0JgCw4
ICpQTydAOCEv8IE3YDQ6NDU6MzbQMCswNTMBQCI0U3UUYmoFkHQ5IFtQQRBU
Q0hdP3dGaXjDK/kZYFJST1IF8ABw/xxgCXAmERxRJq4yjTHwLxf+ZkCQJMIs
GipmGuEjEAQQ2GlnbgeAAjAgC4BH0N8mgBvhDeAnUijWSQVAB0B/GSBCFQQg
JqUoCycHJOFs60mQMo1BBCBBHcAJcAfg/xHQHGAN4QGgHnAcYC7wGeD9O4Fw
AxAYgEvyJnEwJkby/DMyK8BIgCIWIwAR0BowfyrQBHAGkAiQHGEa8yNAcC8F
kFJSKrFH4WYH0VZQclIgIFRLBCAvoVHgb38N0CQgCsADABnADgAiNGR7CHEj
oTY20FEBTxoo1lPLR2EJgC0ZMGYtK9A5L7Y8AaA5tUAfYAWQLQuAvmM7eiXw
HWJYoVkSUiMg7nAYcCsQHGBDJEACMCwQ+x2iOhFyEcBdyFrvMzxQBgovAmBv
LDAvc2tkhl87MUjAYyB8IGLwfz5QPiBjX2P3M3FlLmDWMd9FMR5wK/EZsjyx
M2awC4DHEgAAICdiKCspPMFQ4OcBAB5waDQtKSIsUkEmgP8zcDDQSWEwFmHP
K8Brb2JWHyIlHbEQMGehHpBmNjiELi4+YDhiZjQ3gPsekVbANGA4a09uD2Px
bP+pcp9AQGrgNAHQLDUQ/z4gdjMSMHXxH2EnUGLAC4AdIjIgVRNiMglwZ193
lwUQECBQ0CgfYHJ1PSHXYjIBAB1gYxngKmIxXED9PMB1UNEmMSIWAzABkUgC
Hignsi3weXB6wi0+ZF5ieOAecBowAyA8OCApPikDMAAAe7l8I3kDbCgve2J4
cn1SB4BtYmFwW94xP+BzwFjREgEpFiB+zvZiCsAIgiiCJzOQf0Yogz99FoD/
ggmEaINffBRcff8qYEmQGeB+n4gffw+AH4YP/4vvi0+EX43Pjt+Hj4u/fDKX
VEV9FDzAIo8EICVAoMI9mIFcXG4iPMCPBD88wCYxiL97p5sWdfMzOP92ZD4A
du93/3kDVsB5f3qJv1bBe298f32Pii+M5XGNb/+TX6T/lX+RrKZQps+n35TP
/4ifia+o/5Xvpd+rz6f/sQ//rU+rL7Sft1+2v5Zvl3+Yhf04UDZMUJj/mg+b
H3Xjv0C0NTZ2YDg+IL9ANJyQPDM2nVugFCdgJ0BsX75zeOAnYJ+/eogEU18F
QOcEYqHbomNnby+hCGAdAO/Az6IFt4mioyhegJixYjKlxZNfGDB0X0HhXywD
7c2wclXAvdYmYjDFkCdgOaShfHzLe9CizI5vYs8BkAuAxYAfUHBjkoXPD4/Q
H8y7XTA3QF9idQEgfwZxGcDSz9Pf1O/NYAWgcA551lXW/TzAU0dfRERYRkFw
X1RP3CBF9lakoGm2K5H0zK/Nv9cc/7xG3ZSisl6A3RvJL91U3T//0V/Sb+C/
4c/i3+Pv5P/V7//nD+gf6S/qP+tP2W/af9uP/9yV7x/wKcjfyenLj939I1Ly
X0VAdG3FkNb/2A/ZH/3ewGFVYEiA/T/dH/vP/N//7s/3z/jf+e/6//PP9N/1
6f5GQZAf0NzD/k//X+0RydD/xYCdoSbAAN8B7//PBG8Ff//wPwef8l8KDwsf
DC8NNxTv/xX/Fw8YHw8vED8Ufx2fBx+3CC+iRRKjMLxGdfM1wyJ/ZrB2oMMg
wzGdTMZESEFz/+aRBDPGD8cUJQvEoygMr4T9eyJpCE+9H74iK6PH4E6CeCBr
ekxBYfCz4SwUJf51PMBf8EKgNDJUwbzgRmD4JWx1v5MgazGfMq8zuZ81kDR/
NY2MaEdQemVY0O8r+gQEK0KNMHi1kDtPs/bfQrC5cD2MUTaRqChKUEdS/1KB
YeBWkKSwPG89fnqQQT7/Rfo/jz3YI8s8H0QPRRRHP/9ITycdo2U32pjAOJUr
8Eoffz2NPo6Mdw7DxxRMn0DyICBHRlBfSw0ATkXWTLw3dfM2b4AscGB2oP42
dsFwYCo/K0Z4wLjBLB//LS8uPy9PMF82rzeyWrE4L/8z/zpXNa9gb2F/ON85
7zr/50mvWzVasXVlnZA97z7//1WCZtJAvWqva79syEwcbzn5V20yM1h0XuBY
/1oPWx/3XC8lye3AcuYgyd/K72Vv374iULN4oDgWxZFw7cByEvlpEnNjnbCe
IJ2QY99k7/9+P39PgF9ogGlPbZ9PZN/gv4U2bJKz4XEcgNGfcHKBAv9tX4if
bGVMEopPi1ZN31f05jackFiDNzd2TysZ5sQfeF95b10vXj1WoG5ief2fcHNf
L4LfN5TmwmcPYu//gW+Cf5q/m89oL4avi/9xH/vmwN+AaVCwbN+MX+aBpmS/
p1+lL6Y/TAqrprqILQjGgDEuNy45LjVN9Qx9fScAsDAAAAAfAEIAAQAAAB4A
AABBAGsAaABpAGwAIABCAGgAYQBuAHMAYQBsAGkAAAAAAB8AZQABAAAAMAAA
AEEAawBoAGkAbAAuAEIAaABhAG4AcwBhAGwAaQBAAGgAZwBzAHQALgBjAG8A
bQAAAB8AZAABAAAACgAAAFMATQBUAFAAAAAAAAIBQQABAAAAcAAAAAAAAACB
Kx+kvqMQGZ1uAN0BD1QCAAAAgEEAawBoAGkAbAAgAEIAaABhAG4AcwBhAGwA
aQAAAFMATQBUAFAAAABBAGsAaABpAGwALgBCAGgAYQBuAHMAYQBsAGkAQABo
AGcAcwB0AC4AYwBvAG0AAAAfAAJdAQAAADAAAABBAGsAaABpAGwALgBCAGgA
YQBuAHMAYQBsAGkAQABoAGcAcwB0AC4AYwBvAG0AAAAfAOVfAQAAADYAAABz
AGkAcAA6AGEAYgBoAGEAbgBzAGEAbABpAEAAcwB0AGUAYwAtAGkAbgBjAC4A
YwBvAG0AAAAAAB8AGgwBAAAAHgAAAEEAawBoAGkAbAAgAEIAaABhAG4AcwBh
AGwAaQAAAAAAHwAfDAEAAAAwAAAAQQBrAGgAaQBsAC4AQgBoAGEAbgBzAGEA
bABpAEAAaABnAHMAdAAuAGMAbwBtAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAA
AAAAAgEZDAEAAABwAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAQQBrAGgA
aQBsACAAQgBoAGEAbgBzAGEAbABpAAAAUwBNAFQAUAAAAEEAawBoAGkAbAAu
AEIAaABhAG4AcwBhAGwAaQBAAGgAZwBzAHQALgBjAG8AbQAAAB8AAV0BAAAA
MAAAAEEAawBoAGkAbAAuAEIAaABhAG4AcwBhAGwAaQBAAGgAZwBzAHQALgBj
AG8AbQAAAB8A+D8BAAAAHgAAAEEAawBoAGkAbAAgAEIAaABhAG4AcwBhAGwA
aQAAAAAAHwAjQAEAAAAwAAAAQQBrAGgAaQBsAC4AQgBoAGEAbgBzAGEAbABp
AEAAaABnAHMAdAAuAGMAbwBtAAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAA
AgH5PwEAAABwAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAQQBrAGgAaQBs
ACAAQgBoAGEAbgBzAGEAbABpAAAAUwBNAFQAUAAAAEEAawBoAGkAbAAuAEIA
aABhAG4AcwBhAGwAaQBAAGgAZwBzAHQALgBjAG8AbQAAAB8ACV0BAAAAMAAA
AEEAawBoAGkAbAAuAEIAaABhAG4AcwBhAGwAaQBAAGgAZwBzAHQALgBjAG8A
bQAAAAsAQDoBAAAAHwAaAAEAAAASAAAASQBQAE0ALgBOAG8AdABlAAAAAAAD
APE/CQQAAAsAQDoBAAAAAwD9P+QEAAACAQswAQAAABAAAAAprTxUUNR4Tbyh
o/aGKwZDAwAXAAEAAABAADkAgD08OebPzgFAAAgwVQiHOebPzgELACkAAAAA
AAsAIwAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAHgAAAGEAYwBjAGUA
cAB0AGwAYQBuAGcAdQBhAGcAZQAAAAAAAQAAAAwAAABlAG4ALQBVAFMAAAAL
AACACCAGAAAAAADAAAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAAggAAAFsA
UABBAFQAQwBIAF0AIABzAGsAZAA6ACAARgBpAHgAIABjAGgAZQBjAGsAcABh
AHQAYwBoACAARQBSAFIATwBSAFMAIABhAG4AZAAgAHIAZQBtAG8AdgBlAGQA
IAB1AG4AdQBzAGUAZAAgAGYAdQBuAGMAdABpAG8AbgBzAC4AAAAAAB8APQAB
AAAAAgAAAAAAAAADADYAAAAAAAIBcQABAAAAFgAAAAHOz+X0D0dBLMN0lkwR
pTAvnJVxCoEAAB8AcAABAAAAggAAAFsAUABBAFQAQwBIAF0AIABzAGsAZAA6
ACAARgBpAHgAIABjAGgAZQBjAGsAcABhAHQAYwBoACAARQBSAFIATwBSAFMA
IABhAG4AZAAgAHIAZQBtAG8AdgBlAGQAIAB1AG4AdQBzAGUAZAAgAGYAdQBu
AGMAdABpAG8AbgBzAC4AAAAAAB8ANRABAAAAeAAAADwAOAA3AEIAMABBADQA
OABFADIAMQBBADEAOQA3ADQAQQBCADQANwA4ADAAQgBBADMAMQA5ADEANQAy
ADQAQwAyADEAMABFADcAMQBFAEAATQBZAE0AQgBYADMALgBzAHQAZQBjAC0A
aQBuAGMALgBhAGQAPgAAAAMA3j+fTgAACwAAgAggBgAAAAAAwAAAAAAAAEYA
AAAAA4UAAAAAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAABhQAAAAAAAAMA
gBD/////QAAHMFkitjfmz84BCwACAAEAAAADACYAAAAAAAIBEDABAAAARgAA
AAAAAAAgP6OMYEfDQ6EJMywbR5qoBwDEtXBMb+tSRLKhvMjPg7hrAAL5bXq5
AAC1avTDaOUVT4Fq5jjplpRbAAAbTAoGAAAAAB8A+j8BAAAAHgAAAEEAawBo
AGkAbAAgAEIAaABhAG4AcwBhAGwAaQAAAAAAAwAJWQEAAAADAACACCAGAAAA
AADAAAAAAAAARgAAAAAQhQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAA
AIKFAAAAAAAAQAAAgAggBgAAAAAAwAAAAAAAAEYAAAAAv4UAAECAizfmz84B
CwAAgAggBgAAAAAAwAAAAAAAAEYAAAAADoUAAAAAAAADAACACCAGAAAAAADA
AAAAAAAARgAAAAAYhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAAOuF
AAAJBAAAAwANNP0/AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAgAAAAeAAt
AG0AcwAtAGgAYQBzAC0AYQB0AHQAYQBjAGgAAAABAAAAAgAAAAAAAAAfAACA
hgMCAAAAAADAAAAAAAAARgEAAAAiAAAAeAAtAG8AcgBpAGcAaQBuAGEAdABp
AG4AZwAtAGkAcAAAAAAAAQAAAB4AAABbADEANwAyAC4AMgAwAC4AMgAwAC4A
MwAyAF0AAAAAAK8p

--_000_87B0A48E21A1974AB4780BA3191524C210E71EMYMBX3stecincad_--
