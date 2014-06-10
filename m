Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaFJNvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:51:45 -0400
Received: from mail00k.mail.t-online.hu ([84.2.227.137]:64242 "EHLO
	mail00k.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaFJNvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:51:43 -0400
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2014 09:51:42 EDT
X-Authuid: hr@a1tech.hu
From: Robert Hodaszi <robert.hodaszi@digi.com>
To: jic23@kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, marex@denx.de,
        alexandre.belloni@free-electrons.com, jbe@pengutronix.de,
        hector.palacios@digi.com, fabio.estevam@freescale.com, lars@metafoo.de,
        Robert Hodaszi <robert.hodaszi@digi.com>
Subject: [PATCH 0/2] iio: mxs-lradc: fixes
Date: Tue, 10 Jun 2014 15:41:33 +0200
Message-Id: <1402407695-2984-1-git-send-email-robert.hodaszi@digi.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following patches are fixing some bugs in the MXS LRADC driver.

Note, that I tried the patches on a custom i.MX28 based module. I did not try
them on i.MX23.

The first patch fixes the analog voltage divider.

The second patch adds back the channel 9 to fix the LRADC channel indexes.
(E.g. currently the <&lradc 12> refers to the channel 13.)

Robert Hodaszi (2):
  iio: mxs-lradc: fix divider
  iio: mxs-lradc: add ADC channel 9 as a copy of channel 8

 drivers/staging/iio/adc/mxs-lradc.c | 73 ++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 30 deletions(-)

