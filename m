Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3HABw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:52:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13819 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3HABw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:52:57 -0400
X-AuditID: cbfee68e-b7f276d000002279-4e-51f9bf78dab3
From: Jingoo Han <jg1.han@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        "'Florian Vaussard'" <florian.vaussard@epfl.ch>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] mfd: twl4030-power: Staticize local functions
Date: Thu, 01 Aug 2013 10:52:55 +0900
Message-id: <002b01ce8e59$d763f990$862becb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6OWdPD/wXl5I/qQ/6L5xlK++npUg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zY92K/T8DDa7dZbM486qP0eLywkus
	Fve/HgWyds1hs5j18QerxeluVgc2j2Wtq5k97lzbw+Yx72SgR9+WVYwex29sZ/L4vEkugC2K
	yyYlNSezLLVI3y6BK+NjZ2LBUr6K9Wf6WBsYV/F0MXJySAiYSExds4sNwhaTuHBvPZDNxSEk
	sIxRYufaKYwwRQ1ftzKD2EIC0xkl9v/Jgyj6xShxZtFBsASbgJrEly+H2bsYOThEBLwkbt0J
	AqlhFpjLKDHn5BawQcICdhINt96BbWMRUJV4tXE1mM0rYCnR2NAJZQtK/Jh8jwXEZhbQkli/
	8zgThC0vsXnNW2aIgxQkdpx9DTZTREBPYumJS4wQNSIS+168YwRZLCFwil2icc1HZohlAhLf
	Jh9iATlOQkBWYtMBqDmSEgdX3GCZwCg2C8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6UXGekV
	J+YWl+al6yXn525ihERi3w7GmwesDzEmA62fyCwlmpwPjOS8knhDYzMjC1MTU2Mjc0sz0oSV
	xHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBOf/XPXGT7K6f6zXU8wlPXX1rZl6T5
	M7PxXfHsRznBD2L69cxveDcsC2Df9Tz9LOvmrkhO5+JX6sp/hNzmB59TsX07a95Z3dmdP2NU
	Ov46FjdY1pvN/L3A6oVHyKLEW69cA/TMTxYd2XvBQOOsgP6ZWSllyysubqxl26355531Zb9T
	rA6LBT4rsRRnJBpqMRcVJwIA6M7nkdoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jQd2K/T8DDd4tYbI486qP0eLywkus
	Fve/HgWyds1hs5j18QerxeluVgc2j2Wtq5k97lzbw+Yx72SgR9+WVYwex29sZ/L4vEkugC2q
	gdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gKJYWy
	xJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGx87EgqV8FevP9LE2MK7i6WLk
	5JAQMJFo+LqVGcIWk7hwbz0biC0kMJ1RYv+fvC5GLiD7F6PEmUUHwYrYBNQkvnw5zN7FyMEh
	IuAlcetOEEgNs8BcRok5J7cwgtQIC9hJNNx6BzaIRUBV4tXG1WA2r4ClRGNDJ5QtKPFj8j0W
	EJtZQEti/c7jTBC2vMTmNW+hDlKQ2HH2NdhMEQE9iaUnLjFC1IhI7HvxjnECo8AsJKNmIRk1
	C8moWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjvNnUjsYVzZYHGIU4GBU4uHN
	2PozUIg1say4MvcQowQHs5II79Z0oBBvSmJlVWpRfnxRaU5q8SHGZKBPJzJLiSbnA1NQXkm8
	obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwZr8/aLX1XGHo1QOb
	5p29JSO3m7/P+bOvtpP8pvAPH2e0fFgV2n2Jz9Os9bfoxShPyc7MqTs6uW0Sr3p/yBF0e7hr
	98boX+s/Ht+4YeH3SzqH1oquZ7ghc/9F89r9J9IyM5UMS2adX7g+oDPkNNffqKJzE8uefVQ4
	vrhJdJuhE/sxIaG8GnGBMCWW4oxEQy3mouJEAMGR3as3AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl4030_power_configure_scripts(), twl4030_power_configure_resources(),
twl4030_power_probe() are used only in this file.

Fix the following sparse warnings:

drivers/mfd/twl4030-power.c:496:5: warning: symbol 'twl4030_power_configure_scripts' was not declared. Should it be static?
drivers/mfd/twl4030-power.c:512:5: warning: symbol 'twl4030_power_configure_resources' was not declared. Should it be static?
drivers/mfd/twl4030-power.c:556:5: warning: symbol 'twl4030_power_probe' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/twl4030-power.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index a5fd3c7..adce79d 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -493,7 +493,7 @@ int twl4030_remove_script(u8 flags)
 	return err;
 }
 
-int twl4030_power_configure_scripts(struct twl4030_power_data *pdata)
+static int twl4030_power_configure_scripts(struct twl4030_power_data *pdata)
 {
 	int err;
 	int i;
@@ -509,7 +509,7 @@ int twl4030_power_configure_scripts(struct twl4030_power_data *pdata)
 	return 0;
 }
 
-int twl4030_power_configure_resources(struct twl4030_power_data *pdata)
+static int twl4030_power_configure_resources(struct twl4030_power_data *pdata)
 {
 	struct twl4030_resconfig *resconfig = pdata->resource_config;
 	int err;
@@ -553,7 +553,7 @@ static bool twl4030_power_use_poweroff(struct twl4030_power_data *pdata,
 	return false;
 }
 
-int twl4030_power_probe(struct platform_device *pdev)
+static int twl4030_power_probe(struct platform_device *pdev)
 {
 	struct twl4030_power_data *pdata = pdev->dev.platform_data;
 	struct device_node *node = pdev->dev.of_node;
-- 
1.7.10.4


