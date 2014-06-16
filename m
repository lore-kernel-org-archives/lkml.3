Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaFPQde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:33:34 -0400
Received: from mout.gmx.net ([212.227.15.19]:62123 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbaFPQdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:33:32 -0400
Message-ID: <539F1C59.6070308@gmx.de>
Date: Mon, 16 Jun 2014 18:33:29 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 3.15: kernel BUG at kernel/auditsc.c:1525!
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Cv8SBWb9lUemIkAk29OvUlN+vNePSmst1YQXc3iwRnfJt/JtHkq
 W3LDPNt5mGwR0esRWYWlNH7ufewkYGjxR8dT94a4GpTONcQGKBx/wriupSmwllyRXwhDj1+
 Zw/OkIm7dHmA0RsTZIPHH5ke02jMliqQwegW+2A6e7HLXBM6blhgvPjojgKvcKQJVWzzl1Z
 amU5gTvA53SL4GUXty+6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ cat syscall.c
#include <unistd.h>
#include <sys/syscall.h>
int main(){return syscall(1000)!=-1;}

(pls see https://bugs.gentoo.org/show_bug.cgi?id=513308) gives at a 32 bit stable Gentoo Linux w/ kernel 3.15 :

Jun 16 18:29:42 n22 kernel: ------------[ cut here ]------------
Jun 16 18:29:42 n22 kernel: kernel BUG at kernel/auditsc.c:1525!
Jun 16 18:29:42 n22 kernel: invalid opcode: 0000 [#1] SMP
Jun 16 18:29:42 n22 kernel: Modules linked in: ip6t_REJECT ip6table_filter ip6_tables ipt_MASQUERADE xt_owner xt_LOG xt_limit xt_multiport ipt_REJECT xt_recent xt_conntrack xt_tcpudp nf_conntrack_ftp iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables ctr ccm af_packet bridge stp llc ipv6 tun i915 cfbfillrect uvcvideo cfbimgblt i2c_algo_bit x86_pkg_temp_thermal arc4 iwldvm mac80211 coretemp fbcon bitblit softcursor font cfbcopyarea drm_kms_helper videobuf2_vmalloc videobuf2_memops usblp videobuf2_core kvm_intel videodev drm kvm iwlwifi intel_gtt psmouse evdev agpgart cfg80211 acpi_cpufreq video processor thermal sdhci_pci sdhci mmc_core fb wmi thermal_sys snd_hda_codec_conexant e1000e snd_hda_codec_generic 8250_pci battery tpm_tis tpm thinkpad_acpi nvram ac snd_hda_intel snd_hda_controller snd_hda_codec fbdev snd_pcm 8250 snd_timer i2c_i801 ptp snd serial_core rfkill hwmon button i2c_core pps_core soundcore aesni_intel xts aes
_i586 lrw gf128mul ablk_helper cryptd cbc fuse nfs lockd sunrpc dm_crypt dm_mod hid_monterey hid_microsoft hid_logitech hid_ezkey hid_cypress hid_chicony hid_cherry hid_belkin hid_apple hid_a4tech hid_generic usbhid hid sr_mod cdrom sg [last unloaded: microcode]
Jun 16 18:29:42 n22 kernel: CPU: 1 PID: 29269 Comm: a.out Not tainted 3.15.0 #3
Jun 16 18:29:42 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Jun 16 18:29:42 n22 kernel: task: cb368aa0 ti: e4dee000 task.ti: e4dee000
Jun 16 18:29:42 n22 kernel: EIP: 0060:[<c10b6c70>] EFLAGS: 00010202 CPU: 1
Jun 16 18:29:42 n22 kernel: EIP is at __audit_syscall_entry+0xf0/0x100
Jun 16 18:29:42 n22 kernel: EAX: 40000003 EBX: f1a9a000 ECX: 00000000 EDX: 000000fc
Jun 16 18:29:42 n22 kernel: ESI: 00000001 EDI: cb368aa0 EBP: e4deffb0 ESP: e4deffa4
Jun 16 18:29:42 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jun 16 18:29:42 n22 kernel: CR0: 80050033 CR2: b75dd2c0 CR3: 22f69000 CR4: 000407f0
Jun 16 18:29:42 n22 kernel: Stack:
Jun 16 18:29:42 n22 kernel: 00000000 00000000 b76c8264 e4dee000 c14ca296 00000000 00000008 00000000
Jun 16 18:29:42 n22 kernel: b76c8264 b76c8264 000000fc 0000007b 0000007b 00000000 00000033 000000fc
Jun 16 18:29:42 n22 kernel: b76fab2c 00000073 00000246 bfcd3e1c 0000007b 807f7f7f 807f7f7f
Jun 16 18:29:42 n22 kernel: Call Trace:
Jun 16 18:29:42 n22 kernel: [<c14ca296>] sysenter_audit+0x1e/0x25
Jun 16 18:29:42 n22 kernel: Code: 7d fc 89 ec 5d c3 90 8d 74 26 00 c7 43 34 00 00 00 00 b9 b0 2a 66 c1 89 da c7 43 38 00 00 00 00 89 f8 e8 54 f6 ff ff 89 c6 eb 91 <0f> 0b 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 57 56
Jun 16 18:29:42 n22 kernel: EIP: [<c10b6c70>] __audit_syscall_entry+0xf0/0x100 SS:ESP 0068:e4deffa4
Jun 16 18:29:42 n22 kernel: ---[ end trace eaa43aea29d8101e ]---
Jun 16 18:30:01 n22 crond[29299]: pam_unix(crond:session): session opened for user root by (uid=0)
Jun 16 18:30:01 n22 CROND[29303]: (root) CMD (/usr/lib/sa/sa1 60 15 )
Jun 16 18:30:01 n22 crond[29298]: pam_unix(crond:session): session opened for user root by (uid=0)
Jun 16 18:30:01 n22 CROND[29304]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )
Jun 16 18:30:01 n22 CROND[29298]: pam_unix(crond:session): session closed for user root

-- 
Toralf

