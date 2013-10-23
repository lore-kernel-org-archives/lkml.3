Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab3JWDNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 23:13:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473Ab3JWDNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 23:13:52 -0400
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>, Seiji Aguchi <saguchi@redhat.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>
Cc: "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [BUG] pstore: failed to load 76 record(s) from 'efi'
Date: Wed, 23 Oct 2013 11:13:33 +0800
Message-ID: <87zjq0llwi.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,
  after mount pstore with efi as backend there are only 11 entries in
  pstore dir. Although I have about 80 pstore entries in my nvram.
  I can reproduce it 100% on my DELL XPS. And will try it on one more
  vendor.

  my kernel version is 3.12-rc4. Please let me know if it's not a kernel
  bug but a buggy firmware. :-)
  
  Here is my dmesg out put:
  [   17.076222] IPv6: ADDRCONF(NETDEV_CHANGE): p3p1: link becomes ready
  [  104.749604] pstore: failed to load 76 record(s) from 'efi'  <-- this line appear when I mount pstore.
  [  104.749610] SELinux: initialized (dev pstore, type pstore), not configured for labeling

  Here is the output of `ls /sys/firmware/efi/vars`:
AcpiGlobalVariable-af9ffd67-ec10-488a-9dfc-6cbf5ee22c2e
AMITSESetup-c811fa38-42c8-4579-a9bb-60e94eddfb34
Boot0000-8be4df61-93ca-11d2-aa0d-00e098032b8c
Boot0001-8be4df61-93ca-11d2-aa0d-00e098032b8c
Boot0002-8be4df61-93ca-11d2-aa0d-00e098032b8c
Boot0003-8be4df61-93ca-11d2-aa0d-00e098032b8c
Boot0004-8be4df61-93ca-11d2-aa0d-00e098032b8c
Boot0005-8be4df61-93ca-11d2-aa0d-00e098032b8c
BootCurrent-8be4df61-93ca-11d2-aa0d-00e098032b8c
BootOptionSupport-8be4df61-93ca-11d2-aa0d-00e098032b8c
BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c
CmosError-ceab3323-daab-92ee-c112-abee5a6ebe2c
ConIn-8be4df61-93ca-11d2-aa0d-00e098032b8c
ConInDev-8be4df61-93ca-11d2-aa0d-00e098032b8c
ConOut-8be4df61-93ca-11d2-aa0d-00e098032b8c
ConOutChild1-8be4df61-93ca-11d2-aa0d-00e098032b8c
ConOutChildNumber-8be4df61-93ca-11d2-aa0d-00e098032b8c
ConOutDev-8be4df61-93ca-11d2-aa0d-00e098032b8c
db-d719b2cb-3d3a-4596-a3bc-dad00e67656f
dbx-d719b2cb-3d3a-4596-a3bc-dad00e67656f
DebuggerSerialPortsEnabledVar-97ca1a5b-b760-4d1f-a54b-d19092032c90
DefaultConOutChild-8be4df61-93ca-11d2-aa0d-00e098032b8c
DefaultFBOSetDevOrder-0c923ca9-df73-4ac8-b6d2-98ddc30d99fc
DefaultFBOSetDevOrderUEFI-0c923ca9-df73-4ac8-b6d2-98ddc30d99fc
DELLDIAG_EEPROM-86fd3e21-8683-4f2e-bcc1-2c52493bd1f6
del_var
DriverHealthCount-7459a7d4-6533-4480-bba7-79e25a4443c9
DriverHlthEnable-0885f288-418c-4be1-a6af-8bad61da08fe
dump-type0-10-1-1379387013-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-10-1-1380015708-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-10-1-1380016446-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-10-1-1380441690-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-10-1-1380448560-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-10-1-1380460890-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-10-1-1380467798-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-10-1-1382496073-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-11-1-1379387013-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-11-1-1380015708-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-11-1-1380016446-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-11-1-1380441691-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-11-1-1380448560-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-11-1-1382496074-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-1-1-1379387012-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-1-1-1380015706-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-1-1-1380016444-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-1-1-1380441689-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-1-1-1380448559-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-1-1-1380460875-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-1-1-1380467797-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-1-1-1380524664-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-1-1-1380526061-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-1-1-1380527153-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-1-1-1382496055-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-2-1-1379387012-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-2-1-1380015706-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-2-1-1380016445-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-2-1-1380441689-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-2-1-1380448559-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-2-1-1380460888-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-2-1-1380467797-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-2-1-1380524664-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-2-1-1380526061-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-2-1-1382496055-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-3-1-1379387012-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-3-1-1380015706-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-3-1-1380016445-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-3-1-1380441689-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-3-1-1380448559-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-3-1-1380460889-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-3-1-1380467797-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-3-1-1380524664-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-3-1-1382496055-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-4-1-1379387012-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-4-1-1380015707-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-4-1-1380016445-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-4-1-1380441689-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-4-1-1380448559-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-4-1-1380460889-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-4-1-1382496073-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-5-1-1379387012-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-5-1-1380015707-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-5-1-1380016445-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-5-1-1380441690-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-5-1-1380448559-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-5-1-1380460889-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-5-1-1380467797-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-5-1-1382496073-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-6-1-1379387013-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-6-1-1380015707-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-6-1-1380016445-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-6-1-1380441690-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-6-1-1380448559-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-6-1-1380460889-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-6-1-1382496073-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-7-1-1379387013-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-7-1-1380015707-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-7-1-1380016445-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-7-1-1380441690-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-7-1-1380448560-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-7-1-1380460889-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-7-1-1382496073-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-8-1-1379387013-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-8-1-1380015707-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-8-1-1380016446-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-8-1-1380441690-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-8-1-1380448560-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-8-1-1380460889-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-8-1-1382496073-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-9-1-1379387013-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-9-1-1380015707-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-9-1-1380016446-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-9-1-1380441690-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-9-1-1380448560-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-9-1-1380460890-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-9-1-1382496073-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
EfiTime-9d0da369-540b-46f8-85a0-2b5f2c301e15
ErrOut-8be4df61-93ca-11d2-aa0d-00e098032b8c
ErrOutDev-8be4df61-93ca-11d2-aa0d-00e098032b8c
FBOSetDevOrder-0c923ca9-df73-4ac8-b6d2-98ddc30d99fc
FBOSetDevOrderUEFI-0c923ca9-df73-4ac8-b6d2-98ddc30d99fc
FixedBoot-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
FixedBootUEFI-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
FPDT_Variable-8be4df61-93ca-11d2-aa0d-00e098032b8c
GnvsAreaVar-69917fed-3857-45fd-b687-434b5614ced4
HddSmartError-40ba5790-a9d1-4709-b49e-930567634ffb
HobRomImage-dde1bc72-d45e-4209-ab85-14462d2f5074
IccAdvancedSetupDataVar-7b77fb8b-1e0d-4d7e-953f-3980a261e077
KEK-8be4df61-93ca-11d2-aa0d-00e098032b8c
Lang-8be4df61-93ca-11d2-aa0d-00e098032b8c
LangCodes-8be4df61-93ca-11d2-aa0d-00e098032b8c
LegacyDevOrder-a56074db-65fe-45f7-bd21-2d2bdd8e9652
MemCeil.-40312829-7891-4abd-b200-0c541b061939
MemoryTypeInformation-4c19049f-4137-4dd3-9c10-8b97a83ffdfa
MonotonicCounter-8be4df61-93ca-11d2-aa0d-00e098032b8c
MrcS3Resume2-87f22dcb-7304-4105-bb7c-317143ccc23b
NBGopPlatformData-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
NBPlatformData-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
NetworkStackVar-d1405d16-7afc-4695-bb12-41459d3695a2
new_var
NvRamSpdMap-717fc150-abd9-4614-8015-0b3323eab95c
OA3DellMSDMvariable-fdad31fb-ef81-49ec-aed2-1ddacca1268d
OA3MSDMvariable-8be4df61-93ca-11d2-aa0d-00e098032b8c
OemCpuData-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
OldFBOSetDevOrder-0c923ca9-df73-4ac8-b6d2-98ddc30d99fc
OldFBOSetDevOrderUEFI-0c923ca9-df73-4ac8-b6d2-98ddc30d99fc
OldLegacyDevOrder-a56074db-65fe-45f7-bd21-2d2bdd8e9652
OsIndications-8be4df61-93ca-11d2-aa0d-00e098032b8c
OsIndicationsSupported-8be4df61-93ca-11d2-aa0d-00e098032b8c
PBRDevicePath-8be4df61-93ca-11d2-aa0d-00e098032b8c
PchInit-e6c2f70a-b604-4877-85ba-deec89e117eb
PchS3Peim-e6c2f70a-b604-4877-85ba-deec89e117eb
PciSerialPortsLocationVar-560bf58a-1e0d-4d7e-953f-2980a261e031
PK-8be4df61-93ca-11d2-aa0d-00e098032b8c
PlatformLang-8be4df61-93ca-11d2-aa0d-00e098032b8c
PlatformLangCodes-8be4df61-93ca-11d2-aa0d-00e098032b8c
PNP0501_0_NV-560bf58a-1e0d-4d7e-953f-2980a261e031
PNP0501_0_VV-560bf58a-1e0d-4d7e-953f-2980a261e031
PNP0510_0_NV-560bf58a-1e0d-4d7e-953f-2980a261e031
PNP0510_0_VV-560bf58a-1e0d-4d7e-953f-2980a261e031
PreviousMemoryTypeInformation-4c19049f-4137-4dd3-9c10-8b97a83ffdfa
RestorePostScreen-8be4df61-93ca-11d2-aa0d-00e098032b8c
S3SS-4bafc2b4-02dc-4104-b236-d6f1b98d9e84
SaPegData-c4975200-64f1-4fb6-9773-f6a9f89d985e
SbAslBufferPtrVar-01f33c25-764d-43ea-aeea-6b5a41f3f3e8
ScramblerBaseSeed-87f22dcb-7304-4105-bb7c-317143ccc23b
SecureBoot-8be4df61-93ca-11d2-aa0d-00e098032b8c
SerialPortsEnabledVar-560bf58a-1e0d-4d7e-953f-2980a261e031
Setup-80e1202e-2697-4264-9cc9-80762c3e5863
Setup-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
SetupMode-8be4df61-93ca-11d2-aa0d-00e098032b8c
SetupPlatformData-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
SetupSnbPpmFeatures-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
SignatureSupport-8be4df61-93ca-11d2-aa0d-00e098032b8c
SioSerialPortsLocationVar-560bf58a-1e0d-4d7e-953f-2980a261e031
SMBIOS_START_ADDR-0a602c5b-05a0-40c4-9181-edcd891d0036
StdDefaults-4599d26f-1a11-49b8-b91f-858745cff824
TdtAdvancedSetupDataVar-7b77fb8b-1e0d-4d7e-953f-3980a261e076
test1-12341234-1234-1234-1234-123412341234
test-12341234-1234-1234-1234-123412341234
test2-12341234-1234-2134-1234-123412341234
test3-12341234-1234-1234-1234-123412341234
test4-12341234-1234-1234-1234-123412341234
test5-12341234-1234-1234-1234-123412341234
test6-12341234-1234-1234-1234-123412341234
Timeout-8be4df61-93ca-11d2-aa0d-00e098032b8c
UsbHandOnOffEntry-0a602c5b-05a0-40c4-9181-edcd891d0018
UsbMassDevNum-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
UsbMassDevValid-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
USB_POINT-8be4df61-93ca-11d2-aa0d-00e098032b8c
UsbSupport-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
WdtPersistentData-78ce2354-cfbc-4643-aeba-07a27fa892bf

-- 
Best,
Madper Xie.
