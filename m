Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaIBIXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:23:17 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36932 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaIBIXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:23:15 -0400
Message-ID: <54057E6F.70308@monom.org>
Date: Tue, 02 Sep 2014 10:23:11 +0200
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: linux-nfc@ml01.01.org, linux-kernel@vger.kernel.org
Subject: NFC depmod dependecy cycles
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

I just tried 3.17-rc3 and run into this problem:

# make modules_install

  DEPMOD  3.17.0-rc3-00002-g7505cea
depmod: WARNING: found 6 modules in dependency cycles!
depmod: WARNING:
/lib/modules/3.17.0-rc3-00002-g7505cea/kernel/drivers/nfc/st21nfcb/st21nfcb.ko
in dependency cycle!
depmod: WARNING:
/lib/modules/3.17.0-rc3-00002-g7505cea/kernel/drivers/nfc/st21nfcb/ndlc.ko
in dependency cycle!
depmod: WARNING:
/lib/modules/3.17.0-rc3-00002-g7505cea/kernel/net/rfkill/rfkill.ko in
dependency cycle!
depmod: WARNING:
/lib/modules/3.17.0-rc3-00002-g7505cea/kernel/net/nfc/nfc.ko in
dependency cycle!
depmod: WARNING:
/lib/modules/3.17.0-rc3-00002-g7505cea/kernel/net/nfc/nci/nci.ko in
dependency cycle!
depmod: WARNING:
/lib/modules/3.17.0-rc3-00002-g7505cea/kernel/lib/crc-ccitt.ko in
dependency cycle!
./scripts/depmod.sh: line 57: 23387 Segmentation fault      (core
dumped) "$DEPMOD" "$@" "$KERNELRELEASE" $SYMBOL_PREFIX
make: *** [_modinst_post] Error 139


After disabling the whole NFC subsystem depmod was happy again.

cheers,
daniel
