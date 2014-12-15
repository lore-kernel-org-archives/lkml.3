Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271AbaLORzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:55:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaLORzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:55:36 -0500
Date: Mon, 15 Dec 2014 09:55:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver patches for 3.19-rc1
Message-ID: <20141215175535.GA4665@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 009d0431c3914de64666bec0d350e54fdd59df6a:

  Linux 3.18-rc7 (2014-11-30 16:42:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.19-rc1

for you to fetch changes up to 17d2c6439be65777245914be354c5a97c76ad246:

  Staging: slicoss: Fix long line issues in slicoss.c (2014-12-02 16:54:43 -0800)

----------------------------------------------------------------
Staging patches for 3.19-rc1

Here's the big staging tree pull request for 3.19-rc1.

We continued to delete more lines than were added, always a good thing,
but not at a huge rate this release, only about 70k lines removed
overall mostly from removing the horrid bcm driver.

Lots of normal staging driver cleanups and fixes all over the place,
well over a thousand of them, the shortlog shows all the horrid details.

The "contentious" thing here is the movement of the Android binder code
out of staging into the "real" part of the kernel.  This is code that
has been stable for a few years now and is working as-is in the tens of
millions of devices with no issues.  Yes, the code is horrid, and the
userspace api leaves a lot to be desired, but it's not going to change
due to legacy issues that we have no control over.  Because so many
devices and companies rely on this, and the code is stable, might as
well promote it out of staging.

This was all discussed at the Linux Plumbers conference, and everyone
participating agreed that this was the best way forward.

There is work happening to replace the binder code with something new
that is happening right now, but I don't expect to see the results of
that work for another year at the earliest.  If that ever happens, and
Android switches over to it, I'll gladly remove this version.

As for maintainers, I'll be glad to maintain this code, I've been doing
it for the past few years with no problems.  I'll send a MAINTAINERS
entry for it before 3.19-final is out, still need to talk to the Google
developers about if they are willing to help with it or not, last I
checked they were, which was good.

All of these patches have been in linux-next for a while with no
reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (3):
      staging: octeon-ethernet: drop multiple NAPI instances
      staging: octeon-usb: move helper functions
      staging: octeon-usb: eliminate cvmx_dprintf() usage

Abhilash Kesavan (1):
      iio: adc: exynos_adc: Add support for exynos7

Aede Symen Hoekstra (1):
      staging: wlan-ng: prism2fw: fixed code style issue

Aleh Suprunovich (2):
      staging: octeon-usb: fix checkpatch.pl warnings
      staging: rtl8723au: fix sparse warning

Andreas Ruprecht (9):
      staging: lustre: ldlm: Add missing newlines after declarations
      staging: lustre: ldlm: Fix overlong lines
      staging: lustre: ldlm: Fix warning about missing spaces
      staging: lustre: ldlm: Fix indentation errors for switch-case
      staging: lustre: ldlm: Fix initialization of static variables
      staging: lustre: ldlm: Fix warning about unneeded return statement
      staging: lustre: ldlm: Remove unnecessary line continuations
      staging: lustre: ldlm: Remove unnecessary braces at ifs
      staging: lustre: ldlm: Remove space before braces for defined() check

Anh Le (1):
      Staging: lustre: llite: fix some sparse warnings about userspace pointer

Anjana Sasindran (4):
      Drivers:staging:dgap: Added a blank line after declaration
      staging:drivers:staging:rtl8188eu:hal:rtl8188e_hal_init.c: Added a blank line after declaration
      staging:ft1000_pcmcia:Added a blank line after declaration
      staging: rtl8723au: hal: Removed the extra semicolon

Anton Saraev (2):
      staging:lustre:lnet:selftest: fix sparse warnings
      staging:lustre:lnet:selftest: remove unused function

Athira Lekshmi (1):
      Drivers:staging:rtl8192e: Fixed checkpatch warning

Athira Sharikkal (1):
      Drivers:staging:clocking-wizard: Added a newline

Aya Mahfouz (16):
      staging: vt6655: card.c: replace memcpy() by ether_addr_copy() using coccinelle
      staging: vt6655: dpc.c: replace memcpy() by ether_addr_copy() using coccinelle
      staging: vt6655: wmgr.c and wmgr.h: replace memcpy() by ether_addr_copy() using coccinelle and pack variable
      staging: vt6655: replace memcpy() by ether_addr_copy() using coccinelle and pack variables
      staging: vt6655: wcmd.c: fix print priority warning
      staging: dgnc: dgnc_kcompat.h: remove unused macros
      staging: dgnc: dgnc_driver: remove all occurences of trcbuf_size
      staging: dgnc: remove unused variable named rawreadok
      staging: dgnc: remove debug symbols
      staging: dgnc: dgnc_kcompat.h: remove unused macro
      staging: media: lirc: lirc_zilog.c: replace custom print macros with dev_* and pr_*
      staging: media: lirc: lirc_sir.c: use pr_debug and dev_dbg instead of dprintk
      staging: media: lirc: lirc_imon.c: replace printk by dev_dbg
      staging: media: lirc: lirc_bt829.c: replace dprintk by dev_dbg
      staging: media: lirc: lirc_zilog.c: remove unnecessary 'out of memory' message
      staging: media: lirc: modify print calls

Aybuke Ozdemir (2):
      staging: media: omap24xx: Use min_t instead of min
      staging: media: lirc: Use pr_* instead of printk

Balavasu Kuppusammyprathaban (1):
      staging: lustre: lustre: ptlrpc: Remove unnecessary braces

Behan Webster (5):
      staging, rts5208, LLVMLinux: Change extern inline to static inline
      staging, rtl8192e, LLVMLinux: Change extern inline to static inline
      staging, rtl8192e, LLVMLinux: Remove unused inline prototype
      staging, rtl8192e, LLVMLinux: Remove unused prototype
      staging, rtl8192e, LLVMLinux: Make static local in inline function const

Benjamin Romer (176):
      staging: unisys: clean up enums in uisqueue.h
      staging: unisys: clean up GUESTPART_MSG_TYPE typedef
      staging: unisys: Clean up CamelCase in struct bus_info
      staging: unisys: fix CamelCase in struct add_vbus_guestpart
      staging: unisys: Fix CamelCase function pointers in uisutils
      staging: unisys: fix CamelCase name for registered services variable
      staging: unisys: get rid of MACARRAY typedef
      staging: unisys: remove typedef ReqHandlerInfo_t
      staging: unisys: fix CamelCase in struct req_handler_info
      staging: unisys: fix CamelCase names in ReqHandlerAdd()
      staging: unisys: fix CamelCase in ReqHandlerFind()
      staging: unisys: fix CamelCase in ReqHandlerDel
      staging: unisys: fix indentation in req_handler_info
      staging: unisys: fix CamelCase in uisctrl_register_req_handler_ex
      staging: unisys: fix CamelCase in uisctrl_unregister_req_handler_ex
      staging: unisys: remove uislib_server_inject_add/del_vnic() prototypes
      staging: unisys: Fix CamelCase in uislib_client_inject_add_bus()
      staging: unisys: fix CamelCase in uislib_client_inject_del_bus()
      staging: unisys: Fix CamelCase in uislib_client_inject_add_vhba()
      staging: unisys: Fix CamelCase in uislib_client_inject_pause_vhba()
      staging: unisys: Fix CamelCase in uislib_client_inject_resume_vhba()
      staging: unisys: Fix CamelCase in uislib_client_inject_del_vhba()
      staging: unisys: Fix CamelCase in uislib_client_inject_add_vnic()
      staging: unisys: Fix CamelCase in uislib_client_inject_pause_vnic()
      staging: unisys: Fix CamelCase in uislib_client_inject_resume_vnic()
      staging: unisys: fix CamelCase in uislib_client_inject_del_vnic()
      staging: unisys: fix CamelCase struct name PciId
      staging: unisys: fix CamelCase name for struct InterruptInfo
      staging: unisys: remove DEDICATED_SWITCH macro
      staging: unisys: fix typedef of ULTRA_VBUS_CHANNEL_PROTOCOL
      staging: unisys: Fix VMCALL_IO_CONTROLVM_ADDR_PARAMS structure
      staging: unisys: Fix VMCALL_IO_DIAG_ADDR_PARAMS
      staging: unisys: fix VMCALL_IO_VISORSERIAL_ADDR_PARAMS
      staging: unisys: remove volatile from struct log_info_t
      staging: unisys: Fix VMCALL_CHANNEL_VERSION_MISMATCH_PARAMS
      staging: unisys: Fix ULTRA_VBUS_DEVICEINFO
      staging: unisys: remove old doxygen comments from timskmod.h
      staging: unisys: remove redundant max macro
      staging: unisys: remove unused struct network_policy
      staging: unisys: remove unused fields from iopart structures
      staging: unisys: remove unused vmcall functions from uisutils.h
      staging: unisys: clean up bracing in vbuschannel_sanitize_buffer()
      staging: unisys: fix indentation on vbuschannel_devinfo_to_string()
      staging: unisys: clean up extra parens in vbuschannel_devinfo_to_string
      staging: unisys: delete extra space character in vbuschannel_itoa()
      staging: unisys: fix typedef for VMCALL_MONITOR_INTERFACE_METHOD_TUPLE
      staging: unisys: fix CamelCase in ISSUE_IO_VMCALL macros
      staging: unisys: get rid of IO_DATA_STRUCTURE typedef
      staging: unisys: fix CamelCase channel constants
      staging: unisys: clean up stray blank lines in channel_guid.h
      staging: unisys: remove channel mismatch macros
      staging: unisys: get rid of UltraLogEvent macro
      staging: unisys: remove typedef for CHANNEL_SERVERSTATE
      staging: unisys: get rid of typedef for CHANNEL_CLIENTSTATE
      staging: unisys: fix missing blank line after enum channel_clientstate
      staging: unisys: fix spacing in ULTRA_CHANNELCLI_STRING
      staging: unisys: remove typedef for CHANNEL_HEADER
      staging: unisys: fix CamelCase names in struct channel_header
      staging: unisys: clean up ULTRA_CHANNEL_SERVER_READY macro
      staging: unisys: fix ULTRA_SPAR_CHANNEL_CLIENT_CHK_TRANSITION macro
      staging: unisys: fix CamelCase in PathName_Last_N_Nodes()
      staging: unisys: fix up ULTRA_CHANNEL_CLIENT_TRANSITION macro
      staging: unisys: refactor ULTRA_channel_client_acquire_os()
      staging: unisys: refactor ULTRA_channel_client_release_os()
      staging: unisys: remove typedef SIGNAL_QUEUE_HEADER
      staging: unisys: fix CamelCase in struct signal_queue_header
      staging: unisys: refactor ULTRA_check_channel_client()
      staging: unisys: refactor visor_signal_remove()
      staging: unisys: refactor visor_signalqueue_empty()
      staging: unisys: fix symbol placement in spar_channel_client_acquire
      staging: unisys: refactor SignalInit Macro
      staging: unisys: refactor SignalRemoveAll()
      staging: unisys: refactor ULTRA_check_channel_server()
      staging: unisys: refactor ultra_segment_state
      staging: unisys: fix CamelCase constant names in controlframework.h
      staging: unisys: refactor UltraControlvmChannelProtocolGuid
      staging: unisys: remove ULTRA_CONTROLVM_CHANNEL_OK_SERVER macro
      staging: unisys: fix CamelCase in SPAR_CONTROLVM_CHANNEL_OK_CLIENT
      staging: unisys: remove typedef CONTROLVM_ID
      staging: unisys: fix CamelCase names in struct irq_info
      staging: unisys: fix CamelCase names in struct pci_id
      staging: unisys: remove unused code from controlvmchannel.h
      staging: unisys: replace typedef ULTRA_EFI_SPAR_INDICATION
      staging: unisys: fix CamelCase names in struct efi_spar_indication
      staging: unisys: fix CamelCase macro names in controlframework.h
      staging: unisys: refactor ULTRA_CHIPSET_FEATURE enum
      staging: unisys: refactor CONTROLVM_MESSAGE_PACKET
      staging: unisys: refactor CONTROLVM_MESSAGE_HEADER
      staging: unisys: refactor CONTROLVM_PACKET_DEVICE_CREATE
      staging: unisys: refactor CONTROLVM_PACKET_DEVICE_CONFIGURE
      staging: unisys: refactor CONTROLVM_MESSAGE_DEVICE_CREATE
      staging: unisys: refactor CONTROLVM_MESSAGE_DEVICE_CONFIGURE
      staging: unisys: remove typedef from CONTROLVM_MESSAGE
      staging: unisys: refactor DEVICE_MAP
      staging: unisys: refactor GUEST_DEVICES
      staging: unisys: refactor SPAR_CONTROLVM_CHANNEL_PROTOCOL
      staging: unisys: refactor ULTRA_CONTROLVM_PARAMETERS_HEADER
      staging: unisys: fix misspelled word in controlvmchannel.h
      staging: unisys: refactor UltraDiagChannelProtocolGuid
      staging: unisys: refactor ULTRA_DIAG_CHANNEL_OK_CLIENT
      staging: unisys: refactor ULTRA_DIAG_CHANNEL_OK_SERVER
      staging: unisys: refactor DIAG_EFI_TIME
      staging: unisys: refactor ULTRA_COMPONENT_TYPES
      staging: unisys: refactor DIAG_CHANNEL_EVENT
      staging: unisys: remove typedef for DIAG_SEVERITY
      staging: unisys: remove extra blank lines in diagchannel.h
      staging: unisys: remove typedef from DIAG_CAUSE
      staging: unisys: refactor DIAG_CHANNEL_PROTOCOL_HEADER
      staging: unisys: refactor ULTRA_DIAG_CHANNEL_PROTOCOL
      staging: unisys: clean up line spacing in iochannel.h
      staging: unisys: fix typecast spacing in iochannel.h
      staging: unisys: clean up CamelCase parameter in SPAR_VHBA_CHANNEL_OK_CLIENT
      staging: unisys: remove unused macro ULTRA_VHBA_CHANNEL_OK_SERVER
      staging: unisys: remove unused macro ULTRA_VNIC_CHANNEL_OK_SERVER
      staging: unisys: remove unused macro ULTRA_VSWITCH_CHANNEL_OK_SERVER
      staging: unisys: fix parameters to macro SPAR_VNIC_CHANNEL_OK_CLIENT
      staging: unisys: remove unused macro SPAR_VSWITCH_CHANNEL_OK_CLIENT
      staging: unisys: remove typedef from NET_TYPES
      staging: unisys: fix CamelCase in ETH_IS_LOCALLY_ADMINISTERED
      staging: unisys: refactor TASK_MGMT_TYPES
      staging: unisys: refactor enum VDISK_MGMT_TYPES
      staging: unisys: fix CamelCase names in struct sense_data
      staging: unisys: fix CamelCase name in net_pkt_rcvpost
      staging: unisys: fix CamelCase names in net_pkt_rcv
      staging: unisys: fix CamelCase in uiscmdrsp_disknotify
      staging: unisys: refactor ULTRA_IO_CHANNEL_PROTOCOL
      staging: unisys: remove unused code from iochannel.h
      staging: unisys: clean up UltraVbusChannelProtocol
      staging: unisys: fix parameters for SPAR_VBUS_CHANNEL_OK_CLIENT macro
      staging: unisys: refactor ULTRA_VBUS_CHANNEL_OK_SERVER
      staging: unisys: refactor ULTRA_VBUS_HEADERINFO
      staging: unisys: refactor struct struct ultra_vbus_channel_protocol
      staging: unisys: fix CamelCase in net_adap_info
      staging: unisys: get rid of typedef for VIRTPCI_DEV_TYPE
      staging: unisys: fix CamelCase members of virtpci_dev
      staging: unisys: fix alignment in virtpci.h
      staging: unisys: fix macro spacing in uisutils.h
      staging: unisys: get rid of VISORCHIPSET_STATE typedef
      staging: unisys: refactor VISORCHIPSET_ADDRESSTYPE
      staging: unisys: refactor CRASH_OBJ_TYPE
      staging: unisys: refactor VISORCHIPSET_CHANNEL_INFO
      staging: unisys: refactor VISORCHIPSET_DEVICE_INFO
      staging: unisys: fix CamelCase parameters in finddevice()
      staging: unisys: fix CamelCase parameters in delbusdevices()
      staging: unisys: refactor VISORCHIPSET_BUS_INFO
      staging: unisys: fix CamelCase in findbus()
      staging: unisys: refactor VISORCHIPSET_SWITCH_INFO
      staging: unisys: refactor VISORCHIPSET_EXTERNALPORT_INFO
      staging: unisys: refactor VISORCHIPSET_INTERNALPORT_INFO
      staging: unisys: refactor VISORCHIPSET_BUSDEV_NOTIFIERS
      staging: unisys: refactor VISORCHIPSET_BUSDEV_RESPONDERS
      staging: unisys: fix CamelCase name in visorchipset_register_busdev_client()
      staging: unisys: fix CamelCase name in visorchipset_register_busdev_server()
      staging: unisys: fix CamelCase in visorchipset_device_pause_response()
      staging: unisys: fix CamelCase in visorchipset_get_bus_info
      staging: unisys: fix CamelCase in visorchipset_get_device_info()
      staging: unisys: remove unused definitions from visorchipset.h
      staging: unisys: fix CamelCase in visorchipset_set_bus_context()
      staging: unisys: fix CamelCase in visorchipset_set_device_context()
      staging: unisys: remove visorchipset_controlvm_respond_reportEvent()
      staging: unisys: remove unused macros from visorchipset.h
      staging: unisys: fix line spacing in charqueue.c
      staging: unisys: refactor CHARQUEUE
      staging: unisys: split double assignment in visor_charqueue_create()
      staging: unisys: remove typedef for MEMREGION
      staging: unisys: refactor visor_memregion_create()
      staging: unisys: remove unnecessary spaces in casts in memregion_direct.c
      staging: unisys: remove extra blank lines in memregion_direct.c
      staging: unisys: fix line over 80 characters in mapit()
      staging: unisys: fix sizeof() in visor_memregion_create_overlapped()
      staging: unisys: fix spacing in periodic_work.c
      staging: unisys: fix bracketing in visor_periodic_work_stop()
      staging: unisys: fix spacing in visorkmodutils.c
      staging: unisys: refactor visorutil_spar_detect()
      staging: unisys: refactor visorutil_mod_init()
      staging: unisys: remove unused functions from uislib.c

Bernd Porr (3):
      staging: comedi: usbduxsigma: updated contact details and status
      staging: comedi: usbdux: updated contact details / comments
      staging: comedi: usbduxfast: updated address details

Brian Vandre (2):
      Staging: iio: adc: fix line over 80 characters
      Staging: xgifb: fix space before comma

Bryan Thompson (30):
      staging: unisys: virtpci: Add a blank line after the definition of driver_private
      staging: unisys: virtpci: Remove extraneous blank lines
      staging: unisys: virtpci: Remove space between cast and variable
      staging: unisys: virtpci: Allocate memory using the size of the variable
      staging: unisys: virtpci: Place logical continuation at the end of a line
      staging: unisys: virtpci: Add braces to if/else statements
      staging: unisys: virtpci: Use a single blank line to separate code blocks
      staging: unisys: virtpci: Fix alignment issues
      staging: unisys: virtpci: Adjust lines to contain a maximum of 80 characters
      staging: unisys: virtpci: Fix CamelCase Chipset_DriverInfo
      staging: unisys: virtpci: Fix CamelCase virtpci device list head
      staging: unisys: virtpci: Fix CamelCase virtpci device list lock
      staging: unisys: virtpci: Fix CamelCase vbus driver info variable
      staging: unisys: virtpci: Fix CamelCase write_vbus_chpInfo()
      staging: unisys: virtpci: Fix CamelCase write_vbus_busInfo()
      staging: unisys: virtpci: Fix CamelCase write_vbus_devInfo()
      staging: unisys: virtpci: Fix CamelCase in delete_vbus_device()
      staging: unisys: virtpci: Fix CamelCase name fix_vbus_devInfo()
      staging: unisys: virtpci: Fix CamelCase parameters of fix_vbus_dev_info()
      staging: unisys: virtpci: Fix CamelCase local variables in fix_vbus_dev_info()
      staging: unisys: virtpci: Fix CamelCase local variables in virtpci_device_add()
      staging: unisys: virtpci: Remove GET_BUS_DEV macro
      staging: unisys: visorchannel: Remove multiple blank lines
      staging: unisys: visorchannel: Fix alignment issues
      staging: unisys: visorchannel: Remove space between cast and variable
      staging: unisys: visorchannel: Remove unnecessary parentheses
      staging: unisys: visorchannel: Place logical continuation at the end of a line
      staging: unisys: visorchannel: Adjust lines to contain a maximum of 80 characters
      staging: unisys: visorchannel: Rename goto label Away
      staging: unisys: visorchannel: Add braces to else arm of if/else statement

Chase Southwood (1):
      staging: comedi: change some printk calls to pr_err

Chen Gang (2):
      drivers: staging: lustre: Kconfig: Let LUSTRE_LLITE_LLOOP depend on all !"*_64K*" page
      drivers: staging: rtl8192e: Include "asm/unaligned.h" instead of "access_ok.h" in "rtl819x_BAProc.c"

Chen Weixiang (1):
      staging: ft1000: do not initialise statics to 0 or NULL

Chris Ruffin (1):
      staging: iio: accel: remove unnecessary syntax

Daeseok Youn (9):
      staging: dgap: remove unnecessary if statement for checking NULL
      staging: dgap: change function names properly
      staging: dgap: introduce dgap_stop()
      staging: dgap: re-arrange functions for removing forward declarations
      staging: dgap: remove unnecessary function
      staging: dgap: set tty's flags by tty_alloc_driver()
      staging: dgap: fix memory leak caused by double allocation of tty_structs
      staging: dgap: remove useless variables for saving tty's major
      staging: dgap: introducing find_board_by_major()

Dan Carpenter (5):
      staging: lustre: silence a static checker warning
      staging: lustre: validate size in lustre_posix_acl_xattr_filter()
      staging: lustre: validate size in ll_setxattr()
      staging: r8188eu: get a string from the user correctly
      staging: r8188eu: cleanups in rtw_android_set_block()

Darshana Padmadas (4):
      Staging: iio: meter: Kconfig: Add module name information in Kconfig
      Staging: iio: trigger: Add module name information in Kconfig
      Staging: iio: trigger: Break line over 80 characters
      iio: Add ABI documentation for scaled voltage

David Barksdale (1):
      IIO: add si7020 driver

Denis CIOCCA (7):
      iio:imu: changed structure name from st_sensors to st_sensor_settings
      iio:accel: Removed unnecessary parameter on common_probe function
      iio:gyro: Removed unnecessary parameter on common_probe function
      iio:magnetometer: Removed unnecessary parameter on common_probe function
      iio:pressure: Removed unnecessary parameter on common_probe function
      iio:pressure: Changed pressure data variable name to press_data
      iio:common: Set the device pointer into ST common sensors library

Devendra Naga (5):
      staging: gs_fpgaboot: cleanup in gs_fpgaboot_init function
      staging: gs_fpgpaboot: fix compiler warning with make W=1
      staging: gs_fpgaboot: fix a compiler warning with make W=2
      staging: rtl8192e: add missing tasklet_kill on remove path
      staging: clocking-wizard: check for a valid clk_name pointer

Dilek Uzulmez (14):
      staging: speakup: Change char * array type as static const
      staging: octeon: Fix warning of prefer ether_addr_copy.
      staging: bcm: Fixed else after return or break warning
      staging: vt6655: Remove unnecessary else after return
      staging: vt6655: Removing else after break statement to fix warning
      staging: vt6655: Use ether_addr_copy function
      staging: vt6655: Use ether_addr_copy function
      staging: vt6655: Use ether_addr_copy function
      staging: dgnc: Remove space before tabs
      staging: gdm724x: Fix warning of prefer ether_addr_copy.
      staging: slicoss: Fix warning of prefer ether_addr_copy().
      staging: vt6655: Use ether_addr_copy function
      staging: vt6655: Use ether_addr_copy function
      staging: rtl8188eu: Remove unnecessary else after return

Domagoj Trsan (1):
      staging: skein: fix sparse warnings related to shift operator

Dzmitry Sledneu (1):
      staging: gs_fpgaboot: Fix "out of memory" error handling

Ebru Akagunduz (11):
      staging: rtl8188eu: Fix prefer ether_addr_copy() over memcpy()
      staging: gs_fpgaboot: remove unnecessary 'out of memory' message
      staging: speakup: Change char * array type as static const
      staging: comedi: Fix cast to restricted __be32
      staging: rtl8192u: Remove defined but unused function
      staging: rtl8192u: Fixes symbol as static
      staging: gdm724x: Fix incorrect type in assignment
      staging: wlan-ng: Fix restricted __be16 degrades to integer
      staging: slicoss: Use inplace convert with __be32 *
      staging: wlan-ng: Fix incorrect type in assignments
      staging: ft1000: Remove curly braces for single statement blocks

Eric Rost (9):
      staging: skein: Whitespace cleanup
      staging: skein: File Reorg
      staging: skein: Collapses threefish module
      staging: skein: Renames skein to skein_base
      staging: skein: Adds CryptoAPI Support
      staging: skein: Adds Loadable Module Support
      staging: skein: Inlines rotl_64
      staging: skein: Removes unneeded #define
      staging: skein: Removes skein_debug include

Esra Altintas (5):
      staging: speakup: remove jiffies comparison using time_after_eq() in speakup_dtlk.c
      staging: speakup: Use time_after_eq to compare jiffies in speakup_keypc.c
      staging: bcm: Removed unnecessary 'else' after 'return' statement in Qos.c
      staging: vt6655: Fixed C99 // comment errors in wpa.h
      staging: rtl8712: Fix unnecessary parentheses style warning in rtl871x_xmit.c

Eunbong Song (1):
      staging: octeon-ethernet: disable load balance for receiving packet when CONFIG_RPS is enabled.

Fabio Estevam (5):
      iio: adc: vf610: Return the error code directly
      iio: adc: vf610: Disable the regulator on error
      iio: adc: vf610: SIMPLE_DEV_PM_OPS can fit on a single line
      iio: adc: vf610: Propagate the real error when platform_get_irq() fails
      imx-drm: imx-drm-core: Remove unneeded forward declaration

Fabio Falzoi (2):
      Staging: rts5208: helper function to manage aspm during reset
      Staging: rts5208: helper function to enable interrupts during reset

Filipe Gonçalves (1):
      drivers/staging: Removed unnecessary check for LUSTRE_VERSION_CODE

Geoff Darst (1):
      staging: ft1000 : replace __attribute ((__packed__) with __packed

George McCollister (1):
      iio: as3935: Remove unnecessary semicolons

Giedrius Statkevicius (1):
      staging: lustre: Fix sparse warnings for lnet/lnet/router.c

Giedrius Statkevičius (5):
      staging: rts5208: combine ifs where possible
      staging: rts5208: get rid of Camel Case, remove unneeded lines and parantheses
      staging: rts5208: align divided lines to opening paranthesis
      staging: rts5208: divide lines to make them less than 80 characters long
      staging: rts5208: use ternary operators to reduce indentation level

Greg Donald (9):
      drivers: staging: lustre: Fix "else should follow close brace '}'" errors
      drivers: staging: lustre: Fix "'foo* bar' should be 'foo *bar'" errors
      drivers: staging: rtl8723au: core: Fix "'foo * bar' should be 'foo *bar'" errors
      drivers: staging: rtl8723au: Fix "open brace '{' following struct go on the same line" errors
      drivers: staging: lustre: Fix "space prohibited before that close parenthesis ')'" errors
      drivers: staging: lustre: Fix 'that open brace { should be on the previous line' errors
      drivers: staging: lustre: Fix "'foo * bar' should be 'foo *bar'" errors
      drivers: staging: lustre: Fix "spaces required around that '='" errors
      staging: rtl8192u: Fix "space prohibited after that open parenthesis '('" errors

Greg Kroah-Hartman (9):
      staging: android: binder: move to the "real" part of the kernel
      android: uapi: binder.h
      android: binder: remove binder.h
      Merge 3.18-rc3 into staging-next
      Merge tag 'iio-for-3.19a' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.18-rc4 into staging-next
      Revert "staging: unisys: fix CamelCase macro names in controlframework.h"
      staging: unisys: remove pointless macros
      Merge 3.18-rc7 into staging-work.

Gulsah Kose (4):
      staging: rtl8188eu: core: Removed unnecessary parenthesis.
      staging: rtl8188eu: core: Removed unnecessary return keyword.
      staging: rtl8188eu: os_dep: Removed unnecessary return.
      staging: rtl8188eu: os_dep: Used min_t instead of min

H Hartley Sweeten (462):
      staging: comedi: adl_pci9111: use comedi_handle_events()
      staging: comedi: adl_pci9118: use comedi_handle_events()
      staging: comedi: adv_pci1710: use comedi_handle_events()
      staging: comedi: amplc_pci224: use comedi_handle_events()
      staging: comedi: cb_pcidas: use comedi_handle_events()
      staging: comedi: cb_pcidas64: use comedi_handle_events()
      staging: comedi: das16: use comedi_handle_events()
      staging: comedi: das16m1: use comedi_handle_events()
      staging: comedi: das800: use comedi_handle_events()
      staging: comedi: das1800: use comedi_handle_events()
      staging: comedi: dt282x: use comedi_handle_events()
      staging: comedi: dt3000: use comedi_handle_events()
      staging: comedi: gsc_hpdi: use comedi_handle_events()
      staging: comedi: ni_660x: use comedi_handle_events()
      staging: comedi: ni_at_a2150: use comedi_handle_events()
      staging: comedi: ni_labpc_common: use comedi_handle_events()
      staging: comedi: ni_mio_common: use comedi_handle_events()
      staging: comedi: ni_pcidio: use comedi_handle_events()
      staging: comedi: pcl812: use comedi_handle_events()
      staging: comedi: pcl816: use comedi_handle_events()
      staging: comedi: pcl818: use comedi_handle_events()
      staging: comedi: quatech_daqp_cs: use comedi_handle_events()
      staging: comedi: comedi_fc.h: remove cfc_handle_events()
      staging: comedi: hwdrv_apci3200: use comedi_handle_events()
      staging: comedi: addi_apci_1032: use comedi_handle_events()
      staging: comedi: addi_apci_1564: use comedi_handle_events()
      staging: comedi: addi_apci_3xxx: use comedi_handle_events()
      staging: comedi: amplc_pc236_common: use comedi_handle_events()
      staging: comedi: comedi_parport: use comedi_handle_events()
      staging: comedi: dmm32at: use comedi_handle_events()
      staging: comedi: dt2814: use comedi_handle_events()
      staging: comedi: ni_6527: use comedi_handle_events()
      staging: comedi: ni_65xx: use comedi_handle_events()
      staging: comedi: ni_atmio16d: use comedi_handle_events()
      staging: comedi: pcl726: use comedi_handle_events()
      staging: comedi: hwdrv_apci3120: use comedi_handle_events()
      staging: comedi: hwdrv_apci3120: do comedi_handle_events() at end of interrupt
      staging: comedi: addi_apci_2032: use comedi_handle_events()
      staging: comedi: amplc_dio200_common: use comedi_handle_events()
      staging: comedi: comedi_test: use comedi_handle_events()
      staging: comedi: me4000: use comedi_handle_events()
      staging: comedi: pcl711: use comedi_handle_events()
      staging: comedi: pcmmio: use comedi_handle_events()
      staging: comedi: pcmuio: use comedi_handle_events()
      staging: comedi: s626: use comedi_handle_events()
      staging: comedi: rtd520: clear FIFO when canceling async command
      staging: comedi: rtd520: use comedi_handle_events()
      staging: comedi: amplc_pci230: use comedi_handle_events()
      staging: comedi: amplc_pci224: use comedi_bytes_per_scan()
      staging: comedi: amplc_pci230: use comedi_bytes_per_scan()
      staging: comedi: das16: use comedi_bytes_per_scan()
      staging: comedi: mite: use comedi_bytes_per_scan()
      staging: comedi: pcl812: use comedi_bytes_per_scan()
      staging: comedi: pcl816: use comedi_bytes_per_scan()
      staging: comedi: pcl818: use comedi_bytes_per_scan()
      staging: comedi: comedi_fc.h: remove cfc_bytes_per_scan()
      staging: comedi: mite: use comedi_inc_scan_progress()
      staging: comedi: comedi_fc.h: remove cfc_inc_scan_progress()
      staging: comedi: comedidev.h: don't expose COMEDI_CB_* defines to userspace
      staging: comedi: comedidev.h: clarify async->event error/cancel detection
      staging: comedi: addi_apci_3200: remove driver
      staging: comedi: addi_common.c: remove i_ADDI_Detach()
      staging: comedi: addi_common.c: remove i_ADDI_Reset()
      staging: comedi: addi_common.c: remove addi_auto_attach()
      staging: comedi: addi_common.c: remove v_ADDI_Interrupt()
      staging: comedi: addi_common.c: remove included source file
      staging: comedi: addi_apci_035: remove subdevice callbacks from boardinfo
      staging: comedi: addi_apci_1500: remove subdevice callbacks from boardinfo
      staging: comedi: addi_common.h: remove subdevice callbacks from struct addi_board
      staging: comedi: addi_apci_035: remove unnecessary subdevice initialization
      staging: comedi: addi_apci_035: remove unused subdevices
      staging: comedi: addi_apci_1500: remove unnecessary subdevice initialization
      staging: comedi: addi_apci_1500: remove unused subdevices
      staging: comedi: addi_common.h: rename boardinfo 'pc_DriverName'
      staging: comedi: addi_common.h: remove boardinfo 'i_IorangeBase1'
      staging: comedi: addi_apci_1500: remove eeprom support
      staging: comedi: addi_apci_035: board has eeprom
      staging: comedi: addi_common.h: remove boardinfo member 'i_PCIEeprom'
      staging: comedi: addi_apci_1500: remove boardinfo
      staging: comedi: addi_apci_035: remove boardinfo
      staging: comedi: addi_eeprom: remove source file
      staging: comedi: hwdrv_apci3120: remove need for boardinfo access
      staging: comedi: addi_common.h: remove boardinfo definition
      staging: comedi: addi_common.h: remove unused members from addi_private
      staging: comedi: addi_apci_3120: remove boardinfo 'i_DoMaxdata'
      staging: comedi: addi_apci_3120: remove boardinfo 'i_NbrDoChannel'
      staging: comedi: addi_apci_3120: remove boardinfo 'i_NbrDiChannel'
      staging: comedi: addi_apci_3120: remove boardinfo 'i_NbrAiChannel'
      staging: comedi: addi_apci_3120: remove boardinfo 'i_AiChannelList'
      staging: comedi: addi_apci_3120: simplify analog output boardinfo
      staging: comedi: addi_apci_3120: simplify analog input boardinfo
      staging: comedi: addi_apci_035: separate from addi_common.h
      staging: comedi: addi_apci_1500: separate from addi_common.h
      staging: comedi: addi_apci_3120: separate from addi_common.h
      staging: comedi: addi_common.h: remove file
      staging: comedi: usbdux: introduce usbduxsub_ao_handle_urb()
      staging: comedi: usbdux: introduce usbduxsub_ai_handle_urb()
      staging: comedi: usbduxfast: introduce usbduxfast_ai_handle_urb()
      staging: comedi: usbduxsigma: introduce usbduxsigma_ao_handle_urb()
      staging: comedi: usbduxsigma: introduce usbduxsigma_ai_handle_urb()
      staging: comedi: addi_apci_035: remove driver
      staging: comedi: ni_mio_common: remove deadcode in ni_cdio_cmdtest()
      staging: comedi: ni_6527: remove deadcode in ni6527_intr_cmdtest()
      staging: comedi: ni_65xx: remove deadcode in ni_65xx_intr_cmdtest()
      staging: comedi: addi_apci_3120: DMA requires an interrupt
      staging: comedi: addi_apci_3120: introduce struct apci3120_dmabuf
      staging: comedi: addi_apci_3120: remove unused struct definition
      staging: comedi: addi_apci_3120: remove unipolar range from analog outputs
      staging: comedi: addi_apci_3120: remove private data 'i_IobaseReserved'
      staging: comedi: addi_apci_3120: use correct iobase to write AMCC registers
      staging: comedi: addi_apci_3120: use correct iobase to read board register
      staging: comedi: addi_apci_3120: rename private data 'i_IobaseAddon'
      staging: comedi: addi_apci_3120: rename private data 'i_IobaseAmcc'
      staging: comedi: addi_apci_3120: remove private data 'iobase'
      staging: comedi: addi_apci_3120: prevent deadlock in apci3120_ao_insn_write()
      staging: comedi: addi_apci_3120: remove analog output reset
      staging: comedi: addi_apci_3120: fix apci3120_ao_insn_write()
      staging: comedi: addi_apci_3120: provide analog output 'readback'
      staging: comedi: addi_apci_3120: tidy up analog output subdevice init
      staging: comedi: addi_apci_3120: tidy up digital input subdevice init
      staging: comedi: addi_apci_3120: tidy up digital output subdevice init
      staging: comedi: addi_apci_3120: tidy up analog input subdevice init
      staging: comedi: addi_apci_3120: tidy up timer subdevice init
      staging: comedi: addi_apci_3120: reset the board before hooking up the interrupt
      staging: comedi: addi_apci_3120: don't reset board when canceling ai command
      staging: comedi: addi_apci_3120: don't reset board when detaching driver
      staging: comedi: comedi_buf: introduce comedi_buf_read_samples()
      staging: comedi: amplc_pci224: use comedi_buf_read_samples()
      staging: comedi: cb_pcidas: introduce cb_pcidas_ao_load_fifo()
      staging: comedi: cb_pcidas: introduce cb_pcidas64_ao_fill_buffer()
      staging: comedi: dt282x: introduce dt282x_ao_setup_dma()
      staging: comedi: comedi_fc.h: remove cfc_read_array_from_buffer()
      staging: comedi: comedi_buf: remove export of comedi_read_array_from_buffer()
      staging: comedi: comedi_buf: absorb comedi_read_array_from_buffer()
      staging: comedi: comedi_buf: make comedi_buf_read_samples() always return full samples
      staging: comedi: ni_mio_common: use comedi_buf_read_samples()
      staging: comedi: amplc_pci230: use comedi_buf_read_samples()
      staging: comedi: usbdux: use comedi_buf_read_samples()
      staging: comedi: usbduxsigma: use comedi_buf_read_samples()
      staging: comedi: comedi_buf: remove comedi_buf_get()
      staging: comedi: comedi_buf: dont't export comedi_buf_memcpy_from()
      staging: comedi: comedi_buf: don't export comedi_buf_memcpy_to()
      staging: comedi: comedi_buf: comedi_buf_memcpy_to() remove 'offset' param
      staging: comedi: comedi_buf: comedi_buf_memcpy_from() remove 'offset' param
      staging: comedi: comedi_buf: introduce comedi_buf_write_samples()
      staging: comedi: comedi_fc.h: remove cfc_write_long_to_buffer()
      staging: comedi: comedi_test: use comedi_buf_write_samples()
      staging: comedi: das800: use comedi_buf_write_samples()
      staging: comedi: ni_at_a2150: use comedi_buf_write_samples()
      staging: comedi: s626: use comedi_buf_write_samples()
      staging: comedi: ni_labpc_common: use comedi_buf_write_samples()
      staging: comedi: ni_labpc_isadma: use comedi_buf_write_samples()
      staging: comedi: das1800: use comedi_buf_write_samples()
      staging: comedi: cb_pcidas: use comedi_buf_write_samples()
      staging: comedi: adl_pci9118: use comedi_buf_write_samples()
      staging: comedi: cb_pcidas64: use comedi_buf_write_samples()
      staging: comedi: ni_mio_common: use comedi_buf_write_samples()
      staging: comedi: comedi_fc.h: remove cfc_write_to_buffer()
      staging: comedi: adl_pci9111: use comedi_buf_write_samples()
      staging: comedi: hwdrv_apci3120: use comedi_buf_write_samples()
      staging: comedi: das16m1: use comedi_buf_write_samples()
      staging: comedi: das16: use comedi_buf_write_samples()
      staging: comedi: dt282x: use comedi_buf_write_samples()
      staging: comedi: gsc_hpdi: use comedi_buf_write_samples()
      staging: comedi: usbduxsigma: use comedi_buf_write_samples()
      staging: comedi: usbduxfast: use comedi_buf_write_samples()
      staging: comedi: comedi_fc.h: remove cfc_write_array_to_buffer()
      staging: comedi: addi_apci_1032: use comedi_buf_write_samples()
      staging: comedi: addi_apci_1564: use comedi_buf_write_samples()
      staging: comedi: addi_apci_3xxx: use comedi_buf_write_samples()
      staging: comedi: adv_pci1710: use comedi_buf_write_samples()
      staging: comedi: amplc_pc236_common: use comedi_buf_write_samples()
      staging: comedi: amplc_pci230: use comedi_buf_write_samples()
      staging: comedi: comedi_parport: use comedi_buf_write_samples()
      staging: comedi: dmm32at: use comedi_buf_write_samples()
      staging: comedi: dt3000: use comedi_buf_write_samples()
      staging: comedi: me4000: use comedi_buf_write_samples()
      staging: comedi: ni_6527: use comedi_buf_write_samples()
      staging: comedi: ni_65xx: use comedi_buf_write_samples()
      staging: comedi: ni_atmio16d: use comedi_buf_write_samples()
      staging: comedi: pcl711: use comedi_buf_write_samples()
      staging: comedi: pcl726: use comedi_buf_write_samples()
      staging: comedi: pcl812: use comedi_buf_write_samples()
      staging: comedi: pcl816: use comedi_buf_write_samples()
      staging: comedi: pcl818: use comedi_buf_write_samples()
      staging: comedi: quatech_daqp_cs: use comedi_buf_write_samples()
      staging: comedi: rtd520: use comedi_buf_write_samples()
      staging: comedi: usbdux: use comedi_buf_write_samples()
      staging: comedi: hwdrv_apci3120: use comedi_buf_write_samples()
      staging: comedi: addi_apci_2032: use comedi_buf_write_samples()
      staging: comedi: amplc_dio200_common: use comedi_buf_write_samples()
      staging: comedi: ni_pcidio: use comedi_buf_write_samples()
      staging: comedi: pcmmio: use comedi_buf_write_samples()
      staging: comedi: pcmuio: use comedi_buf_write_samples()
      staging: comedi: comedi_buf: remove comedi_buf_put()
      staging: comedi: comedi_buf: don't export comedi_write_array_to_buffer()
      staging: comedi: comedi_buf: absorb comedi_write_array_to_buffer()
      staging: comedi: comedi_buf: absorb __comedi_buf_write_alloc()
      staging: comedi: me4000: fix firmware downloading
      staging: comedi: addi_apci_1564: remove APCI1564_COUNTER[1234] defines
      staging: comedi: addi_apci_1564: board has 3 timers
      staging: comedi: addi_apci_1564: remove private data 'mode_select_register'
      staging: comedi: comedi_buf: make comedi_buf_write_samples() add samples that fit
      staging: comedi: drivers: replace SDF_WRITEABLE with SDF_WRITABLE
      staging: comedi: drivers: remove inappropriate SDF_* flags from subdevices
      staging: comedi: drivers: digital output subdevices do not need SDF_READABLE
      staging: comedi: drivers do not need to reset the async->cur_chan
      staging: comedi: rtd520: fix ai_read_n() async->cur_chan use
      staging: comedi: rtd520: remove private data 'chan_is_bipolar' member
      staging: comedi: ni_mio_common: remove unused variable in ni_ao_fifo_load()
      staging: comedi: drivers: move comedi_async 'cur_chan' tracking into the core
      staging: comedi: amplc_pci230: remove private data 'ai_scan_pos'
      staging: comedi: remove use of 'bytes_per_sample()'
      staging: comedi: ni_mio_common: use sample manipulation helpers
      staging: comedi: das1800: use sample manipulation helpers
      staging: comedi: das16: use sample manipulation helpers
      staging: comedi: adv_pci1710: use sample manipulation helpers
      staging: comedi: adl_pci9118: use sample manipulation helpers
      staging: comedi: adl_pci9111: use sample manipulation helpers
      staging: comedi: hwdrv_apci3120: use sample manipulation helpers
      staging: comedi: ni_at_a2150: use sample manipulation helpers
      staging: comedi: comedidev.h: add 'scans_done' member to comedi_async
      staging: comedi: addi_apci_2032: use comedi_async 'scans_done' to detect EOA
      staging: comedi: amplc_dio200_common: use comedi_async 'scans_done' to detect EOA
      staging: comedi: pcl711: use comedi_async 'scans_done' to detect EOA
      staging: comedi: pcl812: use comedi_async 'scans_done' to detect EOA
      staging: comedi: pcl816: use comedi_async 'scans_done' to detect EOA
      staging: comedi: pcl818: remove private data member 'ai_act_chan'
      staging: comedi: pcl818: use comedi_async 'scans_done' to detect EOA
      staging: comedi: adv_pci1710: use comedi_async 'scans_done' to detect EOA
      staging: comedi: pcmmio: use comedi_async 'scans_done' to detect EOA
      staging: comedi: pcmuio: use comedi_async 'scans_done' to detect EOA
      staging: comedi: s626: use comedi_async 'scans_done' to detect EOA
      staging: comedi: usbdux: use comedi_async 'scans_done' to detect AO EOA
      staging: comedi: usbdux: use comedi_async 'scans_done' to detect AI EOA
      staging: comedi: usbduxsigma: use comedi_async 'scans_done' to detect AO EOA
      staging: comedi: usbduxsigma: use comedi_async 'scans_done' to detect AI EOA
      staging: comedi: addi_apci_3120: use comedi_async 'scans_done' to detect EOA
      staging: comedi: das800: use comedi_async 'scans_done' to detect EOA
      staging: comedi: drivers: introduce comedi_nscans_left()
      staging: comedi: amplc_pci224: use comedi_async 'scans_done' to detect EOA
      staging: comedi: comedi_test: use comedi_async 'scans_done' to detect EOA
      staging: comedi: amplc_pci230: use comedi_async 'scans_done' to detect AO EOA
      staging: comedi: drivers: introduce comedi_nsamples_left()
      staging: comedi: amplc_pci230: use comedi_async 'scans_done' to detect AI EOA
      staging: comedi: usbduxfast: use comedi_async 'scans_done' to detect AI EOA
      staging: comedi: cb_pcidas: use comedi_async 'scans_done' to detect AI EOA
      staging: comedi: cb_pcidas: use comedi_async 'scans_done' to detect AO EOA
      staging: comedi: cb_pcidas64: use comedi_async 'scans_done' to detect AI EOA
      staging: comedi: cb_pcidas64: use comedi_async 'scans_done' to detect AO EOA
      staging: comedi: quatech_daqp_cs: use comedi_async 'scans_done' to detect EOA
      staging: comedi: das1800: use comedi_async 'scans_done' to detect EOA
      staging: comedi: addi_apci_3120: introduce apci3120_ns_to_timer()
      staging: comedi: addi_apci_3120: rename private data 'b_DigitalOutputRegister'
      staging: comedi: addi_apci_3120: introduce apci3120_timer_write()
      staging: comedi: addi_apci_3120: introduce apci3120_timer_read()
      staging: comedi: addi_apci_3120: tidy up CTR0 register defines
      staging: comedi: addi_apci_3120: fix counter and external interrupt disable
      staging: comedi: addi_apci_3120: rename APCI3120_TIMER_VALUE
      staging: comedi: addi_apci_3120: rename private data 'b_TimerSelectMode'
      staging: comedi: addi_apci_3120: tidy up timer_mode masking
      staging: comedi: addi_apci_3120: introduce apci3120_timer_set_mode()
      staging: comedi: addi_apci_3120: move timer helpers to main driver source
      staging: comedi: addi_apci_3120: rename private data 'us_OutputRegister'
      staging: comedi: addi_apci_3120: tidy up devpriv->ctrl use
      staging: comedi: addi_apci_3120: remove APCI3120_DISABLE_TIMER[012]
      staging: comedi: addi_apci_3120: tidy up APCI3120_ENABLE_TIMER[012]
      staging: comedi: addi_apci_3120: rename APCI3120_ENABLE_EXT_TRIGGER
      staging: comedi: addi_apci_3120: tidy up apci3120_exttrig_{enable,disable}()
      staging: comedi: addi_apci_3120: introduce apci3120_timer_enable()
      staging: comedi: addi_apci_3120: fix timer 2 disable in apci3120_write_insn_timer()
      staging: comedi: addi_apci_3120: rename APCI3120_WR_ADDRESS
      staging: comedi: addi_apci_3120: move apci3120_timer_enable() to driver source
      staging: comedi: addi_apci_3120: move apci3120_exttrig_enable() to driver source
      staging: comedi: addi_apci_3120: introduce apci3120_clr_timer2_interrupt()
      staging: comedi: addi_apci_3120: remove unnecessary reset of the scan sequence
      staging: comedi: addi_apci_3120: tidy up scan chanlist programming
      staging: comedi: addi_apci_3120: remove 'check' param from apci3120_setup_chan_list()
      staging: comedi: addi_apci_3120: introduce apci3120_ai_reset_fifo()
      staging: comedi: addi_apci_3120: move ai range table to driver source
      staging: comedi: addi_apci_3120: remove APCI3120_DISABLE_ALL_INTERRUPT_WITHOUT_TIMER
      staging: comedi: addi_apci_3120: properly disable interrupts in apci3120_cancel()
      staging: comedi: addi_apci_3120: rename private data 'b_ModeSelectRegister'
      staging: comedi: addi_apci_3120: remove unnecessary devpriv->mode masking
      staging: comedi: addi_apci_3120: remove devpriv->mode '0xef' magic value
      staging: comedi: addi_apci_3120: remove APCI3120_DISABLE_TIMER_COUNTER
      staging: comedi: addi_apci_3120: remove APCI3120_DISABLE_WATCHDOG
      staging: comedi: addi_apci_3120: remove APCI3120_DISABLE_TIMER_INT
      staging: comedi: addi_apci_3120: remove APCI3120_DISABLE_EOC_INT
      staging: comedi: addi_apci_3120: remove APCI3120_DISABLE_EOS_INT
      staging: comedi: addi_apci_3120: remove APCI3120_DISABLE_SCAN
      staging: comedi: addi_apci_3120: define the "enable" bits in the mode register
      staging: comedi: addi_apci_3120: define the timer 2 operation bits
      staging: comedi: addi_apci_3120: define the timer 2 clock select bits
      staging: comedi: addi_apci_3120: rename APCI3120_WRITE_MODE_SELECT
      staging: comedi: addi_apci_3120: remove scanning from ai (*insn_read)
      staging: comedi: addi_apci_3120: remove private data 'ui_EocEosConversionTime'
      staging: comedi: addi_apci_3120: remove interrupt support from ai (*insn_read)
      staging: comedi: addi_apci_3120: remove apci3120_ai_insn_config()
      staging: comedi: addi_apci_3120: remove private data 'ui_AiReadData'
      staging: comedi: addi_apci_3120: fix apci3120_ai_insn_read()
      staging: comedi: addi_apci_3120: absorb apci3120_interrupt_handle_eos()
      staging: comedi: addi_apci_3120: remove private data 'ui_AiNbrofChannels'
      staging: comedi: addi_apci_3120: remove private data 'ui_AiChannelList'
      staging: comedi: addi_apci_3120: rename APCI3120_RD_STATUS
      staging: comedi: addi_apci_3120: define status register bits
      staging: comedi: addi_apci_3120: remove private data 'ai_running'
      staging: comedi: addi_apci_3120: move apci3120_do_insn_bits() to driver source
      staging: comedi: addi_apci_3120: move apci3120_di_insn_bits() to driver source
      staging: comedi: addi_apci_3120: move apci3120_ao_insn_write() to driver source
      staging: comedi: addi_apci_3120: move apci3120_ai_insn_read() to driver source
      staging: comedi: addi_apci_3120: remove check in apci3120_setup_chan_list()
      staging: comedi: addi_apci_3120: move apci3120_set_chanlist() to driver source
      staging: comedi: addi_apci_3120: factor DMA setup out of apci3120_cyclic_ai()
      staging: comedi: addi_apci_3120: remove APCI3120_{ENABLE,DISABLE}
      staging: comedi: addi_apci_3120: flip 'us_UseDma' test in apci3120_cyclic_ai()
      staging: comedi: addi_apci_3120: move timer 2 enable in apci3120_cyclic_ai()
      staging: comedi: addi_apci_3120: move start_src check into apci3120_cyclic_ai()
      staging: comedi: addi_apci_3120: absorb apci3120_cyclic_ai()
      staging: comedi: addi_apci_3120: tidy up timer programming in apci3120_ai_cmd()
      staging: comedi: addi_apci_3120: tidy up timer 2 programming in apci3120_ai_cmd()
      staging: comedi: addi_apci_3120: reset fifo after programming chanlist
      staging: comedi: addi_apci_3120: set scan length/start after programming chanlist
      staging: comedi: addi_apci_3120: enable chanlist scanning if needed
      staging: comedi: addi_apci_3120: tidy up devpriv->mode in apci3120_ai_cmd()
      staging: comedi: addi_apci_3120: remove private data 'b_InterruptMode'
      staging: comedi: addi_apci_3120: remove private data 'b_ExttrigEnable'
      staging: comedi: addi_apci_3120: introduce apci3120_init_dma()
      staging: comedi: addi_apci_3120: introduce apci3120_addon_write()
      staging: comedi: addi_apci_3120: use amcc_s5933.h defines
      staging: comedi: addi_apci_3120: define the Add-On registers
      staging: comedi: addi_apci_3120: move APCI3120_FIFO_ADVANCE_ON_BYTE_2
      staging: comedi: addi_apci_3120: move DMA init code to apci3120_init_dma()
      staging: comedi: addi_apci_3120: tidy up apci3120_reset()
      staging: comedi: addi_apci_3120: move apci3120_reset() to driver source
      staging: comedi: addi_apci_3120: rename private data 'us_UseDma'
      staging: comedi: addi_apci_3120: rename private data 'b_DmaDoubleBuffer'
      staging: comedi: addi_apci_3120: rename private data 'ui_DmaActualBuffer'
      staging: comedi: addi_apci_3120: don't use timer 2 to count scans
      staging: comedi: addi_apci_3120: define the AI FIFO register
      staging: comedi: addi_apci_3120: define the AI software trigger register
      staging: comedi: addi_apci_3120: fix timer (*insn_read)
      staging: comedi: addi_apci_3120: fix timer (*insn_config)
      staging: comedi: addi_apci_3120: fix cmd->convert_arg vaildation
      staging: comedi: addi_apci_3120: move AI (*do_cmdtest) to main driver
      staging: comedi: addi_apci_3120: add copyright information
      staging: comedi: addi_apci_3120: remove unnecessary include
      staging: comedi: addi_apci_3120: move apci3120_addon_write() to driver
      staging: comedi: addi_apci_3120: move apci3120_init_dma() to driver
      staging: comedi: addi_apci_3120: move apci3120_setup_dma() to driver
      staging: comedi: addi_apci_3120: move apci3120_ai_cmd() to driver
      staging: comedi: addi_apci_3120: use async->events to report hardware error
      staging: comedi: addi_apci_3120: move apci3120_cancel() to driver
      staging: comedi: addi_apci_3120: move apci3120_interrupt() to driver
      staging: comedi: addi_apci_3120: use comedi_bytes_to_samples()
      staging: comedi: addi_apci_3120: move apci3120_interrupt_dma() to driver
      staging: comedi: addi_apci_3120: change params to apci3120_interrupt_dma()
      staging: comedi: addi_apci_3120: switch DMA buffers after writing samples
      staging: comedi: addi_apci_3120: enable AI async commands
      staging: comedi: addi_apci_3120: absorb apci3120_ai_reset_fifo()
      staging: comedi: addi_apci_1564: board does not use an AMCC PCI controller
      staging: comedi: addi_apci_1564: use correct I/O base for APCI1564_DI_INT_STATUS_REG
      staging: comedi: addi_apci_1564: store PCI BAR 1 base address in private data
      staging: comedi: addi_apci_1564: use dev->iobase for main registers
      staging: comedi: addi_apci_1564: detect PLD revision for I/O mapping
      staging: comedi: addi_apci_1564: fix dev->iobase for all PLD revisions
      staging: comedi: addi_apci_1564: fix timer iobase for all PLD revisions
      staging: comedi: addi_apci_1564: fix counter code in main driver source
      staging: comedi: addi_apci_1564: move counter register defines to driver
      staging: comedi: addi_apci_1564: split timer and counter subdevices
      staging: comedi: addi_tcw.h: provide generic defines for the ADDI-DATA TCW
      staging: comedi: addi_apci_1564: use addi_tcw.h defines for timer
      staging: comedi: addi_apci_1564: use addi_tcw.h defines for counters
      staging: comedi: addi_apci_1564: enable support for PLD Rev 1.0 I/O mapping
      staging: comedi: addi_watchdog: use addi_tcw.h defines for watchdog
      staging: comedi: adl_pci9118: use comedi_async 'scans_done' to detect EOA
      staging: comedi: adl_pci9118: absorb move_block_from_dma()
      staging: comedi: adl_pci9118: use comedi_bytes_to_samples()
      staging: comedi: adl_pci9111: use comedi_async 'scans_done' to detect EOA
      staging: comedi: dmm32at: make AI (*cancel) actually cancel async command
      staging: comedi: dmm32at: use comedi_async 'scans_done' to detect EOA
      staging: comedi: dmm32at: introduce dmm32_ai_get_sample()
      staging: comedi: dmm32at: tidy up dmm32at_ai_rinsn()
      staging: comedi: dmm32at: introduce dmm32at_reset()
      staging: comedi: dmm32at: tidy up subdevice initialization
      staging: comedi: dmm32at: tidy up cmd->scan_begin_{src, arg} validation
      staging: comedi: dmm32at: tidy up cmd->convert_{src, arg} validation
      staging: comedi: dmm32at: remove dmm32at_ns_to_timer()
      staging: comedi: dmm32at: remove unused members of the private data
      staging: comedi: dmm32at: introduce dmm32at_ai_set_chanspec()
      staging: comedi: dmm32at: use 8255 module for Digital I/O subdevice
      staging: comedi: dmm32at: rename DMM32AT_CONV
      staging: comedi: dmm32at: rename DMM32AT_AI[LM]SB
      staging: comedi: dmm32at: rename DMM32AT_AUXDOUT
      staging: comedi: dmm32at: rename DMM32AT_AI{LOW,HIGH}
      staging: comedi: dmm32at: rename DMM32AT_DAC[LM]SB
      staging: comedi: dmm32at: rename DMM32AT_DACSTAT
      staging: comedi: dmm32at: rename DMM32AT_DACMSB_CHAN
      staging: comedi: dmm32at: define the FIFO Depth register
      staging: comedi: dmm32at: rename DMM32AT_FIFOCNTRL
      staging: comedi: dmm32at: rename DMM32AT_FIFOSTAT
      staging: comedi: dmm32at: rename DMM32AT_CNTRL
      staging: comedi: dmm32at: rename DMM32AT_AISTAT
      staging: comedi: dmm32at: rename DMM32AT_INTCLOCK
      staging: comedi: dmm32at: rename DMM32AT_CNTRDIO
      staging: comedi: dmm32at: rename DMM32AT_AICONF
      staging: comedi: dmm32at: rename DMM32AT_AIRBACK
      staging: comedi: dmm32at: tidy up multi-line comments
      staging: comedi: dmm32at: update the MODULE_DESCRIPTION
      staging: comedi: das6402: add basic (*do_cmdtest) for AI async commands
      staging: comedi: das6402: introduce das6402_ai_set_mode()
      staging: comedi: das6402: read analog input samples in interrupt handler
      staging: comedi: das6402: add (*do_cmd) for AI async commands
      staging: comedi: adv_pci1724: use subdevice readback for 'ao_value'
      staging: comedi: adv_pci1724: use subdevice readback for 'offset_value'
      staging: comedi: adv_pci1724: use subdevice readback for 'gain_value'
      staging: comedi: adv_pci1724: remove NUM_AO_CHANNELS define
      staging: comedi: adv_pci1724: introduce adv_pci1724_insn_write()
      staging: comedi: adv_pci1724: use comedi_timeout() to wait for DAC idle state
      staging: comedi: adv_pci1724: absorb set_dac()
      staging: comedi: adv_pci1724: remove PCI_VENDOR_ID_ADVANTECH define
      staging: comedi: adv_pci1724: tidy up the register I/O map
      staging: comedi: adv_pci1724: define the dac control register bits
      staging: comedi: adv_pci1724: define the sync output control/status reg
      staging: comedi: adv_pci1724: remove enum sync_output_trigger_contents
      staging: comedi: adv_pci1724: define the board id register bits
      staging: comedi: adv_pci1724: absorb setup_subdevices()
      staging: comedi: adv_pci1724: remove unnecessary dev_info()
      staging: comedi: adv_pci1724: tidy up the pci_driver declaration
      staging: comedi: adv_pci1724: tidy up the comedi_driver declaration
      staging: comedi: adv_pci1724: tidy up multi-line comments
      staging: comedi: adv_pci1724: rename ao_ranges_1724
      staging: comedi: drivers: have core hook up default (*insn_read) for readback
      staging: comedi: cb_pcidas64: use subdevice readback for 'caldac_state'
      staging: comedi: cb_pcidas64: fix calib_write_insn()
      staging: comedi: cb_pcidas64: use subdevice readback for 'ad8402_state'
      staging: comedi: cb_pcidas64: fix ad8402_write_insn()
      staging: comedi: cb_pcidas: remove unnecessary check in caldac_8800_write()
      staging: comedi: cb_pcidas: fix caldac_write_insn()
      staging: comedi: cb_pcidas: use subdevice readback for 'caldac_value'
      staging: comedi: cb_pcidas: fix trimpot_write_insn()
      staging: comedi: cb_pcidas: use subdevice readback for 'trimpot_value'
      staging: comedi: cb_pcidas: tidy up dac08_write_insn()
      staging: comedi: cb_pcidas: use subdevice readback for 'dac08_value'
      staging: comedi: ni_at_ao: use subdevice readback for 'caldac'
      staging: comedi: ni_labpc_common: move calib readback value check/save to (*insn_write)
      staging: comedi: ni_labpc_common: use subdevice readback for 'caldac'
      staging: comedi: ni_labpc_common: introduce labpc_ao_write()
      staging: comedi: ni_labpc_common: use subdevice readback for analog outputs
      staging: comedi: ni_labpc_common: use subdevice readback for eeprom
      staging: comedi: ni_labpc_common: use comedi_timeout() when writing to eeprom
      staging: comedi: adv_pci1723: tidy up register map
      staging: comedi: adv_pci1723: remove private data 'da_range'
      staging: comedi: adv_pci1723: remove board reset during (*detach)
      staging: comedi: adv_pci1723: absorb pci1723_reset()
      staging: comedi: adv_pci1723: use comedi_subdevice readback for 'ao_data'
      staging: comedi: adv_pci1723: tidy up pci1723_dio_insn_config()
      staging: comedi: adv_pci1723: tidy up DIO io_bits initialization
      staging: comedi: adv_pci1723: remove subdevice 'len_chanlist' initialization
      staging: comedi: adv_pci1723: update the MODULE_DESCRIPTION
      staging: comedi: adv_pci1723: tidy up multi-line comments
      staging: comedi: adv_pci1723: remove comedi_device 'write_subdev' init

Hartmut Knaack (3):
      iio:humidity:si7020: cleanup read_raw and probe
      iio:humidity:si7020: fix pointer to i2c client
      iio:pressure:bmp280: fix pressure calculation

Heena Sirwani (20):
      Staging: iio: gyro: Added description for config symbol.
      Staging: iio: Documentation: Added missing blank line after declarations.
      Staging: iio: Documentation: Simplify error handling.
      Staging: iio: Documentation: Added check for sscanf return value.
      Staging: lustre: lnet: selftest: Made a function static.
      Staging: lustre: lnet: selftest: Made a function static.
      Staging: lustre: lnet: selftest: Made a function static.
      Staging: lustre: lnet: selftest: Made a function static.
      Staging: lustre: lustre: lmv: Removed variable that is not very useful.
      Staging: lustre: lustre: mgc: Remove variable that is not very useful.
      Staging: lustre: lustre: lov: Remove variable that is not very useful.
      Staging: lustre: lustre: osc: Remove variable that is not very useful.
      Staging: lustre: lustre: osc: Remove variable that is not very useful.
      Staging: lustre: lustre: osc: Changed the return code of a function from int to void.
      Staging: rtl8723au: os_dep: Removed variable that is always 0.
      Staging: rtl8723au: core: Removed variable that is always 0.
      Staging: rtl8188eu: core: Remove variable that is not very useful.
      Staging: comedi: drivers: Compressed two lines of code into one.
      Staging: comedi: Compressed two lines of code into one.
      Staging: dgnc: Compress two lines of code into one.

Heiko Stübner (1):
      iio: adc: rockchip_saradc: add support for rk3066-tsadc variant

Ian Abbott (26):
      staging: comedi: cb_pcimdas: use preferred block comment style
      staging: comedi: cb_pcimdas: update driver comment
      staging: comedi: cb_pcimdas: add support for PCIe-DAS1602/16
      staging: comedi: introduce some sample size manipulation functions
      staging: comedi: comedi_test: fix timer lock-up
      staging: comedi: das16: deschedule timer routine on detach
      staging: comedi: das16: use spin-lock when setting timer
      staging: comedi: maybe force CMDF_WRITE command flag
      staging: comedi: me4000: don't clobber command flags
      staging: comedi: ni_mio_common: don't change CMDF_WRITE flag
      staging: comedi: don't allow read() on async command set up for "write"
      staging: comedi: don't allow write() on async command set up for "read"
      staging: comedi: check command direction in poll() file operation
      staging: comedi: check actual data direction for COMEDI_BUFINFO ioctl
      staging: comedi: icp_multi: correct insn_bits returned data for DO
      staging: comedi: prepare support for per-file read and write subdevices
      staging: comedi: add ioctls to set per-file read and write subdevice
      staging: comedi: comedidev.h: remove dummy PCI support functions
      staging: comedi: comedidev.h: remove some #ifdefs
      staging: comedi: split out PCMCIA support into new module
      staging: comedi: split out USB support into new module
      staging: comedi: split out PCI support into new module
      staging: comedi: fix scan_end_arg == chanlist_len assumption
      staging: comedi: adl_pci9118: simplify interrupt_pci9118_ai_dma() a bit
      staging: comedi: adl_pci9118: try and avoid unnecessary DMA restart
      staging: comedi: adl_pci9118: eliminate DMA buffer defragmentation step

Ivan T. Ivanov (2):
      iio: inkern: Add of_xlate function to struct iio_info
      iio: iadc: Qualcomm SPMI PMIC current ADC driver

Jacob Pan (1):
      iio: add documentation for current attribute

Janet Liu (1):
      staging: lustre: fixed sparse warnings related to static declarations

Jeff Kirsher (1):
      staging: bcm: remove driver

Jes Sorensen (52):
      staging: rtl8723au: Fix alignment of mac_addr for ether_addr_copy() usage
      staging: rtl8723au: Remove write-only struct xmit_priv->vcs_type
      staging: rtl8723au: Use enum values for vcs_type
      staging: rtl8723au: Eliminate write-once variable xmit_priv->vcs_setting
      staging: rtl8723au: Use register define REQ_NQOS_SEQ instead of hardcoded value
      staging: rtl8723au: Don't read REQ_NQOS_SEQ 16 bits and write back 8 bits
      staging: rtl8723au: Re-organize struct xmit_priv for better packing
      staging: rtl8723au: Remove unused struct zero_bulkout_content
      staging: rtl8723au: Fold struct wlan_phy_info into struct wlan_bssid_ex
      staging: rtl8723au: Remove unused struct ndis_802_11_key
      staging: rtl8723au: Eliminate write-only struct wlan_network->aid
      staging: rtl8723au: Remove a stack of write only counters
      stating: rtl8723au: Eliminate write-only struct xmit_priv->txirp_cnt
      staging: rtl8723au: Remove unused rtw_calculate_wlan_pkt_size_by_attribue23a()
      staging rtl8723au: rtw_put_smap23a(): Use common SNAP header defines
      staging: rtl8723au: rtw_put_snap23a(): Use put_unaligned to set protocol
      staging: rtl8723au: rtw_put_snap23a(): Make it static
      staging: rtl8723au: portctrl(): Remove a pile of unnecessary clutter
      staging: rtl8723au: rtw_dump_xframe(): Use proper ETH_P_* types
      staging: rtl8723au: pxmitframe->frame_tag is never set to a value > 8
      staging: rtl8723au: Remove unused rtl8723a_update_txdesc() and child functions
      staging: rtl8723au: Remove no-op function Hal_InitChannelPlan23a()
      staging: rtl8723au: Remove sw led handling
      staging: rtl8188eu: usb_dvobj_init(): A NULL pointer check for usb_host_endpoints makes no sense
      staging: rtl8723au: recv_priv.is_signal_dbg is never set
      staging: rtl8723au: recv_priv->rssi is not used for anything
      staging: rtl8723au: Fold ODM_PhyStatusQuery23a_92CSeries() into ODM_PhyStatusQuery23a()
      staging: rtl8732au: Partial clean up of rtl8723a_rf6052.c
      staging: rtl8723au: Fold rtw_ack_tx_done23a() into rtw23a_sctx_done_err()
      staging: rtl8723au: Eliminate do_queue_select() functions
      staging: rtl8723au: Remove unused rtw_sctx_done23a() function
      staging: rtl8723au: Remove write only struct hal_data_8723a.interfaceIndex
      staging: rtl8723au: Fold rtl8723au_set_queue_pipe_mapping into rtl8723au_chip_configure()
      staging: rtl8723au: _InitPowerOn(): Don't zero init variables unnecessarily
      staging: rtl8723au: Fold _InitNormalChipQueuePriority() into _InitQueuePriority()
      staging: rtl8723au: Remove no-op _InitHWLed() function
      staging: rtl8723au: Do not write garbage to REG_SPS0_CTRL
      staging: rtl8723au: Fold _ps_open_RF23a() into rtl8723au_hal_init()
      staging: rtl8723au: phy_SsPwrSwitch92CU() was never called with bRegSSPwrLvl != 1
      staging: rtl8723au: Use a local variable to state if MAC was already powered on
      staging: rtl8723au: rtl8723au_read_port() addr argument wasn't used
      staging: rtl8723au: rtl8723au_read_interrupt() addr argument wasn't used
      staging: rtl8723au: Remove unused slimcombo debug flag
      staging: rtl8723au: rtl8723a_update_ramask(): Fix up some bad formatting
      staging: rtl8723au: Fold _BlockWrite() into _PageWrite()
      staging: rtl8723au: _DisableRFAFEAndResetBB8192C(): Use correct enum value
      staging: rtl8723au: _DisableRFAFEAndResetBB8192C(): Reduce code obfuscation
      staging: rtl8723au: Remove unnecessary wrapper _DisableRFAFEAndResetBB()
      staging: rtl8723au: _ResetDigitalProcedure1_92C() reduce code obfuscation
      staging: rtl8723au: Remove unnecessary wrapper _ResetDigitalProcedure1()
      staging: rtl8723au: _DisableAnalog(): Avoid zero-init variables unnecessarily
      staging: rtl8723au: Hal_InitPGData() avoid unnecessary typecasts

Jia He (1):
      staging: rtl8188eu: Fix coding style space related ERROR problems

Jiayi Ye (11):
      staging: lustre: lustre: obdecho: expand the GOTO macro in echo_client.c
      staging: rtl8188eu: core: fixed msleep < 20ms can sleep for up to 20ms warning in rtw_efuse.c
      staging: ft1000: ft1000-pcmcia: removed unused variable in ft1000_hw.c
      staging: rts5208: fix case of bitwise operator on zero in ms.c
      staging: rtl8188eu: core: fix null dereference on exit path in rtw_mlme.c
      staging: remove unneeded parentheses around the right hand side of an assignment
      staging: rtl8723au: delete successive assignments to the same location
      staging: lustre: lnet: klnds: o2iblnd: fix null dereference on failed path in o2iblnd.c
      staging: dgnc: delete successive assignments to the same location
      staging: rtl8192e: delete successive assignments to the same location
      staging: rtl8192u: delete successive assignments to the same location

Joe Perches (4):
      staging: gs_fpgaboot: Use print_hex_dump_bytes instead of pr_info
      staging: ft1000: Whitespace neatening
      staging: ft1000: Logging message neatening
      staging: lustre: Coalesce string fragments

John Ledbetter (1):
      staging: rtl8192e: Fix pointer type declaration style errors

Julia Lawall (4):
      staging: lustre: osc: remove final uses of the GOTO macro
      staging: lustre: libcfs: remove final uses of the GOTO macro
      staging: lustre: libcfs_debug.h: remove final uses of the GOTO macro
      staging: unisys: remove unneeded structure

Juston Li (1):
      staging: lustre: mdc: use __FMODE_EXEC macro

Karol Wrona (1):
      staging: iio: Add notrigger mode for generic_buffer

Ken Depro (2):
      staging: unisys: Remove unneeded spaces from channel.c
      staging: unisys: Remove extra blank lines from virthba files

Kinka Huang (1):
      staging:rtl8723au: fix sparse warning: incorrect type in assignment

Koray Gulcu (2):
      staging: rtl8192u: Fix sparse warnings of r8182U_core
      staging: rtl8192u: Fix checkpatch.pl warnings

Krzysztof Konopko (3):
      rtl8188eu: Simplify rtw_endofpktfile() in xmit_linux.c
      rtl8188eu: Fix FSF_MAILING_ADDRESS in rtw_led.*
      rtl8188eu: Fix a typo in rtw_led.*

Kumari Radha (5):
      staging: lustre: lustre: obdclass: Added missing line after declaration
      staging: media: omap24xx: Remove unnecessary 'out of memory' message
      staging: media: omap4iss: Remove unnecessary 'out of memory' message
      staging: ft1000: ft1000-pcmcia: Replace printks with netdev_<level> and dev_<level>
      staging: vme: devices: Added a paragraph to describe Kconfig symbol

Le Tan (1):
      staging: fwserial: remove multiple blank lines

Luis de Bethencourt (1):
      staging: octeon: Fix checkpatch 80 character limit warnings

Mahati Chamarthy (4):
      Staging: rtl8723au: include: Remove unnecessary macro
      Staging: rtl8188eu: include: Remove unnecessary macro
      Staging: rtl8188eu: include: Remove unused macros
      Staging: rtl8723au: include: Remove unused macros

Malcolm Priestley (124):
      staging: vt6655: mac80211 conversion: add new rx functions
      staging: vt6655: mac80211 conversion: add new key functions
      staging: vt6655: mac8021 conversion: add new tx functions
      staging: vt6655: mac80211 conversion: s_cbFillTxBufHead
      staging: vt6655: dead code remove s_vFillFragParameter.
      staging: vt6655: mac80211 conversion: s_vFillRTSHead convert to using struct ieee80211_hdr
      staging: vt6655: mac80211 conversion: s_uFillDataHead add power saving poll
      staging: vt6655: mac80211 conversion add main mac80211 functions
      staging: vt6655: mac80211 conversion add channel bands
      staging: vt6655: mac80211 conversion replace suspend resume functions
      staging: vt6655: mac80211 conversion: device_print_info remove netdevice.
      staging: vt6655: mac80211 conversion: changes to device_intr
      staging: vt6655: mac80211 conversion: device_tx_srv tx and add report rates
      staging: vt6655: mac80211 conversion: changes to set channel
      staging: vt6655: mac80211 conversion: enable power saving
      staging: vt6655: mac80211 conversion: changes to CARDbSetPhyParameter
      staging: vt6655: mac80211 conversion: card.c use basic_rates
      staging: vt6655: CARDbSetPhyParameter replace s_vSetRSPINF with CARDvSetRSPINF
      staging: vt6655: mac80211 conversion: device_init_registers remove legacy code
      staging: vt6655: mac80211 conversion: device_free_info
      staging: vt6655: switch driver over to mac80211
      staging: vt6655: phy type same as bb type
      staging: vt6655: mac80211 conversion: device_error remove legacy functions
      staging: vt6655: vt6655_probe remove management pointers
      staging: vt6655: mac80211 conversion: PSbIsNextTBTTWakeUp convert to mac80211
      staging: vt6655: MACvSetDefaultKeyEntry replace WLAN_WEP104_KEYLEN
      staging: vt6655: baseband.c replace BIT0 with BIT(0)
      staging: vt6655: s_vGenerateTxParameter remove unused cbMACHdLen
      staging: vt6655: device_init_registers replace spin lock
      staging: vt6655: baseband.c timers replace spin lock
      staging: vt6655: fifo & frag control remove big endian values
      staging: vt6655: vnt_rx_data: uCurrRSSI should have the value of *rssi
      staging: vt6655: don't update bUpdateBBVGA when off channel
      staging: vt6655: reset tsf on dissociation
      staging: vt6655: deadcode remove zone file operations and vntconfiguration.dat
      staging: vt6655: dead code remove zones and channel table elements
      staging: vt6655: dead code remove net device code
      staging: vt6655: dead code remove iwctl.c/h
      staging: vt6655: dead code remove ioctl.c/h
      staging: vt6655: dead code remove legacy hostap.c/h
      staging: vt6655: dead code remove wpactl.c/h
      staging: vt6655: dpc.c/h remove dead functions
      staging: vt6655: remove dead functions in power.c/h
      staging: vt6655: dead code remove wmgr.c
      staging: vt6655: dead code remove wcmd.c
      staging: vt6655: rxtx remove dead functions
      staging: vt6655: s_cbFillTxBufHead remove unused parameters
      staging: vt6655: dead code remove bssdb.c
      staging: vt6655: dead code datarate.c/h
      staging: vt6655: dead code remove IEEE11.h.c/h
      staging: vt6655: card.c/h remove dead functions
      staging: vt6655: deadcode remove wroute.c/h
      staging: vt6655: dead code remove wpa/wpa2
      staging: vt6655: deadcode remove aes_ccmp/rc4/tkip
      staging: vt6655: dead code remove michael.c/h
      staging: vt6655: dead code remove vntwifi.c functions
      staging: vt6655: key.c remove dead functions
      staging: vt6655: mib remove unused functions and structure members
      staging: vt6655L remove tether.c functions
      staging: vt6655: dead code remove tcrc.c/h
      staging: vt6655: dead code remove 80211mgr.c and functions
      staging: vt6655: dead code remove wctl.c/h
      staging: vt6655: channel.c remove dead functions
      staging: vt6655: move all RATE_* macros to device.h
      staging: vt6655: dead code remove vntwifi.h
      staging: vt6655: wmgr.h remove management structures
      staging: vt6655: dead code remove ndis and pmkid strutures.
      staging: vt6655: dead remove wcmd.h and typedefs
      staging: vt6655: dead code remove bssdb.h header
      staging: vt6655: dead code remove tether.h
      staging: vt6655: dead code remove 80211mgr.h
      staging: vt6655: dead code remove iowpa.h
      staging: vt6655: dead code remove iocmd.h
      staging: vt6655: dead code remove country.h
      staging: vt6655: struct vnt_private remove dead members
      staging: vt6655: device.h remove dead strutures and macros
      staging: vt6655: dead code remove 80211hdr.h
      staging: vt6655: remove typedef void *TimerFunction
      staging: vt6655: Move LIFETIME RES 64us macros to rxtx.h
      staging: vt6655: move MAKE_BEACON_RESERVED to device.h
      staging: vt6655: dead code remove wmgr.h
      staging: vt6655: dead code remove header type.h
      staging: vt6655: mac remove dead variable TxRate_iwconfig
      staging: vt6655: mac.c/h remove member type comments
      staging: vt6655: mac.c and mac.h remove dead functions.
      staging: vt6655: remove fragmentation from driver
      staging: vt6655: device_get_options remove unused device parameters
      staging: vt6655: device_set_options remove unused ethernet addresses
      staging: vt6655: device_init_registers remove uConnectionRate
      staging: vt6655: baseband.c/h remove dead functions
      staging: vt6655: device_set_options remove dead variables
      staging: vt6655: device.h remove dead member wstats
      staging: vt6655 baseband.c camel case replace pDevice -> priv
      staging: vt6655: change tx wake queue
      staging: vt6655: baseband.h remove pDevice from struct vnt_private pointer
      staging: vt6655: baseband replace __iomem where caller is priv dereferenced.
      staging: vt6655: baseband/rf s_bAL7230Init change __iomem for baseband functions
      staging: vt6655: BBbWriteEmbedded replace __iomem with vnt_private for callers
      staging: vt6655: BBbReadEmbedded replace __iomem with vnt_private
      staging: vt6655: Fix issue of byPacketType is not set at all.
      staging: vt6655: CARDvUpdateBasicTopRate use basic_rates to find top rate
      staging: vt6655: dead code remove CARDbAddBasicRate
      staging: vt6655: CARDbSetPhyParameter change CARD_PHY_TYPE to bb_type
      staging: vt6655: CARDvSetRSPINF us bb_type for CARD_PHY_TYPE
      staging: vt6655: s_vCalculateOFDMRParameter use bb_type for CARD_PHY_TYPE
      staging: vt6655: dead code remove typedef enum _CARD_PHY_TYPE
      staging: vt6655: CARDbSetPhyParameter remove unused parameters
      staging: vt6655: replace typedef enum _VIA_BB_TYPE with macros
      staging: vt6655: change typedef enum _VIA_PKT_TYPE to macro
      staging: vt6655: always keep abyCurrentNetAddr aligned to 2
      staging: vt6655: card Remove function vUpdateIFS
      staging: vt6655: card.c move __iomem into functions.
      staging: vt6655: rf remove __iomem *dwIoBase from functions
      staging: vt6655: IFRFbWriteEmbedded replace __iomem with vnt_private
      staging: vt6655: rf.c camel calse vnt_private rename pDevice to priv
      staging: vt6655: rf.c: Remove author comments
      staging: vt6655: rf.c Removed unneeded comments
      staging: vt6655: rf.c clean up function comments
      staging: vt6655: remove duplicate MACvSetPacketFilter
      staging: vt6655: srom remove dead functions
      staging: vt6655: remove unused typedef struct tagSSromReg
      staging: vt6655: s_cbFillTxBufHead remove unused parameter *puMACfragNum
      staging: vt6655: s_cbFillTxBufHead remove parameter *pPacket
      staging: vt6655: s_cbFillTxBufHead remove parameter cbFrameBodySize

Marcus Hufvudsson (1):
      staging: comedi: me4000: Fixed code style issue

Mariusz Gorski (17):
      staging: lustre: Use __init and __exit markers for lifecycle functions
      staging: panel: Use designated initializers
      staging: panel: Remove outdated TODO task
      staging: panel: Fix single-open policy race condition
      staging: panel: Reorder initial DEFAULT_* defines
      staging: panel: Reorder DEFAULT_* values redefines
      staging: panel: Reorder module parameter declarations
      staging: panel: Use better names for two defined values
      staging: panel: Set default parport module param value
      staging: panel: Call init function directly
      staging: panel: Remove magic numbers
      staging: panel: Use defined value or checking module params state
      staging: panel: Start making module params read-only
      staging: panel: Make two more module params read-only
      staging: panel: Refactor LCD init code
      staging: panel: Remove more magic number comparison
      staging: panel: Move LCD-related state into struct lcd

Markus Elfring (4):
      staging: android: ion: Deletion of unnecessary checks before two function calls
      staging: ozwpan: Deletion of unnecessary checks before the function call "oz_free_urb_link"
      staging: olpc_dcon: Deletion of a check before backlight_device_unregister()
      lustre: Deletion of unnecessary checks before three function calls

Masanari Iida (2):
      staging: lustre: Remove unnecessary semicolon
      staging: lustre: Remove unnecessary parentheses.

Melike Yurtoglu (12):
      staging: rts5208: Delete braces are not necessary
      staging: iio: Fix missing blank line warning
      staging: iio: Fix missing blank line warning
      staging: rtl8723au: include: fix space prohibited before
      staging: rtl8192u: Missing a blank line after declarations.
      staging: rtl8192u: Add space after enum definition
      staging: vt6655: Fix do not use // c99 comments.
      staging: vt6655: Fixed else after return or break warning.
      staging: vt6655: fix do not use // c99 comments.
      staging: wlan-ng: remove unnecessary 'out of memory' message
      staging: vt6656: remove unnecessary 'out of memory' message
      staging: ozwpan: Fix incorrect type in assignments

Mikael Svantesson (1):
      staging: skein: skein_api.c: removed space before ','

Mike Krinkin (1):
      staging: rtl8712: remove unnecessary else after return

Naveen Krishna Chatradhi (3):
      iio: exyno-adc: use syscon for PMU register access
      Documentation: dt-bindings: update exynos-adc.txt with syscon handle
      ARM: dts: exynos: Add sysreg phandle to ADC node

Nicky Chorley (2):
      Staging: vt6655: Remove C99 comments
      Staging: ft1000: ft1000-pcmcia: Fix whitespace issues

Niklas Svensson (1):
      staging: skein: fixed sparse warnings related to static declarations

Nitin Kuppelur (1):
      Staging: rtl8712:ieee80211 remove unnecessary else

Oleg Drokin (3):
      staging/lustre/ptlrpc: get rid of lustre 1.8 compatible checksums
      staging/lustre: get rid of deprecaed acl mount option code
      staging/lustre/quota: Get rid of compat quota code

Paul McQuade (1):
      staging: rtl8188eu: hal: space required

Philipp Zabel (7):
      imx-drm: ipuv3-plane: allow local alpha in ipu_plane_mode_set()
      imx-drm: ipuv3-plane: move stride setting out of base setup
      imx-drm: ipuv3-plane: enable double buffering
      imx-drm: ipuv3-plane: fix plane updates for active planes
      imx-drm: currently only IPUv3 is supported, make it mandatory
      imx-drm: parallel-display: Fix drm_panel support
      staging: imx-drm: remove old FSF address from license text

Rahul Bedarkar (2):
      staging: bcm: fix sparse warning in module_param
      staging: dgap: remove unused variable 'orig_count'

Rasmus Villemoes (2):
      staging: vt6655: Remove redundant cast
      staging: rtl8712: Remove redundant cast

Rene Kolarik (1):
      drivers: staging: imx-drm driver cleanup

Rickard Strandqvist (4):
      staging: comedi: drivers: comedi_bond.c: Changed from using strncat to strlcat
      staging: lustre: lustre: ptlrpc: sec.c: Replacing strncat with strlcat to avoid overwrite size
      staging: comedi: drivers: comedi_bond.c: Remove unneeded #define
      staging: rtl8188eu: hal: hal_intf.c: Cleaning up functions that are not used anywhere

Roberta Dobrescu (13):
      staging: iio: light: Remove unnecessary line continuations
      staging: dgnc: Remove non-standard APR/RAPR printing macros
      staging: iio: iio_event_monitor: Add support for missing IIO modifiers
      iio: Add ABI documentation for offset and scaled humidity
      iio: Add ABI documentation for RGBC intensity hardware gain factor
      staging: iio: iio_event_monitor: Add support for missing IIO modifiers
      staging: rtl8723au: Do not use comparisons on bool tests
      staging: rtl8723au: Remove uneeded semicolon
      staging: rtl8723au: hal: Remove uneeded return variable
      staging: rtl8723au: os_dep: Remove uneeded return variable
      staging: rtl8723au: core: Remove uneeded return variable
      staging: rtl8723au: Remove duplicated argument to ||
      staging: rtl8723au: Remove useless static functions

Roberto Medina (1):
      Staging: octeon: ethernet-tx: fixed coding style warnings, missing blank lines

Roxana Blaj (5):
      staging: iio: addac: fix line over 80 characters
      staging: iio: addac: annotate Kconfig entries with module name information
      staging: rtl8192u: add spaces around '=', '+=', '<', '||'
      staging: rtl8192u: remove unnecessary line continuations
      staging: rtl8192u: add intermediate variable

Sanchayan Maity (1):
      iio:adc:vf610-adc: Add temperature sensor support

Sanjeev Sharma (2):
      staging:rtl8723au: core: Added missing space reported by checkpatch.
      staging:rtl8723au: core: Fix checkpatch warning

Sarah Khan (9):
      staging: rtl8712: Fixed else not required after return
      staging: octeon-usb: Removed unnessecary else after return
      staging: bcm: Removed else which was not required after return
      staging: bcm: Removed unnecessary else after return
      staging: bcm: Removed unnecessary braces after return
      staging: gdm72xx: Removed unnecesarry out of memory usage
      staging: xgifb: Removed an unnecessary assignment statement
      staging: vt6655: Replace C99 // comments by /* */
      staging: xgifb: Removed a definition which was not used in driver

Sean Cleator (1):
      Staging: slicoss: Fix long line issues in slicoss.c

Serguey Parkhomovsky (1):
      staging: rtl8712: fix unnecessary elses after return/break in rtl8712_efuse.c

Shrikrishna Khare (1):
      Staging: unisys: visorutil: easyproc: fixed a line over 80 characters coding style issue

Somya Anand (4):
      Staging: dgnc: Remove unused sniff code
      Staging: comedi: replace timeval with ktime_t
      Staging: android: Replace timeval with ktime_t in timed_gpio.c
      staging: android: logger: Add a TODO

Soren Brinkmann (2):
      staging: Add Xilinx Clocking Wizard driver
      staging: clocking-wizard: Contain macro argument in parenthesis

Sudip Mukherjee (6):
      staging: rtl8712: remove unused variables
      staging: unisys: unneeded NULL check
      staging: unisys: dereferencing NULL pointer
      staging: rtl8188eu: unneeded return variable
      staging: rtl8188eu: unneeded NULL check
      staging: unisys: remove duplicate header

Surya Seetharaman (8):
      Staging: comedi: ni_mio_common.c: fixed brace coding style issue in two places
      Staging: lustre: Place a space after a semi colon.
      Staging: rts5028: rtsx_transport.c: fixed a brace coding style issue.
      Staging: comedi: nio_tiocmd: fixed a brace coding style issue.
      Staging: ft1000: ft1000_hw.c: Removed some checkpatch errors and warnings.
      Staging: rtl8188eu: rtw_pwrctrl: fixed checkpatch warning.
      Staging: rtl8188eu: rtw_pwrctrl: removed a checkpatch warning.
      Staging: rtl8188eu: rtw_pwrctrl: removed space before semicolon.

Søren Andersen (1):
      iio: adc: mcp320x. Add support for more ADCs

Tapasweni Pathak (64):
      staging: unisys: common-spar: include: channels: Replace "the the " with "the"
      staging: unisys: virtpci: Replace "the the " with "the"
      staging: iio: accel: Update Kconfig description with module name information
      staging: lustre: lustre: ptlrpc: Replace "the the " with "the"
      staging: lustre: lustre: llite: Replace "the the " with "the"
      staging: rtl8712: Replace "the the " with "the"
      staging: rtl8712: Delete explicit comparison with false and NULL
      staging: rtl8188eu: core: Replace "the the " with "the"
      staging: comedi: drivers: Replace "the the " with "the"
      staging: comedi: Remove unecessary function and it's call
      staging: rtl8192u: ieee80211: Indent if statement
      staging: vt6655: Remove unnecessary cast for argument of kfree
      staging: media: ompa4iss: Replace sprintf with snprintf
      staging: media: cxd2009: use usleep_range()
      staging: media: davinci_vpfe: Replace *__iomem with __iomem *
      staging: rtl8723au: core: Replace open coded version with existing hweight function
      staging: lustre: lustre: llite: use DIV_ROUND_UP
      staging: android: ion: Replace "the the " with "the"
      staging: rtl8712: Remove unnecessary cast for argument of kfree
      staging: wlan-ng: replace kmalloc and memset with kzalloc
      staging: comedi: use DIV_ROUND_UP
      staging: comedi: drivers: use DIV_ROUND_UP
      staging: iio: adc: use DIV_ROUND_UP
      staging: octeon-usb: use DIV_ROUND_UP
      staging: comedi: drivers: Use DIV_ROUND_CLOSEST
      staging: rtl8192u: Remove unused code
      staging: vt6655: Remove unused code inside switch case
      staging: rtl8188eu: os_dep: Remove useless cast on kzalloc
      staging: rtl8188eu: os_dep: Replaced kzalloc and memcpy with kmemdup
      staging: ft1000: Remove parentheses from return arguments
      staging: android: Assign bool to true
      staging: media: lirc: Delete unused function tv2int
      staging: emxx_udc: Remove null check before kfree
      staging: rtl8723au: Remove unnecessary else if
      staging: unisys: visorutil: Remove null check before kfree
      staging: lustre: lustre: llite: Use kstrdup
      staging: rtl8192u: Remove unnecessary if
      staging: rtl8192e: Remove unnecessary code
      staging: rtl8188eu: os_dep: Remove null check before kfree
      staging: rtl8188eu: core: Remove redundant memset before memcpy
      staging: unisys: visorchannel: Improved cleanup code
      staging: android: Replace timeval with timespec64
      staging: dgap: Use unsigned for loop index
      staging: cptm1217: Remove useless cast on void pointer
      staging: dgap: Remove useless cast on void pointer
      staging: dgnc: Remove useless cast on void pointer
      staging: gdm72xx: Remove useless cast on void pointer
      staging: iio: adc: Remove useless cast on void pointer
      staging: media: davinci_vpfe: Remove useless cast on void pointer
      staging: media: lirc: Remove useless cast on void pointer
      staging: ozwpan: Remove useless cast on void pointer
      staging: rtl8188eu: core: Remove useless cast on void pointer
      staging: rtl8188eu: hal: Remove useless cast on void pointer
      staging: rtl8188eu: os_dep: Remove useless cast on void pointer
      staging: rtl8723au: core: Remove useless cast on void pointer
      staging: rts5208: Remove useless cast on void pointer
      staging: ft1000: ft1000-pcmcia: Remove useless cast on void pointer
      staging: ft1000: ft1000-usb: Remove useless cast on void pointer
      staging: rtl8188eu: Remove double test
      staging: dgap: Remove useless cast on NULL
      staging: rt18188eu: Remove useless cast on NULL
      staging: rtl8188eu: core: Remove null check before kfree
      staging: rtl8188eu: core: Improve cleanup code
      staging: emxx_udc: use USB API functions rather than constants

Thomas Gummerer (1):
      staging: lustre: fix sparse errors

Thomas Wood (1):
      drivers: staging: lustre: lnet: api-nc.c: Fix Style Warnings

Tina Johnson (8):
      Staging: lustre: Fix checkpatch warning: Missing blank line
      Staging: lustre: Fix checkpatch warning: Unnecessary braces
      Staging: lustre: Fix checkpatch error: Unnecessary comparison
      Staging: lustre: Fix line over 80 characters warning
      Staging: iio: light: Removed unnecessary parentheses
      Staging: ft1000: ft1000-usb: Removed unnecessary parentheses
      Staging: slicoss: Removed unnecessary parentheses
      Staging: rts5208: Removed unnecessary parentheses

Tina Ruchandani (14):
      staging: lustre: Fix checkpatch.pl spacing-related errors
      staging: lustre: llite: Use kcalloc not kzalloc with mult
      Staging: lustre: llite: Remove C99 '//' comments
      Staging: lustre: llite: Use () around long macro
      Staging: lustre: libcfs: Fix switch-case indent
      Staging: lustre: llite: Declare ptr args correctly
      Staging: rtl8723au: core: Dont have { on new line
      Staging: rtl8723au: core: Dont have { on new line
      Staging: rtl8723au: core: Fix switch-case indent
      Staging: rtl8723au: core: Add braces around macro
      Staging: lustre: lnet: Make functions static
      Staging: lustre: llite: Simplify error handling
      Staging: lustre: lnet: lnet: Better cookie gen
      Staging: lustre: lnet: Improve 'incarnation' stamp

Tobenna P. Igwe (1):
      staging:rtl8723au: Fix sparse warning cast to restricted __le16

Tristan Lelong (1):
      Staging: android: ion: fix typos in comments

Vaishali Thakkar (18):
      Staging: iio: adc: Refine delay computation
      Staging: iio: adc: Fix line over 80 characters
      Staging: iio: adc: Fixing line over 80 characters
      Staging: lustre: lnet: Declare ping_srv_workitems static
      Staging: lustre: Replace non-standard spin-lock's macro
      Staging: lustre: Replace non-standard spinlock macro definations
      Staging: lustre: Remove non-standard spinlock macro definitions
      Staging: lustre: lnet: Make functions static
      Staging: lustre: Remove typedef ldlm_ns_hash_def_t
      Staging: vme: devices: Use kasprintf
      Staging: rtl8723au: Use USB API functions
      Staging: rtl8192u: Annotate association types with proper endianness
      Staging: rtl8192e: Revert one previous commit
      Staging: rtl8192e: Change variable type from u16 to __le16
      Staging: lustre: Use put_unaligned_le64
      Staging: rtl8192e: Use put_unaligned_le16
      Staging: rtl8192u: Use put_unaligned_le16
      Staging: rtl8188eu: Use put_unaligned_le32

Veronika Kabatova (16):
      staging: unisys: Remove typedef and rename struct to lowercase
      staging: wlan-ng: add blank lines after declarations
      staging: unisys: Remove typedef and rename enum to lowercase
      staging: unisys: Union ULTRA_COMPONENT_VERSION not used, removed
      staging: vt6655: device.h: Comments fixes
      staging: vt6655: card.c: Comments fixes
      staging: vt6655: dpc.h: Replace C99 // comment by /* */
      staging: vt6655: dpc.c: Comment fixes
      staging: vt6655: desc.h: Comments fixes
      staging: vt6655: bssdb.h: Replace C99 // comments by /* */
      staging: vt6655: channel.c: Comments fixes
      staging: vt6655: IEEE11h.h: Replace C99 // comment by /* */
      staging: vt6655: ioctl.h: Replace C99 // comment by /* */
      staging: vt6655: iowpa.h: Replace C99 // comments by /* */
      staging: vt6655: iocmd.h: Replace C99 // comments by /* */
      staging: vt6655: iwctl.c: Comments fixes

Vincenzo Scotti (1):
      staging: lustre: fix sparse warnings: static function declaration

Vlad Dogaru (3):
      iio: add ABI documentation for scaled pressure
      iio: add bmp280 pressure and temperature driver
      bmp280: use correct routine for division

Vladimir A. Nazarenko (4):
      staging: vt6655: delete non-standard ioctl 0xFF
      staging: vt6655: remove global variable wpa_Result
      staging: vt6655: remove useless #if 1
      staging: vt6655: delete SndEvt_ToAPI code

WANG Chao (1):
      staging, unisys: remove leftover function kmalloc_kernel()

Yeliz Taneroglu (17):
      staging: speakup: Fixed else after return or break warning
      staging: vt6655: Fixed else after return or break warning
      staging: vt6655: Fixed else after return or break warning
      staging: rtl8723au: core: rtw_cmd: Add blank line after declarations
      staging: rtl8723au: core: rtw_ieee80211: Add blank line after declarations
      staging: rtl8723au: core: rtw_led: Add blank line after declarations
      staging: rtl8723au: core: rtw_mlme: Add blank line after declarations
      staging: rtl8723au: core: rtw_mlme_ext: Add blank line after declarations
      staging: rtl8723au: core: rtw_pwrctrl: Add blank line after declarations
      staging: rtl8723au: core: rtw_wlan_util: Add blank line after declarations
      staging: rtl8723au: core: rtw_recv: Add blank line after declarations
      staging: rtl8723au: core: rtw_xmit: Add blank line after declarations
      staging: rtl8723au: core: rtw_mlme: fix void function return statements
      staging: rtl8723au: core: rtw_pwrctrl: Fix void function return statements style warning.
      staging: rtl8723au: core: rtw_wlan_util: Fix void function return statements style warning.
      staging: rtl8723au: core: rtw_security: Fix void function return statements style warning.
      staging: rtl8723au: core: rtw_ap: Fix void function return statements style warning.

anuvazhayil (4):
      Staging: rtl8723au: rtw_cmd: Fix space prohibited between function name and open parenthesis
      Staging: lustre: libcfs_cpu: Fix ERROR: do not initialise globals to 0 or NULL
      Staging: media: dm365_isif: Add blank line after variable declarations
      Staging: rtl8723au: rtw_cmd: Replace foo*bar to foo *bar

tssurya (1):
      Staging: comedi: ni_tiocmd: fixed a brace coding style issue

 Documentation/ABI/testing/sysfs-bus-iio            |    23 +
 .../devicetree/bindings/arm/samsung/exynos-adc.txt |    11 +-
 .../devicetree/bindings/iio/adc/qcom,spmi-iadc.txt |    46 +
 .../bindings/iio/adc/rockchip-saradc.txt           |     2 +-
 MAINTAINERS                                        |     7 -
 arch/arm/boot/dts/exynos3250.dtsi                  |     3 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |     3 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |     3 +-
 arch/arm/boot/dts/exynos5420.dtsi                  |     3 +-
 drivers/Kconfig                                    |     2 +
 drivers/Makefile                                   |     1 +
 drivers/android/Kconfig                            |    37 +
 drivers/android/Makefile                           |     3 +
 drivers/{staging => }/android/binder.c             |     6 +-
 drivers/{staging => }/android/binder_trace.h       |     0
 drivers/iio/accel/st_accel.h                       |     3 +-
 drivers/iio/accel/st_accel_core.c                  |    22 +-
 drivers/iio/accel/st_accel_i2c.c                   |     3 +-
 drivers/iio/accel/st_accel_spi.c                   |     3 +-
 drivers/iio/adc/Kconfig                            |    14 +
 drivers/iio/adc/Makefile                           |     1 +
 drivers/iio/adc/exynos_adc.c                       |    62 +-
 drivers/iio/adc/mcp320x.c                          |   222 +-
 drivers/iio/adc/qcom-spmi-iadc.c                   |   595 ++
 drivers/iio/adc/rockchip_saradc.c                  |    64 +-
 drivers/iio/adc/vf610_adc.c                        |    45 +-
 drivers/iio/common/st_sensors/st_sensors_core.c    |   126 +-
 drivers/iio/common/st_sensors/st_sensors_i2c.c     |     1 +
 drivers/iio/common/st_sensors/st_sensors_spi.c     |     1 +
 drivers/iio/gyro/st_gyro.h                         |     3 +-
 drivers/iio/gyro/st_gyro_core.c                    |    19 +-
 drivers/iio/gyro/st_gyro_i2c.c                     |     4 +-
 drivers/iio/gyro/st_gyro_spi.c                     |     4 +-
 drivers/iio/humidity/Kconfig                       |    10 +
 drivers/iio/humidity/Makefile                      |     1 +
 drivers/iio/humidity/si7020.c                      |   161 +
 drivers/iio/inkern.c                               |    33 +-
 drivers/iio/magnetometer/st_magn.h                 |     3 +-
 drivers/iio/magnetometer/st_magn_core.c            |    18 +-
 drivers/iio/magnetometer/st_magn_i2c.c             |     3 +-
 drivers/iio/magnetometer/st_magn_spi.c             |     3 +-
 drivers/iio/pressure/Kconfig                       |    11 +
 drivers/iio/pressure/Makefile                      |     1 +
 drivers/iio/pressure/bmp280.c                      |   455 +
 drivers/iio/pressure/st_pressure.h                 |     3 +-
 drivers/iio/pressure/st_pressure_buffer.c          |    12 +-
 drivers/iio/pressure/st_pressure_core.c            |    49 +-
 drivers/iio/pressure/st_pressure_i2c.c             |    11 +-
 drivers/iio/pressure/st_pressure_spi.c             |    11 +-
 drivers/iio/proximity/as3935.c                     |    16 +-
 drivers/staging/Kconfig                            |     4 +-
 drivers/staging/Makefile                           |     2 +-
 drivers/staging/android/Kconfig                    |    30 -
 drivers/staging/android/Makefile                   |     1 -
 drivers/staging/android/TODO                       |     7 +
 drivers/staging/android/binder.h                   |    30 -
 drivers/staging/android/ion/ion.c                  |    10 +-
 drivers/staging/android/ion/ion.h                  |     2 +-
 drivers/staging/android/ion/ion_dummy_driver.c     |     6 +-
 drivers/staging/android/ion/ion_page_pool.c        |     2 +-
 drivers/staging/android/ion/ion_priv.h             |     4 +-
 drivers/staging/android/ion/tegra/tegra_ion.c      |     6 +-
 drivers/staging/android/sync_debug.c               |     5 +-
 drivers/staging/android/timed_gpio.c               |     7 +-
 drivers/staging/bcm/Adapter.h                      |   474 -
 drivers/staging/bcm/Bcmchar.c                      |  2652 -----
 drivers/staging/bcm/Bcmnet.c                       |   240 -
 drivers/staging/bcm/CmHost.c                       |  2254 ----
 drivers/staging/bcm/CmHost.h                       |    62 -
 drivers/staging/bcm/DDRInit.c                      |  1355 ---
 drivers/staging/bcm/DDRInit.h                      |     9 -
 drivers/staging/bcm/Debug.h                        |   242 -
 drivers/staging/bcm/HandleControlPacket.c          |   241 -
 drivers/staging/bcm/HostMIBSInterface.h            |   192 -
 drivers/staging/bcm/IPv6Protocol.c                 |   476 -
 drivers/staging/bcm/IPv6ProtocolHdr.h              |    85 -
 drivers/staging/bcm/InterfaceAdapter.h             |    79 -
 drivers/staging/bcm/InterfaceDld.c                 |   317 -
 drivers/staging/bcm/InterfaceIdleMode.c            |   274 -
 drivers/staging/bcm/InterfaceIdleMode.h            |    15 -
 drivers/staging/bcm/InterfaceInit.c                |   729 --
 drivers/staging/bcm/InterfaceInit.h                |    26 -
 drivers/staging/bcm/InterfaceIsr.c                 |   190 -
 drivers/staging/bcm/InterfaceIsr.h                 |    15 -
 drivers/staging/bcm/InterfaceMacros.h              |    18 -
 drivers/staging/bcm/InterfaceMisc.c                |   247 -
 drivers/staging/bcm/InterfaceMisc.h                |    42 -
 drivers/staging/bcm/InterfaceRx.c                  |   289 -
 drivers/staging/bcm/InterfaceRx.h                  |     7 -
 drivers/staging/bcm/InterfaceTx.c                  |   213 -
 drivers/staging/bcm/InterfaceTx.h                  |     7 -
 drivers/staging/bcm/Ioctl.h                        |   226 -
 drivers/staging/bcm/Kconfig                        |     6 -
 drivers/staging/bcm/LeakyBucket.c                  |   364 -
 drivers/staging/bcm/Macros.h                       |   352 -
 drivers/staging/bcm/Makefile                       |    12 -
 drivers/staging/bcm/Misc.c                         |  1587 ---
 drivers/staging/bcm/PHSDefines.h                   |    94 -
 drivers/staging/bcm/PHSModule.c                    |  1703 ---
 drivers/staging/bcm/PHSModule.h                    |    59 -
 drivers/staging/bcm/Protocol.h                     |   128 -
 drivers/staging/bcm/Prototypes.h                   |   217 -
 drivers/staging/bcm/Qos.c                          |  1200 ---
 drivers/staging/bcm/Queue.h                        |    29 -
 drivers/staging/bcm/TODO                           |    26 -
 drivers/staging/bcm/Transmit.c                     |   271 -
 drivers/staging/bcm/Typedefs.h                     |    47 -
 drivers/staging/bcm/cntrl_SignalingInterface.h     |   311 -
 drivers/staging/bcm/headers.h                      |    78 -
 drivers/staging/bcm/hostmibs.c                     |   164 -
 drivers/staging/bcm/led_control.c                  |   952 --
 drivers/staging/bcm/led_control.h                  |    84 -
 drivers/staging/bcm/nvm.c                          |  4661 --------
 drivers/staging/bcm/nvm.h                          |   286 -
 drivers/staging/bcm/sort.c                         |    52 -
 drivers/staging/bcm/target_params.h                |    57 -
 drivers/staging/bcm/vendorspecificextn.c           |   145 -
 drivers/staging/bcm/vendorspecificextn.h           |    18 -
 drivers/staging/clocking-wizard/Kconfig            |     9 +
 drivers/staging/clocking-wizard/Makefile           |     1 +
 drivers/staging/clocking-wizard/TODO               |    12 +
 .../clocking-wizard/clk-xlnx-clock-wizard.c        |   341 +
 drivers/staging/clocking-wizard/dt-binding.txt     |    30 +
 drivers/staging/comedi/Kconfig                     |    28 +-
 drivers/staging/comedi/Makefile                    |     7 +-
 drivers/staging/comedi/comedi.h                    |    13 +-
 drivers/staging/comedi/comedi_buf.c                |   157 +-
 drivers/staging/comedi/comedi_compat32.c           |     2 +
 drivers/staging/comedi/comedi_fops.c               |   279 +-
 drivers/staging/comedi/comedi_pci.c                |    16 +
 drivers/staging/comedi/comedi_pcmcia.c             |    16 +
 drivers/staging/comedi/comedi_usb.c                |    16 +
 drivers/staging/comedi/comedidev.h                 |   139 +-
 drivers/staging/comedi/drivers.c                   |   102 +-
 drivers/staging/comedi/drivers/Makefile            |     1 -
 .../staging/comedi/drivers/addi-data/addi_common.c |   274 -
 .../staging/comedi/drivers/addi-data/addi_common.h |   144 -
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |   360 -
 .../comedi/drivers/addi-data/hwdrv_apci035.c       |   480 -
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    28 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |   381 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |  2050 ----
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |  3003 ------
 drivers/staging/comedi/drivers/addi_apci_035.c     |    77 -
 drivers/staging/comedi/drivers/addi_apci_1032.c    |     5 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c    |   117 +-
 drivers/staging/comedi/drivers/addi_apci_1516.c    |     2 +-
 drivers/staging/comedi/drivers/addi_apci_1564.c    |   268 +-
 drivers/staging/comedi/drivers/addi_apci_16xx.c    |     2 +-
 drivers/staging/comedi/drivers/addi_apci_2032.c    |    32 +-
 drivers/staging/comedi/drivers/addi_apci_2200.c    |     2 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c    |  1153 +-
 drivers/staging/comedi/drivers/addi_apci_3200.c    |   125 -
 drivers/staging/comedi/drivers/addi_apci_3501.c    |     7 +-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |    11 +-
 drivers/staging/comedi/drivers/addi_tcw.h          |    56 +
 drivers/staging/comedi/drivers/addi_watchdog.c     |    32 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |     1 -
 drivers/staging/comedi/drivers/adl_pci9111.c       |    40 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |   202 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |    76 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |   338 +-
 drivers/staging/comedi/drivers/adv_pci1724.c       |   471 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |     8 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |     1 -
 drivers/staging/comedi/drivers/amcc_s5933.h        |     2 +
 .../staging/comedi/drivers/amplc_dio200_common.c   |    34 +-
 .../staging/comedi/drivers/amplc_pc236_common.c    |     5 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |     2 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |    53 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |   193 +-
 drivers/staging/comedi/drivers/amplc_pci263.c      |     2 +-
 drivers/staging/comedi/drivers/c6xdigio.c          |     2 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |     1 -
 drivers/staging/comedi/drivers/cb_pcidas.c         |   283 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |   295 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |    83 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |     9 +-
 drivers/staging/comedi/drivers/comedi_fc.h         |    43 -
 drivers/staging/comedi/drivers/comedi_parport.c    |     5 +-
 drivers/staging/comedi/drivers/comedi_test.c       |    63 +-
 drivers/staging/comedi/drivers/dac02.c             |     1 -
 drivers/staging/comedi/drivers/daqboard2000.c      |     1 -
 drivers/staging/comedi/drivers/das08.c             |     3 +-
 drivers/staging/comedi/drivers/das16.c             |    23 +-
 drivers/staging/comedi/drivers/das16m1.c           |     7 +-
 drivers/staging/comedi/drivers/das1800.c           |    62 +-
 drivers/staging/comedi/drivers/das6402.c           |   202 +-
 drivers/staging/comedi/drivers/das800.c            |    38 +-
 drivers/staging/comedi/drivers/dmm32at.c           |   702 +-
 drivers/staging/comedi/drivers/dt2801.c            |     1 -
 drivers/staging/comedi/drivers/dt2811.c            |     1 -
 drivers/staging/comedi/drivers/dt2814.c            |     2 +-
 drivers/staging/comedi/drivers/dt282x.c            |    62 +-
 drivers/staging/comedi/drivers/dt3000.c            |     9 +-
 drivers/staging/comedi/drivers/dt9812.c            |     4 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |     4 +-
 drivers/staging/comedi/drivers/fl512.c             |     1 -
 drivers/staging/comedi/drivers/gsc_hpdi.c          |     8 +-
 drivers/staging/comedi/drivers/icp_multi.c         |     9 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |     1 -
 drivers/staging/comedi/drivers/me4000.c            |   120 +-
 drivers/staging/comedi/drivers/me_daq.c            |     5 +-
 drivers/staging/comedi/drivers/mf6x4.c             |     1 -
 drivers/staging/comedi/drivers/mite.c              |     9 +-
 drivers/staging/comedi/drivers/multiq3.c           |     1 -
 drivers/staging/comedi/drivers/ni_6527.c           |     8 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |     9 +-
 drivers/staging/comedi/drivers/ni_660x.c           |     2 +-
 drivers/staging/comedi/drivers/ni_670x.c           |     1 -
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    21 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |    56 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |     8 +-
 drivers/staging/comedi/drivers/ni_labpc.h          |     6 -
 drivers/staging/comedi/drivers/ni_labpc_common.c   |   152 +-
 drivers/staging/comedi/drivers/ni_labpc_isadma.c   |     7 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |   166 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |    14 +-
 drivers/staging/comedi/drivers/ni_stc.h            |    16 +-
 drivers/staging/comedi/drivers/ni_tiocmd.c         |     6 +-
 drivers/staging/comedi/drivers/ni_usb6501.c        |     2 +-
 drivers/staging/comedi/drivers/pcl711.c            |    25 +-
 drivers/staging/comedi/drivers/pcl726.c            |     6 +-
 drivers/staging/comedi/drivers/pcl812.c            |    40 +-
 drivers/staging/comedi/drivers/pcl816.c            |    26 +-
 drivers/staging/comedi/drivers/pcl818.c            |    34 +-
 drivers/staging/comedi/drivers/pcmmio.c            |    32 +-
 drivers/staging/comedi/drivers/pcmuio.c            |    34 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |    38 +-
 drivers/staging/comedi/drivers/rtd520.c            |    77 +-
 drivers/staging/comedi/drivers/rti800.c            |     1 -
 drivers/staging/comedi/drivers/rti802.c            |     1 -
 drivers/staging/comedi/drivers/s526.c              |     1 -
 drivers/staging/comedi/drivers/s626.c              |    38 +-
 drivers/staging/comedi/drivers/serial2002.c        |     4 +-
 drivers/staging/comedi/drivers/usbdux.c            |   400 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |   145 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |   350 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |     8 +-
 drivers/staging/comedi/range.c                     |    36 +-
 drivers/staging/cptm1217/clearpad_tm1217.c         |     2 +-
 drivers/staging/dgap/dgap.c                        | 10566 +++++++++----------
 drivers/staging/dgap/dgap.h                        |     3 -
 drivers/staging/dgnc/dgnc_cls.c                    |    30 +-
 drivers/staging/dgnc/dgnc_driver.c                 |    33 +-
 drivers/staging/dgnc/dgnc_driver.h                 |    61 +-
 drivers/staging/dgnc/dgnc_kcompat.h                |    18 -
 drivers/staging/dgnc/dgnc_neo.c                    |    30 +-
 drivers/staging/dgnc/dgnc_sysfs.c                  |    37 -
 drivers/staging/dgnc/dgnc_tty.c                    |   146 +-
 drivers/staging/dgnc/dgnc_tty.h                    |     2 -
 drivers/staging/emxx_udc/emxx_udc.c                |     7 +-
 drivers/staging/ft1000/ft1000-pcmcia/boot.h        |    34 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |    30 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c   |    50 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |   212 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |   935 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   |  1204 ++-
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   400 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   436 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h   |    60 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    97 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |     4 +-
 drivers/staging/fwserial/fwserial.c                |     3 -
 drivers/staging/gdm724x/gdm_lte.c                  |    10 +-
 drivers/staging/gdm724x/gdm_mux.h                  |     8 +-
 drivers/staging/gdm72xx/gdm_wimax.c                |     6 +-
 drivers/staging/gs_fpgaboot/gs_fpgaboot.c          |    57 +-
 drivers/staging/iio/Documentation/generic_buffer.c |    81 +-
 .../staging/iio/Documentation/iio_event_monitor.c  |    32 +-
 drivers/staging/iio/Documentation/iio_utils.h      |     7 +
 drivers/staging/iio/Documentation/lsiio.c          |    20 +-
 drivers/staging/iio/accel/Kconfig                  |    39 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |     1 +
 drivers/staging/iio/adc/ad7192.c                   |     3 +-
 drivers/staging/iio/adc/ad7280a.c                  |     2 +-
 drivers/staging/iio/adc/ad7606_spi.c               |     2 +-
 drivers/staging/iio/adc/ad7816.c                   |     3 +-
 drivers/staging/iio/adc/lpc32xx_adc.c              |     2 +-
 drivers/staging/iio/adc/mxs-lradc.c                |     6 +-
 drivers/staging/iio/adc/spear_adc.c                |     4 +-
 drivers/staging/iio/addac/Kconfig                  |     9 +
 drivers/staging/iio/addac/adt7316.h                |     3 +-
 drivers/staging/iio/gyro/Kconfig                   |     5 +-
 drivers/staging/iio/light/tsl2x7x_core.c           |    17 +-
 drivers/staging/iio/meter/Kconfig                  |    15 +
 drivers/staging/iio/trigger/Kconfig                |     5 +-
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |     3 +-
 drivers/staging/imx-drm/Kconfig                    |     7 +-
 drivers/staging/imx-drm/imx-drm-core.c             |     5 +-
 drivers/staging/imx-drm/imx-ldb.c                  |     5 -
 drivers/staging/imx-drm/imx-tve.c                  |     8 +-
 drivers/staging/imx-drm/ipuv3-crtc.c               |     5 -
 drivers/staging/imx-drm/ipuv3-plane.c              |    43 +-
 drivers/staging/imx-drm/ipuv3-plane.h              |     2 +
 drivers/staging/imx-drm/parallel-display.c         |    13 +-
 .../lustre/include/linux/libcfs/libcfs_debug.h     |    12 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    17 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |    34 +-
 .../lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c  |     3 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    60 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |    89 +-
 .../lustre/lnet/klnds/socklnd/socklnd_proto.c      |    15 +-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |    18 +-
 drivers/staging/lustre/lnet/lnet/lib-md.c          |     2 +-
 drivers/staging/lustre/lnet/lnet/lib-move.c        |    98 +-
 drivers/staging/lustre/lnet/lnet/lib-ptl.c         |     3 +-
 drivers/staging/lustre/lnet/lnet/lo.c              |     8 +-
 drivers/staging/lustre/lnet/lnet/module.c          |    10 +-
 drivers/staging/lustre/lnet/lnet/router.c          |    52 +-
 drivers/staging/lustre/lnet/lnet/router_proc.c     |    25 +-
 drivers/staging/lustre/lnet/selftest/brw_test.c    |     8 +-
 drivers/staging/lustre/lnet/selftest/conctl.c      |    34 +-
 drivers/staging/lustre/lnet/selftest/conrpc.c      |    20 +-
 drivers/staging/lustre/lnet/selftest/console.c     |     6 +-
 drivers/staging/lustre/lnet/selftest/framework.c   |    75 +-
 drivers/staging/lustre/lnet/selftest/module.c      |    19 +-
 drivers/staging/lustre/lnet/selftest/ping_test.c   |     2 +-
 drivers/staging/lustre/lnet/selftest/rpc.c         |    63 +-
 drivers/staging/lustre/lnet/selftest/timer.c       |     8 +-
 drivers/staging/lustre/lustre/Kconfig              |     2 +-
 drivers/staging/lustre/lustre/include/dt_object.h  |     4 +-
 .../lustre/lustre/include/linux/lustre_compat25.h  |     8 +-
 drivers/staging/lustre/lustre/include/linux/obd.h  |     3 +-
 .../staging/lustre/lustre/include/lprocfs_status.h |     8 +-
 drivers/staging/lustre/lustre/include/lu_object.h  |     4 +-
 .../staging/lustre/lustre/include/lustre_capa.h    |     2 +-
 .../staging/lustre/lustre/include/lustre_disk.h    |     3 +-
 drivers/staging/lustre/lustre/include/lustre_dlm.h |     2 +-
 .../staging/lustre/lustre/include/lustre_eacl.h    |     2 +-
 drivers/staging/lustre/lustre/include/lustre_lib.h |     2 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |     7 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |     2 +-
 drivers/staging/lustre/lustre/ldlm/interval_tree.c |     5 +
 drivers/staging/lustre/lustre/ldlm/ldlm_extent.c   |     4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |    10 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_internal.h |     8 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      |     7 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |   219 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    28 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |    63 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |    78 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |    45 +-
 drivers/staging/lustre/lustre/libcfs/debug.c       |    18 +-
 drivers/staging/lustre/lustre/libcfs/fail.c        |    24 +-
 drivers/staging/lustre/lustre/libcfs/hash.c        |    28 +-
 drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c  |     2 +-
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c |    32 +-
 .../lustre/lustre/libcfs/linux/linux-debug.c       |     6 +-
 .../lustre/lustre/libcfs/linux/linux-proc.c        |     2 +-
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |     3 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |    38 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |     6 +-
 drivers/staging/lustre/lustre/llite/dir.c          |    96 +-
 drivers/staging/lustre/lustre/llite/file.c         |    25 +-
 drivers/staging/lustre/lustre/llite/llite_capa.c   |     3 +-
 drivers/staging/lustre/lustre/llite/llite_close.c  |    16 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |    30 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   114 +-
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |     9 +-
 drivers/staging/lustre/lustre/llite/llite_rmtacl.c |     7 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |     8 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |    89 +-
 drivers/staging/lustre/lustre/llite/namei.c        |    18 +-
 drivers/staging/lustre/lustre/llite/remote_perm.c  |     5 +-
 drivers/staging/lustre/lustre/llite/rw.c           |    22 +-
 drivers/staging/lustre/lustre/llite/rw26.c         |     6 +-
 drivers/staging/lustre/lustre/llite/statahead.c    |    16 +-
 drivers/staging/lustre/lustre/llite/super25.c      |     2 +-
 drivers/staging/lustre/lustre/llite/symlink.c      |     4 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |     7 +-
 drivers/staging/lustre/lustre/llite/vvp_page.c     |     3 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |     6 +-
 drivers/staging/lustre/lustre/llite/xattr_cache.c  |     5 +-
 drivers/staging/lustre/lustre/lmv/lmv_fld.c        |     3 +-
 drivers/staging/lustre/lustre/lmv/lmv_intent.c     |     8 +-
 drivers/staging/lustre/lustre/lmv/lmv_internal.h   |     4 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |    41 +-
 drivers/staging/lustre/lustre/lov/lov_ea.c         |     5 +-
 drivers/staging/lustre/lustre/lov/lov_obd.c        |    35 +-
 drivers/staging/lustre/lustre/lov/lov_pack.c       |     3 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |     4 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |     4 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |    12 +-
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |    14 +-
 drivers/staging/lustre/lustre/obdclass/acl.c       |     8 +-
 drivers/staging/lustre/lustre/obdclass/capa.c      |    14 +-
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |     3 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |     3 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |     6 +-
 drivers/staging/lustre/lustre/obdclass/debug.c     |    12 +-
 drivers/staging/lustre/lustre/obdclass/dt_object.c |    15 +-
 drivers/staging/lustre/lustre/obdclass/genops.c    |    28 +-
 .../lustre/lustre/obdclass/linux/linux-module.c    |     4 +-
 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |     5 +-
 drivers/staging/lustre/lustre/obdclass/llog.c      |     4 +-
 drivers/staging/lustre/lustre/obdclass/llog_cat.c  |    10 +-
 drivers/staging/lustre/lustre/obdclass/llog_obd.c  |     2 +-
 drivers/staging/lustre/lustre/obdclass/llog_swab.c |     3 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |    14 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |     3 +-
 .../staging/lustre/lustre/obdclass/obd_config.c    |    11 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |    38 +-
 .../staging/lustre/lustre/obdecho/echo_client.c    |   140 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c      |   176 +-
 .../staging/lustre/lustre/osc/osc_cl_internal.h    |     2 +-
 drivers/staging/lustre/lustre/osc/osc_lock.c       |     6 +-
 drivers/staging/lustre/lustre/osc/osc_object.c     |     3 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |    11 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |    51 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      |    48 +-
 drivers/staging/lustre/lustre/ptlrpc/events.c      |     7 +-
 drivers/staging/lustre/lustre/ptlrpc/import.c      |   115 +-
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |    37 +-
 drivers/staging/lustre/lustre/ptlrpc/llog_client.c |     3 +-
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |    18 +-
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |     7 +-
 drivers/staging/lustre/lustre/ptlrpc/nrs.c         |    33 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    59 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |    22 +-
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |     7 +-
 drivers/staging/lustre/lustre/ptlrpc/recover.c     |     7 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |    27 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |     3 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_null.c    |    18 -
 drivers/staging/lustre/lustre/ptlrpc/sec_plain.c   |     4 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |    90 +-
 drivers/staging/media/cxd2099/cxd2099.c            |     2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.h   |     4 +-
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |    62 +-
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.h    |    58 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |     4 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.h |     2 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |    11 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.h    |     6 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |     8 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.h |     2 +-
 drivers/staging/media/lirc/lirc_bt829.c            |    14 +-
 drivers/staging/media/lirc/lirc_igorplugusb.c      |     2 +-
 drivers/staging/media/lirc/lirc_imon.c             |    31 +-
 drivers/staging/media/lirc/lirc_sasem.c            |    10 +-
 drivers/staging/media/lirc/lirc_sir.c              |    18 +-
 drivers/staging/media/lirc/lirc_zilog.c            |   137 +-
 drivers/staging/media/omap24xx/omap24xxcam.c       |     6 +-
 drivers/staging/media/omap24xx/tcm825x.c           |     2 +-
 drivers/staging/media/omap4iss/iss.c               |     4 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |     2 +-
 drivers/staging/octeon-usb/octeon-hcd.c            |    69 +-
 drivers/staging/octeon/ethernet-rx.c               |   156 +-
 drivers/staging/octeon/ethernet-tx.c               |    11 +
 drivers/staging/octeon/ethernet.c                  |     8 +-
 drivers/staging/octeon/octeon-ethernet.h           |     1 -
 drivers/staging/olpc_dcon/olpc_dcon.c              |     3 +-
 drivers/staging/ozwpan/ozhcd.c                     |    22 +-
 drivers/staging/ozwpan/ozusbsvc1.c                 |    12 +-
 drivers/staging/panel/TODO                         |     1 -
 drivers/staging/panel/panel.c                      |   807 +-
 drivers/staging/rtl8188eu/core/rtw_ap.c            |    17 +-
 drivers/staging/rtl8188eu/core/rtw_cmd.c           |     9 +-
 drivers/staging/rtl8188eu/core/rtw_debug.c         |    14 +-
 drivers/staging/rtl8188eu/core/rtw_efuse.c         |    47 +-
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c     |    16 +-
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c     |     1 -
 drivers/staging/rtl8188eu/core/rtw_led.c           |    12 +-
 drivers/staging/rtl8188eu/core/rtw_mlme.c          |    10 +-
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c      |    34 +-
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c       |     7 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c          |    20 +-
 drivers/staging/rtl8188eu/core/rtw_security.c      |    24 +-
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c       |     2 +-
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c     |     1 -
 drivers/staging/rtl8188eu/core/rtw_xmit.c          |    14 +-
 drivers/staging/rtl8188eu/hal/bb_cfg.c             |     4 +-
 drivers/staging/rtl8188eu/hal/fw.c                 |     8 +-
 drivers/staging/rtl8188eu/hal/hal_intf.c           |    16 -
 drivers/staging/rtl8188eu/hal/mac_cfg.c            |     2 +-
 drivers/staging/rtl8188eu/hal/odm.c                |     8 +-
 drivers/staging/rtl8188eu/hal/odm_HWConfig.c       |     2 +-
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c       |     2 +-
 drivers/staging/rtl8188eu/hal/phy.c                |     2 +-
 drivers/staging/rtl8188eu/hal/rf.c                 |     2 +-
 drivers/staging/rtl8188eu/hal/rf_cfg.c             |     4 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c       |     6 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c        |    30 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |     3 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_xmit.c      |     2 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c     |     2 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |     4 +-
 drivers/staging/rtl8188eu/include/hal_intf.h       |     3 -
 drivers/staging/rtl8188eu/include/ieee80211_ext.h  |    20 +-
 drivers/staging/rtl8188eu/include/odm_debug.h      |    31 +-
 drivers/staging/rtl8188eu/include/osdep_service.h  |     4 +-
 drivers/staging/rtl8188eu/include/rtw_debug.h      |     2 +-
 drivers/staging/rtl8188eu/include/rtw_led.h        |     8 +-
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h   |    26 +-
 drivers/staging/rtl8188eu/include/wifi.h           |    36 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |    31 +-
 drivers/staging/rtl8188eu/os_dep/os_intfs.c        |    11 +-
 drivers/staging/rtl8188eu/os_dep/osdep_service.c   |     2 +-
 drivers/staging/rtl8188eu/os_dep/rtw_android.c     |    41 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |    35 +-
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c   |     8 +-
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c      |    10 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c     |     4 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c         |     8 -
 drivers/staging/rtl8192e/rtl819x_BAProc.c          |    24 +-
 drivers/staging/rtl8192e/rtllib.h                  |     6 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |     6 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |    12 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    22 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    26 +-
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c      |     2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |     3 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c  |     2 +-
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    |    20 +-
 .../staging/rtl8192u/ieee80211/rtl819x_HTProc.c    |    11 +-
 drivers/staging/rtl8192u/r8192U_core.c             |    22 +-
 drivers/staging/rtl8192u/r8192U_dm.c               |    91 -
 drivers/staging/rtl8192u/r8192U_wx.c               |     6 -
 drivers/staging/rtl8192u/r819xU_firmware.c         |    20 +-
 drivers/staging/rtl8192u/r819xU_firmware.h         |     8 +-
 drivers/staging/rtl8192u/r819xU_phy.c              |     1 +
 drivers/staging/rtl8712/hal_init.c                 |    11 +-
 drivers/staging/rtl8712/ieee80211.c                |    17 +-
 drivers/staging/rtl8712/osdep_service.h            |     8 +-
 drivers/staging/rtl8712/recv_linux.c               |     2 +-
 drivers/staging/rtl8712/rtl8712_cmd.c              |    13 +-
 drivers/staging/rtl8712/rtl8712_efuse.c            |    43 +-
 drivers/staging/rtl8712/rtl8712_recv.c             |    24 +-
 drivers/staging/rtl8712/rtl871x_cmd.c              |    58 +-
 drivers/staging/rtl8712/rtl871x_io.c               |     6 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |    23 +-
 drivers/staging/rtl8712/rtl871x_ioctl_set.c        |    24 +-
 drivers/staging/rtl8712/rtl871x_mlme.c             |    27 +-
 drivers/staging/rtl8712/rtl871x_mp.c               |     4 +-
 drivers/staging/rtl8712/rtl871x_mp_ioctl.c         |     3 -
 drivers/staging/rtl8712/rtl871x_pwrctrl.c          |     4 +-
 drivers/staging/rtl8712/rtl871x_recv.c             |    19 +-
 drivers/staging/rtl8712/rtl871x_recv.h             |     3 -
 drivers/staging/rtl8712/rtl871x_security.c         |    10 +-
 drivers/staging/rtl8712/rtl871x_sta_mgt.c          |    11 +-
 drivers/staging/rtl8712/rtl871x_xmit.c             |    15 +-
 drivers/staging/rtl8712/usb_intf.c                 |    16 +-
 drivers/staging/rtl8712/usb_ops_linux.c            |     9 +-
 drivers/staging/rtl8712/xmit_linux.c               |     4 +-
 drivers/staging/rtl8723au/Makefile                 |     3 -
 drivers/staging/rtl8723au/core/rtw_ap.c            |   159 +-
 drivers/staging/rtl8723au/core/rtw_cmd.c           |   181 +-
 drivers/staging/rtl8723au/core/rtw_efuse.c         |    23 +-
 drivers/staging/rtl8723au/core/rtw_ieee80211.c     |     4 +-
 drivers/staging/rtl8723au/core/rtw_led.c           |  1893 ----
 drivers/staging/rtl8723au/core/rtw_mlme.c          |    76 +-
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c      |    67 +-
 drivers/staging/rtl8723au/core/rtw_pwrctrl.c       |     8 +-
 drivers/staging/rtl8723au/core/rtw_recv.c          |   165 +-
 drivers/staging/rtl8723au/core/rtw_security.c      |    98 +-
 drivers/staging/rtl8723au/core/rtw_sreset.c        |     2 +-
 drivers/staging/rtl8723au/core/rtw_wlan_util.c     |    15 +-
 drivers/staging/rtl8723au/core/rtw_xmit.c          |    94 +-
 .../staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c    |     2 +-
 drivers/staging/rtl8723au/hal/hal_com.c            |     4 +-
 drivers/staging/rtl8723au/hal/odm_HWConfig.c       |    13 +-
 .../staging/rtl8723au/hal/rtl8723a_bt-coexist.c    |    44 +-
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c       |     7 +-
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c  |   493 +-
 drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c    |     3 +-
 drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c    |   229 +-
 drivers/staging/rtl8723au/hal/rtl8723a_xmit.c      |    31 -
 drivers/staging/rtl8723au/hal/rtl8723au_led.c      |   124 -
 drivers/staging/rtl8723au/hal/rtl8723au_xmit.c     |    33 +-
 drivers/staging/rtl8723au/hal/usb_halinit.c        |   479 +-
 drivers/staging/rtl8723au/hal/usb_ops_linux.c      |    21 +-
 .../staging/rtl8723au/include/Hal8723UHWImg_CE.h   |     2 +-
 drivers/staging/rtl8723au/include/drv_types.h      |     2 -
 drivers/staging/rtl8723au/include/odm_debug.h      |    30 +-
 drivers/staging/rtl8723au/include/rtl8723a_dm.h    |     3 +-
 drivers/staging/rtl8723au/include/rtl8723a_hal.h   |    11 -
 drivers/staging/rtl8723au/include/rtl8723a_led.h   |    30 -
 drivers/staging/rtl8723au/include/rtl8723a_recv.h  |     6 +-
 drivers/staging/rtl8723au/include/rtl8723a_xmit.h  |     1 -
 drivers/staging/rtl8723au/include/rtw_cmd.h        |     4 +-
 drivers/staging/rtl8723au/include/rtw_ht.h         |     3 +-
 drivers/staging/rtl8723au/include/rtw_led.h        |   181 -
 drivers/staging/rtl8723au/include/rtw_mlme.h       |     2 +-
 drivers/staging/rtl8723au/include/rtw_mlme_ext.h   |     6 +-
 drivers/staging/rtl8723au/include/rtw_recv.h       |     3 -
 drivers/staging/rtl8723au/include/rtw_xmit.h       |    18 +-
 drivers/staging/rtl8723au/include/usb_ops.h        |     2 +-
 drivers/staging/rtl8723au/include/usb_ops_linux.h  |     4 +-
 drivers/staging/rtl8723au/include/wlan_bssdef.h    |    21 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  |    20 +-
 drivers/staging/rtl8723au/os_dep/os_intfs.c        |    19 +-
 drivers/staging/rtl8723au/os_dep/usb_intf.c        |    37 +-
 drivers/staging/rtl8723au/os_dep/usb_ops_linux.c   |    23 -
 drivers/staging/rts5208/ms.c                       |     4 +-
 drivers/staging/rts5208/rtsx.c                     |     4 +-
 drivers/staging/rts5208/rtsx_chip.c                |   459 +-
 drivers/staging/rts5208/rtsx_scsi.c                |     3 +-
 drivers/staging/rts5208/rtsx_transport.c           |     8 +-
 drivers/staging/rts5208/rtsx_transport.h           |     2 +-
 drivers/staging/skein/Kconfig                      |    24 +-
 drivers/staging/skein/Makefile                     |    13 +-
 drivers/staging/skein/skein_api.c                  |     2 +-
 drivers/staging/skein/skein_api.h                  |     2 +-
 drivers/staging/skein/{skein.c => skein_base.c}    |    23 +-
 drivers/staging/skein/{skein.h => skein_base.h}    |    39 +-
 drivers/staging/skein/skein_block.c                |   932 +-
 drivers/staging/skein/skein_block.h                |     2 +-
 drivers/staging/skein/skein_generic.c              |   216 +
 drivers/staging/skein/skein_iv.h                   |     2 +-
 drivers/staging/skein/threefish_api.h              |     2 +-
 drivers/staging/slicoss/slicoss.c                  |    46 +-
 drivers/staging/speakup/kobjects.c                 |     6 +-
 drivers/staging/speakup/main.c                     |     2 +-
 drivers/staging/speakup/speakup_dtlk.c             |     2 +-
 drivers/staging/speakup/speakup_keypc.c            |     2 +-
 drivers/staging/unisys/channels/channel.c          |   114 +-
 drivers/staging/unisys/channels/chanstub.c         |     8 +-
 drivers/staging/unisys/channels/chanstub.h         |     8 +-
 .../unisys/common-spar/include/channels/channel.h  |   505 +-
 .../common-spar/include/channels/channel_guid.h    |    27 +-
 .../include/channels/controlframework.h            |    47 +-
 .../include/channels/controlvmchannel.h            |   623 +-
 .../common-spar/include/channels/diagchannel.h     |   168 +-
 .../common-spar/include/channels/iochannel.h       |   292 +-
 .../common-spar/include/channels/vbuschannel.h     |    80 +-
 .../unisys/common-spar/include/vbusdeviceinfo.h    |    37 +-
 .../unisys/common-spar/include/vmcallinterface.h   |    47 +-
 drivers/staging/unisys/include/timskmod.h          |    17 +-
 drivers/staging/unisys/include/uisqueue.h          |    75 +-
 drivers/staging/unisys/include/uisutils.h          |   162 +-
 drivers/staging/unisys/include/vbushelper.h        |    16 +-
 drivers/staging/unisys/uislib/uislib.c             |   521 +-
 drivers/staging/unisys/uislib/uisqueue.c           |     8 +-
 drivers/staging/unisys/uislib/uisutils.c           |   109 +-
 drivers/staging/unisys/virthba/virthba.c           |   104 +-
 drivers/staging/unisys/virthba/virthba.h           |     4 -
 drivers/staging/unisys/virtpci/virtpci.c           |   332 +-
 drivers/staging/unisys/virtpci/virtpci.h           |    20 +-
 drivers/staging/unisys/visorchannel/globals.h      |     1 -
 drivers/staging/unisys/visorchannel/visorchannel.h |     2 +-
 .../unisys/visorchannel/visorchannel_funcs.c       |   301 +-
 drivers/staging/unisys/visorchipset/file.c         |     6 +-
 drivers/staging/unisys/visorchipset/parser.c       |    52 +-
 drivers/staging/unisys/visorchipset/testing.h      |     5 +-
 drivers/staging/unisys/visorchipset/visorchipset.h |   275 +-
 .../unisys/visorchipset/visorchipset_main.c        |   702 +-
 drivers/staging/unisys/visorutil/charqueue.c       |    40 +-
 drivers/staging/unisys/visorutil/charqueue.h       |    17 +-
 drivers/staging/unisys/visorutil/easyproc.c        |     6 +-
 drivers/staging/unisys/visorutil/memregion.h       |    28 +-
 .../staging/unisys/visorutil/memregion_direct.c    |    64 +-
 drivers/staging/unisys/visorutil/periodic_work.c   |    19 +-
 drivers/staging/unisys/visorutil/procobjecttree.c  |    15 +-
 drivers/staging/unisys/visorutil/visorkmodutils.c  |    26 +-
 drivers/staging/vme/devices/Kconfig                |     3 +
 drivers/staging/vme/devices/vme_pio2_gpio.c        |     4 +-
 drivers/staging/vt6655/80211hdr.h                  |   318 -
 drivers/staging/vt6655/80211mgr.c                  |  1019 --
 drivers/staging/vt6655/80211mgr.h                  |   725 --
 drivers/staging/vt6655/IEEE11h.c                   |   141 -
 drivers/staging/vt6655/IEEE11h.h                   |    42 -
 drivers/staging/vt6655/Kconfig                     |     4 +-
 drivers/staging/vt6655/Makefile                    |    23 +-
 drivers/staging/vt6655/aes_ccmp.c                  |   374 -
 drivers/staging/vt6655/aes_ccmp.h                  |    37 -
 drivers/staging/vt6655/baseband.c                  |   777 +-
 drivers/staging/vt6655/baseband.h                  |    39 +-
 drivers/staging/vt6655/bssdb.c                     |  1512 ---
 drivers/staging/vt6655/bssdb.h                     |   326 -
 drivers/staging/vt6655/card.c                      |  1259 +--
 drivers/staging/vt6655/card.h                      |   120 +-
 drivers/staging/vt6655/channel.c                   |   844 +-
 drivers/staging/vt6655/channel.h                   |    22 +-
 drivers/staging/vt6655/country.h                   |   161 -
 drivers/staging/vt6655/datarate.c                  |   410 -
 drivers/staging/vt6655/datarate.h                  |    78 -
 drivers/staging/vt6655/desc.h                      |   134 +-
 drivers/staging/vt6655/device.h                    |   476 +-
 drivers/staging/vt6655/device_cfg.h                |     2 -
 drivers/staging/vt6655/device_main.c               |  2635 ++---
 drivers/staging/vt6655/dpc.c                       |  1312 +--
 drivers/staging/vt6655/dpc.h                       |    10 +-
 drivers/staging/vt6655/hostap.c                    |   765 --
 drivers/staging/vt6655/hostap.h                    |    58 -
 drivers/staging/vt6655/iocmd.h                     |   408 -
 drivers/staging/vt6655/ioctl.c                     |   658 --
 drivers/staging/vt6655/ioctl.h                     |    36 -
 drivers/staging/vt6655/iowpa.h                     |   130 -
 drivers/staging/vt6655/iwctl.c                     |  1937 ----
 drivers/staging/vt6655/iwctl.h                     |   206 -
 drivers/staging/vt6655/key.c                       |   838 +-
 drivers/staging/vt6655/key.h                       |   131 +-
 drivers/staging/vt6655/mac.c                       |   780 --
 drivers/staging/vt6655/mac.h                       |    53 -
 drivers/staging/vt6655/mib.c                       |   423 -
 drivers/staging/vt6655/mib.h                       |   261 -
 drivers/staging/vt6655/michael.c                   |   148 -
 drivers/staging/vt6655/michael.h                   |    52 -
 drivers/staging/vt6655/power.c                     |   208 +-
 drivers/staging/vt6655/power.h                     |    16 -
 drivers/staging/vt6655/rc4.c                       |    88 -
 drivers/staging/vt6655/rc4.h                       |    47 -
 drivers/staging/vt6655/rf.c                        |   381 +-
 drivers/staging/vt6655/rf.h                        |     9 +-
 drivers/staging/vt6655/rxtx.c                      |  2112 +---
 drivers/staging/vt6655/rxtx.h                      |    52 +-
 drivers/staging/vt6655/srom.c                      |   252 -
 drivers/staging/vt6655/srom.h                      |    49 -
 drivers/staging/vt6655/tcrc.c                      |   191 -
 drivers/staging/vt6655/tcrc.h                      |    50 -
 drivers/staging/vt6655/tether.c                    |   105 -
 drivers/staging/vt6655/tether.h                    |   192 -
 drivers/staging/vt6655/tkip.c                      |   268 -
 drivers/staging/vt6655/tkip.h                      |    57 -
 drivers/staging/vt6655/tmacro.h                    |     2 -
 drivers/staging/vt6655/ttype.h                     |    42 -
 drivers/staging/vt6655/upc.h                       |     1 -
 drivers/staging/vt6655/vntconfiguration.dat        |     1 -
 drivers/staging/vt6655/vntwifi.c                   |   700 --
 drivers/staging/vt6655/vntwifi.h                   |   273 -
 drivers/staging/vt6655/wcmd.c                      |  1023 --
 drivers/staging/vt6655/wcmd.h                      |   123 -
 drivers/staging/vt6655/wctl.c                      |   233 -
 drivers/staging/vt6655/wctl.h                      |   105 -
 drivers/staging/vt6655/wmgr.c                      |  4602 --------
 drivers/staging/vt6655/wmgr.h                      |   420 -
 drivers/staging/vt6655/wpa.c                       |   300 -
 drivers/staging/vt6655/wpa.h                       |    83 -
 drivers/staging/vt6655/wpa2.c                      |   359 -
 drivers/staging/vt6655/wpa2.h                      |    77 -
 drivers/staging/vt6655/wpactl.c                    |   896 --
 drivers/staging/vt6655/wpactl.h                    |    64 -
 drivers/staging/vt6655/wroute.c                    |   187 -
 drivers/staging/vt6655/wroute.h                    |    45 -
 drivers/staging/vt6656/main_usb.c                  |    10 +-
 drivers/staging/wlan-ng/hfa384x.h                  |     3 +
 drivers/staging/wlan-ng/hfa384x_usb.c              |     6 +-
 drivers/staging/wlan-ng/p80211conv.c               |     2 +-
 drivers/staging/wlan-ng/p80211hdr.h                |     2 +-
 drivers/staging/wlan-ng/p80211netdev.c             |     4 +-
 drivers/staging/wlan-ng/prism2fw.c                 |     9 +-
 drivers/staging/xgifb/XGI_main_26.c                |     2 +-
 drivers/staging/xgifb/vb_def.h                     |     1 -
 drivers/staging/xgifb/vb_setmode.c                 |     2 +-
 drivers/staging/xgifb/vb_util.c                    |     5 +-
 include/linux/iio/common/st_sensors.h              |    10 +-
 include/linux/iio/iio.h                            |     8 +
 include/uapi/linux/Kbuild                          |     1 +
 include/uapi/linux/android/Kbuild                  |     2 +
 .../uapi => include/uapi/linux/android}/binder.h   |     1 +
 751 files changed, 22267 insertions(+), 84258 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/qcom,spmi-iadc.txt
 create mode 100644 drivers/android/Kconfig
 create mode 100644 drivers/android/Makefile
 rename drivers/{staging => }/android/binder.c (99%)
 rename drivers/{staging => }/android/binder_trace.h (100%)
 create mode 100644 drivers/iio/adc/qcom-spmi-iadc.c
 create mode 100644 drivers/iio/humidity/si7020.c
 create mode 100644 drivers/iio/pressure/bmp280.c
 delete mode 100644 drivers/staging/android/binder.h
 delete mode 100644 drivers/staging/bcm/Adapter.h
 delete mode 100644 drivers/staging/bcm/Bcmchar.c
 delete mode 100644 drivers/staging/bcm/Bcmnet.c
 delete mode 100644 drivers/staging/bcm/CmHost.c
 delete mode 100644 drivers/staging/bcm/CmHost.h
 delete mode 100644 drivers/staging/bcm/DDRInit.c
 delete mode 100644 drivers/staging/bcm/DDRInit.h
 delete mode 100644 drivers/staging/bcm/Debug.h
 delete mode 100644 drivers/staging/bcm/HandleControlPacket.c
 delete mode 100644 drivers/staging/bcm/HostMIBSInterface.h
 delete mode 100644 drivers/staging/bcm/IPv6Protocol.c
 delete mode 100644 drivers/staging/bcm/IPv6ProtocolHdr.h
 delete mode 100644 drivers/staging/bcm/InterfaceAdapter.h
 delete mode 100644 drivers/staging/bcm/InterfaceDld.c
 delete mode 100644 drivers/staging/bcm/InterfaceIdleMode.c
 delete mode 100644 drivers/staging/bcm/InterfaceIdleMode.h
 delete mode 100644 drivers/staging/bcm/InterfaceInit.c
 delete mode 100644 drivers/staging/bcm/InterfaceInit.h
 delete mode 100644 drivers/staging/bcm/InterfaceIsr.c
 delete mode 100644 drivers/staging/bcm/InterfaceIsr.h
 delete mode 100644 drivers/staging/bcm/InterfaceMacros.h
 delete mode 100644 drivers/staging/bcm/InterfaceMisc.c
 delete mode 100644 drivers/staging/bcm/InterfaceMisc.h
 delete mode 100644 drivers/staging/bcm/InterfaceRx.c
 delete mode 100644 drivers/staging/bcm/InterfaceRx.h
 delete mode 100644 drivers/staging/bcm/InterfaceTx.c
 delete mode 100644 drivers/staging/bcm/InterfaceTx.h
 delete mode 100644 drivers/staging/bcm/Ioctl.h
 delete mode 100644 drivers/staging/bcm/Kconfig
 delete mode 100644 drivers/staging/bcm/LeakyBucket.c
 delete mode 100644 drivers/staging/bcm/Macros.h
 delete mode 100644 drivers/staging/bcm/Makefile
 delete mode 100644 drivers/staging/bcm/Misc.c
 delete mode 100644 drivers/staging/bcm/PHSDefines.h
 delete mode 100644 drivers/staging/bcm/PHSModule.c
 delete mode 100644 drivers/staging/bcm/PHSModule.h
 delete mode 100644 drivers/staging/bcm/Protocol.h
 delete mode 100644 drivers/staging/bcm/Prototypes.h
 delete mode 100644 drivers/staging/bcm/Qos.c
 delete mode 100644 drivers/staging/bcm/Queue.h
 delete mode 100644 drivers/staging/bcm/TODO
 delete mode 100644 drivers/staging/bcm/Transmit.c
 delete mode 100644 drivers/staging/bcm/Typedefs.h
 delete mode 100644 drivers/staging/bcm/cntrl_SignalingInterface.h
 delete mode 100644 drivers/staging/bcm/headers.h
 delete mode 100644 drivers/staging/bcm/hostmibs.c
 delete mode 100644 drivers/staging/bcm/led_control.c
 delete mode 100644 drivers/staging/bcm/led_control.h
 delete mode 100644 drivers/staging/bcm/nvm.c
 delete mode 100644 drivers/staging/bcm/nvm.h
 delete mode 100644 drivers/staging/bcm/sort.c
 delete mode 100644 drivers/staging/bcm/target_params.h
 delete mode 100644 drivers/staging/bcm/vendorspecificextn.c
 delete mode 100644 drivers/staging/bcm/vendorspecificextn.h
 create mode 100644 drivers/staging/clocking-wizard/Kconfig
 create mode 100644 drivers/staging/clocking-wizard/Makefile
 create mode 100644 drivers/staging/clocking-wizard/TODO
 create mode 100644 drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
 create mode 100644 drivers/staging/clocking-wizard/dt-binding.txt
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/addi_common.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/addi_common.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
 delete mode 100644 drivers/staging/comedi/drivers/addi_apci_035.c
 delete mode 100644 drivers/staging/comedi/drivers/addi_apci_3200.c
 create mode 100644 drivers/staging/comedi/drivers/addi_tcw.h
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_led.c
 delete mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_xmit.c
 delete mode 100644 drivers/staging/rtl8723au/hal/rtl8723au_led.c
 delete mode 100644 drivers/staging/rtl8723au/include/rtl8723a_led.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_led.h
 rename drivers/staging/skein/{skein.c => skein_base.c} (97%)
 rename drivers/staging/skein/{skein.h => skein_base.h} (92%)
 create mode 100644 drivers/staging/skein/skein_generic.c
 delete mode 100644 drivers/staging/vt6655/80211hdr.h
 delete mode 100644 drivers/staging/vt6655/80211mgr.c
 delete mode 100644 drivers/staging/vt6655/80211mgr.h
 delete mode 100644 drivers/staging/vt6655/IEEE11h.c
 delete mode 100644 drivers/staging/vt6655/IEEE11h.h
 delete mode 100644 drivers/staging/vt6655/aes_ccmp.c
 delete mode 100644 drivers/staging/vt6655/aes_ccmp.h
 delete mode 100644 drivers/staging/vt6655/bssdb.c
 delete mode 100644 drivers/staging/vt6655/bssdb.h
 delete mode 100644 drivers/staging/vt6655/country.h
 delete mode 100644 drivers/staging/vt6655/datarate.c
 delete mode 100644 drivers/staging/vt6655/datarate.h
 delete mode 100644 drivers/staging/vt6655/hostap.c
 delete mode 100644 drivers/staging/vt6655/hostap.h
 delete mode 100644 drivers/staging/vt6655/iocmd.h
 delete mode 100644 drivers/staging/vt6655/ioctl.c
 delete mode 100644 drivers/staging/vt6655/ioctl.h
 delete mode 100644 drivers/staging/vt6655/iowpa.h
 delete mode 100644 drivers/staging/vt6655/iwctl.c
 delete mode 100644 drivers/staging/vt6655/iwctl.h
 delete mode 100644 drivers/staging/vt6655/michael.c
 delete mode 100644 drivers/staging/vt6655/michael.h
 delete mode 100644 drivers/staging/vt6655/rc4.c
 delete mode 100644 drivers/staging/vt6655/rc4.h
 delete mode 100644 drivers/staging/vt6655/tcrc.c
 delete mode 100644 drivers/staging/vt6655/tcrc.h
 delete mode 100644 drivers/staging/vt6655/tether.c
 delete mode 100644 drivers/staging/vt6655/tether.h
 delete mode 100644 drivers/staging/vt6655/tkip.c
 delete mode 100644 drivers/staging/vt6655/tkip.h
 delete mode 100644 drivers/staging/vt6655/ttype.h
 delete mode 100644 drivers/staging/vt6655/vntconfiguration.dat
 delete mode 100644 drivers/staging/vt6655/vntwifi.c
 delete mode 100644 drivers/staging/vt6655/vntwifi.h
 delete mode 100644 drivers/staging/vt6655/wcmd.c
 delete mode 100644 drivers/staging/vt6655/wcmd.h
 delete mode 100644 drivers/staging/vt6655/wctl.c
 delete mode 100644 drivers/staging/vt6655/wctl.h
 delete mode 100644 drivers/staging/vt6655/wmgr.c
 delete mode 100644 drivers/staging/vt6655/wmgr.h
 delete mode 100644 drivers/staging/vt6655/wpa.c
 delete mode 100644 drivers/staging/vt6655/wpa.h
 delete mode 100644 drivers/staging/vt6655/wpa2.c
 delete mode 100644 drivers/staging/vt6655/wpa2.h
 delete mode 100644 drivers/staging/vt6655/wpactl.c
 delete mode 100644 drivers/staging/vt6655/wpactl.h
 delete mode 100644 drivers/staging/vt6655/wroute.c
 delete mode 100644 drivers/staging/vt6655/wroute.h
 create mode 100644 include/uapi/linux/android/Kbuild
 rename {drivers/staging/android/uapi => include/uapi/linux/android}/binder.h (99%)
