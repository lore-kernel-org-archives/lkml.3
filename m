Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaFTPAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:00:17 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:38443 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaFTPAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:00:12 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 00/41] Cleanup and consolidate efuse related code.
Date: Fri, 20 Jun 2014 20:29:06 +0530
Message-Id: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


navin patidar (41):
  staging: rtl8188eu: Rename hal_EfusePowerSwitch_RTL8188E()
  staging: rtl8188eu: Remove rtl8188e_ReadEFuse()
  staging: rtl8188eu: Remove unused function ReadEFuse_Pseudo()
  staging: rtl8188eu: Remove rtl8188e_EfuseGetCurrentSize()
  staging: rtl8188eu: Remove unused function
    Hal_EfuseGetCurrentSize_Pseudo()
  staging: rtl8188eu: Remove function
    Hal_EFUSEGetEfuseDefinition_Pseudo88E()
  staging: rtl8188eu: Rename Hal_EFUSEGetEfuseDefinition88E()
  staging: rtl8188eu: assign hal_EfusePgPacketRead_8188e() to
    ->Efuse_PgPacketRead
  staging:rtl8188eu:assign hal_EfusePgPacketWrite_8188e() to
    ->Efuse_PgPacketWrite
  staging:rtl8188eu: Assign rtl8188e_Efuse_WordEnableDataWrite() to
    ->Efuse_WordEnableDataWrite
  staging: rtl8188eu: rtw_efuse.c: Remove unnecessary function
    declaration
  staging: rtl8188eu: Rename rtl8188e_EFUSE_GetEfuseDefinition()
  staging: rtl8188eu: Rename hal_EfuseGetCurrentSize_8188e()
  staging: rtl8188eu: Rename rtl8188e_EfusePowerSwitch() to
    Efuse_PowerSwitch()
  staging: rtl8188eu: Rename function Hal_EfuseWordEnableDataWrite()
  staging: rtl8188eu: Remove function Hal_EfuseReadEFuse88E()
  staging: rtl8188eu: Rename function ReadEFuseByIC() to
    efuse_ReadEFuse()
  staging: rtl8188eu: Rename hal_EfusePgPacketRead_8188e() to
    Efuse_PgPacketRead()
  staging: rtl8188eu: Rename hal_EfusePgPacketWrite_8188e()
  staging: rtl8188eu: Remove function Efuse_Write1ByteToFakeContent()
  staging: rtl8188eu: Remove function Efuse_Read1ByteFromFakeContent()
  staging: rtl8188eu: Remove function rtw_BT_efuse_map_write()
  staging: rtl8188eu: Remove unused function Efuse_PgPacketWrite_BT()
  staging: rtl8188eu: Remove function rtw_BT_efuse_map_read()
  staging: rtl8188eu: Remove unused function ReadEFuseByte()
  staging: rtl8188eu: Remove unused function EFUSE_Read1Byte()
  staging: rtl8188eu: efuse_OneByteRead():Remove unused parameter bool
    test
  staging: rtl8188eu: efuse_OneByteWrite(): Remove unused parameter
    bool test
  staging: rtl8188eu: efuse_ReadEFuse(): Remove parameter bool
    bPseudoTest
  staging: rtl8188eu: Efuse_GetCurrentSize(): Remove parameter bool
    test
  staging: rtl8188eu: Efuse_ReadAllMap(): Remove unused parameter bool
    test
  staging: rtl8188eu: EFUSE_ShadowMapUpdate():Remove unused parameter
    bool test
  staging: rtl8188eu: Efuse_WordEnableDataWrite(): Remove unused
    parameter test
  staging: rtl8188eu: hal_EfuseCheckIfDatafollowed(): Remove unused
    parameter
  staging: rtl8188eu: Remove bool bPseudoTest parameter from efuse
    functions
  staging: rtl8188eu: rtl8188e_hal_init.c: Remove forward declarations
  staging: rtl8188eu: hal_EfusePartialWriteCheck(): Remove bluetooth
    specific code
  staging: rtl8188eu: rtw_efuse.c: Remove unused global variables
  staging: rtl8188eu: rtw_efuse.c: Remove unused local variables
  staging: rtl8188eu: rtw_efuse.c: Remove unnecessary comments
  staging: rtl8188eu: Move all efuse related code to rtw_efuse.c

 drivers/staging/rtl8188eu/core/rtw_efuse.c        | 1392 +++++++++++++--------
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c     |   10 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c | 1253 +------------------
 drivers/staging/rtl8188eu/include/hal_intf.h      |   18 -
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h  |    2 +
 drivers/staging/rtl8188eu/include/rtw_efuse.h     |   43 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |  108 +-
 7 files changed, 920 insertions(+), 1906 deletions(-)

--
1.7.10.4

