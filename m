Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab3LJH67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:58:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab3LJH64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:58:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/25] 3.4.74-stable review
Date: Tue, 10 Dec 2013 00:00:08 -0800
Message-Id: <20131210075930.808460227@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.74 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Dec 12 07:59:15 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.74-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.74-rc1

Alan Cox <alan@linux.intel.com>
    drivers/char/i8k.c: add Dell XPLS L421X

David Cluytens <david.cluytens@gmail.com>
    USB: cdc-acm: Added support for the Lenovo RD02-D400 USB Modem

Colin Leitner <colin.leitner@googlemail.com>
    USB: spcp8x5: correct handling of CS5 setting

Colin Leitner <colin.leitner@googlemail.com>
    USB: mos7840: correct handling of CS5 setting

Colin Leitner <colin.leitner@googlemail.com>
    USB: pl2303: fixed handling of CS5 setting

Seth Heasley <seth.heasley@intel.com>
    i2c: i801: SMBus patch for Intel Avoton DeviceIDs

Seth Heasley <seth.heasley@intel.com>
    ahci: AHCI-mode SATA patch for Intel Avoton DeviceIDs

James Ralston <james.d.ralston@intel.com>
    ahci: Add Device IDs for Intel Lynx Point-LP PCH

Sergei Trofimovich <slyfox@gentoo.org>
    um: add missing declaration of 'getrlimit()' and friends

Tom Gundersen <teg@jklm.no>
    Input: mousedev - allow disabling even without CONFIG_EXPERT

Tom Gundersen <teg@jklm.no>
    Input: allow deselecting serio drivers even without CONFIG_EXPERT

Shawn Landden <shawn@churchofgit.com>
    net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Laxman Dewangan <ldewangan@nvidia.com>
    irq: Enable all irqs unconditionally in irq_resume

Liu Gang <Gang.Liu@freescale.com>
    powerpc/gpio: Fix the wrong GPIO input data on MPC8572/MPC8536

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Update list of irrecoverable errors on DELEGRETURN

Linus Walleij <linus.walleij@linaro.org>
    net: smc91: fix crash regression on the versatile

Stephen M. Cameron <scameron@beardog.cce.hp.com>
    SCSI: hpsa: return 0 from driver probe function on success, not 1

Stephen M. Cameron <scameron@beardog.cce.hp.com>
    SCSI: hpsa: do not discard scsi status on aborted commands

Dan Williams <dan.j.williams@intel.com>
    SCSI: libsas: fix usage of ata_tf_to_fis

James Bottomley <JBottomley@Parallels.com>
    SCSI: enclosure: fix WARN_ON in dual path device removing

Bo Shen <voice.shen@atmel.com>
    ASoC: wm8731: fix dsp mode configuration

Mark Brown <broonie@linaro.org>
    ASoC: wm8990: Mark the register map as dirty when powering down

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: authenc - Find proper IV address in ablkcipher callback

Horia Geanta <horia.geanta@freescale.com>
    crypto: ccm - Fix handling of zero plaintext when computing mac

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: scatterwalk - Set the chain pointer indication bit


-------------

Diffstat:

 Documentation/i2c/busses/i2c-i801  |  1 +
 Makefile                           |  4 ++--
 arch/um/os-Linux/start_up.c        |  2 ++
 crypto/algif_hash.c                |  3 +++
 crypto/algif_skcipher.c            |  3 +++
 crypto/authenc.c                   |  7 ++++---
 crypto/ccm.c                       |  3 ++-
 drivers/ata/ahci.c                 | 24 ++++++++++++++++++++++++
 drivers/char/i8k.c                 |  7 +++++++
 drivers/gpio/gpio-mpc8xxx.c        |  8 ++++++--
 drivers/i2c/busses/Kconfig         |  1 +
 drivers/i2c/busses/i2c-i801.c      |  3 +++
 drivers/input/Kconfig              |  2 +-
 drivers/input/keyboard/Kconfig     |  4 ++--
 drivers/input/serio/Kconfig        |  6 +++---
 drivers/misc/enclosure.c           |  7 +++++++
 drivers/net/ethernet/smsc/smc91x.h | 22 ++++------------------
 drivers/scsi/hpsa.c                |  4 ++--
 drivers/scsi/libsas/sas_ata.c      |  2 +-
 drivers/usb/class/cdc-acm.c        |  2 ++
 drivers/usb/serial/mos7840.c       | 32 ++++++++++++++++----------------
 drivers/usb/serial/pl2303.c        | 32 +++++++++++++++-----------------
 drivers/usb/serial/spcp8x5.c       | 30 ++++++++++++++----------------
 fs/nfs/nfs4proc.c                  | 10 ++++++++--
 include/crypto/scatterwalk.h       |  1 +
 kernel/irq/pm.c                    |  2 +-
 net/ipv4/udp.c                     |  3 +++
 sound/soc/codecs/wm8731.c          |  4 ++--
 sound/soc/codecs/wm8990.c          |  2 ++
 29 files changed, 142 insertions(+), 89 deletions(-)


