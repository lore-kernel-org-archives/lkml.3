Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbbA0Lam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:30:42 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36557 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbbA0Laj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:30:39 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-0d-54c7764be96f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>, Marek Belisko <marek@goldelico.com>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        Darren Hart <dvhart@infradead.org>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFT PATCH 0/4] Check return value of power_supply_register
Date: Tue, 27 Jan 2015 12:30:17 +0100
Message-id: <1422358221-13199-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xK7reZcdDDM5t4bBYcqKbxWLSk/fM
	Fl0LDSwmrpzMbPH6haHF5V1z2Cw+9x5htNjedpTF4t/SLWwWq/e8YLY4vbvEgdtj56y77B5r
	3p9i9jh27Q6Lx+YVWh6bVnWyefRtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfGyr7FbAWLuSsa
	bq9hb2CczdnFyMkhIWAi0bpjByuELSZx4d56ti5GLg4hgaWMEoeXr2eGcPqYJD78n8QOUsUm
	YCyxefkSsCoRgRZmiZ0LT7GAJJgFDCV+vvsDViQs4CJx9HYLM4jNIqAqsebmXaA4BwevgLvE
	yam2ENvkJE4em8w6gZF7ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQ0Pqyg3HxMatD
	jAIcjEo8vBxFx0OEWBPLiitzDzFKcDArifB6RQCFeFMSK6tSi/Lji0pzUosPMTJxcEo1MOb+
	qromMvm5wOJuvfO2mqfe6F1737613+vzBO7Fq5dI+PIG3eLfbSGwivtPx/awkpzKTWZHqvo8
	1z+5N/9REe+H1q+WK07e3cSxd/dWy6fGSmFrPwSce/T2RM3fhgbBBxc2bamK+lhVdJmF5cE3
	o4vq7+8rmEbMdefqKZ3F2u6l1mK4Z9GK5XOVWIozEg21mIuKEwFhcL+lCwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


During global rework of power supply register API I found possible
issues related to not checked return value.

The power_supply_register() return value was ignored and during driver
removal the power supply was always unregistered. This theoretically
could lead to invalid memory accesses. However I did not reproduce
the issue (only code analysis).

Affected drivers:
1. twl4030_madc
2. compal-laptop
3. ipaq_micro_battery

I prepared patches but DID NOT test them. Only compilation + sparse
 + smatch + coccicheck.

I am kindly asking for review and testing.


P.S. The acpi/sbs.c driver has the same issue. Before unregistering
power supply it checks if sbs->charger.dev is non-NULL... which will
be non-NULL in most error-paths. However the driver is little more
complicated so fixing this without doing tests would be very
error-prone.


Best regards,
Krzysztof


Krzysztof Kozlowski (4):
  power_supply: twl4030_madc: Check return value of
    power_supply_register
  compal-laptop: Check return value of power_supply_register
  power_supply: ipaq_micro_battery: Fix leaking workqueue
  power_supply: ipaq_micro_battery: Check return values in probe

 drivers/platform/x86/compal-laptop.c |  7 ++++++-
 drivers/power/ipaq_micro_battery.c   | 22 ++++++++++++++++++++--
 drivers/power/twl4030_madc_battery.c |  7 +++++--
 3 files changed, 31 insertions(+), 5 deletions(-)

-- 
1.9.1

