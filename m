Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaAZP7u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 10:59:50 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59235 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaAZP7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 10:59:49 -0500
MIME-Version: 1.0
Date: Sun, 26 Jan 2014 10:59:48 -0500
X-Google-Sender-Auth: KSF8CP1FzDoLNIRYzbOjMa92GIA
Message-ID: <CA+5PVA4fnCo8anT0HZCVu4+AFAseibm=0yD8nL3Lm7Q5dA-qZQ@mail.gmail.com>
Subject: ath9k ARM build error with v3.13-8330-g4ba9920
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: ath9k-devel@venema.h4ckr.net, netdev <netdev@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This commit:

commit 4dc78c437a0a2ac152a2b2c5e91a814a6ef3599e
Author: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Date:   Wed Dec 18 09:53:26 2013 +0530

    ath9k: Fix RTC reset delay

    The delay that is required after issuing a RTC reset
    varies for each chip. Handle this properly.

    Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

adds a udelay(10000) call to the ath9k driver.  This will cause a
build error on various ARM configs because the value passed to udelay
is too large:

ERROR: "__bad_udelay" [drivers/net/wireless/ath/ath9k/ath9k_hw.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Is the 10000 microsecond udelay really required?  I believe the limit
on ARM is 2000.  Perhaps something else could be done in this case?

josh
