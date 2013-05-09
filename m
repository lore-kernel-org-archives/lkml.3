Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3EIRJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 13:09:48 -0400
Received: from nm24.access.bullet.mail.sp2.yahoo.com ([98.139.44.151]:27701
	"EHLO nm24.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab3EIRJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 13:09:46 -0400
X-Yahoo-Newman-Id: 645140.99242.bm@smtp103.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: xyHC95UVM1myPiJfGXro3TsPnfySeCL0LZbajV0R0jsmtAw
 djbv6Wm1_B734Z6g5uBKhQAqDkclBU7yE1kDYFocN8oLAqJaSMjBd6ew40lO
 MeRC_mNhao5WLep8l0BR1.zw1gUbeFAWH5C2SFfkxmsZdYr6N4WFHPnA5GpH
 AjvSmtI2a2QoJUn1CApXPXTNcWNnQuXmJnX0ye9yMQFx6f.3Vw0hRqLaDvRA
 5c1fVQuNEgAy2B_jn6ziMpOpH7.rdU_stgdg0K8HzmHjekcAjDaPcmjF6aOE
 lmYBT.HPQ8mf80LIn3s9WG6RhKIb_UT80LSYPftiun0QzJoDMauCucX6nhO.
 y8z4soE1cWKjG7OKASw0KKusBTvbqVzC3D2dtbO1y3l0GOiZuEu2bV8WgoP5
 xUaxc.Lw0cq3.B.XMDrbpDkRt_7a4fP1rbkbzWL8p5rlzG2IQ2IEnSvUS_fC
 d4gpgbUr_PwTloPv5CYvoEqKDANfrOZ9p0rY-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp103.sbc.mail.gq1.yahoo.com with SMTP; 09 May 2013 10:09:45 -0700 PDT
From: Guenter Roeck <linux@roeck-us.net>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Jean Delvare <khali@linux-fr.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jingoo Han <jg1.han@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 0/3] pm: Introduce __pm to mark power management code
Date: Thu,  9 May 2013 10:09:48 -0700
Message-Id: <1368119391-13837-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series introduces a marker for power management functions
and data. This this marker, #ifdef CONFIG_PM and #ifdef CONFIG_PM_SLEEP
can be removed from most of the code. This ensures that the conditional code
still compiles but is not included in the object file.

As a side effect, drivers declaring struct dev_pm_ops unconditionally
get a bit smaller if CONFIG_PM_SLEEP is not configured.

The first patch in the series introduces the marker, the following
two patches introduce the marker in two drivers to demonstrate its use.

The patch series depends on the "PM: Add pm_ops_ptr() macro" patch
submitted by Jingoo Han.
