Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbaLKC66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:58:58 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:12112 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176AbaLKC64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:58:56 -0500
X-AuditID: cbfee68f-f791c6d000004834-77-5489085d6bc7
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: catalin.marinas@arm.com, Will.Deacon@arm.com, heiko@sntech.de,
        Li.Xiubo@freescale.com, shc_work@mail.ru, p.zabel@pengutronix.de,
        nicoleotsuka@gmail.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        robh+dt@kernel.org, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net
Cc: padma.v@samsung.com, alsa-devel@alsa-project.org, shawn.guo@freescale.com,
        bcousson@baylibre.com, tony@atomide.com, kernel@pengutronix.de,
        kgene@kernel.org, kesavan.abhilash@gmail.com, pawel.moll@arm.com
Subject: [PATCH 2/2] misc: sram: switch to ioremap_wc from ioremap
Date: Thu, 11 Dec 2014 08:28:46 +0530
Message-id: <1418266726-12004-2-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418266726-12004-1-git-send-email-a.kesavan@samsung.com>
References: <1418266726-12004-1-git-send-email-a.kesavan@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzVSa0hTYRju2zk752gKH/P2tUhylKDV2rz1lZImGid/ZKA/QkpbdlDLG9u0
	+mOjMi+Ul5lWoqYTry2my8xrrmliGWU5RcEpXUGtJEwzTW1r9O953+d5n+eF92UIwSQpZJJS
	lZw8VZYsouxJrbNf1r7TTF60ZKBpOza9NfLwunqQxlP31/l4of4mwJ8MOQAb/nQAfK1WR+HN
	D/N83FzaSWLtuggXfpwncN5ILh+PdlVQeO7WBI3N00MkXpv8ReGiOw9JnN07QOP66zdIrO4Q
	4j5TBJ79MUSGuLIti1cpVlulBezaqhqwy0tqkl2YyKbZjf5CHttZbqZZfXMexU6N91BsX6WW
	ZmsLSvjs7coBPlu4LmEL2poB+2S8imAX9e4nYIx90DkuOSmTk+8/fMY+8XNrFZ3e6njJ/DhO
	BdRb84Edg6Afqn7ZQNmwKxqZ1lmwPSOAdQCZNF3Uf1HxmybSRmgA6uld4lkJASzgoQcaDyum
	oBhVbywRVpEzbOKhue8bwFoQcBSgXM17vlXlBEPR65Xyf7Yk3I2WS3uBFTvCcDSjqaTzAWOJ
	24kq1EHWth08it7pN4EtLBytqFr+BSA4xSBT9yNg84FoucRI2mZ3IL2BsG29DT1rnCCLgFM1
	2NIMXLj0+HTF2QS5r1ghS1FkpCaI49NS9MBy8eGNL4UdwGwINALIAJGDY+NYTrSAL8tUXE4x
	An9LQjEhdIlPszxJqjJO6hvgg/39/H19DhwMELk51gh/RwlggkzJXeC4dE4eJ89I5hRGwGPs
	hCow+LQoLGv+p+fei0Lv8Ho3MyLoV1G6oIbVb51SncPJOjcDCnO121w8H+x5SjwLvbq/wuAj
	C5X9S8/HShtDY0wx7ZkleWRbnCxSEHtPFdleJgnpchssiz4+nDhijg30jXDx8rg7s6us49CV
	+helOmWNxD16zzF9pFYg1XWOizNEpCJRJvUm5ArZX/9VZnjsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAd1Yjs4Qg5fnBCyuXDzEZPF30jF2
	izvz/7JavF/Ww2jx5EA7o8WBPzsYLZoXr2ez+P/oNavFqqk7WSzW/FWy6H/8mtmi80IHq8Xl
	XXPYLF713mC3uHvvBIvF75vf2SwmTF/LYtG69wi7xbKWNhaLSTukLPZf8bJ4+fEEi4OYx4bP
	TWwea+atYfT4/WsSo8e3r5NYPN7faGX3+He4n8lj56y77B6bVnWyedy5tofNY//cNewei/sm
	s3pMmXuE1aP/r4FH35ZVjB7br81j9vi8SS5AIKqB0SYjNTEltUghNS85PyUzL91WyTs43jne
	1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHGApKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1D
	guB6jAzQQMIaxoynG+exF2zkrbi7Nb6BcRJ3FyMnh4SAicTE8ytZIGwxiQv31rN1MXJxCAks
	YpTYs/crE0hCSKCPSWL1IkUQm01AT2LBv6/MIEUiAiuZJF69+8cI4jALXGaU6Fj0kBWkSljA
	SeLcj1lsIDaLgKrEt6l7GUFsXgFXifuL5rJ3MXIArVOQmDPJBiTMKeAmcWnTf0aIZa4SPxo2
	ME9g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziBPJPewbiqweIQowAHoxIPb8Dl
	9hAh1sSy4srcQ4wSHMxKIrxJNzpChHhTEiurUovy44tKc1KLDzGaAh01kVlKNDkfmNzySuIN
	jU3MTY1NLU0sTMwslcR5lezbQoQE0hNLUrNTUwtSi2D6mDg4pYAh5/Fq0Ze4qu+tu7g741Yx
	FTSz33D+d2vVljxbxobXLE93bfcUieCpDNi068Pu+F/CU+SaE9y/HOZYId9oGHbY6ATTvR+v
	2Z/29D3dJ3SzoO7JIp7k8Mnn9FdGbV3czRKyWMj55OqFt8QT3hb82xJUsHbzVbvv/7d9eP1/
	UcXB07WXfKw+8C6RU2Ipzkg01GIuKk4EAJXHYRo2AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the SRAM allocator returns device memory via ioremap.
This causes issues on ARM64 when the internal SoC SRAM allocated by
the generic sram driver is used for audio playback. The destination
buffer address (which is ioremapped SRAM) is not 64-bit aligned for
certain streams (e.g. 44.1k sampling rate). In such cases we get
unhandled alignment faults. Use ioremap_wc in place of ioremap which
gives us normal non-cacheable memory instead of device memory.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
This is based on the discussion about the crash here:
http://www.spinics.net/lists/arm-kernel/msg384647.html

 drivers/misc/sram.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
index 21181fa..15b4d4e 100644
--- a/drivers/misc/sram.c
+++ b/drivers/misc/sram.c
@@ -69,12 +69,23 @@ static int sram_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&reserve_list);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	virt_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(virt_base))
-		return PTR_ERR(virt_base);
+	if (!res) {
+		dev_err(&pdev->dev, "found no memory resource\n");
+		return -EINVAL;
+	}
 
 	size = resource_size(res);
 
+	if (!devm_request_mem_region(&pdev->dev,
+			res->start, size, pdev->name)) {
+		dev_err(&pdev->dev, "could not request region for resource\n");
+		return -EBUSY;
+	}
+
+	virt_base = devm_ioremap_wc(&pdev->dev, res->start, size);
+	if (IS_ERR(virt_base))
+		return PTR_ERR(virt_base);
+
 	sram = devm_kzalloc(&pdev->dev, sizeof(*sram), GFP_KERNEL);
 	if (!sram)
 		return -ENOMEM;
-- 
1.7.9.5

