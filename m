Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161258AbaDJNVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:21:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9105 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161238AbaDJNVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:21:12 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-3e-53469ac7544d
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, aaro.koskinen@iki.fi,
        tony@atomide.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 12/13] extcon: extcon-max8997: check if pdata exists
Date: Thu, 10 Apr 2014 15:16:50 +0200
Message-id: <1397135811-12866-13-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
References: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRfyyUcRzH+97z4x509rjQE9PsqbayUmfWvhuZFueZvzTrH/1RTzydK7+6
	w6itTkgs96uZSHGOwzlE2rD8uGMzqzgUq/wcKVYaIZvbyZ313+v9eb+29x8fAhG2oT6ENCWd
	k6WwSTTuir6zL5BnBsvFsed2Gmlo+hEOzW9OQfPsAzi58R2D2sXfCKwcGMagpuEpAlU/dRhU
	tUfAPlsHgLn6FhwOrzQAWPhhEYHWb09wWNvTiELdoxoUjndV4PB5jQqF1YZ8BC7q3vNg7eQo
	D37Nqcdh3a9dHKpLm1A419/Jh83LpSjM7x7gwx6rDYO9H6PD/RjTSxNgtja1KDOuLOYxXZ0V
	GKNWrQOms3yazzTUbeBM/6YOZV7XBzBtxkKcWWksw5ipibc40/vCxGeKc1dxZlmzgzOdfxX8
	GM8419AELkmaycnOhl13TdyaUIG0V3hWrUmJK4ABKwIuBEUGUwN9n/B99qasMy177EoIyWpA
	lc1bkf1QwKNG9VrgsHDyNNX+V+1kTxKhqkpGgENCyCGMMpp7EUdxiIyg9Du7TgklT1D6EZVz
	TkCKqaGidrQIEHtz/lSFNtSBLnvn7vFjDhSSkVRJE60GgipwwAi8uLT4NPkNSXJQoJxNlmek
	SALjU5PbgPOTS74dwKiAFkASgD4o6DNExgoxNlOenWwBFIHQnoLWEnGsUJDAZt/lZKnXZBlJ
	nNwCfAmUPiww54dcFpISNp27zXFpnOx/yyNcfBTg/tA9+5qPe5TU4vHMy32ebJ2P4MQm6QA7
	tRBW5PH5Tt6fWb7GZv/SfPKq/7Yk7lbo8YcXc5a6/NKPDIv6i91Wicd9kW7WMc3gFYt5ek15
	cz3YZW7bFFcpWoMi+9JRjwIliEfoyo2xmPMBTZqpScNMSI4t2ivL/8KlqLwgb3calSeyogBE
	Jmf/AfFhzPTFAgAA
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds check if pdata is NULL, to avoid NULL pointer dereference
when platform data is not available. After this changes, in described
situation driver will be configured with default values.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-max8997.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index c071588..d7d12e9 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -726,7 +726,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	if (pdata->muic_pdata) {
+	if (pdata && pdata->muic_pdata) {
 		struct max8997_muic_platform_data *muic_pdata
 			= pdata->muic_pdata;
 
-- 
1.7.9.5

