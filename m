Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaATVOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:14:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36378 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaATVOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:14:17 -0500
Date: Tue, 21 Jan 2014 00:13:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, Greg KH <gregkh@linuxfoundation.org>,
        bergwolf@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        oleg.drokin@intel.com, jacques-charles.lafoucriere@cea.fr,
        jinshan.xiong@intel.com, linux-metag@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: lustre: lustre: include: add
 "__attribute__((packed))" for the related union
Message-ID: <20140120211356.GG4815@mwanda>
References: <52DA4E6A.1000308@gmail.com>
 <20140118100547.GS7444@mwanda>
 <52DA56C2.5010802@gmail.com>
 <20140118142404.GT7444@mwanda>
 <52DBA3D4.3090308@gmail.com>
 <52DD0EFF.2010305@imgtec.com>
 <20140120123045.GV7444@mwanda>
 <52DD18A5.1090308@imgtec.com>
 <20140120125603.GD4815@mwanda>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20140120125603.GD4815@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I made a quick and dirty sparse patch to check for this.  I don't think
I will bother trying to send it to sparse upstream, but you can if you
want to.

It found 289 unions which might need a __packed added.  The lustre
unions were not in my allmodconfig so they're not listed.

Perhaps there could be a command line option or a pragma so that unions
will work in the kernel.  We don't care about linking to outside
libraries.

regards,
dan carpenter

diff --git a/symbol.c b/symbol.c
index ebba56deaf94..596e47883aad 100644
--- a/symbol.c
+++ b/symbol.c
@@ -187,6 +187,12 @@ static struct symbol * examine_struct_union_type(struct symbol *sym, int advance
 		bit_size = (bit_size + bit_align) & ~bit_align;
 	}
 	sym->bit_size = bit_size;
+
+	if (!advance && (info.bit_size / 8) % 4) {
+		int pad = 4 - (info.bit_size / 8) % 4;
+		warning(sym->pos, "'%s' union will be padded with %d bytes unless __attribute__((packed)).",  sym->ident ? sym->ident->name: "<null>", pad);
+	}
+
 	return sym;
 }
 

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=err-list

drivers/acpi/sbshc.c:55:7: warning: 'acpi_smb_status' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/atm/horizon.h:317:9: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:2173:15: warning: 'DAC960_V1_StatusMailbox' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:2580:15: warning: 'DAC960_GEM_OutboundDoorBellRegister' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:2618:15: warning: 'DAC960_GEM_ErrorStatusRegister' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:2867:15: warning: 'DAC960_BA_InboundDoorBellRegister' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:2891:15: warning: 'DAC960_BA_OutboundDoorBellRegister' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:2912:15: warning: 'DAC960_BA_InterruptMaskRegister' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:2929:15: warning: 'DAC960_BA_ErrorStatusRegister' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:3173:15: warning: 'DAC960_LP_InboundDoorBellRegister' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:3197:15: warning: 'DAC960_LP_OutboundDoorBellRegister' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:3218:15: warning: 'DAC960_LP_InterruptMaskRegister' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:3234:15: warning: 'DAC960_LP_ErrorStatusRegister' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:3487:15: warning: 'DAC960_LA_InboundDoorBellRegister' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:3511:15: warning: 'DAC960_LA_OutboundDoorBellRegister' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:3532:15: warning: 'DAC960_LA_InterruptMaskRegister' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:3548:15: warning: 'DAC960_LA_ErrorStatusRegister' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:3869:15: warning: 'DAC960_PG_ErrorStatusRegister' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:4155:15: warning: 'DAC960_PD_OutboundDoorBellRegister' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:4174:15: warning: 'DAC960_PD_InterruptEnableRegister' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/DAC960.h:4189:15: warning: 'DAC960_PD_ErrorStatusRegister' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/block/mtip32xx/mtip32xx.h:221:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/mtip32xx/mtip32xx.h:225:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/mtip32xx/mtip32xx.h:229:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/mtip32xx/mtip32xx.h:233:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/mtip32xx/mtip32xx.h:238:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/mtip32xx/mtip32xx.h:242:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/mtip32xx/mtip32xx.h:246:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/block/paride/paride.h:120:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/block/xen-blkback/common.h:197:1: warning: 'blkif_common_sring_entry' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/char/tpm/tpm_acpi.c:34:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/char/tpm/tpm.h:209:15: warning: 'cap_t' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/firmware/dcdbas.h:88:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/ast/ast_mode.c:991:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/gma500/oaktrail.h:138:7: warning: 'oaktrail_panel_rx' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/gma500/oaktrail.h:157:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/gma500/oaktrail.h:174:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/i915/intel_bios.h:245:7: warning: 'child_device_config' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:1079:9: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:1118:9: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:1169:9: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:1213:3: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:1219:3: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:1279:8: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:1363:8: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:1620:9: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:1636:8: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:1747:9: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:2491:15: warning: '_ATOM_FIRMWARE_CAPABILITY_ACCESS' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:3194:15: warning: '_ATOM_I2C_ID_CONFIG_ACCESS' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:3269:15: warning: '_ATOM_MODE_MISC_INFO_ACCESS' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:4139:8: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:4337:9: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:502:3: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:548:8: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:6444:8: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:6448:8: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:6467:3: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:6549:8: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:6553:8: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:6617:8: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:6621:8: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:7122:9: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:7137:9: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:7153:9: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:7225:9: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:7483:15: warning: '_ATOM_CONNECTOR_INFO_ACCESS' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:7562:15: warning: '_ATOM_ENCODER_ATTRIBUTE' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:847:9: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:901:8: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:906:9: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/atombios.h:951:9: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/ci_dpm.c:4828:7: warning: 'pplib_power_state' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/kv_dpm.c:2441:7: warning: 'pplib_power_state' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/ni_dpm.c:3910:7: warning: 'pplib_power_state' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/radeon_atombios.c:1994:7: warning: 'pplib_power_state' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/radeon_atombios.c:3261:7: warning: 'voltage_object_info' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/radeon_atombios.c:3267:7: warning: 'voltage_object' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/radeon_atombios.c:42:7: warning: 'atom_supported_devices' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/rs780_dpm.c:711:7: warning: 'pplib_power_state' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/rv6xx_dpm.c:1789:7: warning: 'pplib_power_state' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/rv770_dpm.c:2134:7: warning: 'pplib_power_state' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/rv770_smc.h:96:10: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/si_dpm.c:6131:7: warning: 'pplib_power_state' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/sumo_dpm.c:1385:7: warning: 'pplib_power_state' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/gpu/drm/radeon/trinity_dpm.c:1606:7: warning: 'pplib_power_state' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/gpu/drm/vmwgfx/svga3d_surfacedefs.h:211:17: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/gpu/drm/vmwgfx/svga3d_surfacedefs.h:215:17: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/hv/hyperv_vmbus.h:161:7: warning: 'hv_message_flags' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/input/misc/yealink.c:87:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/isdn/hisax/hisax.h:330:9: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/media/dvb-frontends/bcm3510_priv.h:38:15: warning: 'bcm3510_register_value' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/media/usb/dvb-usb/dib0700_core.c:661:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/mfd/lm3533-core.c:250:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/mmc/host/vub300.c:156:7: warning: 'sd_response' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/net/can/usb/ems_usb.c:183:23: warning: '<null>' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h:501:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h:115:7: warning: 'bnx2x_classification_ramrod_data' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/broadcom/cnic_defs.h:3255:7: warning: 'fcoe_idx16_field_union' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/broadcom/cnic_defs.h:3539:7: warning: 'fcoe_vlan_field_union' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/broadcom/cnic_defs.h:3547:7: warning: 'fcoe_vlan_vif_field_union' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/brocade/bna/bfi_enet.h:204:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/brocade/bna/bfi.h:34:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/brocade/bna/bfi.h:451:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/brocade/bna/bfi.h:460:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/intel/e1000e/hw.h:679:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/intel/e1000e/ich8lan.c:62:7: warning: 'ich8_hws_flash_status' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/intel/e1000e/ich8lan.c:79:7: warning: 'ich8_hws_flash_ctrl' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/intel/i40e/i40e_type.h:422:39: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/intel/i40e/i40e_type.h:452:39: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/intel/i40evf/i40e_type.h:430:39: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/intel/i40evf/i40e_type.h:460:39: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/intel/igb/e1000_hw.h:556:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/ethernet/intel/ixgbe/ixgbe.h:275:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/ethernet/intel/ixgbe/ixgbe_type.h:2283:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/ethernet/micrel/ks8851.c:58:7: warning: 'ks8851_tx_hdr' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/plip/plip.c:187:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/at76c50x-usb.h:227:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/ath/ath10k/htc.h:68:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/ath/ath10k/htc.h:72:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/ath/ath10k/htt.h:1013:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/ath/ath10k/htt.h:246:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/ath/ath10k/htt.h:545:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/ath/ath10k/htt.h:592:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/ath/ath10k/htt.h:633:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/ath/carl9170/wlan.h:345:15: warning: '<null>' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/net/wireless/b43legacy/xmit.h:18:1: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/b43/xmit.h:19:1: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/b43/xmit.h:238:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/b43/xmit.h:251:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/b43/xmit.h:266:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/hostap/hostap_wlan.h:906:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/ipw2x00/ipw2100.h:152:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/ipw2x00/libipw.h:428:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/iwlegacy/3945.h:144:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/iwlegacy/commands.h:1396:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/iwlegacy/commands.h:1498:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/iwlegacy/common.h:535:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/iwlwifi/dvm/commands.h:1298:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/libertas/host.h:327:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/mwifiex/fw.h:621:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/mwifiex/fw.h:640:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/mwifiex/fw.h:724:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/mwifiex/scan.c:61:7: warning: 'mwifiex_scan_cmd_config_tlv' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/ray_cs.h:36:11: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/rayctl.h:521:11: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/rayctl.h:604:11: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/rtlwifi/rtl8188ee/../wifi.h:629:7: warning: 'aci_aifsn' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/rtlwifi/rtl8192ce/../wifi.h:629:7: warning: 'aci_aifsn' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/rtlwifi/rtl8192cu/../wifi.h:629:7: warning: 'aci_aifsn' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/rtlwifi/rtl8192de/../wifi.h:629:7: warning: 'aci_aifsn' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/rtlwifi/rtl8192se/../wifi.h:629:7: warning: 'aci_aifsn' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/rtlwifi/rtl8723ae/../wifi.h:629:7: warning: 'aci_aifsn' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/ti/wl12xx/../wlcore/tx.h:116:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/ti/wl12xx/../wlcore/tx.h:137:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/ti/wl18xx/../wlcore/tx.h:116:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/ti/wl18xx/../wlcore/tx.h:137:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/net/wireless/ti/wlcore/tx.h:116:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/net/wireless/ti/wlcore/tx.h:137:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/nfc/pn533.c:222:7: warning: 'pn533_cmd_poll_initdata' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/platform/x86/dell-laptop.c:49:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/platform/x86/wmi.c:53:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/3w-9xxx.h:499:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/3w-sas.h:229:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/3w-xxxx.h:304:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/advansys.c:2354:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/bfa/bfa_defs.h:1013:7: warning: 'sfp_xcvr_so1_code_u' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/bfa/bfa_defs.h:1023:7: warning: 'sfp_xcvr_so2_code_u' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/bfa/bfa_defs.h:1033:7: warning: 'sfp_xcvr_eth_code_u' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/bfa/bfa_defs.h:1054:7: warning: 'sfp_xcvr_fc2_code_u' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/bfa/bfa_defs.h:1068:7: warning: 'sfp_xcvr_fc3_code_u' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/bfa/bfa_defs.h:988:7: warning: 'sfp_xcvr_e10g_code_u' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/bfa/bfa_fcs.h:203:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/bfa/bfi.h:57:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/BusLogic.h:287:7: warning: 'blogic_cntrl_reg' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/BusLogic.h:320:7: warning: 'blogic_int_reg' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/device_handler/scsi_dh_rdac.c:206:33: warning: '<null>' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/scsi/esas2r/atvda.h:198:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/esas2r/atvda.h:250:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/esas2r/atvda.h:301:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/esas2r/atvda.h:372:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/hpsa_cmd.h:192:7: warning: 'SCSI3Addr' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/ips.h:933:10: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/isci/phy.h:143:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/isci/probe_roms.h:231:23: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/isci/scu_task_context.h:921:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/megaraid.h:588:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/megaraid/megaraid_sas.h:389:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/megaraid/megaraid_sas.h:400:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/qla1280.h:400:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/scsi/qla1280.h:469:31: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/qla1280.h:485:31: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/qla1280.h:502:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/scsi/qla2xxx/qla_def.h:1525:15: warning: 'target_id_t' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:992:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/staging/ft1000/ft1000-usb/ft1000_hw.c:1141:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/staging/media/as102/as102_fw.h:29:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/staging/media/as102/as10x_cmd.h:193:7: warning: 'as10x_add_pid_filter' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/staging/slicoss/slichw.h:272:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/staging/slicoss/slichw.h:690:7: warning: 'oemfru' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/staging/slicoss/slichw.h:723:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
drivers/staging/slicoss/slichw.h:817:15: warning: '<null>' union will be padded with 1 bytes unless __attribute__((packed)).
drivers/staging/slicoss/slicoss.c:1192:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/staging/wlan-ng/p80211hdr.h:169:7: warning: 'p80211_hdr' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/staging/wlan-ng/prism2fw.c:98:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/tty/ipwireless/hardware.c:153:7: warning: 'nl_packet' union will be padded with 2 bytes unless __attribute__((packed)).
drivers/usb/storage/realtek_cr.c:92:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
fs/adfs/dir_f.h:42:7: warning: 'adfs_dirtail' union will be padded with 3 bytes unless __attribute__((packed)).
fs/cifs/cifspdu.h:555:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
fs/ocfs2/stack_user.c:164:7: warning: 'ocfs2_control_message' union will be padded with 1 bytes unless __attribute__((packed)).
fs/reiserfs/reiserfs.h:1169:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
fs/ufs/ufs_fs.h:293:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
/home/dcarpenter/progs/kernel/devel/arch/x86/include/asm/kvm_emulate.h:232:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
/home/dcarpenter/progs/kernel/devel/include/uapi/linux/atmsap.h:105:11: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
/home/dcarpenter/progs/kernel/devel/include/uapi/linux/atmsap.h:114:11: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
/home/dcarpenter/progs/kernel/devel/include/uapi/linux/bcache.h:200:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
/home/dcarpenter/progs/kernel/devel/include/uapi/linux/cciss_defs.h:56:15: warning: '_SCSI3Addr_struct' union will be padded with 2 bytes unless __attribute__((packed)).
/home/dcarpenter/progs/kernel/devel/include/uapi/linux/if_arcnet.h:93:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
/home/dcarpenter/progs/kernel/devel/include/uapi/linux/irda.h:148:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
/home/dcarpenter/progs/kernel/devel/include/uapi/linux/netfilter_ipv4/ipt_ECN.h:26:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
/home/dcarpenter/progs/kernel/devel/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h:13:7: warning: 'nf_conntrack_man_proto' union will be padded with 2 bytes unless __attribute__((packed)).
/home/dcarpenter/progs/kernel/devel/include/uapi/linux/netfilter/xt_ecn.h:28:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
/home/dcarpenter/progs/kernel/devel/include/uapi/linux/netfilter/xt_string.h:20:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
/home/dcarpenter/progs/kernel/devel/include/uapi/linux/nfsd/cld.h:50:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
/home/dcarpenter/progs/kernel/devel/include/uapi/sound/hdspm.h:158:15: warning: '<null>' union will be padded with 1 bytes unless __attribute__((packed)).
include/drm/drm_edid.h:139:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/drm/drm_edid.h:160:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/linux/f2fs_fs.h:360:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/linux/hyperv.h:330:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/linux/ide.h:269:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/linux/ide.h:278:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/linux/ieee80211.h:1025:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/linux/ieee80211.h:2021:15: warning: '<null>' union will be padded with 1 bytes unless __attribute__((packed)).
include/linux/input/sparse-keymap.h:38:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/linux/ipv6.h:170:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/linux/isdnif.h:372:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/linux/mlx4/cq.h:47:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/linux/phonet.h:35:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/linux/usb/wusb-wa.h:101:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/linux/usb/wusb-wa.h:106:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/linux/usb/wusb-wa.h:97:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/net/caif/cfctrl.h:65:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/net/irda/discovery.h:53:15: warning: '__u16_host_order' union will be padded with 2 bytes unless __attribute__((packed)).
include/net/mac80211.h:681:31: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/net/netfilter/nf_conntrack_tuple.h:42:23: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/net/phonet/pep.h:61:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/net/xfrm.h:121:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/rxrpc/packet.h:62:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/scsi/osd_initiator.h:307:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/scsi/sas.h:218:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/scsi/sas.h:219:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/scsi/sas.h:227:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/scsi/sas.h:242:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/scsi/sas.h:243:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/scsi/sas.h:251:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/scsi/sas.h:272:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/scsi/sas.h:284:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
include/uapi/linux/i2c.h:128:7: warning: 'i2c_smbus_data' union will be padded with 2 bytes unless __attribute__((packed)).
include/uapi/linux/netfilter_bridge/ebt_802_3.h:49:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/uapi/linux/phonet.h:71:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
include/xen/interface/io/netif.h:125:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
lib/zlib_deflate/defutil.h:41:11: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
lib/zlib_deflate/defutil.h:45:11: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
lib/zlib_inflate/inffast.c:24:7: warning: 'uu' union will be padded with 2 bytes unless __attribute__((packed)).
net/decnet/af_decnet.c:1345:15: warning: '<null>' union will be padded with 1 bytes unless __attribute__((packed)).
net/irda/wrapper.c:89:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
net/netfilter/ipset/ip_set_hash_netnet.c:269:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
net/netfilter/ipset/ip_set_hash_netnet.c:48:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
net/netfilter/ipset/ip_set_hash_netportnet.c:316:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
net/netfilter/ipset/ip_set_hash_netportnet.c:50:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
net/netfilter/nft_ct.c:26:14: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
net/netfilter/nft_meta.c:24:15: warning: '<null>' union will be padded with 3 bytes unless __attribute__((packed)).
security/integrity/evm/../integrity.h:70:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
security/integrity/ima/../integrity.h:70:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
security/integrity/integrity.h:70:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).
sound/pci/ctxfi/cthw20k1.c:115:7: warning: 'src_mgr_dirty' union will be padded with 2 bytes unless __attribute__((packed)).
sound/pci/ctxfi/cthw20k1.c:148:7: warning: 'srcimp_mgr_dirty' union will be padded with 2 bytes unless __attribute__((packed)).
sound/pci/ctxfi/cthw20k1.c:594:7: warning: 'amixer_dirty' union will be padded with 2 bytes unless __attribute__((packed)).
sound/pci/ctxfi/cthw20k1.c:756:7: warning: 'dai_dirty' union will be padded with 2 bytes unless __attribute__((packed)).
sound/pci/ctxfi/cthw20k1.c:771:7: warning: 'dao_dirty' union will be padded with 2 bytes unless __attribute__((packed)).
sound/pci/ctxfi/cthw20k1.c:90:7: warning: 'src_dirty' union will be padded with 2 bytes unless __attribute__((packed)).
sound/pci/ctxfi/cthw20k2.c:115:7: warning: 'src_mgr_dirty' union will be padded with 2 bytes unless __attribute__((packed)).
sound/pci/ctxfi/cthw20k2.c:148:7: warning: 'srcimp_mgr_dirty' union will be padded with 2 bytes unless __attribute__((packed)).
sound/pci/ctxfi/cthw20k2.c:593:7: warning: 'amixer_dirty' union will be padded with 2 bytes unless __attribute__((packed)).
sound/pci/ctxfi/cthw20k2.c:747:7: warning: 'dai_dirty' union will be padded with 2 bytes unless __attribute__((packed)).
sound/pci/ctxfi/cthw20k2.c:787:7: warning: 'dao_dirty' union will be padded with 2 bytes unless __attribute__((packed)).
sound/pci/ctxfi/cthw20k2.c:90:7: warning: 'src_dirty' union will be padded with 2 bytes unless __attribute__((packed)).
sound/pci/hda/patch_hdmi.c:169:7: warning: 'audio_infoframe' union will be padded with 3 bytes unless __attribute__((packed)).
sound/usb/usx2y/usbus428ctldefs.h:90:15: warning: '<null>' union will be padded with 2 bytes unless __attribute__((packed)).

--RnlQjJ0d97Da+TV1--
