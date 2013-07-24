Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3GXShi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:37:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44504 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXShf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:37:35 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, linux-serial@vger.kernel.org
Subject: [PATCH 0/4] msm_serial fixes and improvements
Date: Wed, 24 Jul 2013 11:37:27 -0700
Message-Id: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.4.837.g0bde8c0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a couple fixes and improvements to the msm_serial
driver. The first two patches fix a bug on UARTDM devices and
silence sparse warnings. The last two patches improve the baud
code detection and increase the throughput on UARTDM devices.

After this it is rather trivial to add support for newer UARTDM
devices via new compatible fields.

Stephen Boyd (4):
  msm_serial: Fix NUL byte output on UARTDM
  msm_serial: Fix sparse warnings
  msm_serial: Make baud_code detection more dynamic
  msm_serial: Send more than 1 character at a time on UARTDM

 drivers/tty/serial/msm_serial.c | 180 ++++++++++++++++++++--------------------
 drivers/tty/serial/msm_serial.h |  19 ++---
 2 files changed, 97 insertions(+), 102 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

