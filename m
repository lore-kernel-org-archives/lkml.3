Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaBMOfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:35:38 -0500
Received: from 213083164162.static.sonofon.dk ([213.83.164.162]:47746 "EHLO
	HORWDSPRD01.spectralink.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751323AbaBMOfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:35:36 -0500
From: =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
To: richardcochran@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
Subject: [PATCH v3 0/3] dp83640: Get pin and master/slave configuration from DT
Date: Thu, 13 Feb 2014 15:35:22 +0100
Message-Id: <1392302129-24947-1-git-send-email-stefan.sorensen@spectralink.com>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Feb 2014 14:35:34.0760 (UTC) FILETIME=[DADE3680:01CF28C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add DT configuration to the DP83640 PHY driver and makes
the configuration of periodic output pins dynamic.

Changes since v2:
 - Add patch to properly configure perout triggers 0+1
 - Keep extts and perout numbers separate
 - Shorten pr_err lines

Changes since v1:
 - Add bindings documentation
 - Keep module parameters
 - Rename gpio->pin
 - Split patch into DT part and dynamic periodic output support

Stefan Sørensen (3):
  net:phy:dp83640: Program pulsewidth2 values of perout triggers 0 and 1
  net:phy:dp83640: Support a configurable number of periodic outputs
  net:phy:dp83640: Get pin and master/slave configuration from DT

 Documentation/devicetree/bindings/net/dp83640.txt |  29 ++++
 drivers/net/phy/dp83640.c                         | 199 +++++++++++++++-------
 2 files changed, 170 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dp83640.txt

-- 
1.8.5.3

