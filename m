Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaF2RtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 13:49:12 -0400
Received: from mail.alumni.tu-berlin.de ([130.149.5.29]:41551 "EHLO
	mail-2.alumni.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbaF2RtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 13:49:10 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jun 2014 13:49:10 EDT
X-tubIT-Incoming-IP: 91.46.217.216
Message-ID: <53B05033.7070709@math.tu-berlin.de>
Date: Sun, 29 Jun 2014 19:43:15 +0200
From: Thomas Richter <thor@math.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
        =?ISO-8859-15?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Kernel OOPS when reloading i915 after resume from suspend
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ville, hi Daniel,

still experimenting with the resume from suspend on the Fujitsu S6010. I 
can, however, still create a kernel oops. The kernel source comes from 
alm_fixes5, kernel 3.15.0-rc7+. For that, do the following:

1) Shut down X,
2) Unbind the consoles:

echo 0 > /sys/class/vtconsole/vtcon1/bind
echo 0 > /sys/class/vtconsole/vtcon0/bind

3) Remove the i915

rmmod i915

4) Suspend the system

pm-suspend

5) Resume the system by pressing on the power-button.
6) Reload the i915 module with

modprobe i915.

Result is a kernel-Oops:

Jun 29 19:34:00 tyleet kernel: [  321.283072] [drm] Memory usable by 
graphics device = 128M
Jun 29 19:34:00 tyleet kernel: [  321.286770] [drm] Supports vblank 
timestamp caching Rev 2 (21.10.2013).
Jun 29 19:34:00 tyleet kernel: [  321.286782] [drm] Driver supports 
precise vblank timestamp query.
Jun 29 19:34:00 tyleet kernel: [  321.286959] [drm] applying pipe a 
force quirk
Jun 29 19:34:00 tyleet kernel: [  321.286965] [drm] applying pipe b 
force quirk
Jun 29 19:34:00 tyleet kernel: [  321.307436] *pde = 00000000
Jun 29 19:34:00 tyleet kernel: [  321.307568] Oops: 0000 [#1]
Jun 29 19:34:00 tyleet kernel: [  321.307751] Modules linked in: i915(+) 
michael_mic arc4 ecb lib80211_crypt_tkip lib80211_crypt_ccmp binfmt_misc 
fuse netconsole loop firewire_sbp2 hid_generic usbhid hid snd_intel8x0 
sg snd_ac97_codec ac97_bus snd_pcm sr_mod snd_seq cdrom snd_seq_device 
ipw2100 pcmcia libipw mousedev cfg80211 snd_timer firewire_ohci 
i2c_algo_bit irda firewire_core snd apanel yenta_socket pcmcia_rsrc 
rfkill lib80211 8139too input_polldev evdev psmouse 8139cp pcspkr 
drm_kms_helper mii soundcore pcmcia_core crc_itu_t crc_ccitt lpc_ich 
i2c_i801 mfd_core uhci_hcd 8250 drm usbcore serial_core fujitsu_laptop 
led_class intel_agp i2c_core video intel_gtt usb_common ac battery 
agpgart button [last unloaded: i915]
Jun 29 19:34:00 tyleet kernel: [  321.308031] EIP: 0060:[<f859e809>] 
EFLAGS: 00010286 CPU: 0
Jun 29 19:34:00 tyleet kernel: [  321.308031] EIP is at 
drm_mm_insert_node_in_range_generic+0x49/0x360 [drm]
Jun 29 19:34:00 tyleet kernel: [  321.308031] EAX: 00000000 EBX: 
fffffff8 ECX: 0012c000 EDX: 00000000
Jun 29 19:34:00 tyleet kernel: [  321.308031] ESI: 00000000 EDI: 
f09e5620 EBP: 00010000 ESP: f6a8397c
Jun 29 19:34:00 tyleet kernel: [  321.308031]  DS: 007b ES: 007b FS: 
0000 GS: 0033 SS: 0068
Jun 29 19:34:00 tyleet kernel: [  321.308031] CR0: 8005003b CR2: 
00000008 CR3: 30ad5000 CR4: 000007d0
Jun 29 19:34:00 tyleet kernel: [  321.308031]  f6801d00 ead3bed4 
f6bf5120 0012c000 00000000 000080d0 f817481f ead3bed4
Jun 29 19:34:00 tyleet kernel: [  321.308031]  f09e5620 f09e5620 
00000005 08000000 00000000 f09e5620 00010000 f8179c4b
Jun 29 19:34:00 tyleet kernel: [  321.308031]  00010000 00000000 
00000000 08000000 00000000 00000000 eac50000 00000001
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f817481f>] ? 
i915_gem_obj_lookup_or_create_vma+0x3f/0x120 [i915]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f8179c4b>] ? 
i915_gem_object_pin+0x3db/0x6b0 [i915]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f817acc4>] ? 
i915_gem_object_pin_to_display_plane+0x94/0x130 [i915]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f819ce3b>] ? 
intel_pin_and_fence_fb_obj+0x4b/0x100 [i915]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f81a2f7a>] ? 
__intel_set_mode+0x67a/0x14d0 [i915]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f85a065a>] ? 
drm_mode_object_get+0x5a/0x80 [drm]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c10c43d1>] ? 
kmem_cache_alloc+0x31/0x100
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f81a63b3>] ? 
intel_set_mode+0x23/0x40 [i915]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f81a66a7>] ? 
intel_get_load_detect_pipe+0x1d7/0x410 [i915]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f81a8316>] ? 
intel_modeset_setup_hw_state+0xab6/0xd40 [i915]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f818ca90>] ? 
gen4_write64+0x50/0x50 [i915]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f81a8d56>] ? 
intel_modeset_init+0x7b6/0x12f0 [i915]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c10c43d1>] ? 
kmem_cache_alloc+0x31/0x100

Message from syslogd@tyleet at Jun 29 19:34:00 ...
  kernel:[  321.308031] CPU: 0 PID: 3087 Comm: modprobe Not tainted 
3.15.0-rc7+ #13

Message from syslogd@tyleet at Jun 29 19:34:00 ...
  kernel:[  321.308031] Hardware name: FUJITSU SIEMENS LIFEBOOK S 
Series/FJNB159, BIOS Version 1.07  10/28/2002

Message from syslogd@tyleet at Jun 29 19:34:00 ...
  kernel:[  321.308031] task: f163d450 ti: f6a82000 task.ti: f6a82000

Message from syslogd@tyleet at Jun 29 19:34:00 ...
  kernel:[  321.308031] Stack:

Message from syslogd@tyleet at Jun 29 19:34:00 ...
  kernel:[  321.308031] Call Trace:
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f8598991>] ? 
drm_irq_install+0xa1/0x180 [drm]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f81d2ef1>] ? 
i915_driver_load+0x9d1/0xee0 [i915]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f81d0790>] ? 
i915_dma_init+0x2c0/0x2c0 [i915]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c117c17b>] ? 
kobject_uevent_env+0xeb/0x4f0
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c117c17b>] ? 
kobject_uevent_env+0xeb/0x4f0
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c117bff0>] ? 
add_uevent_var+0xc0/0xc0
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c1224c1c>] ? 
get_device+0xc/0x20
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c1312643>] ? 
klist_node_init+0x33/0x50
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c13126f7>] ? 
klist_add_tail+0x17/0x40
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f859da41>] ? 
drm_sysfs_device_add+0xb1/0x110 [drm]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f859a79e>] ? 
drm_dev_register+0x9e/0x100 [drm]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f859cc39>] ? 
drm_get_pci_dev+0x79/0x1f0 [drm]
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c119db2f>] ? 
pci_device_probe+0x7f/0xd0
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c111e4ad>] ? 
sysfs_create_link+0x1d/0x40
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c12286ca>] ? 
driver_probe_device+0x6a/0x230
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c117b5b0>] ? 
kobject_add_internal+0x150/0x2c0
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c1228890>] ? 
driver_probe_device+0x230/0x230
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c1228909>] ? 
__driver_attach+0x79/0x80
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c12270c8>] ? 
bus_for_each_dev+0x38/0x70
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c1228296>] ? 
driver_attach+0x16/0x20
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c1228890>] ? 
driver_probe_device+0x230/0x230
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c1227f41>] ? 
bus_add_driver+0xe1/0x1e0
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c1228e61>] ? 
driver_register+0x51/0xd0
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f8208000>] ? 0xf8207fff
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<f8208000>] ? 0xf8207fff
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c1000472>] ? 
do_one_initcall+0xe2/0x130
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c131a468>] ? 
mutex_lock+0x8/0x15
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c1095335>] ? 
jump_label_module_notify+0x155/0x1a0
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c104ecf0>] ? 
notifier_call_chain+0x40/0x60
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c104ef3b>] ? 
__blocking_notifier_call_chain+0x4b/0x70
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c107f082>] ? 
load_module+0x1a62/0x2180
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c102d4c0>] ? 
vmalloc_sync_all+0xd0/0xd0
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c107f831>] ? 
SyS_init_module+0x91/0xd0
Jun 29 19:34:00 tyleet kernel: [  321.308031]  [<c131bc2f>] ? 
sysenter_do_call+0x12/0x26
Jun 29 19:34:00 tyleet kernel: [  321.308031] CR2: 0000000000000008
Jun 29 19:34:00 tyleet kernel: [  321.325446] ---[ end trace 
fc5dd80a77850fec ]---

Message from syslogd@tyleet at Jun 29 19:34:00 ...
  kernel:[  321.308031] Code: 85 d2 0f 85 2a 03 00 00 89 c3 83 e3 02 89 
5c 24 10 0f 84 7b 02 00 00 8b 4c 24 04 8b 51 04 39 54 24 04 8d 5a f8 0f 
84 7a 02 00 00 <f6> 42 08 01 0f 84 f4 02 00 00 31 ed ba ff ff ff ff 83 
e0 01 89

Message from syslogd@tyleet at Jun 29 19:34:00 ...
  kernel:[  321.308031] EIP: [<f859e809>] 
drm_mm_insert_node_in_range_generic+0x49/0x360 [drm] SS:ESP 0068:f6a8397c
Jun 29 19:34:13 tyleet kernel: [  334.472130] usb 1-2: USB disconnect, 
device number 3
Jun 29 19:34:16 tyleet kernel: [  336.852068] usb 1-2: new low-speed USB 
device number 4 using uhci_hcd
Jun 29 19:34:16 tyleet kernel: [  337.027169] usb 1-2: New USB device 
found, idVendor=046d, idProduct=c05f
Jun 29 19:34:16 tyleet kernel: [  337.027221] usb 1-2: New USB device 
strings: Mfr=1, Product=2, SerialNumber=0
Jun 29 19:34:16 tyleet kernel: [  337.027248] usb 1-2: Product: USB 
Optical Mouse
Jun 29 19:34:16 tyleet kernel: [  337.027271] usb 1-2: Manufacturer: 
Logitech
Jun 29 19:34:16 tyleet kernel: [  337.048399] input: Logitech USB 
Optical Mouse as 
/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/0003:046D:C05F.0003/input/input13
Jun 29 19:34:16 tyleet kernel: [  337.050604] hid-generic 
0003:046D:C05F.0003: input,hidraw0: USB HID v1.11 Mouse [Logitech USB 
Optical Mouse] on usb-0000:00:1d.0-2/input0
Jun 29 19:34:16 tyleet mtp-probe: checking bus 1, device 4: 
"/sys/devices/pci0000:00/0000:00:1d.0/usb1/1-2"
Jun 29 19:34:16 tyleet mtp-probe: bus: 1, device: 4 was not an MTP device

Greetings,
	Thomas
