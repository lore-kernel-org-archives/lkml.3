Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbaEGKOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 06:14:22 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37320 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbaEGKOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 06:14:19 -0400
Message-ID: <536A0777.1050407@gmail.com>
Date: Wed, 07 May 2014 12:14:15 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Dave Jones <davej@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Wei Liu <wei.liu2@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: debug_dma_assert_idle - snd_hda_intel - cpu touching an active
 dma mapped cacheline
References: <534F01D1.9000206@gmail.com> <534F858B.4060208@ladisch.de> <53500CDB.8050802@gmail.com> <53570F1F.1000709@gmail.com> <53575099.1030501@gmail.com> <5361D69E.1060802@gmail.com> <53684172.6090402@gmail.com>
In-Reply-To: <53684172.6090402@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tested with 12 consecutive reboots and several non consecutive(multiboot), 
3.15.0-0.rc4.git1.1.fc21.i686  PASSED

Probably some of these net patches did the job, 

$ xzgrep diff\ --git kernel-3.15.0-0.rc4.git1.1.fc21.src/patch-3.15-rc4-git1.xz 
diff --git a/Documentation/devicetree/bindings/net/arc_emac.txt b/Documentation/devicetree/bindings/net/arc_emac.txt
diff --git a/Documentation/networking/scaling.txt b/Documentation/networking/scaling.txt
diff --git a/MAINTAINERS b/MAINTAINERS
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
diff --git a/arch/xtensa/boot/dts/kc705.dts b/arch/xtensa/boot/dts/kc705.dts
diff --git a/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi b/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi
diff --git a/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi b/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi
diff --git a/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi b/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi
diff --git a/arch/xtensa/boot/dts/xtfpga.dtsi b/arch/xtensa/boot/dts/xtfpga.dtsi
diff --git a/arch/xtensa/include/asm/bootparam.h b/arch/xtensa/include/asm/bootparam.h
diff --git a/arch/xtensa/include/asm/fixmap.h b/arch/xtensa/include/asm/fixmap.h
diff --git a/arch/xtensa/include/asm/highmem.h b/arch/xtensa/include/asm/highmem.h
diff --git a/arch/xtensa/include/asm/pgtable.h b/arch/xtensa/include/asm/pgtable.h
diff --git a/arch/xtensa/include/asm/sysmem.h b/arch/xtensa/include/asm/sysmem.h
diff --git a/arch/xtensa/include/asm/tlbflush.h b/arch/xtensa/include/asm/tlbflush.h
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
diff --git a/arch/xtensa/kernel/smp.c b/arch/xtensa/kernel/smp.c
diff --git a/arch/xtensa/kernel/xtensa_ksyms.c b/arch/xtensa/kernel/xtensa_ksyms.c
diff --git a/arch/xtensa/mm/Makefile b/arch/xtensa/mm/Makefile
diff --git a/arch/xtensa/mm/cache.c b/arch/xtensa/mm/cache.c
diff --git a/arch/xtensa/mm/highmem.c b/arch/xtensa/mm/highmem.c
diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
diff --git a/arch/xtensa/mm/mmu.c b/arch/xtensa/mm/mmu.c
diff --git a/arch/xtensa/mm/tlb.c b/arch/xtensa/mm/tlb.c
diff --git a/arch/xtensa/platforms/iss/Makefile b/arch/xtensa/platforms/iss/Makefile
diff --git a/arch/xtensa/platforms/xt2000/setup.c b/arch/xtensa/platforms/xt2000/setup.c
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
diff --git a/drivers/isdn/hisax/icc.c b/drivers/isdn/hisax/icc.c
diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
diff --git a/drivers/net/can/c_can/Kconfig b/drivers/net/can/c_can/Kconfig
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
diff --git a/drivers/net/can/c_can/c_can_pci.c b/drivers/net/can/c_can/c_can_pci.c
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
diff --git a/drivers/net/can/sja1000/sja1000_isa.c b/drivers/net/can/sja1000/sja1000_isa.c
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
diff --git a/drivers/net/ethernet/altera/Kconfig b/drivers/net/ethernet/altera/Kconfig
diff --git a/drivers/net/ethernet/altera/altera_msgdma.c b/drivers/net/ethernet/altera/altera_msgdma.c
diff --git a/drivers/net/ethernet/altera/altera_msgdma.h b/drivers/net/ethernet/altera/altera_msgdma.h
diff --git a/drivers/net/ethernet/altera/altera_sgdma.c b/drivers/net/ethernet/altera/altera_sgdma.c
diff --git a/drivers/net/ethernet/altera/altera_sgdma.h b/drivers/net/ethernet/altera/altera_sgdma.h
diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
diff --git a/drivers/net/ethernet/altera/altera_tse_ethtool.c b/drivers/net/ethernet/altera/altera_tse_ethtool.c
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
diff --git a/drivers/net/ethernet/arc/emac.h b/drivers/net/ethernet/arc/emac.h
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
diff --git a/drivers/net/ethernet/chelsio/Kconfig b/drivers/net/ethernet/chelsio/Kconfig
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
diff --git a/drivers/net/ethernet/intel/e1000e/phy.h b/drivers/net/ethernet/intel/e1000e/phy.h
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
diff --git a/drivers/net/ethernet/intel/i40e/i40e_nvm.c b/drivers/net/ethernet/intel/i40e/i40e_nvm.c
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
diff --git a/drivers/net/ethernet/intel/igb/e1000_i210.c b/drivers/net/ethernet/intel/igb/e1000_i210.c
diff --git a/drivers/net/ethernet/intel/igb/e1000_mac.c b/drivers/net/ethernet/intel/igb/e1000_mac.c
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h b/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_core.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_core.c
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_desc.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_desc.c
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_desc.h b/drivers/net/ethernet/samsung/sxgbe/sxgbe_desc.h
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_dma.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_dma.c
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_reg.h b/drivers/net/ethernet/samsung/sxgbe/sxgbe_reg.h
diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
diff --git a/drivers/staging/iio/resolver/ad2s1200.c b/drivers/staging/iio/resolver/ad2s1200.c
diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
diff --git a/drivers/usb/host/ohci-hub.c b/drivers/usb/host/ohci-hub.c
diff --git a/drivers/usb/host/ohci-pci.c b/drivers/usb/host/ohci-pci.c
diff --git a/drivers/usb/host/ohci.h b/drivers/usb/host/ohci.h
diff --git a/drivers/usb/phy/phy-fsm-usb.c b/drivers/usb/phy/phy-fsm-usb.c
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
diff --git a/include/linux/netlink.h b/include/linux/netlink.h
diff --git a/include/linux/sock_diag.h b/include/linux/sock_diag.h
diff --git a/include/linux/tty.h b/include/linux/tty.h
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
diff --git a/include/net/sock.h b/include/net/sock.h
diff --git a/kernel/audit.c b/kernel/audit.c
diff --git a/mm/slab.c b/mm/slab.c
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
diff --git a/net/can/gw.c b/net/can/gw.c
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
diff --git a/net/core/filter.c b/net/core/filter.c
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
diff --git a/net/core/sock.c b/net/core/sock.c
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
diff --git a/net/decnet/dn_fib.c b/net/decnet/dn_fib.c
diff --git a/net/decnet/netfilter/dn_rtmsg.c b/net/decnet/netfilter/dn_rtmsg.c
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
diff --git a/net/packet/diag.c b/net/packet/diag.c
diff --git a/net/phonet/pn_netlink.c b/net/phonet/pn_netlink.c
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
diff --git a/scripts/sortextable.c b/scripts/sortextable.c
diff --git a/tools/net/bpf_dbg.c b/tools/net/bpf_dbg.c

http://pkgs.fedoraproject.org/repo/pkgs/kernel/patch-3.15-rc4-git1.xz/4b0ef9f7c4d9492c34d8263fa875c52f/patch-3.15-rc4-git1.xz


poma


