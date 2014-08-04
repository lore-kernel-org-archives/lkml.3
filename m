Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaHDRDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:03:38 -0400
Received: from mx3.wp.pl ([212.77.101.10]:42411 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaHDRDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:03:32 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2014 13:03:29 EDT
Date: Mon, 4 Aug 2014 18:56:44 +0200
From: Janek Kozicki <janek_listy@wp.pl>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Resume from hibernation fails 40% of time, kernel 3.16.0 (64GB of
 RAM, 32 Xeon E5-2687W cores)
Message-ID: <20140804185644.05a56986@absurd>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-Face: $rkfae+2_DGd"-<Fvf,vE7&hL?oJC.uN!6/loh7NMwb/Cs*h!wXg0^+WL;VPwQ0]e0\sPi~63[g*K.:C@jj9zV:L^0&vNyT+aq.9L.0V'8yV%Q/PzmqW{8{/P`>BPR=BhRod2pTifbsp+}LY@O++;u~RqNMBFJgn?R{QHO^@4;?(l5x002ZHJ$zZd~:,H{5E&LV]7X9\7Bw*fl
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAALVBMVEUBAQEtLS1KSkpRUVFXV1dYWFhjY2Nzc3N3d3eHh4eKioqdnZ24uLjLy8vc3NxVIagyAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH2AIVEzgS1fgQtQAAAjRJREFUOMtt1DFv00AUAOAzFQNbjigSyoQaRaBMhKgLUyKXpVNNeUpk9vyDqFJhQ1kiBuaqAwJCqvPtSLY7RlTn5+5IdnYkkt/AOyfxXVLe5vf53Z1875kd34tOEax8djmj6GyjhB5bxz50GdsVZr9fqRjZwAtKOJw5Wqs2MMZ16ALHsaDncF7xAHix1oEFHAB8f+pRjcO4gfZDykcYzbiucRolOLUJ6kjA0xtVt+A6TySlM0RajIpK6DzwKZ/nOYbF/gclHMo1ZOHYY/+Ha+AWuM+3oMS4eeqYzZ8FiCltgUqI8cd2wwAVpJk+8LWYjBtnJdQpHQqJMd4Oxt4bU9ESiFGc5hkqaH74asAX4iabP5I5gZ+qjgGlJCqZa3h3lxhoeVcSE1qLQC4sqKOK9MGW9E3izFqqHokoztLFEgXg31sbZEKnWi2T74A4NxfVQqlkjKtcAWD+zcArFEES01dR0E/nnV0IgugmDd/2L84sOAouRBBHEc7gtc8teDkRlE0iNQPo2w3Xhh/D4TCIQ4LRLoTvgwjj6RRgavdurxYGMaIuGOyAW/PpNlCcU9/93AHenAWYjPoAwa+G3e3to/MgFNTAEKvKDjzuCzHTnY3qqdXtx24VijzQfZ0yewZ5cwRFQaa+mIYr1uI0I76+3W4xhlvoVRwOA0Fdl64HlJnxP6T8YpX/Lga4Wv4A3ErrU5oTfN7Mu/llXMl8RXEPji/lQkN3H7qXqgC2By47EXeU/7PJ/wPxRKMnuZwIeAAAAABJRU5ErkJggg==
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/cEJe+m.7nh.4DHL/+fQKd3_"
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [YXPk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I have an up-to-date recently installed debian wheezy. I downloaded
https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.16.tar.xz and compiled it using:

  cp /boot/config-`uname -r` ./.config
  make menuconfig
  fakeroot make-kpkg --initrd --append-to-version=-vanilla.1 kernel_image kernel_headers -j38
  dpkg -i linux-image-3.16.0-vanilla.1_3.16.0-vanilla.1-10.00.Custom_amd64.deb linux-headers-3.16.0-vanilla.1_3.16.0-vanilla.1-10.00.Custom_amd64.deb

where .config was taken from debian /boot/config-3.14-0.bpo.1-amd64

my PC has 64GB of RAM, 32 Xeon E5-2687W cores and motherboard SuperMicro MBD-X9DRI

I just did 25 tries of suspend/resume cycle. I tried 4 different
methods of hibernation, you will find a full summary of my tries
(including how many failures for each method) in attached script
SLEEP.sh which I always used to perform hibernation.

The failure was always a reboot after resume had almost succeeded. In
cases when there was a success there was a ---[cut here]--- part
which is in the attachment. All of my successes are included in the
attachments (please note that method had 0 success rate, so no
success logs are attached for it).

I post here to get your help, and my first question: how can I
retrieve some useful logs from a failed resume attempt?

best regards
-- 
Janek Kozicki                               http://janek.kozicki.pl/  |

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: application/x-shellscript
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=SLEEP.sh

IyEvYmluL2Jhc2gKCmxvZ2dlciAiPT09PT09PT09PSB0b3VjaCBmb3JjZWZzY2sgPT09PT09PT09
PT0iCnRvdWNoIC9mb3JjZWZzY2sKL2Jpbi9zeW5jCnNsZWVwIDEKCmxvZ2dlciAiPT09PT09PT09
PSBTVEFSVCBISUJFUk5BVElPTiA9PT09PT09PT0iCiMjIyMjIyMjPT09IEJlbG93IGFyZSA0IGRp
ZmZlcmVudCBtZXRob2RzIG9mIHN0YXJ0aW5nIGhpYmVybmF0aW9uID09PSMjIyMjIyMjCiMjIyMj
IyMjIGh0dHBzOi8vaGVscC51YnVudHUuY29tL2NvbW11bml0eS9Qb3dlck1hbmFnZW1lbnQvSGli
ZXJuYXRlICMjIyMjIyMjCiMjIyMjIyMjPT09PT09PT09PT09PT09PT09PT09PSBCZWdpbiA0IG1l
dGhvZHM6ID09PT09PT09PT09PT09PT09PT09PSMjIyMjIyMjCiMjIG1ldGhvZCAxKSAgICBrZXJu
ZWwgMy4xMy4wICAgICAgICAgICAgLSBmYWlscyBhbHdheXMKIyMgICAgICAgICAgICAgIGtlcm5l
bCAzLjE2LjAtdmFuaWxsYS4xICAtIDUgc3VjY2Vzc2VzcywgMCBmYWlsdXJlcwovdXNyL3NiaW4v
aGliZXJuYXRlCgojIyBtZXRob2QgMikgICAga2VybmVsIDMuMTMuMCAgICAgICAgICAgIC0gZmFp
bHMgYWx3YXlzCiMjICAgICAgICAgICAgICBrZXJuZWwgMy4xNi4wLXZhbmlsbGEuMSAgLSA4IHN1
Y2Nlc3Nlc3MsIDIgZmFpbHVyZXMKIy91c3Ivc2Jpbi9zMmRpc2sKCiMjIG1ldGhvZCAzKSAgICBr
ZXJuZWwgMy4xMy4wICAgICAgICAgICAgLSBmYWlscyBhd2xheXMKIyMgICAgICAgICAgICAgIGtl
cm5lbCAzLjE2LjAtdmFuaWxsYS4xICAtIDAgc3VjY2Vzc2VzcywgNSBmYWlsdXJlcwojZWNobyBw
bGF0Zm9ybSA+IC9zeXMvcG93ZXIvZGlzawojZWNobyBkaXNrID4gL3N5cy9wb3dlci9zdGF0ZQoK
IyMgbWV0aG9kIDQpICAgIGtlcm5lbCAzLjIuMCAgICAgICAgICAgICAtIDgwJSBzdWNlc3NlcyAy
MCUgZmFpbHVyZXMgKEkgdXNlZCBpdCBmb3IgbW9udGhzKQojIyAgICAgICAgICAgICAga2VybmVs
IDMuMTItYnBvICAgICAgICAgIC0gZmFpbHMgYWx3YXlzCiMjICAgICAgICAgICAgICBrZXJuZWwg
My4xMy4wICAgICAgICAgICAgLSAzIHN1Y2Nlc3NlcywgMiBmYWlsdXJlcwojIyAgICAgICAgICAg
ICAga2VybmVsIDMuMTYuMC12YW5pbGxhLjEgIC0gMiBzdWNjZXNzZXNzLCAzIGZhaWx1cmVzCiNl
Y2hvIHNodXRkb3duID4gL3N5cy9wb3dlci9kaXNrCiNlY2hvIGRpc2sgPiAvc3lzL3Bvd2VyL3N0
YXRlCiMjIyMjIyMjPT09PT09PT09PT09PT09PT09PT09PT0gRU5EIDQgbWV0aG9kcyA9PT09PT09
PT09PT09PT09PT09PT09PSMjIyMjIyMjCgpzbGVlcCA1Ci9ldGMvaW5pdC5kL3JzeXNsb2cgcmVz
dGFydApsb2dnZXIgIj09PT09PT09PT0gcmVzdW1lIGNvbXBsZXRlID09PT09PT09PT09IgoK

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_1_success1.txt

Aug  4 17:48:34 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:48:37 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:48:40 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:48:43 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:48:46 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:48:49 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:48:52 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:49:01 parback CRON[18567]: (root) CMD (/root/bin/FPING             > /dev/null 2>&1)
Aug  4 17:49:01 parback root: FPING
Aug  4 17:48:55 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:48:58 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:48:58 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:48:59 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:48:59 absurd kernel: [  425.727911] ehci-pci 0000:00:1d.0: remove, state 1
Aug  4 17:48:59 absurd kernel: [  425.727926] usb usb2: USB disconnect, device number 1
Aug  4 17:48:59 absurd kernel: [  425.727937] usb 2-1: USB disconnect, device number 2
Aug  4 17:48:59 absurd kernel: [  425.727940] usb 2-1.1: USB disconnect, device number 3
Aug  4 17:48:59 absurd kernel: [  425.728815] sd 7:0:0:0: [sde] Synchronizing SCSI cache
Aug  4 17:48:59 absurd kernel: [  425.728869] sd 7:0:0:0: [sde]  
Aug  4 17:48:59 absurd kernel: [  425.728872] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Aug  4 17:48:59 absurd kernel: [  425.729419] usb 2-1.2: USB disconnect, device number 4
Aug  4 17:48:59 absurd kernel: [  425.729815] usb 2-1.3: USB disconnect, device number 5
Aug  4 17:48:59 absurd kernel: [  425.729823] usb 2-1.3.1: USB disconnect, device number 6
Aug  4 17:48:59 absurd kernel: [  425.730090] usb 2-1.3.3: USB disconnect, device number 7
Aug  4 17:48:59 absurd acpid: input device has been disconnected, fd 7
Aug  4 17:48:59 absurd kernel: [  425.906096] ehci-pci 0000:00:1d.0: USB bus 2 deregistered
Aug  4 17:48:59 absurd kernel: [  425.906161] ehci-pci 0000:00:1a.0: remove, state 1
Aug  4 17:48:59 absurd kernel: [  425.906171] usb usb1: USB disconnect, device number 1
Aug  4 17:48:59 absurd kernel: [  425.906174] usb 1-1: USB disconnect, device number 2
Aug  4 17:48:59 absurd kernel: [  425.906177] usb 1-1.6: USB disconnect, device number 3
Aug  4 17:48:59 absurd acpid: input device has been disconnected, fd 8
Aug  4 17:48:59 absurd kernel: [  426.126946] ehci-pci 0000:00:1a.0: USB bus 1 deregistered
Aug  4 17:49:00 absurd kernel: [  426.732587] Syncing filesystems ... done.
Aug  4 17:50:11 absurd kernel: [  426.735038] Freezing user space processes ... (elapsed 0.001 seconds) done.
Aug  4 17:50:11 absurd kernel: [  426.738015] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:50:11 absurd kernel: [  426.738077] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:50:11 absurd kernel: [  426.739146] PM: Basic memory bitmaps created
Aug  4 17:50:11 absurd kernel: [  426.739328] PM: Preallocating image memory... done (allocated 16300583 pages)
Aug  4 17:50:11 absurd kernel: [  432.409251] PM: Allocated 65202332 kbytes in 5.67 seconds (3924.63 MB/s)
Aug  4 17:50:11 absurd kernel: [  432.409311] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:50:11 absurd kernel: [  432.411484] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:50:11 absurd kernel: [  432.411944] serial 00:04: disabled
Aug  4 17:50:11 absurd kernel: [  432.412021] serial 00:03: disabled
Aug  4 17:50:11 absurd kernel: [  432.474670] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:50:11 absurd kernel: [  432.487906] PM: freeze of devices complete after 76.403 msecs
Aug  4 17:50:11 absurd kernel: [  432.488505] PM: late freeze of devices complete after 0.597 msecs
Aug  4 17:50:11 absurd kernel: [  432.490427] PM: noirq freeze of devices complete after 1.921 msecs
Aug  4 17:50:11 absurd kernel: [  432.490428] Disabling non-boot CPUs ...
Aug  4 17:50:11 absurd kernel: [  432.490534] intel_pstate CPU 1 exiting
Aug  4 17:50:11 absurd kernel: [  432.492249] kvm: disabling virtualization on CPU1
Aug  4 17:50:11 absurd kernel: [  432.492291] smpboot: CPU 1 is now offline
Aug  4 17:50:11 absurd kernel: [  432.493142] intel_pstate CPU 2 exiting
Aug  4 17:50:11 absurd kernel: [  432.494972] kvm: disabling virtualization on CPU2
Aug  4 17:50:11 absurd kernel: [  432.494979] smpboot: CPU 2 is now offline
Aug  4 17:50:11 absurd kernel: [  432.495594] intel_pstate CPU 3 exiting
Aug  4 17:50:11 absurd kernel: [  432.497350] kvm: disabling virtualization on CPU3
Aug  4 17:50:11 absurd kernel: [  432.497355] smpboot: CPU 3 is now offline
Aug  4 17:50:11 absurd kernel: [  432.498027] intel_pstate CPU 4 exiting
Aug  4 17:50:11 absurd kernel: [  432.499752] kvm: disabling virtualization on CPU4
Aug  4 17:50:11 absurd kernel: [  432.499785] smpboot: CPU 4 is now offline
Aug  4 17:50:11 absurd kernel: [  432.500417] intel_pstate CPU 5 exiting
Aug  4 17:50:11 absurd kernel: [  432.502104] kvm: disabling virtualization on CPU5
Aug  4 17:50:11 absurd kernel: [  432.502110] smpboot: CPU 5 is now offline
Aug  4 17:50:11 absurd kernel: [  432.502761] intel_pstate CPU 6 exiting
Aug  4 17:50:11 absurd kernel: [  432.504428] kvm: disabling virtualization on CPU6
Aug  4 17:50:11 absurd kernel: [  432.504441] smpboot: CPU 6 is now offline
Aug  4 17:50:11 absurd kernel: [  432.505487] intel_pstate CPU 7 exiting
Aug  4 17:50:11 absurd kernel: [  432.507079] kvm: disabling virtualization on CPU7
Aug  4 17:50:11 absurd kernel: [  432.507087] smpboot: CPU 7 is now offline
Aug  4 17:50:11 absurd kernel: [  432.508099] intel_pstate CPU 8 exiting
Aug  4 17:50:11 absurd kernel: [  432.509734] kvm: disabling virtualization on CPU8
Aug  4 17:50:11 absurd kernel: [  432.509742] smpboot: CPU 8 is now offline
Aug  4 17:50:11 absurd kernel: [  432.510846] intel_pstate CPU 9 exiting
Aug  4 17:50:11 absurd kernel: [  432.512460] kvm: disabling virtualization on CPU9
Aug  4 17:50:11 absurd kernel: [  432.512479] smpboot: CPU 9 is now offline
Aug  4 17:50:11 absurd kernel: [  432.513477] intel_pstate CPU 10 exiting
Aug  4 17:50:11 absurd kernel: [  432.515090] kvm: disabling virtualization on CPU10
Aug  4 17:50:11 absurd kernel: [  432.615694] smpboot: CPU 10 is now offline
Aug  4 17:50:11 absurd kernel: [  432.616472] intel_pstate CPU 11 exiting
Aug  4 17:50:11 absurd kernel: [  432.618021] kvm: disabling virtualization on CPU11
Aug  4 17:50:11 absurd kernel: [  432.618031] smpboot: CPU 11 is now offline
Aug  4 17:50:11 absurd kernel: [  432.619042] intel_pstate CPU 12 exiting
Aug  4 17:50:11 absurd kernel: [  432.620617] kvm: disabling virtualization on CPU12
Aug  4 17:50:11 absurd kernel: [  432.620636] smpboot: CPU 12 is now offline
Aug  4 17:50:11 absurd kernel: [  432.622174] intel_pstate CPU 13 exiting
Aug  4 17:50:11 absurd kernel: [  432.623880] kvm: disabling virtualization on CPU13
Aug  4 17:50:11 absurd kernel: [  432.623894] smpboot: CPU 13 is now offline
Aug  4 17:50:11 absurd kernel: [  432.625329] intel_pstate CPU 14 exiting
Aug  4 17:50:11 absurd kernel: [  432.627038] kvm: disabling virtualization on CPU14
Aug  4 17:50:11 absurd kernel: [  432.727630] smpboot: CPU 14 is now offline
Aug  4 17:50:11 absurd kernel: [  432.728536] intel_pstate CPU 15 exiting
Aug  4 17:50:11 absurd kernel: [  432.730193] kvm: disabling virtualization on CPU15
Aug  4 17:50:11 absurd kernel: [  432.831571] smpboot: CPU 15 is now offline
Aug  4 17:50:11 absurd kernel: [  432.832174] intel_pstate CPU 16 exiting
Aug  4 17:50:11 absurd kernel: [  432.833755] kvm: disabling virtualization on CPU16
Aug  4 17:50:11 absurd kernel: [  432.935483] smpboot: CPU 16 is now offline
Aug  4 17:50:11 absurd kernel: [  432.935902] intel_pstate CPU 17 exiting
Aug  4 17:50:11 absurd kernel: [  432.937376] kvm: disabling virtualization on CPU17
Aug  4 17:50:11 absurd kernel: [  432.937389] smpboot: CPU 17 is now offline
Aug  4 17:50:11 absurd kernel: [  432.937823] intel_pstate CPU 18 exiting
Aug  4 17:50:11 absurd kernel: [  432.939530] kvm: disabling virtualization on CPU18
Aug  4 17:50:11 absurd kernel: [  432.939554] smpboot: CPU 18 is now offline
Aug  4 17:50:11 absurd kernel: [  432.941311] intel_pstate CPU 19 exiting
Aug  4 17:50:11 absurd kernel: [  432.943250] kvm: disabling virtualization on CPU19
Aug  4 17:50:11 absurd kernel: [  433.043476] smpboot: CPU 19 is now offline
Aug  4 17:50:11 absurd kernel: [  433.044411] intel_pstate CPU 20 exiting
Aug  4 17:50:11 absurd kernel: [  433.046236] kvm: disabling virtualization on CPU20
Aug  4 17:50:11 absurd kernel: [  433.147364] smpboot: CPU 20 is now offline
Aug  4 17:50:11 absurd kernel: [  433.148002] intel_pstate CPU 21 exiting
Aug  4 17:50:11 absurd kernel: [  433.149617] kvm: disabling virtualization on CPU21
Aug  4 17:50:11 absurd kernel: [  433.149639] smpboot: CPU 21 is now offline
Aug  4 17:50:11 absurd kernel: [  433.150142] intel_pstate CPU 22 exiting
Aug  4 17:50:11 absurd kernel: [  433.151718] kvm: disabling virtualization on CPU22
Aug  4 17:50:11 absurd kernel: [  433.151775] smpboot: CPU 22 is now offline
Aug  4 17:50:11 absurd kernel: [  433.153185] intel_pstate CPU 23 exiting
Aug  4 17:50:11 absurd kernel: [  433.154847] kvm: disabling virtualization on CPU23
Aug  4 17:50:11 absurd kernel: [  433.154869] smpboot: CPU 23 is now offline
Aug  4 17:50:11 absurd kernel: [  433.155810] intel_pstate CPU 24 exiting
Aug  4 17:50:11 absurd kernel: [  433.157520] kvm: disabling virtualization on CPU24
Aug  4 17:50:11 absurd kernel: [  433.259310] smpboot: CPU 24 is now offline
Aug  4 17:50:11 absurd kernel: [  433.260346] intel_pstate CPU 25 exiting
Aug  4 17:50:11 absurd kernel: [  433.261905] kvm: disabling virtualization on CPU25
Aug  4 17:50:11 absurd kernel: [  433.363247] smpboot: CPU 25 is now offline
Aug  4 17:50:11 absurd kernel: [  433.364383] intel_pstate CPU 26 exiting
Aug  4 17:50:11 absurd kernel: [  433.365926] kvm: disabling virtualization on CPU26
Aug  4 17:50:11 absurd kernel: [  433.467182] smpboot: CPU 26 is now offline
Aug  4 17:50:11 absurd kernel: [  433.467948] intel_pstate CPU 27 exiting
Aug  4 17:50:11 absurd kernel: [  433.469563] kvm: disabling virtualization on CPU27
Aug  4 17:50:11 absurd kernel: [  433.571130] smpboot: CPU 27 is now offline
Aug  4 17:50:11 absurd kernel: [  433.572346] intel_pstate CPU 28 exiting
Aug  4 17:50:11 absurd kernel: [  433.573938] kvm: disabling virtualization on CPU28
Aug  4 17:50:11 absurd kernel: [  433.675068] smpboot: CPU 28 is now offline
Aug  4 17:50:11 absurd kernel: [  433.676213] intel_pstate CPU 29 exiting
Aug  4 17:50:11 absurd kernel: [  433.677776] kvm: disabling virtualization on CPU29
Aug  4 17:50:11 absurd kernel: [  433.779009] smpboot: CPU 29 is now offline
Aug  4 17:50:11 absurd kernel: [  433.780168] intel_pstate CPU 30 exiting
Aug  4 17:50:11 absurd kernel: [  433.781707] kvm: disabling virtualization on CPU30
Aug  4 17:50:11 absurd kernel: [  433.882944] smpboot: CPU 30 is now offline
Aug  4 17:50:11 absurd kernel: [  433.883715] intel_pstate CPU 31 exiting
Aug  4 17:50:11 absurd kernel: [  433.886644] kvm: disabling virtualization on CPU31
Aug  4 17:50:11 absurd kernel: [  433.986872] smpboot: CPU 31 is now offline
Aug  4 17:50:11 absurd kernel: [  433.988104] PM: Creating hibernation image:
Aug  4 17:50:11 absurd kernel: [  434.669910] PM: Need to copy 397234 pages
Aug  4 17:50:11 absurd kernel: [  434.669912] PM: Normal pages needed: 397234 + 1024, available pages: 16370431
Aug  4 17:50:11 absurd kernel: [  433.994013] Enabling non-boot CPUs ...
Aug  4 17:50:11 absurd kernel: [  433.994285] x86: Booting SMP configuration:
Aug  4 17:50:11 absurd kernel: [  433.994286] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:50:11 absurd kernel: [  434.005994] kvm: enabling virtualization on CPU1
Aug  4 17:50:11 absurd kernel: [  434.008270] Intel pstate controlling: cpu 1
Aug  4 17:50:11 absurd kernel: [  434.008342] CPU1 is up
Aug  4 17:50:11 absurd kernel: [  434.008475] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:50:11 absurd kernel: [  434.020183] kvm: enabling virtualization on CPU2
Aug  4 17:50:11 absurd kernel: [  434.022469] Intel pstate controlling: cpu 2
Aug  4 17:50:11 absurd kernel: [  434.022537] CPU2 is up
Aug  4 17:50:11 absurd kernel: [  434.022675] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:50:11 absurd kernel: [  434.034391] kvm: enabling virtualization on CPU3
Aug  4 17:50:11 absurd kernel: [  434.036649] Intel pstate controlling: cpu 3
Aug  4 17:50:11 absurd kernel: [  434.036715] CPU3 is up
Aug  4 17:50:11 absurd kernel: [  434.036858] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:50:11 absurd kernel: [  434.048556] kvm: enabling virtualization on CPU4
Aug  4 17:50:11 absurd kernel: [  434.050863] Intel pstate controlling: cpu 4
Aug  4 17:50:11 absurd kernel: [  434.050930] CPU4 is up
Aug  4 17:50:11 absurd kernel: [  434.051065] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:50:11 absurd kernel: [  434.062758] kvm: enabling virtualization on CPU5
Aug  4 17:50:11 absurd kernel: [  434.065049] Intel pstate controlling: cpu 5
Aug  4 17:50:11 absurd kernel: [  434.065113] CPU5 is up
Aug  4 17:50:11 absurd kernel: [  434.065251] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:50:11 absurd kernel: [  434.076938] kvm: enabling virtualization on CPU6
Aug  4 17:50:11 absurd kernel: [  434.079233] Intel pstate controlling: cpu 6
Aug  4 17:50:11 absurd kernel: [  434.079296] CPU6 is up
Aug  4 17:50:11 absurd kernel: [  434.079432] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:50:11 absurd kernel: [  434.091114] kvm: enabling virtualization on CPU7
Aug  4 17:50:11 absurd kernel: [  434.093427] Intel pstate controlling: cpu 7
Aug  4 17:50:11 absurd kernel: [  434.093493] CPU7 is up
Aug  4 17:50:11 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 17:50:11 absurd kernel: [  434.093898] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:50:11 absurd kernel: [  434.107203] kvm: enabling virtualization on CPU8
Aug  4 17:50:11 absurd kernel: [  434.127632] Intel pstate controlling: cpu 8
Aug  4 17:50:11 absurd kernel: [  434.127680] CPU8 is up
Aug  4 17:50:11 absurd kernel: [  434.128013] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:50:11 absurd kernel: [  434.141370] kvm: enabling virtualization on CPU9
Aug  4 17:50:11 absurd kernel: [  434.143634] Intel pstate controlling: cpu 9
Aug  4 17:50:11 absurd kernel: [  434.143682] CPU9 is up
Aug  4 17:50:11 absurd kernel: [  434.143934] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:50:11 absurd kernel: [  434.157299] kvm: enabling virtualization on CPU10
Aug  4 17:50:11 absurd kernel: [  434.159559] Intel pstate controlling: cpu 10
Aug  4 17:50:11 absurd kernel: [  434.159611] CPU10 is up
Aug  4 17:50:11 absurd kernel: [  434.159855] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:50:11 absurd kernel: [  434.173235] kvm: enabling virtualization on CPU11
Aug  4 17:50:11 absurd kernel: [  434.175491] Intel pstate controlling: cpu 11
Aug  4 17:50:11 absurd kernel: [  434.175542] CPU11 is up
Aug  4 17:50:11 absurd kernel: [  434.175745] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:50:11 absurd kernel: [  434.189119] kvm: enabling virtualization on CPU12
Aug  4 17:50:11 absurd kernel: [  434.191388] Intel pstate controlling: cpu 12
Aug  4 17:50:11 absurd kernel: [  434.191439] CPU12 is up
Aug  4 17:50:11 absurd kernel: [  434.191612] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:50:11 absurd kernel: [  434.204929] kvm: enabling virtualization on CPU13
Aug  4 17:50:11 absurd kernel: [  434.207261] Intel pstate controlling: cpu 13
Aug  4 17:50:11 absurd kernel: [  434.207312] CPU13 is up
Aug  4 17:50:11 absurd kernel: [  434.207491] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:50:11 absurd kernel: [  434.220807] kvm: enabling virtualization on CPU14
Aug  4 17:50:11 absurd kernel: [  434.223161] Intel pstate controlling: cpu 14
Aug  4 17:50:11 absurd kernel: [  434.223212] CPU14 is up
Aug  4 17:50:11 absurd kernel: [  434.223379] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:50:11 absurd kernel: [  434.236708] kvm: enabling virtualization on CPU15
Aug  4 17:50:11 absurd kernel: [  434.239050] Intel pstate controlling: cpu 15
Aug  4 17:50:11 absurd kernel: [  434.239099] CPU15 is up
Aug  4 17:50:11 absurd kernel: [  434.239229] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:50:11 absurd kernel: [  434.250964] kvm: enabling virtualization on CPU16
Aug  4 17:50:11 absurd kernel: [  434.253455] Intel pstate controlling: cpu 16
Aug  4 17:50:11 absurd kernel: [  434.253523] CPU16 is up
Aug  4 17:50:11 absurd kernel: [  434.253670] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:50:11 absurd kernel: [  434.265368] kvm: enabling virtualization on CPU17
Aug  4 17:50:11 absurd kernel: [  434.267848] Intel pstate controlling: cpu 17
Aug  4 17:50:11 absurd kernel: [  434.267912] CPU17 is up
Aug  4 17:50:11 absurd kernel: [  434.268060] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:50:11 absurd kernel: [  434.279758] kvm: enabling virtualization on CPU18
Aug  4 17:50:11 absurd kernel: [  434.282274] Intel pstate controlling: cpu 18
Aug  4 17:50:11 absurd kernel: [  434.282337] CPU18 is up
Aug  4 17:50:11 absurd kernel: [  434.282486] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:50:11 absurd kernel: [  434.294192] kvm: enabling virtualization on CPU19
Aug  4 17:50:11 absurd kernel: [  434.296715] Intel pstate controlling: cpu 19
Aug  4 17:50:11 absurd kernel: [  434.296777] CPU19 is up
Aug  4 17:50:11 absurd kernel: [  434.296925] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:50:11 absurd kernel: [  434.308617] kvm: enabling virtualization on CPU20
Aug  4 17:50:11 absurd kernel: [  434.311168] Intel pstate controlling: cpu 20
Aug  4 17:50:11 absurd kernel: [  434.311228] CPU20 is up
Aug  4 17:50:11 absurd kernel: [  434.311377] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:50:11 absurd kernel: [  434.323062] kvm: enabling virtualization on CPU21
Aug  4 17:50:11 absurd kernel: [  434.325531] Intel pstate controlling: cpu 21
Aug  4 17:50:11 absurd kernel: [  434.325594] CPU21 is up
Aug  4 17:50:11 absurd kernel: [  434.325741] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:50:11 absurd kernel: [  434.337418] kvm: enabling virtualization on CPU22
Aug  4 17:50:11 absurd kernel: [  434.339990] Intel pstate controlling: cpu 22
Aug  4 17:50:11 absurd kernel: [  434.340054] CPU22 is up
Aug  4 17:50:11 absurd kernel: [  434.340203] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:50:11 absurd kernel: [  434.351875] kvm: enabling virtualization on CPU23
Aug  4 17:50:11 absurd kernel: [  434.354408] Intel pstate controlling: cpu 23
Aug  4 17:50:11 absurd kernel: [  434.354471] CPU23 is up
Aug  4 17:50:11 absurd kernel: [  434.354784] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:50:11 absurd kernel: [  434.368090] kvm: enabling virtualization on CPU24
Aug  4 17:50:11 absurd kernel: [  434.370507] Intel pstate controlling: cpu 24
Aug  4 17:50:11 absurd kernel: [  434.370553] CPU24 is up
Aug  4 17:50:11 absurd kernel: [  434.370745] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:50:11 absurd kernel: [  434.384077] kvm: enabling virtualization on CPU25
Aug  4 17:50:11 absurd kernel: [  434.386534] Intel pstate controlling: cpu 25
Aug  4 17:50:11 absurd kernel: [  434.386579] CPU25 is up
Aug  4 17:50:11 absurd kernel: [  434.386764] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:50:11 absurd kernel: [  434.400114] kvm: enabling virtualization on CPU26
Aug  4 17:50:11 absurd kernel: [  434.402562] Intel pstate controlling: cpu 26
Aug  4 17:50:11 absurd kernel: [  434.402608] CPU26 is up
Aug  4 17:50:11 absurd kernel: [  434.402786] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:50:11 absurd kernel: [  434.416148] kvm: enabling virtualization on CPU27
Aug  4 17:50:11 absurd kernel: [  434.418596] Intel pstate controlling: cpu 27
Aug  4 17:50:11 absurd kernel: [  434.418646] CPU27 is up
Aug  4 17:50:11 absurd kernel: [  434.418819] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:50:11 absurd kernel: [  434.432158] kvm: enabling virtualization on CPU28
Aug  4 17:50:11 absurd kernel: [  434.434646] Intel pstate controlling: cpu 28
Aug  4 17:50:11 absurd kernel: [  434.434692] CPU28 is up
Aug  4 17:50:11 absurd kernel: [  434.434870] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:50:11 absurd kernel: [  434.448174] kvm: enabling virtualization on CPU29
Aug  4 17:50:11 absurd kernel: [  434.450594] Intel pstate controlling: cpu 29
Aug  4 17:50:11 absurd kernel: [  434.450640] CPU29 is up
Aug  4 17:50:11 absurd kernel: [  434.450819] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:50:11 absurd kernel: [  434.464116] kvm: enabling virtualization on CPU30
Aug  4 17:50:11 absurd kernel: [  434.466548] Intel pstate controlling: cpu 30
Aug  4 17:50:11 absurd kernel: [  434.466593] CPU30 is up
Aug  4 17:50:11 absurd kernel: [  434.466769] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:50:11 absurd kernel: [  434.480049] kvm: enabling virtualization on CPU31
Aug  4 17:50:11 absurd kernel: [  434.482540] Intel pstate controlling: cpu 31
Aug  4 17:50:11 absurd kernel: [  434.482585] CPU31 is up
Aug  4 17:50:11 absurd kernel: [  434.588757] PM: noirq restore of devices complete after 16.093 msecs
Aug  4 17:50:11 absurd kernel: [  434.589149] PM: early restore of devices complete after 0.334 msecs
Aug  4 17:50:11 absurd kernel: [  434.748963] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:50:11 absurd kernel: [  434.749080] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:50:11 absurd kernel: [  434.749081] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:50:11 absurd kernel: [  434.749110] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:50:11 absurd kernel: [  434.749151] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:50:11 absurd kernel: [  434.749249] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749255] igb 0000:02:00.1: irq 100 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749264] igb 0000:02:00.1: irq 101 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749269] igb 0000:02:00.1: irq 102 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749275] igb 0000:02:00.1: irq 103 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749281] igb 0000:02:00.1: irq 104 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749286] igb 0000:02:00.1: irq 105 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749292] igb 0000:02:00.1: irq 106 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749298] igb 0000:02:00.1: irq 107 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749327] igb 0000:02:00.0: irq 111 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749333] igb 0000:02:00.0: irq 112 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749342] igb 0000:02:00.0: irq 113 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749348] igb 0000:02:00.0: irq 114 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749357] igb 0000:02:00.0: irq 115 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749363] igb 0000:02:00.0: irq 116 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749368] igb 0000:02:00.0: irq 117 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749376] igb 0000:02:00.0: irq 118 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749382] igb 0000:02:00.0: irq 119 for MSI/MSI-X
Aug  4 17:50:11 absurd kernel: [  434.749570] serial 00:03: activated
Aug  4 17:50:11 absurd kernel: [  434.749895] serial 00:04: activated
Aug  4 17:50:11 absurd kernel: [  434.753054] ------------[ cut here ]------------
Aug  4 17:50:11 absurd kernel: [  434.753061] WARNING: CPU: 30 PID: 7747 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:50:11 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:50:11 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:50:11 absurd kernel: [  434.753094] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj raid1 usb_storage snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel nvidia(PO) kvm joydev hid_generic snd_hda_codec_ca0132 crct10dif_pclmul iTCO_wdt crc32_pclmul iTCO_vendor_support usbhid ghash_clmulni_intel hid mxm_wmi evdev aesni_intel snd_hda_intel aes_x86_64 ablk_helper cryptd glue_helper lrw snd_hda_controller gf128mul snd_hda_codec pcspkr snd_hwdep sb_edac snd_pcm edac_core snd_seq i2c_i801 snd_seq_device snd_timer snd lpc_ich mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler tpm_tis tpm processor wmi thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci libata scsi_transport_sas scsi_mod igb usbcore i2c_a
Aug  4 17:50:11 absurd kernel: lgo_bit usb_common i2c_core dca ptp pps_core [last unloaded: ehci_hcd]
Aug  4 17:50:11 absurd kernel: [  434.753108] CPU: 30 PID: 7747 Comm: kworker/u66:10 Tainted: P        W  O  3.16.0-vanilla.1 #1
Aug  4 17:50:11 absurd kernel: [  434.753108] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:50:11 absurd kernel: [  434.753113] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:50:11 absurd kernel: [  434.753114]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:50:11 absurd kernel: [  434.753115]  ffffffff810664f6 ffffffffa03ff09b ffff88107f46f9e0 ffff88105751aac0
Aug  4 17:50:11 absurd kernel: [  434.753116]  ffff88104d2b7c90 ffff88105796b000 ffffffff813a7d3b ffff881055182200
Aug  4 17:50:11 absurd kernel: [  434.753117] Call Trace:
Aug  4 17:50:11 absurd kernel: [  434.753123]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:50:11 absurd kernel: [  434.753126]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:50:11 absurd kernel: [  434.753129]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:50:11 absurd kernel: [  434.753130]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:50:11 absurd kernel: [  434.753134]  [<ffffffffa03fe03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:50:11 absurd kernel: [  434.753138]  [<ffffffffa02cfe21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:50:11 absurd kernel: [  434.753141]  [<ffffffffa02cff17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:50:11 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:50:11 absurd kernel: [  434.753144]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:50:11 absurd kernel: [  434.753147]  [<ffffffffa02cf951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:50:11 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:50:11 absurd kernel: [  434.753150]  [<ffffffffa02d1776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:50:11 absurd kernel: [  434.753152]  [<ffffffffa03ab070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:50:11 absurd kernel: [  434.753155]  [<ffffffffa0334c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:50:11 absurd kernel: [  434.753157]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:50:11 absurd kernel: [  434.753160]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:50:11 absurd kernel: [  434.753161]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:50:11 absurd kernel: [  434.753163]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:50:11 absurd kernel: [  434.753164]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:50:11 absurd kernel: [  434.753166]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:50:11 absurd kernel: [  434.753167]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:50:11 absurd kernel: [  434.753169]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:50:11 absurd kernel: [  434.753171]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:50:11 absurd kernel: [  434.753172]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:50:11 absurd kernel: [  434.753173]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:50:11 absurd kernel: [  434.753175]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:50:11 absurd kernel: [  434.753176]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:50:11 absurd kernel: [  434.753177] ---[ end trace db395c2b3c067208 ]---
Aug  4 17:50:11 absurd kernel: [  434.753178] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:50:11 absurd kernel: [  435.068261] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:50:11 absurd kernel: [  435.068818] ata1.00: configured for UDMA/133
Aug  4 17:50:11 absurd kernel: [  435.076252] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:50:11 absurd kernel: [  435.084207] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:50:11 absurd kernel: [  435.100237] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:50:11 absurd kernel: [  435.100262] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:50:11 absurd kernel: [  435.101803] ata4.00: configured for UDMA/100
Aug  4 17:50:11 absurd kernel: [  435.103573] ata5.00: configured for UDMA/133
Aug  4 17:50:11 absurd kernel: [  435.105786] ata2.00: configured for UDMA/133
Aug  4 17:50:11 absurd kernel: [  435.152441] PM: restore of devices complete after 403.829 msecs
Aug  4 17:50:11 absurd kernel: [  435.220127] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:50:11 absurd kernel: [  435.231945] ata6.00: configured for UDMA/133
Aug  4 17:50:11 absurd kernel: [  435.358168] Restarting kernel threads ... done.
Aug  4 17:50:11 absurd kernel: [  435.359080] PM: Basic memory bitmaps freed
Aug  4 17:50:11 absurd kernel: [  435.359143] Restarting tasks ... done.
Aug  4 17:50:11 absurd NetworkManager[4243]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:50:11 absurd kernel: [  435.495964] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Aug  4 17:50:11 absurd kernel: [  435.496384] ehci-pci: EHCI PCI platform driver
Aug  4 17:50:11 absurd kernel: [  435.496474] ehci-pci 0000:00:1a.0: EHCI Host Controller
Aug  4 17:50:11 absurd kernel: [  435.496479] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
Aug  4 17:50:11 absurd kernel: [  435.496491] ehci-pci 0000:00:1a.0: debug port 2
Aug  4 17:50:11 absurd kernel: [  435.500381] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:50:11 absurd kernel: [  435.500393] ehci-pci 0000:00:1a.0: irq 16, io mem 0xdf324000
Aug  4 17:50:11 absurd kernel: [  435.511922] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Aug  4 17:50:11 absurd kernel: [  435.511953] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Aug  4 17:50:11 absurd kernel: [  435.511954] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  4 17:50:11 absurd kernel: [  435.511955] usb usb1: Product: EHCI Host Controller
Aug  4 17:50:11 absurd kernel: [  435.511956] usb usb1: Manufacturer: Linux 3.16.0-vanilla.1 ehci_hcd
Aug  4 17:50:11 absurd kernel: [  435.511957] usb usb1: SerialNumber: 0000:00:1a.0
Aug  4 17:50:11 absurd kernel: [  435.512067] hub 1-0:1.0: USB hub found
Aug  4 17:50:11 absurd kernel: [  435.512072] hub 1-0:1.0: 2 ports detected
Aug  4 17:50:11 absurd kernel: [  435.526231] ehci-pci 0000:00:1d.0: EHCI Host Controller
Aug  4 17:50:11 absurd kernel: [  435.526236] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
Aug  4 17:50:11 absurd kernel: [  435.526246] ehci-pci 0000:00:1d.0: debug port 2
Aug  4 17:50:11 absurd kernel: [  435.530150] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:50:11 absurd kernel: [  435.530161] ehci-pci 0000:00:1d.0: irq 23, io mem 0xdf323000
Aug  4 17:50:11 absurd kernel: [  435.539905] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Aug  4 17:50:11 absurd kernel: [  435.539928] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Aug  4 17:50:11 absurd kernel: [  435.539930] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  4 17:50:11 absurd kernel: [  435.539931] usb usb2: Product: EHCI Host Controller
Aug  4 17:50:11 absurd kernel: [  435.539932] usb usb2: Manufacturer: Linux 3.16.0-vanilla.1 ehci_hcd
Aug  4 17:50:11 absurd kernel: [  435.539933] usb usb2: SerialNumber: 0000:00:1d.0
Aug  4 17:50:11 absurd kernel: [  435.540022] hub 2-0:1.0: USB hub found
Aug  4 17:50:11 absurd kernel: [  435.540026] hub 2-0:1.0: 2 ports detected
Aug  4 17:50:11 absurd acpid: client connected from 4432[0:0]
Aug  4 17:50:11 absurd acpid: 1 client rule loaded
Aug  4 17:50:11 absurd acpid: client connected from 4432[0:0]
Aug  4 17:50:11 absurd acpid: 1 client rule loaded
Aug  4 17:50:11 absurd kernel: [  435.823795] usb 1-1: new high-speed USB device number 2 using ehci-pci
Aug  4 17:50:11 absurd acpid: client connected from 4432[0:0]
Aug  4 17:50:11 absurd acpid: 1 client rule loaded
Aug  4 17:50:11 absurd kernel: [  435.956069] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
Aug  4 17:50:11 absurd kernel: [  435.956072] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Aug  4 17:50:11 absurd kernel: [  435.956349] hub 1-1:1.0: USB hub found
Aug  4 17:50:11 absurd kernel: [  435.956411] hub 1-1:1.0: 6 ports detected
Aug  4 17:50:12 absurd kernel: [  436.067660] usb 2-1: new high-speed USB device number 2 using ehci-pci
Aug  4 17:50:12 absurd acpid: client connected from 4432[0:0]
Aug  4 17:50:12 absurd acpid: 1 client rule loaded
Aug  4 17:50:12 absurd kernel: [  436.199897] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
Aug  4 17:50:12 absurd kernel: [  436.199899] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Aug  4 17:50:12 absurd kernel: [  436.200224] hub 2-1:1.0: USB hub found
Aug  4 17:50:12 absurd kernel: [  436.200268] hub 2-1:1.0: 8 ports detected
Aug  4 17:50:12 absurd kernel: [  436.271626] usb 1-1.6: new full-speed USB device number 3 using ehci-pci
Aug  4 17:50:12 absurd kernel: [  436.365085] usb 1-1.6: New USB device found, idVendor=0557, idProduct=2221
Aug  4 17:50:12 absurd kernel: [  436.365090] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Aug  4 17:50:12 absurd kernel: [  436.365092] usb 1-1.6: Product: Hermon USB hidmouse Device
Aug  4 17:50:12 absurd kernel: [  436.365094] usb 1-1.6: Manufacturer: Winbond Electronics Corp
Aug  4 17:50:12 absurd kernel: [  436.366429] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/0003:0557:2221.000A/input/input13
Aug  4 17:50:12 absurd kernel: [  436.366559] hid-generic 0003:0557:2221.000A: input,hidraw0: USB HID v1.00 Mouse [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.6/input0
Aug  4 17:50:12 absurd kernel: [  436.367199] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.1/0003:0557:2221.000B/input/input14
Aug  4 17:50:12 absurd kernel: [  436.367259] hid-generic 0003:0557:2221.000B: input,hidraw1: USB HID v1.00 Keyboard [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.6/input1
Aug  4 17:50:12 absurd mtp-probe: checking bus 1, device 3: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6"
Aug  4 17:50:12 absurd mtp-probe: bus: 1, device: 3 was not an MTP device
Aug  4 17:50:12 absurd kernel: [  436.471492] usb 2-1.1: new high-speed USB device number 3 using ehci-pci
Aug  4 17:50:12 absurd kernel: [  436.565210] usb 2-1.1: New USB device found, idVendor=0bc2, idProduct=3312
Aug  4 17:50:12 absurd kernel: [  436.565213] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 17:50:12 absurd kernel: [  436.565214] usb 2-1.1: Product: Expansion Desk
Aug  4 17:50:12 absurd kernel: [  436.565216] usb 2-1.1: Manufacturer: Seagate 
Aug  4 17:50:12 absurd kernel: [  436.565217] usb 2-1.1: SerialNumber: NA4M6A1L
Aug  4 17:50:12 absurd kernel: [  436.565510] usb-storage 2-1.1:1.0: USB Mass Storage device detected
Aug  4 17:50:12 absurd kernel: [  436.565812] scsi8 : usb-storage 2-1.1:1.0
Aug  4 17:50:12 absurd mtp-probe: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1"
Aug  4 17:50:12 absurd kernel: [  436.635415] usb 2-1.2: new low-speed USB device number 4 using ehci-pci
Aug  4 17:50:12 absurd kernel: [  436.733962] usb 2-1.2: New USB device found, idVendor=0665, idProduct=5161
Aug  4 17:50:12 absurd kernel: [  436.733966] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 17:50:12 absurd kernel: [  436.733969] usb 2-1.2: Product: USB to Serial
Aug  4 17:50:12 absurd kernel: [  436.733971] usb 2-1.2: Manufacturer: INNO TECH
Aug  4 17:50:12 absurd kernel: [  436.733973] usb 2-1.2: SerialNumber: 20100826
Aug  4 17:50:12 absurd kernel: [  436.740146] hid-generic 0003:0665:5161.000C: hiddev0,hidraw2: USB HID v1.00 Device [INNO TECH USB to Serial] on usb-0000:00:1d.0-1.2/input0
Aug  4 17:50:12 absurd mtp-probe: checking bus 2, device 4: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2"
Aug  4 17:50:12 absurd kernel: [  436.811325] usb 2-1.3: new high-speed USB device number 5 using ehci-pci
Aug  4 17:50:12 absurd mtp-probe: bus: 2, device: 3 was not an MTP device
Aug  4 17:50:12 absurd mtp-probe: bus: 2, device: 4 was not an MTP device
Aug  4 17:50:12 absurd kernel: [  436.903772] usb 2-1.3: New USB device found, idVendor=1a40, idProduct=0101
Aug  4 17:50:12 absurd kernel: [  436.903792] usb 2-1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Aug  4 17:50:12 absurd kernel: [  436.903795] usb 2-1.3: Product: USB 2.0 Hub
Aug  4 17:50:12 absurd kernel: [  436.904228] hub 2-1.3:1.0: USB hub found
Aug  4 17:50:12 absurd kernel: [  436.904385] hub 2-1.3:1.0: 4 ports detected
Aug  4 17:50:13 absurd kernel: [  437.175144] usb 2-1.3.1: new high-speed USB device number 6 using ehci-pci
Aug  4 17:50:13 absurd kernel: [  437.267552] usb 2-1.3.1: New USB device found, idVendor=1a40, idProduct=0101
Aug  4 17:50:13 absurd kernel: [  437.267556] usb 2-1.3.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Aug  4 17:50:13 absurd kernel: [  437.267558] usb 2-1.3.1: Product: USB 2.0 Hub
Aug  4 17:50:13 absurd kernel: [  437.267855] hub 2-1.3.1:1.0: USB hub found
Aug  4 17:50:13 absurd kernel: [  437.267897] hub 2-1.3.1:1.0: 4 ports detected
Aug  4 17:50:13 absurd kernel: [  437.355012] usb 2-1.3.3: new full-speed USB device number 7 using ehci-pci
Aug  4 17:50:13 absurd kernel: [  437.468006] usb 2-1.3.3: New USB device found, idVendor=046d, idProduct=c52b
Aug  4 17:50:13 absurd kernel: [  437.468013] usb 2-1.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Aug  4 17:50:13 absurd kernel: [  437.468016] usb 2-1.3.3: Product: USB Receiver
Aug  4 17:50:13 absurd kernel: [  437.468019] usb 2-1.3.3: Manufacturer: Logitech
Aug  4 17:50:13 absurd kernel: [  437.479949] logitech-djreceiver 0003:046D:C52B.000F: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1.3.3/input2
Aug  4 17:50:13 absurd kernel: [  437.537719] input: Logitech Unifying Device. Wireless PID:101b as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3/2-1.3.3:1.2/0003:046D:C52B.000F/0003:046D:C52B.0010/input/input15
Aug  4 17:50:13 absurd kernel: [  437.537935] logitech-djdevice 0003:046D:C52B.0010: input,hidraw4: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:101b] on usb-0000:00:1d.0-1.3.3:1
Aug  4 17:50:13 absurd mtp-probe: checking bus 2, device 7: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3"
Aug  4 17:50:13 absurd mtp-probe: bus: 2, device: 7 was not an MTP device
Aug  4 17:50:13 absurd kernel: [  437.539978] input: Logitech Unifying Device. Wireless PID:2011 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3/2-1.3.3:1.2/0003:046D:C52B.000F/0003:046D:C52B.0011/input/input16
Aug  4 17:50:13 absurd kernel: [  437.540155] logitech-djdevice 0003:046D:C52B.0011: input,hidraw5: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:2011] on usb-0000:00:1d.0-1.3.3:2
Aug  4 17:50:13 absurd kernel: [  437.563813] scsi 8:0:0:0: Direct-Access     Seagate  Expansion Desk   0737 PQ: 0 ANSI: 6
Aug  4 17:50:13 absurd kernel: [  437.564244] sd 8:0:0:0: Attached scsi generic sg5 type 0
Aug  4 17:50:13 absurd kernel: [  437.564861] sd 8:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:50:13 absurd kernel: [  437.565624] sd 8:0:0:0: [sde] Write Protect is off
Aug  4 17:50:13 absurd kernel: [  437.565626] sd 8:0:0:0: [sde] Mode Sense: 2b 00 10 08
Aug  4 17:50:13 absurd kernel: [  437.566395] sd 8:0:0:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
Aug  4 17:50:13 absurd kernel: [  437.567629] sd 8:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:50:14 absurd NetworkManager[4243]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:50:14 absurd kernel: [  438.070857] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 17:50:14 absurd upsd[4451]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 17:50:14 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:16 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:50:16 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="7972" x-info="http://www.rsyslog.com"] start
Aug  4 17:50:16 absurd salomea: ========== resume complete ===========
Aug  4 17:50:17 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:32 router dhcpd: DHCPDISCOVER from 00:25:90:ce:a1:20 via eth0
Aug  4 17:50:33 router dhcpd: DHCPOFFER on 192.168.16.231 to 00:25:90:ce:a1:20 via eth0
Aug  4 17:50:33 router dhcpd: DHCPREQUEST for 192.168.16.231 (192.168.16.1) from 00:25:90:ce:a1:20 via eth0
Aug  4 17:50:33 router dhcpd: DHCPACK on 192.168.16.231 to 00:25:90:ce:a1:20 via eth0
Aug  4 17:50:20 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:20 absurd kernel: [  444.520801]  sde: sde1
Aug  4 17:50:20 absurd kernel: [  444.522034] sd 8:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:50:20 absurd kernel: [  444.523585] sd 8:0:0:0: [sde] Attached SCSI disk
Aug  4 17:50:23 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:26 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:29 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:32 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:35 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_1_success2.txt

Aug  4 17:50:38 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:41 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:44 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:47 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:50 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:53 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:56 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:50:59 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:51:00 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:51:01 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:51:01 absurd kernel: [  485.776612] ehci-pci 0000:00:1d.0: remove, state 1
Aug  4 17:51:01 absurd kernel: [  485.776627] usb usb2: USB disconnect, device number 1
Aug  4 17:51:01 absurd kernel: [  485.776645] usb 2-1: USB disconnect, device number 2
Aug  4 17:51:01 absurd kernel: [  485.776648] usb 2-1.1: USB disconnect, device number 3
Aug  4 17:51:01 absurd kernel: [  485.777593] sd 8:0:0:0: [sde] Synchronizing SCSI cache
Aug  4 17:51:01 absurd kernel: [  485.777647] sd 8:0:0:0: [sde]  
Aug  4 17:51:01 absurd kernel: [  485.777651] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Aug  4 17:51:01 absurd kernel: [  485.778339] usb 2-1.2: USB disconnect, device number 4
Aug  4 17:51:01 absurd kernel: [  485.778956] usb 2-1.3: USB disconnect, device number 5
Aug  4 17:51:01 absurd kernel: [  485.778968] usb 2-1.3.1: USB disconnect, device number 6
Aug  4 17:51:01 absurd kernel: [  485.779436] usb 2-1.3.3: USB disconnect, device number 7
Aug  4 17:51:01 absurd acpid: input device has been disconnected, fd 19
Aug  4 17:51:02 absurd kernel: [  485.973359] ehci-pci 0000:00:1d.0: USB bus 2 deregistered
Aug  4 17:51:02 absurd kernel: [  485.973470] ehci-pci 0000:00:1a.0: remove, state 1
Aug  4 17:51:02 absurd kernel: [  485.973484] usb usb1: USB disconnect, device number 1
Aug  4 17:51:02 absurd kernel: [  485.973487] usb 1-1: USB disconnect, device number 2
Aug  4 17:51:02 absurd kernel: [  485.973491] usb 1-1.6: USB disconnect, device number 3
Aug  4 17:51:02 absurd kernel: [  486.226207] ehci-pci 0000:00:1a.0: USB bus 1 deregistered
Aug  4 17:51:02 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:51:02 absurd kernel: [  486.847778] Syncing filesystems ... done.
Aug  4 17:52:18 absurd kernel: [  486.850015] Freezing user space processes ... (elapsed 0.001 seconds) done.
Aug  4 17:52:18 absurd kernel: [  486.852992] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:52:18 absurd kernel: [  486.853055] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:52:18 absurd kernel: [  486.854124] PM: Basic memory bitmaps created
Aug  4 17:52:18 absurd kernel: [  486.854346] PM: Preallocating image memory... done (allocated 16299534 pages)
Aug  4 17:52:18 absurd kernel: [  492.730918] PM: Allocated 65198136 kbytes in 5.87 seconds (3790.19 MB/s)
Aug  4 17:52:18 absurd kernel: [  492.730982] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:52:18 absurd kernel: [  492.733370] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:52:18 absurd kernel: [  492.734079] serial 00:04: disabled
Aug  4 17:52:18 absurd kernel: [  492.734157] serial 00:03: disabled
Aug  4 17:52:18 absurd kernel: [  492.800881] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:52:18 absurd kernel: [  492.814695] PM: freeze of devices complete after 81.296 msecs
Aug  4 17:52:18 absurd kernel: [  492.815266] PM: late freeze of devices complete after 0.569 msecs
Aug  4 17:52:18 absurd kernel: [  492.817178] PM: noirq freeze of devices complete after 1.912 msecs
Aug  4 17:52:18 absurd kernel: [  492.817179] Disabling non-boot CPUs ...
Aug  4 17:52:18 absurd kernel: [  492.817323] intel_pstate CPU 1 exiting
Aug  4 17:52:18 absurd kernel: [  492.819153] kvm: disabling virtualization on CPU1
Aug  4 17:52:18 absurd kernel: [  492.819851] smpboot: CPU 1 is now offline
Aug  4 17:52:18 absurd kernel: [  492.820401] intel_pstate CPU 2 exiting
Aug  4 17:52:18 absurd kernel: [  492.822435] kvm: disabling virtualization on CPU2
Aug  4 17:52:18 absurd kernel: [  492.822443] smpboot: CPU 2 is now offline
Aug  4 17:52:18 absurd kernel: [  492.823590] intel_pstate CPU 3 exiting
Aug  4 17:52:18 absurd kernel: [  492.825686] kvm: disabling virtualization on CPU3
Aug  4 17:52:18 absurd kernel: [  492.825693] smpboot: CPU 3 is now offline
Aug  4 17:52:18 absurd kernel: [  492.826789] intel_pstate CPU 4 exiting
Aug  4 17:52:18 absurd kernel: [  492.828823] kvm: disabling virtualization on CPU4
Aug  4 17:52:18 absurd kernel: [  492.930576] smpboot: CPU 4 is now offline
Aug  4 17:52:18 absurd kernel: [  492.931154] intel_pstate CPU 5 exiting
Aug  4 17:52:18 absurd kernel: [  492.933077] kvm: disabling virtualization on CPU5
Aug  4 17:52:18 absurd kernel: [  493.034517] smpboot: CPU 5 is now offline
Aug  4 17:52:18 absurd kernel: [  493.035089] intel_pstate CPU 6 exiting
Aug  4 17:52:18 absurd kernel: [  493.036962] kvm: disabling virtualization on CPU6
Aug  4 17:52:18 absurd kernel: [  493.138457] smpboot: CPU 6 is now offline
Aug  4 17:52:18 absurd kernel: [  493.139030] intel_pstate CPU 7 exiting
Aug  4 17:52:18 absurd kernel: [  493.140902] kvm: disabling virtualization on CPU7
Aug  4 17:52:18 absurd kernel: [  493.242396] smpboot: CPU 7 is now offline
Aug  4 17:52:18 absurd kernel: [  493.243498] intel_pstate CPU 8 exiting
Aug  4 17:52:18 absurd kernel: [  493.245287] kvm: disabling virtualization on CPU8
Aug  4 17:52:18 absurd kernel: [  493.246014] smpboot: CPU 8 is now offline
Aug  4 17:52:18 absurd kernel: [  493.246822] intel_pstate CPU 9 exiting
Aug  4 17:52:18 absurd kernel: [  493.248441] kvm: disabling virtualization on CPU9
Aug  4 17:52:18 absurd kernel: [  493.248454] smpboot: CPU 9 is now offline
Aug  4 17:52:18 absurd kernel: [  493.249478] intel_pstate CPU 10 exiting
Aug  4 17:52:18 absurd kernel: [  493.251074] kvm: disabling virtualization on CPU10
Aug  4 17:52:18 absurd kernel: [  493.251091] smpboot: CPU 10 is now offline
Aug  4 17:52:18 absurd kernel: [  493.252394] intel_pstate CPU 11 exiting
Aug  4 17:52:18 absurd kernel: [  493.254056] kvm: disabling virtualization on CPU11
Aug  4 17:52:18 absurd kernel: [  493.254069] smpboot: CPU 11 is now offline
Aug  4 17:52:18 absurd kernel: [  493.255202] intel_pstate CPU 12 exiting
Aug  4 17:52:18 absurd kernel: [  493.256868] kvm: disabling virtualization on CPU12
Aug  4 17:52:18 absurd kernel: [  493.256875] smpboot: CPU 12 is now offline
Aug  4 17:52:18 absurd kernel: [  493.257995] intel_pstate CPU 13 exiting
Aug  4 17:52:18 absurd kernel: [  493.259641] kvm: disabling virtualization on CPU13
Aug  4 17:52:18 absurd kernel: [  493.259648] smpboot: CPU 13 is now offline
Aug  4 17:52:18 absurd kernel: [  493.260751] intel_pstate CPU 14 exiting
Aug  4 17:52:18 absurd kernel: [  493.262358] kvm: disabling virtualization on CPU14
Aug  4 17:52:18 absurd kernel: [  493.362324] smpboot: CPU 14 is now offline
Aug  4 17:52:18 absurd kernel: [  493.363148] intel_pstate CPU 15 exiting
Aug  4 17:52:18 absurd kernel: [  493.364698] kvm: disabling virtualization on CPU15
Aug  4 17:52:18 absurd kernel: [  493.466273] smpboot: CPU 15 is now offline
Aug  4 17:52:18 absurd kernel: [  493.466886] intel_pstate CPU 16 exiting
Aug  4 17:52:18 absurd kernel: [  493.468546] kvm: disabling virtualization on CPU16
Aug  4 17:52:18 absurd kernel: [  493.570199] smpboot: CPU 16 is now offline
Aug  4 17:52:18 absurd kernel: [  493.570707] intel_pstate CPU 17 exiting
Aug  4 17:52:18 absurd kernel: [  493.572719] kvm: disabling virtualization on CPU17
Aug  4 17:52:18 absurd kernel: [  493.572729] smpboot: CPU 17 is now offline
Aug  4 17:52:18 absurd kernel: [  493.573498] intel_pstate CPU 18 exiting
Aug  4 17:52:18 absurd kernel: [  493.575328] kvm: disabling virtualization on CPU18
Aug  4 17:52:18 absurd kernel: [  493.575367] smpboot: CPU 18 is now offline
Aug  4 17:52:18 absurd kernel: [  493.576142] intel_pstate CPU 19 exiting
Aug  4 17:52:18 absurd kernel: [  493.578031] kvm: disabling virtualization on CPU19
Aug  4 17:52:18 absurd kernel: [  493.678157] smpboot: CPU 19 is now offline
Aug  4 17:52:18 absurd kernel: [  493.679033] intel_pstate CPU 20 exiting
Aug  4 17:52:18 absurd kernel: [  493.680843] kvm: disabling virtualization on CPU20
Aug  4 17:52:18 absurd kernel: [  493.782091] smpboot: CPU 20 is now offline
Aug  4 17:52:18 absurd kernel: [  493.782833] intel_pstate CPU 21 exiting
Aug  4 17:52:18 absurd kernel: [  493.784605] kvm: disabling virtualization on CPU21
Aug  4 17:52:18 absurd kernel: [  493.886030] smpboot: CPU 21 is now offline
Aug  4 17:52:18 absurd kernel: [  493.886855] intel_pstate CPU 22 exiting
Aug  4 17:52:18 absurd kernel: [  493.888605] kvm: disabling virtualization on CPU22
Aug  4 17:52:18 absurd kernel: [  493.989968] smpboot: CPU 22 is now offline
Aug  4 17:52:18 absurd kernel: [  493.990722] intel_pstate CPU 23 exiting
Aug  4 17:52:18 absurd kernel: [  493.992441] kvm: disabling virtualization on CPU23
Aug  4 17:52:18 absurd kernel: [  494.093907] smpboot: CPU 23 is now offline
Aug  4 17:52:18 absurd kernel: [  494.095032] intel_pstate CPU 24 exiting
Aug  4 17:52:18 absurd kernel: [  494.096659] kvm: disabling virtualization on CPU24
Aug  4 17:52:18 absurd kernel: [  494.197843] smpboot: CPU 24 is now offline
Aug  4 17:52:18 absurd kernel: [  494.198796] intel_pstate CPU 25 exiting
Aug  4 17:52:18 absurd kernel: [  494.200616] kvm: disabling virtualization on CPU25
Aug  4 17:52:18 absurd kernel: [  494.301794] smpboot: CPU 25 is now offline
Aug  4 17:52:18 absurd kernel: [  494.302933] intel_pstate CPU 26 exiting
Aug  4 17:52:18 absurd kernel: [  494.304582] kvm: disabling virtualization on CPU26
Aug  4 17:52:18 absurd kernel: [  494.304591] smpboot: CPU 26 is now offline
Aug  4 17:52:18 absurd kernel: [  494.305442] intel_pstate CPU 27 exiting
Aug  4 17:52:18 absurd kernel: [  494.307051] kvm: disabling virtualization on CPU27
Aug  4 17:52:18 absurd kernel: [  494.307071] smpboot: CPU 27 is now offline
Aug  4 17:52:18 absurd kernel: [  494.308169] intel_pstate CPU 28 exiting
Aug  4 17:52:18 absurd kernel: [  494.309855] kvm: disabling virtualization on CPU28
Aug  4 17:52:18 absurd kernel: [  494.309889] smpboot: CPU 28 is now offline
Aug  4 17:52:18 absurd kernel: [  494.310956] intel_pstate CPU 29 exiting
Aug  4 17:52:18 absurd kernel: [  494.312590] kvm: disabling virtualization on CPU29
Aug  4 17:52:18 absurd kernel: [  494.312610] smpboot: CPU 29 is now offline
Aug  4 17:52:18 absurd kernel: [  494.313617] intel_pstate CPU 30 exiting
Aug  4 17:52:18 absurd kernel: [  494.315233] kvm: disabling virtualization on CPU30
Aug  4 17:52:18 absurd kernel: [  494.315254] smpboot: CPU 30 is now offline
Aug  4 17:52:18 absurd kernel: [  494.315952] intel_pstate CPU 31 exiting
Aug  4 17:52:18 absurd kernel: [  494.317615] kvm: disabling virtualization on CPU31
Aug  4 17:52:18 absurd kernel: [  494.317909] smpboot: CPU 31 is now offline
Aug  4 17:52:18 absurd kernel: [  494.319258] PM: Creating hibernation image:
Aug  4 17:52:18 absurd kernel: [  495.613679] PM: Need to copy 399128 pages
Aug  4 17:52:18 absurd kernel: [  495.613682] PM: Normal pages needed: 399128 + 1024, available pages: 16368536
Aug  4 17:52:18 absurd kernel: [  494.326011] Enabling non-boot CPUs ...
Aug  4 17:52:18 absurd kernel: [  494.326313] x86: Booting SMP configuration:
Aug  4 17:52:18 absurd kernel: [  494.326315] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:52:18 absurd kernel: [  494.339115] kvm: enabling virtualization on CPU1
Aug  4 17:52:18 absurd kernel: [  494.341412] Intel pstate controlling: cpu 1
Aug  4 17:52:18 absurd kernel: [  494.341483] CPU1 is up
Aug  4 17:52:18 absurd kernel: [  494.341613] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:52:18 absurd kernel: [  494.353325] kvm: enabling virtualization on CPU2
Aug  4 17:52:18 absurd kernel: [  494.355593] Intel pstate controlling: cpu 2
Aug  4 17:52:18 absurd kernel: [  494.355659] CPU2 is up
Aug  4 17:52:18 absurd kernel: [  494.355796] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:52:18 absurd kernel: [  494.367511] kvm: enabling virtualization on CPU3
Aug  4 17:52:18 absurd kernel: [  494.369786] Intel pstate controlling: cpu 3
Aug  4 17:52:18 absurd kernel: [  494.369852] CPU3 is up
Aug  4 17:52:18 absurd kernel: [  494.369983] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:52:18 absurd kernel: [  494.381680] kvm: enabling virtualization on CPU4
Aug  4 17:52:18 absurd kernel: [  494.383949] Intel pstate controlling: cpu 4
Aug  4 17:52:18 absurd kernel: [  494.384015] CPU4 is up
Aug  4 17:52:18 absurd kernel: [  494.384153] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:52:18 absurd kernel: [  494.395844] kvm: enabling virtualization on CPU5
Aug  4 17:52:18 absurd kernel: [  494.398132] Intel pstate controlling: cpu 5
Aug  4 17:52:18 absurd kernel: [  494.398199] CPU5 is up
Aug  4 17:52:18 absurd kernel: [  494.398338] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:52:18 absurd kernel: [  494.410026] kvm: enabling virtualization on CPU6
Aug  4 17:52:18 absurd kernel: [  494.412324] Intel pstate controlling: cpu 6
Aug  4 17:52:18 absurd kernel: [  494.412390] CPU6 is up
Aug  4 17:52:18 absurd kernel: [  494.412537] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:52:18 absurd kernel: [  494.424218] kvm: enabling virtualization on CPU7
Aug  4 17:52:18 absurd kernel: [  494.426534] Intel pstate controlling: cpu 7
Aug  4 17:52:18 absurd kernel: [  494.426602] CPU7 is up
Aug  4 17:52:18 absurd kernel: [  494.427005] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:52:18 absurd kernel: [  494.440310] kvm: enabling virtualization on CPU8
Aug  4 17:52:18 absurd kernel: [  494.460741] Intel pstate controlling: cpu 8
Aug  4 17:52:18 absurd kernel: [  494.460791] CPU8 is up
Aug  4 17:52:18 absurd kernel: [  494.461123] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:52:18 absurd kernel: [  494.474481] kvm: enabling virtualization on CPU9
Aug  4 17:52:18 absurd kernel: [  494.476763] Intel pstate controlling: cpu 9
Aug  4 17:52:18 absurd kernel: [  494.476815] CPU9 is up
Aug  4 17:52:18 absurd kernel: [  494.477078] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:52:18 absurd kernel: [  494.490464] kvm: enabling virtualization on CPU10
Aug  4 17:52:18 absurd kernel: [  494.492707] Intel pstate controlling: cpu 10
Aug  4 17:52:18 absurd kernel: [  494.492756] CPU10 is up
Aug  4 17:52:18 absurd kernel: [  494.493002] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:52:18 absurd kernel: [  494.506382] kvm: enabling virtualization on CPU11
Aug  4 17:52:18 absurd kernel: [  494.508640] Intel pstate controlling: cpu 11
Aug  4 17:52:18 absurd kernel: [  494.508689] CPU11 is up
Aug  4 17:52:18 absurd kernel: [  494.508886] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:52:18 absurd kernel: [  494.522262] kvm: enabling virtualization on CPU12
Aug  4 17:52:18 absurd kernel: [  494.524532] Intel pstate controlling: cpu 12
Aug  4 17:52:18 absurd kernel: [  494.524582] CPU12 is up
Aug  4 17:52:18 absurd kernel: [  494.524767] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:52:18 absurd kernel: [  494.538090] kvm: enabling virtualization on CPU13
Aug  4 17:52:18 absurd kernel: [  494.540433] Intel pstate controlling: cpu 13
Aug  4 17:52:18 absurd kernel: [  494.540485] CPU13 is up
Aug  4 17:52:18 absurd kernel: [  494.540659] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:52:18 absurd kernel: [  494.553974] kvm: enabling virtualization on CPU14
Aug  4 17:52:18 absurd kernel: [  494.556327] Intel pstate controlling: cpu 14
Aug  4 17:52:18 absurd kernel: [  494.556381] CPU14 is up
Aug  4 17:52:18 absurd kernel: [  494.556565] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:52:18 absurd kernel: [  494.569871] kvm: enabling virtualization on CPU15
Aug  4 17:52:18 absurd kernel: [  494.572146] Intel pstate controlling: cpu 15
Aug  4 17:52:18 absurd kernel: [  494.572194] CPU15 is up
Aug  4 17:52:18 absurd kernel: [  494.572325] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:52:18 absurd kernel: [  494.584064] kvm: enabling virtualization on CPU16
Aug  4 17:52:18 absurd kernel: [  494.586551] Intel pstate controlling: cpu 16
Aug  4 17:52:18 absurd kernel: [  494.586619] CPU16 is up
Aug  4 17:52:18 absurd kernel: [  494.586772] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:52:18 absurd kernel: [  494.598467] kvm: enabling virtualization on CPU17
Aug  4 17:52:18 absurd kernel: [  494.600974] Intel pstate controlling: cpu 17
Aug  4 17:52:18 absurd kernel: [  494.601041] CPU17 is up
Aug  4 17:52:18 absurd kernel: [  494.601190] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:52:18 absurd kernel: [  494.612887] kvm: enabling virtualization on CPU18
Aug  4 17:52:18 absurd kernel: [  494.615403] Intel pstate controlling: cpu 18
Aug  4 17:52:18 absurd kernel: [  494.615468] CPU18 is up
Aug  4 17:52:18 absurd kernel: [  494.615618] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:52:18 absurd kernel: [  494.627324] kvm: enabling virtualization on CPU19
Aug  4 17:52:18 absurd kernel: [  494.629850] Intel pstate controlling: cpu 19
Aug  4 17:52:18 absurd kernel: [  494.629917] CPU19 is up
Aug  4 17:52:18 absurd kernel: [  494.630068] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:52:18 absurd kernel: [  494.641759] kvm: enabling virtualization on CPU20
Aug  4 17:52:18 absurd kernel: [  494.644315] Intel pstate controlling: cpu 20
Aug  4 17:52:18 absurd kernel: [  494.644391] CPU20 is up
Aug  4 17:52:18 absurd kernel: [  494.644542] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:52:18 absurd kernel: [  494.656225] kvm: enabling virtualization on CPU21
Aug  4 17:52:18 absurd kernel: [  494.658707] Intel pstate controlling: cpu 21
Aug  4 17:52:18 absurd kernel: [  494.658772] CPU21 is up
Aug  4 17:52:18 absurd kernel: [  494.658915] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:52:18 absurd kernel: [  494.670596] kvm: enabling virtualization on CPU22
Aug  4 17:52:18 absurd kernel: [  494.673093] Intel pstate controlling: cpu 22
Aug  4 17:52:18 absurd kernel: [  494.673156] CPU22 is up
Aug  4 17:52:18 absurd kernel: [  494.673304] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:52:18 absurd kernel: [  494.684976] kvm: enabling virtualization on CPU23
Aug  4 17:52:18 absurd kernel: [  494.687566] Intel pstate controlling: cpu 23
Aug  4 17:52:18 absurd kernel: [  494.687636] CPU23 is up
Aug  4 17:52:18 absurd kernel: [  494.687945] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:52:18 absurd kernel: [  494.701249] kvm: enabling virtualization on CPU24
Aug  4 17:52:18 absurd kernel: [  494.703721] Intel pstate controlling: cpu 24
Aug  4 17:52:18 absurd kernel: [  494.703767] CPU24 is up
Aug  4 17:52:18 absurd kernel: [  494.703955] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:52:18 absurd kernel: [  494.717289] kvm: enabling virtualization on CPU25
Aug  4 17:52:18 absurd kernel: [  494.719747] Intel pstate controlling: cpu 25
Aug  4 17:52:18 absurd kernel: [  494.719795] CPU25 is up
Aug  4 17:52:18 absurd kernel: [  494.719976] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:52:18 absurd kernel: [  494.733349] kvm: enabling virtualization on CPU26
Aug  4 17:52:18 absurd kernel: [  494.735768] Intel pstate controlling: cpu 26
Aug  4 17:52:18 absurd kernel: [  494.735815] CPU26 is up
Aug  4 17:52:18 absurd kernel: [  494.735997] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:52:18 absurd kernel: [  494.749360] kvm: enabling virtualization on CPU27
Aug  4 17:52:18 absurd kernel: [  494.751797] Intel pstate controlling: cpu 27
Aug  4 17:52:18 absurd kernel: [  494.751845] CPU27 is up
Aug  4 17:52:18 absurd kernel: [  494.752027] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:52:18 absurd kernel: [  494.765385] kvm: enabling virtualization on CPU28
Aug  4 17:52:18 absurd kernel: [  494.767839] Intel pstate controlling: cpu 28
Aug  4 17:52:18 absurd kernel: [  494.767887] CPU28 is up
Aug  4 17:52:18 absurd kernel: [  494.768065] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:52:18 absurd kernel: [  494.781366] kvm: enabling virtualization on CPU29
Aug  4 17:52:18 absurd kernel: [  494.783785] Intel pstate controlling: cpu 29
Aug  4 17:52:18 absurd kernel: [  494.783836] CPU29 is up
Aug  4 17:52:18 absurd kernel: [  494.784009] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:52:18 absurd kernel: [  494.797306] kvm: enabling virtualization on CPU30
Aug  4 17:52:18 absurd kernel: [  494.799745] Intel pstate controlling: cpu 30
Aug  4 17:52:18 absurd kernel: [  494.799793] CPU30 is up
Aug  4 17:52:18 absurd kernel: [  494.799972] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:52:18 absurd kernel: [  494.813282] kvm: enabling virtualization on CPU31
Aug  4 17:52:18 absurd kernel: [  494.815740] Intel pstate controlling: cpu 31
Aug  4 17:52:18 absurd kernel: [  494.815787] CPU31 is up
Aug  4 17:52:18 absurd kernel: [  494.920501] PM: noirq restore of devices complete after 14.861 msecs
Aug  4 17:52:18 absurd kernel: [  494.920891] PM: early restore of devices complete after 0.331 msecs
Aug  4 17:52:18 absurd kernel: [  495.080636] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:52:18 absurd kernel: [  495.080747] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:52:18 absurd kernel: [  495.080748] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:52:18 absurd kernel: [  495.080749] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:52:18 absurd kernel: [  495.080750] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:52:18 absurd kernel: [  495.080939] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.080940] igb 0000:02:00.0: irq 100 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.080950] igb 0000:02:00.1: irq 101 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.080952] igb 0000:02:00.0: irq 102 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.080958] igb 0000:02:00.1: irq 103 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.080960] igb 0000:02:00.0: irq 104 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.080965] igb 0000:02:00.1: irq 105 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.080968] igb 0000:02:00.0: irq 106 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.080973] igb 0000:02:00.1: irq 107 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.080978] igb 0000:02:00.0: irq 111 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.080980] igb 0000:02:00.1: irq 112 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.080988] igb 0000:02:00.0: irq 113 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.080990] igb 0000:02:00.1: irq 114 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.080998] igb 0000:02:00.0: irq 115 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.081001] igb 0000:02:00.1: irq 116 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.081006] igb 0000:02:00.0: irq 117 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.081008] igb 0000:02:00.1: irq 118 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.081014] igb 0000:02:00.0: irq 119 for MSI/MSI-X
Aug  4 17:52:18 absurd kernel: [  495.081262] serial 00:03: activated
Aug  4 17:52:18 absurd kernel: [  495.081587] serial 00:04: activated
Aug  4 17:52:18 absurd kernel: [  495.084738] ------------[ cut here ]------------
Aug  4 17:52:18 absurd kernel: [  495.084744] WARNING: CPU: 10 PID: 8647 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:52:18 absurd kernel: [  495.084778] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj raid1 usb_storage snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel nvidia(PO) kvm joydev hid_generic snd_hda_codec_ca0132 crct10dif_pclmul iTCO_wdt crc32_pclmul iTCO_vendor_support usbhid ghash_clmulni_intel hid mxm_wmi evdev aesni_intel snd_hda_intel aes_x86_64 ablk_helper cryptd glue_helper lrw snd_hda_controller gf128mul snd_hda_codec pcspkr snd_hwdep sb_edac snd_pcm edac_core snd_seq i2c_i801 snd_seq_device snd_timer snd lpc_ich mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler tpm_tis tpm processor wmi thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci libata scsi_transport_sas scsi_mod igb usbcore i2c_a
Aug  4 17:52:18 absurd kernel: lgo_bit usb_common i2c_core dca ptp pps_core [last unloaded: ehci_hcd]
Aug  4 17:52:18 absurd kernel: [  495.084791] CPU: 10 PID: 8647 Comm: kworker/u66:12 Tainted: P        W  O  3.16.0-vanilla.1 #1
Aug  4 17:52:18 absurd kernel: [  495.084792] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:52:18 absurd kernel: [  495.084796] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:52:18 absurd kernel: [  495.084798]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:52:18 absurd kernel: [  495.084799]  ffffffff810664f6 ffffffffa03ff09b ffff88107f46fa60 ffff8810558cf040
Aug  4 17:52:18 absurd kernel: [  495.084800]  ffff88104d2b7c90 ffff88105796b000 ffffffff813a7d3b ffff881055182200
Aug  4 17:52:18 absurd kernel: [  495.084800] Call Trace:
Aug  4 17:52:18 absurd kernel: [  495.084806]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:52:18 absurd kernel: [  495.084810]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:52:18 absurd kernel: [  495.084812]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:52:18 absurd kernel: [  495.084814]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:52:18 absurd kernel: [  495.084817]  [<ffffffffa03fe03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:52:18 absurd kernel: [  495.084821]  [<ffffffffa02cfe21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:52:18 absurd kernel: [  495.084824]  [<ffffffffa02cff17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:52:18 absurd kernel: [  495.084828]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:52:18 absurd kernel: [  495.084830]  [<ffffffffa02cf951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:52:18 absurd kernel: [  495.084833]  [<ffffffffa02d1776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:52:18 absurd kernel: [  495.084836]  [<ffffffffa03ab070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:52:18 absurd kernel: [  495.084838]  [<ffffffffa0334c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:52:18 absurd kernel: [  495.084842]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:52:18 absurd kernel: [  495.084844]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:52:18 absurd kernel: [  495.084846]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:52:18 absurd kernel: [  495.084847]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:52:18 absurd kernel: [  495.084848]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:52:18 absurd kernel: [  495.084851]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:52:18 absurd kernel: [  495.084852]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:52:18 absurd kernel: [  495.084855]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:52:18 absurd kernel: [  495.084856]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:52:18 absurd kernel: [  495.084857]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:52:18 absurd kernel: [  495.084859]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:52:18 absurd kernel: [  495.084860]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:52:18 absurd kernel: [  495.084861]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:52:18 absurd kernel: [  495.084862] ---[ end trace db395c2b3c067209 ]---
Aug  4 17:52:18 absurd kernel: [  495.084863] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:52:18 absurd kernel: [  495.415977] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:52:18 absurd kernel: [  495.419406] ata5.00: configured for UDMA/133
Aug  4 17:52:18 absurd kernel: [  495.431970] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:52:18 absurd kernel: [  495.431998] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:52:18 absurd kernel: [  495.432028] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:52:18 absurd kernel: [  495.433708] ata4.00: configured for UDMA/100
Aug  4 17:52:18 absurd kernel: [  495.439962] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:52:18 absurd kernel: [  495.440489] ata1.00: configured for UDMA/133
Aug  4 17:52:18 absurd kernel: [  495.453900] ata2.00: configured for UDMA/133
Aug  4 17:52:18 absurd kernel: [  495.480200] PM: restore of devices complete after 399.915 msecs
Aug  4 17:52:18 absurd kernel: [  495.543831] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:52:18 absurd kernel: [  495.554038] ata6.00: configured for UDMA/133
Aug  4 17:52:18 absurd kernel: [  495.687240] Restarting kernel threads ... done.
Aug  4 17:52:18 absurd kernel: [  495.688219] PM: Basic memory bitmaps freed
Aug  4 17:52:18 absurd kernel: [  495.688282] Restarting tasks ... done.
Aug  4 17:52:18 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:52:18 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:52:18 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:52:18 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:52:18 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 17:52:18 absurd upsmon[4479]: UPS duo2pro@localhost is unavailable
Aug  4 17:52:18 absurd NetworkManager[4243]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:52:18 absurd kernel: [  495.832143] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Aug  4 17:52:18 absurd kernel: [  495.832743] ehci-pci: EHCI PCI platform driver
Aug  4 17:52:18 absurd kernel: [  495.832861] ehci-pci 0000:00:1a.0: EHCI Host Controller
Aug  4 17:52:18 absurd kernel: [  495.832870] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
Aug  4 17:52:18 absurd kernel: [  495.832884] ehci-pci 0000:00:1a.0: debug port 2
Aug  4 17:52:18 absurd kernel: [  495.836775] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:52:18 absurd kernel: [  495.836790] ehci-pci 0000:00:1a.0: irq 16, io mem 0xdf324000
Aug  4 17:52:18 absurd kernel: [  495.847636] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Aug  4 17:52:18 absurd kernel: [  495.847668] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Aug  4 17:52:18 absurd kernel: [  495.847669] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  4 17:52:18 absurd kernel: [  495.847671] usb usb1: Product: EHCI Host Controller
Aug  4 17:52:18 absurd kernel: [  495.847672] usb usb1: Manufacturer: Linux 3.16.0-vanilla.1 ehci_hcd
Aug  4 17:52:18 absurd kernel: [  495.847673] usb usb1: SerialNumber: 0000:00:1a.0
Aug  4 17:52:18 absurd kernel: [  495.847803] hub 1-0:1.0: USB hub found
Aug  4 17:52:18 absurd kernel: [  495.847808] hub 1-0:1.0: 2 ports detected
Aug  4 17:52:18 absurd kernel: [  495.864338] ehci-pci 0000:00:1d.0: EHCI Host Controller
Aug  4 17:52:18 absurd kernel: [  495.864343] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
Aug  4 17:52:18 absurd kernel: [  495.864353] ehci-pci 0000:00:1d.0: debug port 2
Aug  4 17:52:18 absurd kernel: [  495.868250] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:52:18 absurd kernel: [  495.868259] ehci-pci 0000:00:1d.0: irq 23, io mem 0xdf323000
Aug  4 17:52:18 absurd kernel: [  495.879638] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Aug  4 17:52:18 absurd kernel: [  495.879661] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Aug  4 17:52:18 absurd kernel: [  495.879663] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  4 17:52:18 absurd kernel: [  495.879664] usb usb2: Product: EHCI Host Controller
Aug  4 17:52:18 absurd kernel: [  495.879665] usb usb2: Manufacturer: Linux 3.16.0-vanilla.1 ehci_hcd
Aug  4 17:52:18 absurd kernel: [  495.879666] usb usb2: SerialNumber: 0000:00:1d.0
Aug  4 17:52:18 absurd kernel: [  495.879826] hub 2-0:1.0: USB hub found
Aug  4 17:52:18 absurd kernel: [  495.879840] hub 2-0:1.0: 2 ports detected
Aug  4 17:52:18 absurd acpid: client connected from 4432[0:0]
Aug  4 17:52:18 absurd acpid: 1 client rule loaded
Aug  4 17:52:18 absurd acpid: client connected from 4432[0:0]
Aug  4 17:52:18 absurd acpid: 1 client rule loaded
Aug  4 17:52:18 absurd kernel: [  496.159558] usb 1-1: new high-speed USB device number 2 using ehci-pci
Aug  4 17:52:18 absurd acpid: client connected from 4432[0:0]
Aug  4 17:52:18 absurd acpid: 1 client rule loaded
Aug  4 17:52:18 absurd kernel: [  496.291881] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
Aug  4 17:52:18 absurd kernel: [  496.291887] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Aug  4 17:52:18 absurd kernel: [  496.292378] hub 1-1:1.0: USB hub found
Aug  4 17:52:18 absurd kernel: [  496.292440] hub 1-1:1.0: 6 ports detected
Aug  4 17:52:19 absurd kernel: [  496.403406] usb 2-1: new high-speed USB device number 2 using ehci-pci
Aug  4 17:52:19 absurd acpid: client connected from 4432[0:0]
Aug  4 17:52:19 absurd acpid: 1 client rule loaded
Aug  4 17:52:19 absurd kernel: [  496.535729] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
Aug  4 17:52:19 absurd kernel: [  496.535736] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Aug  4 17:52:19 absurd kernel: [  496.536135] hub 2-1:1.0: USB hub found
Aug  4 17:52:19 absurd kernel: [  496.536297] hub 2-1:1.0: 8 ports detected
Aug  4 17:52:19 absurd kernel: [  496.607443] usb 1-1.6: new full-speed USB device number 3 using ehci-pci
Aug  4 17:52:19 absurd kernel: [  496.700850] usb 1-1.6: New USB device found, idVendor=0557, idProduct=2221
Aug  4 17:52:19 absurd kernel: [  496.700853] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Aug  4 17:52:19 absurd kernel: [  496.700855] usb 1-1.6: Product: Hermon USB hidmouse Device
Aug  4 17:52:19 absurd kernel: [  496.700856] usb 1-1.6: Manufacturer: Winbond Electronics Corp
Aug  4 17:52:19 absurd kernel: [  496.702108] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/0003:0557:2221.0012/input/input17
Aug  4 17:52:19 absurd kernel: [  496.702411] hid-generic 0003:0557:2221.0012: input,hidraw0: USB HID v1.00 Mouse [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.6/input0
Aug  4 17:52:19 absurd kernel: [  496.703206] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.1/0003:0557:2221.0013/input/input18
Aug  4 17:52:19 absurd kernel: [  496.703313] hid-generic 0003:0557:2221.0013: input,hidraw1: USB HID v1.00 Keyboard [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.6/input1
Aug  4 17:52:19 absurd mtp-probe: checking bus 1, device 3: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6"
Aug  4 17:52:19 absurd mtp-probe: bus: 1, device: 3 was not an MTP device
Aug  4 17:52:19 absurd kernel: [  496.807303] usb 2-1.1: new high-speed USB device number 3 using ehci-pci
Aug  4 17:52:19 absurd kernel: [  496.901257] usb 2-1.1: New USB device found, idVendor=0bc2, idProduct=3312
Aug  4 17:52:19 absurd kernel: [  496.901276] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 17:52:19 absurd kernel: [  496.901279] usb 2-1.1: Product: Expansion Desk
Aug  4 17:52:19 absurd kernel: [  496.901281] usb 2-1.1: Manufacturer: Seagate 
Aug  4 17:52:19 absurd kernel: [  496.901283] usb 2-1.1: SerialNumber: NA4M6A1L
Aug  4 17:52:19 absurd kernel: [  496.901693] usb-storage 2-1.1:1.0: USB Mass Storage device detected
Aug  4 17:52:19 absurd kernel: [  496.901963] scsi9 : usb-storage 2-1.1:1.0
Aug  4 17:52:19 absurd mtp-probe: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1"
Aug  4 17:52:19 absurd kernel: [  496.971222] usb 2-1.2: new low-speed USB device number 4 using ehci-pci
Aug  4 17:52:19 absurd kernel: [  497.069762] usb 2-1.2: New USB device found, idVendor=0665, idProduct=5161
Aug  4 17:52:19 absurd kernel: [  497.069767] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 17:52:19 absurd kernel: [  497.069770] usb 2-1.2: Product: USB to Serial
Aug  4 17:52:19 absurd kernel: [  497.069772] usb 2-1.2: Manufacturer: INNO TECH
Aug  4 17:52:19 absurd kernel: [  497.069774] usb 2-1.2: SerialNumber: 20100826
Aug  4 17:52:19 absurd kernel: [  497.076726] hid-generic 0003:0665:5161.0014: hiddev0,hidraw2: USB HID v1.00 Device [INNO TECH USB to Serial] on usb-0000:00:1d.0-1.2/input0
Aug  4 17:52:19 absurd mtp-probe: checking bus 2, device 4: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2"
Aug  4 17:52:19 absurd kernel: [  497.147140] usb 2-1.3: new high-speed USB device number 5 using ehci-pci
Aug  4 17:52:19 absurd mtp-probe: bus: 2, device: 3 was not an MTP device
Aug  4 17:52:19 absurd mtp-probe: bus: 2, device: 4 was not an MTP device
Aug  4 17:52:19 absurd kernel: [  497.239930] usb 2-1.3: New USB device found, idVendor=1a40, idProduct=0101
Aug  4 17:52:19 absurd kernel: [  497.239936] usb 2-1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Aug  4 17:52:19 absurd kernel: [  497.239940] usb 2-1.3: Product: USB 2.0 Hub
Aug  4 17:52:19 absurd kernel: [  497.240393] hub 2-1.3:1.0: USB hub found
Aug  4 17:52:19 absurd kernel: [  497.240566] hub 2-1.3:1.0: 4 ports detected
Aug  4 17:52:20 absurd kernel: [  497.510950] usb 2-1.3.1: new high-speed USB device number 6 using ehci-pci
Aug  4 17:52:20 absurd kernel: [  497.603640] usb 2-1.3.1: New USB device found, idVendor=1a40, idProduct=0101
Aug  4 17:52:20 absurd kernel: [  497.603647] usb 2-1.3.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Aug  4 17:52:20 absurd kernel: [  497.603650] usb 2-1.3.1: Product: USB 2.0 Hub
Aug  4 17:52:20 absurd kernel: [  497.604083] hub 2-1.3.1:1.0: USB hub found
Aug  4 17:52:20 absurd kernel: [  497.604265] hub 2-1.3.1:1.0: 4 ports detected
Aug  4 17:52:20 absurd kernel: [  497.690808] usb 2-1.3.3: new full-speed USB device number 7 using ehci-pci
Aug  4 17:52:20 absurd kernel: [  497.803548] usb 2-1.3.3: New USB device found, idVendor=046d, idProduct=c52b
Aug  4 17:52:20 absurd kernel: [  497.803568] usb 2-1.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Aug  4 17:52:20 absurd kernel: [  497.803571] usb 2-1.3.3: Product: USB Receiver
Aug  4 17:52:20 absurd kernel: [  497.803573] usb 2-1.3.3: Manufacturer: Logitech
Aug  4 17:52:20 absurd kernel: [  497.815348] logitech-djreceiver 0003:046D:C52B.0017: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1.3.3/input2
Aug  4 17:52:20 absurd kernel: [  497.872320] input: Logitech Unifying Device. Wireless PID:101b as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3/2-1.3.3:1.2/0003:046D:C52B.0017/0003:046D:C52B.0018/input/input19
Aug  4 17:52:20 absurd kernel: [  497.872528] logitech-djdevice 0003:046D:C52B.0018: input,hidraw4: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:101b] on usb-0000:00:1d.0-1.3.3:1
Aug  4 17:52:20 absurd kernel: [  497.874400] input: Logitech Unifying Device. Wireless PID:2011 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3/2-1.3.3:1.2/0003:046D:C52B.0017/0003:046D:C52B.0019/input/input20
Aug  4 17:52:20 absurd mtp-probe: checking bus 2, device 7: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3"
Aug  4 17:52:20 absurd mtp-probe: bus: 2, device: 7 was not an MTP device
Aug  4 17:52:20 absurd kernel: [  497.874599] logitech-djdevice 0003:046D:C52B.0019: input,hidraw5: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:2011] on usb-0000:00:1d.0-1.3.3:2
Aug  4 17:52:20 absurd kernel: [  497.899570] scsi 9:0:0:0: Direct-Access     Seagate  Expansion Desk   0737 PQ: 0 ANSI: 6
Aug  4 17:52:20 absurd kernel: [  497.900576] sd 9:0:0:0: Attached scsi generic sg5 type 0
Aug  4 17:52:20 absurd kernel: [  497.901069] sd 9:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:52:20 absurd kernel: [  497.901825] sd 9:0:0:0: [sde] Write Protect is off
Aug  4 17:52:20 absurd kernel: [  497.901834] sd 9:0:0:0: [sde] Mode Sense: 2b 00 10 08
Aug  4 17:52:20 absurd kernel: [  497.902604] sd 9:0:0:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
Aug  4 17:52:20 absurd kernel: [  497.903512] sd 9:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:52:21 absurd NetworkManager[4243]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:52:21 absurd kernel: [  498.414542] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 17:52:21 absurd upsd[4451]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 17:52:21 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:52:34 router kernel: [612079.512017] eth1: no IPv6 routers present
Aug  4 17:52:34 router kernel: [612079.512017] eth1: no IPv6 routers present
Aug  4 17:52:23 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:52:23 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="8887" x-info="http://www.rsyslog.com"] start
Aug  4 17:52:23 absurd salomea: ========== resume complete ===========
Aug  4 17:52:24 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:52:27 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:52:27 absurd kernel: [  504.843709]  sde: sde1
Aug  4 17:52:27 absurd kernel: [  504.845071] sd 9:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:52:27 absurd kernel: [  504.846738] sd 9:0:0:0: [sde] Attached SCSI disk
Aug  4 17:52:30 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:52:33 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:52:36 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:52:39 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_1_success3.txt

ug  4 17:52:45 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:52:48 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:52:51 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:52:54 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:52:57 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:52:59 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:53:00 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:53:00 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:53:00 absurd kernel: [  537.868163] ehci-pci 0000:00:1d.0: remove, state 1
Aug  4 17:53:00 absurd kernel: [  537.868189] usb usb2: USB disconnect, device number 1
Aug  4 17:53:00 absurd kernel: [  537.868193] usb 2-1: USB disconnect, device number 2
Aug  4 17:53:00 absurd kernel: [  537.868195] usb 2-1.1: USB disconnect, device number 3
Aug  4 17:53:00 absurd kernel: [  537.869005] sd 9:0:0:0: [sde] Synchronizing SCSI cache
Aug  4 17:53:00 absurd kernel: [  537.869045] sd 9:0:0:0: [sde]  
Aug  4 17:53:00 absurd kernel: [  537.869048] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Aug  4 17:53:00 absurd kernel: [  537.869629] usb 2-1.2: USB disconnect, device number 4
Aug  4 17:53:00 absurd kernel: [  537.870144] usb 2-1.3: USB disconnect, device number 5
Aug  4 17:53:00 absurd kernel: [  537.870152] usb 2-1.3.1: USB disconnect, device number 6
Aug  4 17:53:00 absurd kernel: [  537.870506] usb 2-1.3.3: USB disconnect, device number 7
Aug  4 17:53:00 absurd acpid: input device has been disconnected, fd 19
Aug  4 17:53:00 absurd kernel: [  538.062591] ehci-pci 0000:00:1d.0: USB bus 2 deregistered
Aug  4 17:53:00 absurd kernel: [  538.062697] ehci-pci 0000:00:1a.0: remove, state 1
Aug  4 17:53:00 absurd kernel: [  538.062708] usb usb1: USB disconnect, device number 1
Aug  4 17:53:00 absurd kernel: [  538.062710] usb 1-1: USB disconnect, device number 2
Aug  4 17:53:00 absurd kernel: [  538.062713] usb 1-1.6: USB disconnect, device number 3
Aug  4 17:53:01 absurd kernel: [  538.330441] ehci-pci 0000:00:1a.0: USB bus 1 deregistered
Aug  4 17:54:18 absurd kernel: [  538.920955] Syncing filesystems ... done.
Aug  4 17:54:18 absurd kernel: [  538.923005] Freezing user space processes ... (elapsed 0.001 seconds) done.
Aug  4 17:54:18 absurd kernel: [  538.925742] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:54:18 absurd kernel: [  538.925805] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:54:18 absurd kernel: [  538.926873] PM: Basic memory bitmaps created
Aug  4 17:54:18 absurd kernel: [  538.927038] PM: Preallocating image memory... done (allocated 16299810 pages)
Aug  4 17:54:18 absurd kernel: [  544.213140] PM: Allocated 65199240 kbytes in 5.28 seconds (4213.93 MB/s)
Aug  4 17:54:18 absurd kernel: [  544.213200] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:54:18 absurd kernel: [  544.215329] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:54:18 absurd kernel: [  544.215865] serial 00:04: disabled
Aug  4 17:54:18 absurd kernel: [  544.215941] serial 00:03: disabled
Aug  4 17:54:18 absurd kernel: [  544.277928] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:54:18 absurd kernel: [  544.291553] PM: freeze of devices complete after 76.204 msecs
Aug  4 17:54:18 absurd kernel: [  544.292105] PM: late freeze of devices complete after 0.551 msecs
Aug  4 17:54:18 absurd kernel: [  544.293951] PM: noirq freeze of devices complete after 1.845 msecs
Aug  4 17:54:18 absurd kernel: [  544.293952] Disabling non-boot CPUs ...
Aug  4 17:54:18 absurd kernel: [  544.294081] intel_pstate CPU 1 exiting
Aug  4 17:54:18 absurd kernel: [  544.295918] kvm: disabling virtualization on CPU1
Aug  4 17:54:18 absurd kernel: [  544.295972] smpboot: CPU 1 is now offline
Aug  4 17:54:18 absurd kernel: [  544.296838] intel_pstate CPU 2 exiting
Aug  4 17:54:18 absurd kernel: [  544.298677] kvm: disabling virtualization on CPU2
Aug  4 17:54:18 absurd kernel: [  544.298699] smpboot: CPU 2 is now offline
Aug  4 17:54:18 absurd kernel: [  544.299517] intel_pstate CPU 3 exiting
Aug  4 17:54:18 absurd kernel: [  544.301627] kvm: disabling virtualization on CPU3
Aug  4 17:54:18 absurd kernel: [  544.301635] smpboot: CPU 3 is now offline
Aug  4 17:54:18 absurd kernel: [  544.302252] intel_pstate CPU 4 exiting
Aug  4 17:54:18 absurd kernel: [  544.304047] kvm: disabling virtualization on CPU4
Aug  4 17:54:18 absurd kernel: [  544.304081] smpboot: CPU 4 is now offline
Aug  4 17:54:18 absurd kernel: [  544.304734] intel_pstate CPU 5 exiting
Aug  4 17:54:18 absurd kernel: [  544.306451] kvm: disabling virtualization on CPU5
Aug  4 17:54:18 absurd kernel: [  544.306457] smpboot: CPU 5 is now offline
Aug  4 17:54:18 absurd kernel: [  544.307109] intel_pstate CPU 6 exiting
Aug  4 17:54:18 absurd kernel: [  544.308840] kvm: disabling virtualization on CPU6
Aug  4 17:54:18 absurd kernel: [  544.411437] smpboot: CPU 6 is now offline
Aug  4 17:54:18 absurd kernel: [  544.411902] intel_pstate CPU 7 exiting
Aug  4 17:54:18 absurd kernel: [  544.413626] kvm: disabling virtualization on CPU7
Aug  4 17:54:18 absurd kernel: [  544.413633] smpboot: CPU 7 is now offline
Aug  4 17:54:18 absurd kernel: [  544.414698] intel_pstate CPU 8 exiting
Aug  4 17:54:18 absurd kernel: [  544.416338] kvm: disabling virtualization on CPU8
Aug  4 17:54:18 absurd kernel: [  544.416365] smpboot: CPU 8 is now offline
Aug  4 17:54:18 absurd kernel: [  544.418282] intel_pstate CPU 9 exiting
Aug  4 17:54:18 absurd kernel: [  544.420620] kvm: disabling virtualization on CPU9
Aug  4 17:54:18 absurd kernel: [  544.420652] smpboot: CPU 9 is now offline
Aug  4 17:54:18 absurd kernel: [  544.423384] intel_pstate CPU 10 exiting
Aug  4 17:54:18 absurd kernel: [  544.425675] kvm: disabling virtualization on CPU10
Aug  4 17:54:18 absurd kernel: [  544.527383] smpboot: CPU 10 is now offline
Aug  4 17:54:18 absurd kernel: [  544.528709] intel_pstate CPU 11 exiting
Aug  4 17:54:18 absurd kernel: [  544.530821] kvm: disabling virtualization on CPU11
Aug  4 17:54:18 absurd kernel: [  544.530833] smpboot: CPU 11 is now offline
Aug  4 17:54:18 absurd kernel: [  544.533273] intel_pstate CPU 12 exiting
Aug  4 17:54:18 absurd kernel: [  544.535501] kvm: disabling virtualization on CPU12
Aug  4 17:54:18 absurd kernel: [  544.535528] smpboot: CPU 12 is now offline
Aug  4 17:54:18 absurd kernel: [  544.538070] intel_pstate CPU 13 exiting
Aug  4 17:54:18 absurd kernel: [  544.540231] kvm: disabling virtualization on CPU13
Aug  4 17:54:18 absurd kernel: [  544.540255] smpboot: CPU 13 is now offline
Aug  4 17:54:18 absurd kernel: [  544.542757] intel_pstate CPU 14 exiting
Aug  4 17:54:18 absurd kernel: [  544.544922] kvm: disabling virtualization on CPU14
Aug  4 17:54:18 absurd kernel: [  544.647340] smpboot: CPU 14 is now offline
Aug  4 17:54:18 absurd kernel: [  544.648648] intel_pstate CPU 15 exiting
Aug  4 17:54:18 absurd kernel: [  544.650719] kvm: disabling virtualization on CPU15
Aug  4 17:54:18 absurd kernel: [  544.751284] smpboot: CPU 15 is now offline
Aug  4 17:54:18 absurd kernel: [  544.752066] intel_pstate CPU 16 exiting
Aug  4 17:54:18 absurd kernel: [  544.753916] kvm: disabling virtualization on CPU16
Aug  4 17:54:18 absurd kernel: [  544.855189] smpboot: CPU 16 is now offline
Aug  4 17:54:18 absurd kernel: [  544.855807] intel_pstate CPU 17 exiting
Aug  4 17:54:18 absurd kernel: [  544.857480] kvm: disabling virtualization on CPU17
Aug  4 17:54:18 absurd kernel: [  544.857489] smpboot: CPU 17 is now offline
Aug  4 17:54:18 absurd kernel: [  544.858128] intel_pstate CPU 18 exiting
Aug  4 17:54:18 absurd kernel: [  544.859772] kvm: disabling virtualization on CPU18
Aug  4 17:54:18 absurd kernel: [  544.859801] smpboot: CPU 18 is now offline
Aug  4 17:54:18 absurd kernel: [  544.860376] intel_pstate CPU 19 exiting
Aug  4 17:54:18 absurd kernel: [  544.861930] kvm: disabling virtualization on CPU19
Aug  4 17:54:18 absurd kernel: [  544.861937] smpboot: CPU 19 is now offline
Aug  4 17:54:18 absurd kernel: [  544.862569] intel_pstate CPU 20 exiting
Aug  4 17:54:18 absurd kernel: [  544.864067] kvm: disabling virtualization on CPU20
Aug  4 17:54:18 absurd kernel: [  544.864083] smpboot: CPU 20 is now offline
Aug  4 17:54:18 absurd kernel: [  544.864628] intel_pstate CPU 21 exiting
Aug  4 17:54:18 absurd kernel: [  544.866138] kvm: disabling virtualization on CPU21
Aug  4 17:54:18 absurd kernel: [  544.866144] smpboot: CPU 21 is now offline
Aug  4 17:54:18 absurd kernel: [  544.866669] intel_pstate CPU 22 exiting
Aug  4 17:54:18 absurd kernel: [  544.868150] kvm: disabling virtualization on CPU22
Aug  4 17:54:18 absurd kernel: [  544.868165] smpboot: CPU 22 is now offline
Aug  4 17:54:18 absurd kernel: [  544.868645] intel_pstate CPU 23 exiting
Aug  4 17:54:18 absurd kernel: [  544.870216] kvm: disabling virtualization on CPU23
Aug  4 17:54:18 absurd kernel: [  544.971119] smpboot: CPU 23 is now offline
Aug  4 17:54:18 absurd kernel: [  544.971893] intel_pstate CPU 24 exiting
Aug  4 17:54:18 absurd kernel: [  544.973425] kvm: disabling virtualization on CPU24
Aug  4 17:54:18 absurd kernel: [  544.973433] smpboot: CPU 24 is now offline
Aug  4 17:54:18 absurd kernel: [  544.974243] intel_pstate CPU 25 exiting
Aug  4 17:54:18 absurd kernel: [  544.975810] kvm: disabling virtualization on CPU25
Aug  4 17:54:18 absurd kernel: [  544.975842] smpboot: CPU 25 is now offline
Aug  4 17:54:18 absurd kernel: [  544.978669] intel_pstate CPU 26 exiting
Aug  4 17:54:18 absurd kernel: [  544.980342] kvm: disabling virtualization on CPU26
Aug  4 17:54:18 absurd kernel: [  544.980351] smpboot: CPU 26 is now offline
Aug  4 17:54:18 absurd kernel: [  544.981163] intel_pstate CPU 27 exiting
Aug  4 17:54:18 absurd kernel: [  544.982721] kvm: disabling virtualization on CPU27
Aug  4 17:54:18 absurd kernel: [  545.083089] smpboot: CPU 27 is now offline
Aug  4 17:54:18 absurd kernel: [  545.084198] intel_pstate CPU 28 exiting
Aug  4 17:54:18 absurd kernel: [  545.085790] kvm: disabling virtualization on CPU28
Aug  4 17:54:18 absurd kernel: [  545.187030] smpboot: CPU 28 is now offline
Aug  4 17:54:18 absurd kernel: [  545.188090] intel_pstate CPU 29 exiting
Aug  4 17:54:18 absurd kernel: [  545.189664] kvm: disabling virtualization on CPU29
Aug  4 17:54:18 absurd kernel: [  545.189673] smpboot: CPU 29 is now offline
Aug  4 17:54:18 absurd kernel: [  545.190410] intel_pstate CPU 30 exiting
Aug  4 17:54:18 absurd kernel: [  545.191888] kvm: disabling virtualization on CPU30
Aug  4 17:54:18 absurd kernel: [  545.191922] smpboot: CPU 30 is now offline
Aug  4 17:54:18 absurd kernel: [  545.192676] intel_pstate CPU 31 exiting
Aug  4 17:54:18 absurd kernel: [  545.194672] kvm: disabling virtualization on CPU31
Aug  4 17:54:18 absurd kernel: [  545.294922] smpboot: CPU 31 is now offline
Aug  4 17:54:18 absurd kernel: [  545.296155] PM: Creating hibernation image:
Aug  4 17:54:18 absurd kernel: [  545.897028] PM: Need to copy 398458 pages
Aug  4 17:54:18 absurd kernel: [  545.897030] PM: Normal pages needed: 398458 + 1024, available pages: 16369209
Aug  4 17:54:18 absurd kernel: [  545.302452] Enabling non-boot CPUs ...
Aug  4 17:54:18 absurd kernel: [  545.302740] x86: Booting SMP configuration:
Aug  4 17:54:18 absurd kernel: [  545.302741] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:54:18 absurd kernel: [  545.314546] kvm: enabling virtualization on CPU1
Aug  4 17:54:18 absurd kernel: [  545.316824] Intel pstate controlling: cpu 1
Aug  4 17:54:18 absurd kernel: [  545.316903] CPU1 is up
Aug  4 17:54:18 absurd kernel: [  545.317050] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:54:18 absurd kernel: [  545.328756] kvm: enabling virtualization on CPU2
Aug  4 17:54:18 absurd kernel: [  545.331022] Intel pstate controlling: cpu 2
Aug  4 17:54:18 absurd kernel: [  545.331090] CPU2 is up
Aug  4 17:54:18 absurd kernel: [  545.331226] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:54:18 absurd kernel: [  545.342947] kvm: enabling virtualization on CPU3
Aug  4 17:54:18 absurd kernel: [  545.345210] Intel pstate controlling: cpu 3
Aug  4 17:54:18 absurd kernel: [  545.345278] CPU3 is up
Aug  4 17:54:18 absurd kernel: [  545.345414] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:54:18 absurd kernel: [  545.357112] kvm: enabling virtualization on CPU4
Aug  4 17:54:18 absurd kernel: [  545.359389] Intel pstate controlling: cpu 4
Aug  4 17:54:18 absurd kernel: [  545.359454] CPU4 is up
Aug  4 17:54:18 absurd kernel: [  545.359590] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:54:18 absurd kernel: [  545.371280] kvm: enabling virtualization on CPU5
Aug  4 17:54:18 absurd kernel: [  545.373576] Intel pstate controlling: cpu 5
Aug  4 17:54:18 absurd kernel: [  545.373641] CPU5 is up
Aug  4 17:54:18 absurd kernel: [  545.373776] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:54:18 absurd kernel: [  545.385464] kvm: enabling virtualization on CPU6
Aug  4 17:54:18 absurd kernel: [  545.387756] Intel pstate controlling: cpu 6
Aug  4 17:54:18 absurd kernel: [  545.387822] CPU6 is up
Aug  4 17:54:18 absurd kernel: [  545.387962] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:54:18 absurd kernel: [  545.399643] kvm: enabling virtualization on CPU7
Aug  4 17:54:18 absurd kernel: [  545.401957] Intel pstate controlling: cpu 7
Aug  4 17:54:18 absurd kernel: [  545.402022] CPU7 is up
Aug  4 17:54:18 absurd kernel: [  545.402413] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:54:18 absurd kernel: [  545.415717] kvm: enabling virtualization on CPU8
Aug  4 17:54:18 absurd kernel: [  545.436121] Intel pstate controlling: cpu 8
Aug  4 17:54:18 absurd kernel: [  545.436175] CPU8 is up
Aug  4 17:54:18 absurd kernel: [  545.436516] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:54:18 absurd kernel: [  545.449869] kvm: enabling virtualization on CPU9
Aug  4 17:54:18 absurd kernel: [  545.452137] Intel pstate controlling: cpu 9
Aug  4 17:54:18 absurd kernel: [  545.452187] CPU9 is up
Aug  4 17:54:18 absurd kernel: [  545.452448] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:54:18 absurd kernel: [  545.465813] kvm: enabling virtualization on CPU10
Aug  4 17:54:18 absurd kernel: [  545.468080] Intel pstate controlling: cpu 10
Aug  4 17:54:18 absurd kernel: [  545.468129] CPU10 is up
Aug  4 17:54:18 absurd kernel: [  545.468375] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:54:18 absurd kernel: [  545.481753] kvm: enabling virtualization on CPU11
Aug  4 17:54:18 absurd kernel: [  545.484014] Intel pstate controlling: cpu 11
Aug  4 17:54:18 absurd kernel: [  545.484066] CPU11 is up
Aug  4 17:54:18 absurd kernel: [  545.484268] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:54:18 absurd kernel: [  545.497640] kvm: enabling virtualization on CPU12
Aug  4 17:54:18 absurd kernel: [  545.499918] Intel pstate controlling: cpu 12
Aug  4 17:54:18 absurd kernel: [  545.499968] CPU12 is up
Aug  4 17:54:18 absurd kernel: [  545.500152] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:54:18 absurd kernel: [  545.513236] kvm: enabling virtualization on CPU13
Aug  4 17:54:18 absurd kernel: [  545.515510] Intel pstate controlling: cpu 13
Aug  4 17:54:18 absurd kernel: [  545.515564] CPU13 is up
Aug  4 17:54:18 absurd kernel: [  545.515733] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:54:18 absurd kernel: [  545.528812] kvm: enabling virtualization on CPU14
Aug  4 17:54:18 absurd kernel: [  545.531111] Intel pstate controlling: cpu 14
Aug  4 17:54:18 absurd kernel: [  545.531158] CPU14 is up
Aug  4 17:54:18 absurd kernel: [  545.531334] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:54:18 absurd kernel: [  545.544212] kvm: enabling virtualization on CPU15
Aug  4 17:54:18 absurd kernel: [  545.546520] Intel pstate controlling: cpu 15
Aug  4 17:54:18 absurd kernel: [  545.546566] CPU15 is up
Aug  4 17:54:18 absurd kernel: [  545.546689] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:54:18 absurd kernel: [  545.558708] kvm: enabling virtualization on CPU16
Aug  4 17:54:18 absurd kernel: [  545.561208] Intel pstate controlling: cpu 16
Aug  4 17:54:18 absurd kernel: [  545.561279] CPU16 is up
Aug  4 17:54:18 absurd kernel: [  545.561425] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:54:18 absurd kernel: [  545.573122] kvm: enabling virtualization on CPU17
Aug  4 17:54:18 absurd kernel: [  545.575601] Intel pstate controlling: cpu 17
Aug  4 17:54:18 absurd kernel: [  545.575667] CPU17 is up
Aug  4 17:54:18 absurd kernel: [  545.575809] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:54:18 absurd kernel: [  545.587506] kvm: enabling virtualization on CPU18
Aug  4 17:54:18 absurd kernel: [  545.590000] Intel pstate controlling: cpu 18
Aug  4 17:54:18 absurd kernel: [  545.590070] CPU18 is up
Aug  4 17:54:18 absurd kernel: [  545.590222] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:54:18 absurd kernel: [  545.601924] kvm: enabling virtualization on CPU19
Aug  4 17:54:18 absurd kernel: [  545.604388] Intel pstate controlling: cpu 19
Aug  4 17:54:18 absurd kernel: [  545.604453] CPU19 is up
Aug  4 17:54:18 absurd kernel: [  545.604599] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:54:18 absurd kernel: [  545.616288] kvm: enabling virtualization on CPU20
Aug  4 17:54:18 absurd kernel: [  545.618814] Intel pstate controlling: cpu 20
Aug  4 17:54:18 absurd kernel: [  545.618878] CPU20 is up
Aug  4 17:54:18 absurd kernel: [  545.619028] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:54:18 absurd kernel: [  545.630712] kvm: enabling virtualization on CPU21
Aug  4 17:54:18 absurd kernel: [  545.633264] Intel pstate controlling: cpu 21
Aug  4 17:54:18 absurd kernel: [  545.633329] CPU21 is up
Aug  4 17:54:18 absurd kernel: [  545.633476] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:54:18 absurd kernel: [  545.645154] kvm: enabling virtualization on CPU22
Aug  4 17:54:18 absurd kernel: [  545.647719] Intel pstate controlling: cpu 22
Aug  4 17:54:18 absurd kernel: [  545.647782] CPU22 is up
Aug  4 17:54:18 absurd kernel: [  545.647931] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:54:18 absurd kernel: [  545.659601] kvm: enabling virtualization on CPU23
Aug  4 17:54:18 absurd kernel: [  545.662084] Intel pstate controlling: cpu 23
Aug  4 17:54:18 absurd kernel: [  545.662149] CPU23 is up
Aug  4 17:54:18 absurd kernel: [  545.662426] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:54:18 absurd kernel: [  545.674703] kvm: enabling virtualization on CPU24
Aug  4 17:54:18 absurd kernel: [  545.677138] Intel pstate controlling: cpu 24
Aug  4 17:54:18 absurd kernel: [  545.677181] CPU24 is up
Aug  4 17:54:18 absurd kernel: [  545.677366] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:54:18 absurd kernel: [  545.689539] kvm: enabling virtualization on CPU25
Aug  4 17:54:18 absurd kernel: [  545.691951] Intel pstate controlling: cpu 25
Aug  4 17:54:18 absurd kernel: [  545.691997] CPU25 is up
Aug  4 17:54:18 absurd kernel: [  545.692176] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:54:18 absurd kernel: [  545.704257] kvm: enabling virtualization on CPU26
Aug  4 17:54:18 absurd kernel: [  545.706660] Intel pstate controlling: cpu 26
Aug  4 17:54:18 absurd kernel: [  545.706705] CPU26 is up
Aug  4 17:54:18 absurd kernel: [  545.706887] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:54:18 absurd kernel: [  545.718982] kvm: enabling virtualization on CPU27
Aug  4 17:54:18 absurd kernel: [  545.721377] Intel pstate controlling: cpu 27
Aug  4 17:54:18 absurd kernel: [  545.721421] CPU27 is up
Aug  4 17:54:18 absurd kernel: [  545.721592] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:54:18 absurd kernel: [  545.733588] kvm: enabling virtualization on CPU28
Aug  4 17:54:18 absurd kernel: [  545.736005] Intel pstate controlling: cpu 28
Aug  4 17:54:18 absurd kernel: [  545.736049] CPU28 is up
Aug  4 17:54:18 absurd kernel: [  545.736211] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:54:18 absurd kernel: [  545.748181] kvm: enabling virtualization on CPU29
Aug  4 17:54:18 absurd kernel: [  545.750634] Intel pstate controlling: cpu 29
Aug  4 17:54:18 absurd kernel: [  545.750676] CPU29 is up
Aug  4 17:54:18 absurd kernel: [  545.750846] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:54:18 absurd kernel: [  545.762784] kvm: enabling virtualization on CPU30
Aug  4 17:54:18 absurd kernel: [  545.765278] Intel pstate controlling: cpu 30
Aug  4 17:54:18 absurd kernel: [  545.765323] CPU30 is up
Aug  4 17:54:18 absurd kernel: [  545.765499] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:54:18 absurd kernel: [  545.777419] kvm: enabling virtualization on CPU31
Aug  4 17:54:18 absurd kernel: [  545.779868] Intel pstate controlling: cpu 31
Aug  4 17:54:18 absurd kernel: [  545.779913] CPU31 is up
Aug  4 17:54:18 absurd kernel: [  545.857213] PM: noirq restore of devices complete after 15.908 msecs
Aug  4 17:54:18 absurd kernel: [  545.857631] PM: early restore of devices complete after 0.359 msecs
Aug  4 17:54:18 absurd kernel: [  546.017560] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:54:18 absurd kernel: [  546.017561] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:54:18 absurd kernel: [  546.017562] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:54:18 absurd kernel: [  546.017568] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:54:18 absurd kernel: [  546.017609] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:54:18 absurd kernel: [  546.017787] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017793] igb 0000:02:00.1: irq 100 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017802] igb 0000:02:00.1: irq 101 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017808] igb 0000:02:00.1: irq 102 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017813] igb 0000:02:00.1: irq 103 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017818] igb 0000:02:00.1: irq 104 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017824] igb 0000:02:00.1: irq 105 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017829] igb 0000:02:00.1: irq 106 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017836] igb 0000:02:00.1: irq 107 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017871] igb 0000:02:00.0: irq 111 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017877] igb 0000:02:00.0: irq 112 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017886] igb 0000:02:00.0: irq 113 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017891] igb 0000:02:00.0: irq 114 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017900] igb 0000:02:00.0: irq 115 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017906] igb 0000:02:00.0: irq 116 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017911] igb 0000:02:00.0: irq 117 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017920] igb 0000:02:00.0: irq 118 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.017926] igb 0000:02:00.0: irq 119 for MSI/MSI-X
Aug  4 17:54:18 absurd kernel: [  546.018121] serial 00:03: activated
Aug  4 17:54:18 absurd kernel: [  546.018447] serial 00:04: activated
Aug  4 17:54:18 absurd kernel: [  546.021637] ------------[ cut here ]------------
Aug  4 17:54:18 absurd kernel: [  546.021644] WARNING: CPU: 14 PID: 9549 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:54:18 absurd kernel: [  546.021678] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj raid1 usb_storage snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel nvidia(PO) kvm joydev hid_generic snd_hda_codec_ca0132 crct10dif_pclmul iTCO_wdt crc32_pclmul iTCO_vendor_support usbhid ghash_clmulni_intel hid mxm_wmi evdev aesni_intel snd_hda_intel aes_x86_64 ablk_helper cryptd glue_helper lrw snd_hda_controller gf128mul snd_hda_codec pcspkr snd_hwdep sb_edac snd_pcm edac_core snd_seq i2c_i801 snd_seq_device snd_timer snd lpc_ich mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler tpm_tis tpm processor wmi thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci libata scsi_transport_sas scsi_mod igb usbcore i2c_a
Aug  4 17:54:18 absurd kernel: lgo_bit usb_common i2c_core dca ptp pps_core [last unloaded: ehci_hcd]
Aug  4 17:54:18 absurd kernel: [  546.021691] CPU: 14 PID: 9549 Comm: kworker/u66:2 Tainted: P        W  O  3.16.0-vanilla.1 #1
Aug  4 17:54:18 absurd kernel: [  546.021692] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:54:18 absurd kernel: [  546.021697] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:54:18 absurd kernel: [  546.021698]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:54:18 absurd kernel: [  546.021699]  ffffffff810664f6 ffffffffa03ff09b ffff881057a2bec0 ffff881057940b80
Aug  4 17:54:18 absurd kernel: [  546.021700]  ffff881051aa7c90 ffff88105796b000 ffffffff813a7d3b ffff881055182200
Aug  4 17:54:18 absurd kernel: [  546.021701] Call Trace:
Aug  4 17:54:18 absurd kernel: [  546.021707]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:54:18 absurd kernel: [  546.021710]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:54:18 absurd kernel: [  546.021712]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:54:18 absurd kernel: [  546.021714]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:54:18 absurd kernel: [  546.021717]  [<ffffffffa03fe03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:54:18 absurd kernel: [  546.021723]  [<ffffffffa02cfe21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:54:18 absurd kernel: [  546.021725]  [<ffffffffa02cff17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:54:18 absurd kernel: [  546.021729]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:54:18 absurd kernel: [  546.021732]  [<ffffffffa02cf951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:54:18 absurd kernel: [  546.021734]  [<ffffffffa02d1776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:54:18 absurd kernel: [  546.021737]  [<ffffffffa03ab070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:54:18 absurd kernel: [  546.021740]  [<ffffffffa0334c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:54:18 absurd kernel: [  546.021743]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:54:18 absurd kernel: [  546.021747]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:54:18 absurd kernel: [  546.021749]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:54:18 absurd kernel: [  546.021750]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:54:18 absurd kernel: [  546.021751]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:54:18 absurd kernel: [  546.021753]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:54:18 absurd kernel: [  546.021755]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:54:18 absurd kernel: [  546.021757]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:54:18 absurd kernel: [  546.021758]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:54:18 absurd kernel: [  546.021760]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:54:18 absurd kernel: [  546.021761]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:54:18 absurd kernel: [  546.021762]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:54:18 absurd kernel: [  546.021763]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:54:18 absurd kernel: [  546.021764] ---[ end trace db395c2b3c06720a ]---
Aug  4 17:54:18 absurd kernel: [  546.021766] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:54:18 absurd kernel: [  546.336670] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:54:18 absurd kernel: [  546.358719] ata2.00: configured for UDMA/133
Aug  4 17:54:18 absurd kernel: [  546.368654] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:54:18 absurd kernel: [  546.368679] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:54:18 absurd kernel: [  546.368702] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:54:18 absurd kernel: [  546.369164] ata1.00: configured for UDMA/133
Aug  4 17:54:18 absurd kernel: [  546.369944] ata4.00: configured for UDMA/100
Aug  4 17:54:18 absurd kernel: [  546.376647] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:54:18 absurd kernel: [  546.379904] ata5.00: configured for UDMA/133
Aug  4 17:54:18 absurd kernel: [  546.416742] PM: restore of devices complete after 399.650 msecs
Aug  4 17:54:18 absurd kernel: [  546.464591] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:54:18 absurd kernel: [  546.475209] ata6.00: configured for UDMA/133
Aug  4 17:54:18 absurd kernel: [  546.568418] Restarting kernel threads ... done.
Aug  4 17:54:18 absurd kernel: [  546.569374] PM: Basic memory bitmaps freed
Aug  4 17:54:18 absurd kernel: [  546.569436] Restarting tasks ... done.
Aug  4 17:54:18 absurd upsd[4451]: Can't connect to UPS [duo2pro] (blazer_usb-duo2pro): No such file or directory
Aug  4 17:54:18 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:54:18 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:54:18 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:54:18 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:54:18 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 17:54:18 absurd NetworkManager[4243]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:54:18 absurd kernel: [  546.697944] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Aug  4 17:54:18 absurd kernel: [  546.698325] ehci-pci: EHCI PCI platform driver
Aug  4 17:54:18 absurd kernel: [  546.698410] ehci-pci 0000:00:1a.0: EHCI Host Controller
Aug  4 17:54:18 absurd kernel: [  546.698415] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
Aug  4 17:54:18 absurd kernel: [  546.698427] ehci-pci 0000:00:1a.0: debug port 2
Aug  4 17:54:18 absurd kernel: [  546.702309] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:54:18 absurd kernel: [  546.702352] ehci-pci 0000:00:1a.0: irq 16, io mem 0xdf324000
Aug  4 17:54:18 absurd kernel: [  546.712405] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Aug  4 17:54:18 absurd kernel: [  546.712470] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Aug  4 17:54:18 absurd kernel: [  546.712472] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  4 17:54:18 absurd kernel: [  546.712474] usb usb1: Product: EHCI Host Controller
Aug  4 17:54:18 absurd kernel: [  546.712475] usb usb1: Manufacturer: Linux 3.16.0-vanilla.1 ehci_hcd
Aug  4 17:54:18 absurd kernel: [  546.712476] usb usb1: SerialNumber: 0000:00:1a.0
Aug  4 17:54:18 absurd kernel: [  546.712655] hub 1-0:1.0: USB hub found
Aug  4 17:54:18 absurd kernel: [  546.712671] hub 1-0:1.0: 2 ports detected
Aug  4 17:54:18 absurd kernel: [  546.756401] ehci-pci 0000:00:1d.0: EHCI Host Controller
Aug  4 17:54:18 absurd kernel: [  546.756406] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
Aug  4 17:54:18 absurd kernel: [  546.756417] ehci-pci 0000:00:1d.0: debug port 2
Aug  4 17:54:18 absurd kernel: [  546.760318] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:54:18 absurd kernel: [  546.760329] ehci-pci 0000:00:1d.0: irq 23, io mem 0xdf323000
Aug  4 17:54:18 absurd kernel: [  546.768355] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Aug  4 17:54:18 absurd kernel: [  546.768382] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Aug  4 17:54:18 absurd kernel: [  546.768383] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  4 17:54:18 absurd kernel: [  546.768384] usb usb2: Product: EHCI Host Controller
Aug  4 17:54:18 absurd kernel: [  546.768385] usb usb2: Manufacturer: Linux 3.16.0-vanilla.1 ehci_hcd
Aug  4 17:54:18 absurd kernel: [  546.768386] usb usb2: SerialNumber: 0000:00:1d.0
Aug  4 17:54:18 absurd kernel: [  546.768490] hub 2-0:1.0: USB hub found
Aug  4 17:54:18 absurd kernel: [  546.768494] hub 2-0:1.0: 2 ports detected
Aug  4 17:54:18 absurd acpid: client connected from 4432[0:0]
Aug  4 17:54:18 absurd acpid: 1 client rule loaded
Aug  4 17:54:18 absurd acpid: client connected from 4432[0:0]
Aug  4 17:54:18 absurd acpid: 1 client rule loaded
Aug  4 17:54:18 absurd kernel: [  547.024307] usb 1-1: new high-speed USB device number 2 using ehci-pci
Aug  4 17:54:18 absurd acpid: client connected from 4432[0:0]
Aug  4 17:54:18 absurd acpid: 1 client rule loaded
Aug  4 17:54:18 absurd kernel: [  547.156515] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
Aug  4 17:54:18 absurd kernel: [  547.156521] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Aug  4 17:54:18 absurd kernel: [  547.157015] hub 1-1:1.0: USB hub found
Aug  4 17:54:18 absurd kernel: [  547.157148] hub 1-1:1.0: 6 ports detected
Aug  4 17:54:18 absurd kernel: [  547.268175] usb 2-1: new high-speed USB device number 2 using ehci-pci
Aug  4 17:54:19 absurd acpid: client connected from 4432[0:0]
Aug  4 17:54:19 absurd acpid: 1 client rule loaded
Aug  4 17:54:19 absurd kernel: [  547.400376] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
Aug  4 17:54:19 absurd kernel: [  547.400383] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Aug  4 17:54:19 absurd kernel: [  547.400892] hub 2-1:1.0: USB hub found
Aug  4 17:54:19 absurd kernel: [  547.400989] hub 2-1:1.0: 8 ports detected
Aug  4 17:54:19 absurd kernel: [  547.472143] usb 1-1.6: new full-speed USB device number 3 using ehci-pci
Aug  4 17:54:19 absurd kernel: [  547.565574] usb 1-1.6: New USB device found, idVendor=0557, idProduct=2221
Aug  4 17:54:19 absurd kernel: [  547.565580] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Aug  4 17:54:19 absurd kernel: [  547.565583] usb 1-1.6: Product: Hermon USB hidmouse Device
Aug  4 17:54:19 absurd kernel: [  547.565585] usb 1-1.6: Manufacturer: Winbond Electronics Corp
Aug  4 17:54:19 absurd kernel: [  547.567132] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/0003:0557:2221.001A/input/input21
Aug  4 17:54:19 absurd kernel: [  547.567456] hid-generic 0003:0557:2221.001A: input,hidraw0: USB HID v1.00 Mouse [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.6/input0
Aug  4 17:54:19 absurd kernel: [  547.568358] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.1/0003:0557:2221.001B/input/input22
Aug  4 17:54:19 absurd kernel: [  547.568532] hid-generic 0003:0557:2221.001B: input,hidraw1: USB HID v1.00 Keyboard [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.6/input1
Aug  4 17:54:19 absurd mtp-probe: checking bus 1, device 3: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6"
Aug  4 17:54:19 absurd mtp-probe: bus: 1, device: 3 was not an MTP device
Aug  4 17:54:19 absurd kernel: [  547.671962] usb 2-1.1: new high-speed USB device number 3 using ehci-pci
Aug  4 17:54:19 absurd kernel: [  547.766062] usb 2-1.1: New USB device found, idVendor=0bc2, idProduct=3312
Aug  4 17:54:19 absurd kernel: [  547.766081] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 17:54:19 absurd kernel: [  547.766083] usb 2-1.1: Product: Expansion Desk
Aug  4 17:54:19 absurd kernel: [  547.766085] usb 2-1.1: Manufacturer: Seagate 
Aug  4 17:54:19 absurd kernel: [  547.766087] usb 2-1.1: SerialNumber: NA4M6A1L
Aug  4 17:54:19 absurd kernel: [  547.766319] usb-storage 2-1.1:1.0: USB Mass Storage device detected
Aug  4 17:54:19 absurd kernel: [  547.766743] scsi10 : usb-storage 2-1.1:1.0
Aug  4 17:54:19 absurd mtp-probe: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1"
Aug  4 17:54:19 absurd kernel: [  547.835909] usb 2-1.2: new low-speed USB device number 4 using ehci-pci
Aug  4 17:54:19 absurd kernel: [  547.934599] usb 2-1.2: New USB device found, idVendor=0665, idProduct=5161
Aug  4 17:54:19 absurd kernel: [  547.934604] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 17:54:19 absurd kernel: [  547.934607] usb 2-1.2: Product: USB to Serial
Aug  4 17:54:19 absurd kernel: [  547.934610] usb 2-1.2: Manufacturer: INNO TECH
Aug  4 17:54:19 absurd kernel: [  547.934612] usb 2-1.2: SerialNumber: 20100826
Aug  4 17:54:19 absurd kernel: [  547.941251] hid-generic 0003:0665:5161.001C: hiddev0,hidraw2: USB HID v1.00 Device [INNO TECH USB to Serial] on usb-0000:00:1d.0-1.2/input0
Aug  4 17:54:19 absurd mtp-probe: checking bus 2, device 4: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2"
Aug  4 17:54:19 absurd kernel: [  548.011987] usb 2-1.3: new high-speed USB device number 5 using ehci-pci
Aug  4 17:54:19 absurd mtp-probe: bus: 2, device: 3 was not an MTP device
Aug  4 17:54:19 absurd mtp-probe: bus: 2, device: 4 was not an MTP device
Aug  4 17:54:19 absurd kernel: [  548.104263] usb 2-1.3: New USB device found, idVendor=1a40, idProduct=0101
Aug  4 17:54:19 absurd kernel: [  548.104268] usb 2-1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Aug  4 17:54:19 absurd kernel: [  548.104271] usb 2-1.3: Product: USB 2.0 Hub
Aug  4 17:54:19 absurd kernel: [  548.104481] hub 2-1.3:1.0: USB hub found
Aug  4 17:54:19 absurd kernel: [  548.104571] hub 2-1.3:1.0: 4 ports detected
Aug  4 17:54:20 absurd kernel: [  548.375551] usb 2-1.3.1: new high-speed USB device number 6 using ehci-pci
Aug  4 17:54:20 absurd kernel: [  548.468168] usb 2-1.3.1: New USB device found, idVendor=1a40, idProduct=0101
Aug  4 17:54:20 absurd kernel: [  548.468173] usb 2-1.3.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Aug  4 17:54:20 absurd kernel: [  548.468176] usb 2-1.3.1: Product: USB 2.0 Hub
Aug  4 17:54:20 absurd kernel: [  548.468629] hub 2-1.3.1:1.0: USB hub found
Aug  4 17:54:20 absurd kernel: [  548.468734] hub 2-1.3.1:1.0: 4 ports detected
Aug  4 17:54:20 absurd kernel: [  548.555456] usb 2-1.3.3: new full-speed USB device number 7 using ehci-pci
Aug  4 17:54:20 absurd kernel: [  548.668471] usb 2-1.3.3: New USB device found, idVendor=046d, idProduct=c52b
Aug  4 17:54:20 absurd kernel: [  548.668477] usb 2-1.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Aug  4 17:54:20 absurd kernel: [  548.668480] usb 2-1.3.3: Product: USB Receiver
Aug  4 17:54:20 absurd kernel: [  548.668483] usb 2-1.3.3: Manufacturer: Logitech
Aug  4 17:54:20 absurd kernel: [  548.680157] logitech-djreceiver 0003:046D:C52B.001F: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1.3.3/input2
Aug  4 17:54:20 absurd kernel: [  548.738888] input: Logitech Unifying Device. Wireless PID:101b as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3/2-1.3.3:1.2/0003:046D:C52B.001F/0003:046D:C52B.0020/input/input23
Aug  4 17:54:20 absurd kernel: [  548.739126] logitech-djdevice 0003:046D:C52B.0020: input,hidraw4: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:101b] on usb-0000:00:1d.0-1.3.3:1
Aug  4 17:54:20 absurd mtp-probe: checking bus 2, device 7: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3"
Aug  4 17:54:20 absurd mtp-probe: bus: 2, device: 7 was not an MTP device
Aug  4 17:54:20 absurd kernel: [  548.740966] input: Logitech Unifying Device. Wireless PID:2011 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3/2-1.3.3:1.2/0003:046D:C52B.001F/0003:046D:C52B.0021/input/input24
Aug  4 17:54:20 absurd kernel: [  548.741154] logitech-djdevice 0003:046D:C52B.0021: input,hidraw5: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:2011] on usb-0000:00:1d.0-1.3.3:2
Aug  4 17:54:20 absurd kernel: [  548.764288] scsi 10:0:0:0: Direct-Access     Seagate  Expansion Desk   0737 PQ: 0 ANSI: 6
Aug  4 17:54:20 absurd kernel: [  548.765237] sd 10:0:0:0: Attached scsi generic sg5 type 0
Aug  4 17:54:20 absurd kernel: [  548.765699] sd 10:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:54:20 absurd kernel: [  548.766484] sd 10:0:0:0: [sde] Write Protect is off
Aug  4 17:54:20 absurd kernel: [  548.766492] sd 10:0:0:0: [sde] Mode Sense: 2b 00 10 08
Aug  4 17:54:20 absurd kernel: [  548.767312] sd 10:0:0:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
Aug  4 17:54:20 absurd kernel: [  548.768231] sd 10:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:54:20 absurd NetworkManager[4243]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:54:20 absurd kernel: [  548.791569] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 17:54:21 absurd upsd[4451]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 17:54:21 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:54:23 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:54:23 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="9796" x-info="http://www.rsyslog.com"] start
Aug  4 17:54:23 absurd salomea: ========== resume complete ===========
Aug  4 17:54:24 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:54:27 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:54:27 absurd kernel: [  555.715076]  sde: sde1
Aug  4 17:54:27 absurd kernel: [  555.716661] sd 10:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:54:27 absurd kernel: [  555.718134] sd 10:0:0:0: [sde] Attached SCSI disk
Aug  4 17:54:30 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:54:33 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:54:36 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:54:39 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:54:42 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_1_success4.txt

Aug  4 17:54:48 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:54:51 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:54:54 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:54:57 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:55:00 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:55:00 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:55:01 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:55:01 absurd kernel: [  589.858624] ehci-pci 0000:00:1d.0: remove, state 1
Aug  4 17:55:01 absurd kernel: [  589.858665] usb usb2: USB disconnect, device number 1
Aug  4 17:55:01 absurd kernel: [  589.858669] usb 2-1: USB disconnect, device number 2
Aug  4 17:55:01 absurd kernel: [  589.858672] usb 2-1.1: USB disconnect, device number 3
Aug  4 17:55:01 absurd kernel: [  589.859701] sd 10:0:0:0: [sde] Synchronizing SCSI cache
Aug  4 17:55:01 absurd kernel: [  589.859795] sd 10:0:0:0: [sde]  
Aug  4 17:55:01 absurd kernel: [  589.859800] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Aug  4 17:55:01 absurd kernel: [  589.860504] usb 2-1.2: USB disconnect, device number 4
Aug  4 17:55:01 absurd kernel: [  589.860985] usb 2-1.3: USB disconnect, device number 5
Aug  4 17:55:01 absurd kernel: [  589.860995] usb 2-1.3.1: USB disconnect, device number 6
Aug  4 17:55:01 absurd kernel: [  589.861379] usb 2-1.3.3: USB disconnect, device number 7
Aug  4 17:55:01 absurd acpid: input device has been disconnected, fd 19
Aug  4 17:55:01 absurd kernel: [  590.069502] ehci-pci 0000:00:1d.0: USB bus 2 deregistered
Aug  4 17:55:01 absurd kernel: [  590.069568] ehci-pci 0000:00:1a.0: remove, state 1
Aug  4 17:55:01 absurd kernel: [  590.069578] usb usb1: USB disconnect, device number 1
Aug  4 17:55:01 absurd kernel: [  590.069582] usb 1-1: USB disconnect, device number 2
Aug  4 17:55:01 absurd kernel: [  590.069585] usb 1-1.6: USB disconnect, device number 3
Aug  4 17:55:02 absurd kernel: [  590.322345] ehci-pci 0000:00:1a.0: USB bus 1 deregistered
Aug  4 17:56:20 absurd kernel: [  590.899116] Syncing filesystems ... done.
Aug  4 17:56:20 atak /USR/SBIN/CRON[2106]: (janek) CMD (/home/janek/usr/rrd/rrd-feed)
Aug  4 17:55:15 atak /USR/SBIN/CRON[2106]: (janek) CMD (/home/janek/usr/rrd/rrd-feed)
Aug  4 17:56:20 absurd kernel: [  590.901239] Freezing user space processes ... (elapsed 0.001 seconds) done.
Aug  4 17:56:20 absurd kernel: [  590.904155] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:56:20 absurd kernel: [  590.904220] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:56:20 absurd kernel: [  590.905761] PM: Basic memory bitmaps created
Aug  4 17:56:20 absurd kernel: [  590.905935] PM: Preallocating image memory... done (allocated 16298587 pages)
Aug  4 17:56:20 absurd kernel: [  596.509295] PM: Allocated 65194348 kbytes in 5.60 seconds (3972.26 MB/s)
Aug  4 17:56:20 absurd kernel: [  596.509359] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:56:20 absurd kernel: [  596.511849] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:56:20 absurd kernel: [  596.512541] serial 00:04: disabled
Aug  4 17:56:20 absurd kernel: [  596.512619] serial 00:03: disabled
Aug  4 17:56:20 absurd kernel: [  596.576337] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:56:20 absurd kernel: [  596.591482] PM: freeze of devices complete after 79.602 msecs
Aug  4 17:56:20 absurd kernel: [  596.592056] PM: late freeze of devices complete after 0.572 msecs
Aug  4 17:56:20 absurd kernel: [  596.593966] PM: noirq freeze of devices complete after 1.909 msecs
Aug  4 17:56:20 absurd kernel: [  596.593967] Disabling non-boot CPUs ...
Aug  4 17:56:20 absurd kernel: [  596.594106] intel_pstate CPU 1 exiting
Aug  4 17:56:20 absurd kernel: [  596.595931] kvm: disabling virtualization on CPU1
Aug  4 17:56:20 absurd kernel: [  596.596607] smpboot: CPU 1 is now offline
Aug  4 17:56:20 absurd kernel: [  596.597123] intel_pstate CPU 2 exiting
Aug  4 17:56:20 absurd kernel: [  596.598870] kvm: disabling virtualization on CPU2
Aug  4 17:56:20 absurd kernel: [  596.699378] smpboot: CPU 2 is now offline
Aug  4 17:56:20 absurd kernel: [  596.699817] intel_pstate CPU 3 exiting
Aug  4 17:56:20 absurd kernel: [  596.701531] kvm: disabling virtualization on CPU3
Aug  4 17:56:20 absurd kernel: [  596.803336] smpboot: CPU 3 is now offline
Aug  4 17:56:20 absurd kernel: [  596.803872] intel_pstate CPU 4 exiting
Aug  4 17:56:20 absurd kernel: [  596.805573] kvm: disabling virtualization on CPU4
Aug  4 17:56:20 absurd kernel: [  596.805585] smpboot: CPU 4 is now offline
Aug  4 17:56:20 absurd kernel: [  596.806278] intel_pstate CPU 5 exiting
Aug  4 17:56:20 absurd kernel: [  596.808005] kvm: disabling virtualization on CPU5
Aug  4 17:56:20 absurd kernel: [  596.808026] smpboot: CPU 5 is now offline
Aug  4 17:56:20 absurd kernel: [  596.808795] intel_pstate CPU 6 exiting
Aug  4 17:56:20 absurd kernel: [  596.810797] kvm: disabling virtualization on CPU6
Aug  4 17:56:20 absurd kernel: [  596.911248] smpboot: CPU 6 is now offline
Aug  4 17:56:20 absurd kernel: [  596.911637] intel_pstate CPU 7 exiting
Aug  4 17:56:20 absurd kernel: [  596.913244] kvm: disabling virtualization on CPU7
Aug  4 17:56:20 absurd kernel: [  596.913248] smpboot: CPU 7 is now offline
Aug  4 17:56:20 absurd kernel: [  596.914323] intel_pstate CPU 8 exiting
Aug  4 17:56:20 absurd kernel: [  596.915942] kvm: disabling virtualization on CPU8
Aug  4 17:56:20 absurd kernel: [  596.915968] smpboot: CPU 8 is now offline
Aug  4 17:56:20 absurd kernel: [  596.917284] intel_pstate CPU 9 exiting
Aug  4 17:56:20 absurd kernel: [  596.919134] kvm: disabling virtualization on CPU9
Aug  4 17:56:20 absurd kernel: [  596.919150] smpboot: CPU 9 is now offline
Aug  4 17:56:20 absurd kernel: [  596.920652] intel_pstate CPU 10 exiting
Aug  4 17:56:20 absurd kernel: [  596.922489] kvm: disabling virtualization on CPU10
Aug  4 17:56:20 absurd kernel: [  596.922497] smpboot: CPU 10 is now offline
Aug  4 17:56:20 absurd kernel: [  596.924020] intel_pstate CPU 11 exiting
Aug  4 17:56:20 absurd kernel: [  596.925834] kvm: disabling virtualization on CPU11
Aug  4 17:56:20 absurd kernel: [  596.925843] smpboot: CPU 11 is now offline
Aug  4 17:56:20 absurd kernel: [  596.927364] intel_pstate CPU 12 exiting
Aug  4 17:56:20 absurd kernel: [  596.928969] kvm: disabling virtualization on CPU12
Aug  4 17:56:20 absurd kernel: [  597.031175] smpboot: CPU 12 is now offline
Aug  4 17:56:20 absurd kernel: [  597.031930] intel_pstate CPU 13 exiting
Aug  4 17:56:20 absurd kernel: [  597.033470] kvm: disabling virtualization on CPU13
Aug  4 17:56:20 absurd kernel: [  597.135130] smpboot: CPU 13 is now offline
Aug  4 17:56:20 absurd kernel: [  597.135826] intel_pstate CPU 14 exiting
Aug  4 17:56:20 absurd kernel: [  597.137356] kvm: disabling virtualization on CPU14
Aug  4 17:56:20 absurd kernel: [  597.239071] smpboot: CPU 14 is now offline
Aug  4 17:56:20 absurd kernel: [  597.239762] intel_pstate CPU 15 exiting
Aug  4 17:56:20 absurd kernel: [  597.241294] kvm: disabling virtualization on CPU15
Aug  4 17:56:20 absurd kernel: [  597.343027] smpboot: CPU 15 is now offline
Aug  4 17:56:20 absurd kernel: [  597.343515] intel_pstate CPU 16 exiting
Aug  4 17:56:20 absurd kernel: [  597.345036] kvm: disabling virtualization on CPU16
Aug  4 17:56:20 absurd kernel: [  597.446930] smpboot: CPU 16 is now offline
Aug  4 17:56:20 absurd kernel: [  597.447326] intel_pstate CPU 17 exiting
Aug  4 17:56:20 absurd kernel: [  597.448813] kvm: disabling virtualization on CPU17
Aug  4 17:56:20 absurd kernel: [  597.448824] smpboot: CPU 17 is now offline
Aug  4 17:56:20 absurd kernel: [  597.449174] intel_pstate CPU 18 exiting
Aug  4 17:56:20 absurd kernel: [  597.451398] kvm: disabling virtualization on CPU18
Aug  4 17:56:20 absurd kernel: [  597.451449] smpboot: CPU 18 is now offline
Aug  4 17:56:20 absurd kernel: [  597.452274] intel_pstate CPU 19 exiting
Aug  4 17:56:20 absurd kernel: [  597.454115] kvm: disabling virtualization on CPU19
Aug  4 17:56:20 absurd kernel: [  597.554870] smpboot: CPU 19 is now offline
Aug  4 17:56:20 absurd kernel: [  597.555544] intel_pstate CPU 20 exiting
Aug  4 17:56:20 absurd kernel: [  597.557191] kvm: disabling virtualization on CPU20
Aug  4 17:56:20 absurd kernel: [  597.557208] smpboot: CPU 20 is now offline
Aug  4 17:56:20 absurd kernel: [  597.557676] intel_pstate CPU 21 exiting
Aug  4 17:56:20 absurd kernel: [  597.560211] kvm: disabling virtualization on CPU21
Aug  4 17:56:20 absurd kernel: [  597.662845] smpboot: CPU 21 is now offline
Aug  4 17:56:20 absurd kernel: [  597.663714] intel_pstate CPU 22 exiting
Aug  4 17:56:20 absurd kernel: [  597.665510] kvm: disabling virtualization on CPU22
Aug  4 17:56:20 absurd kernel: [  597.766748] smpboot: CPU 22 is now offline
Aug  4 17:56:20 absurd kernel: [  597.767373] intel_pstate CPU 23 exiting
Aug  4 17:56:20 absurd kernel: [  597.768946] kvm: disabling virtualization on CPU23
Aug  4 17:56:20 absurd kernel: [  597.768961] smpboot: CPU 23 is now offline
Aug  4 17:56:20 absurd kernel: [  597.769430] intel_pstate CPU 24 exiting
Aug  4 17:56:20 absurd kernel: [  597.770766] kvm: disabling virtualization on CPU24
Aug  4 17:56:20 absurd kernel: [  597.771523] smpboot: CPU 24 is now offline
Aug  4 17:56:20 absurd kernel: [  597.772454] intel_pstate CPU 25 exiting
Aug  4 17:56:20 absurd kernel: [  597.773970] kvm: disabling virtualization on CPU25
Aug  4 17:56:20 absurd kernel: [  597.874693] smpboot: CPU 25 is now offline
Aug  4 17:56:20 absurd kernel: [  597.875911] intel_pstate CPU 26 exiting
Aug  4 17:56:20 absurd kernel: [  597.877560] kvm: disabling virtualization on CPU26
Aug  4 17:56:20 absurd kernel: [  597.877568] smpboot: CPU 26 is now offline
Aug  4 17:56:20 absurd kernel: [  597.878430] intel_pstate CPU 27 exiting
Aug  4 17:56:20 absurd kernel: [  597.880034] kvm: disabling virtualization on CPU27
Aug  4 17:56:20 absurd kernel: [  597.982635] smpboot: CPU 27 is now offline
Aug  4 17:56:20 absurd kernel: [  597.983813] intel_pstate CPU 28 exiting
Aug  4 17:56:20 absurd kernel: [  597.985426] kvm: disabling virtualization on CPU28
Aug  4 17:56:20 absurd kernel: [  598.086604] smpboot: CPU 28 is now offline
Aug  4 17:56:20 absurd kernel: [  598.087675] intel_pstate CPU 29 exiting
Aug  4 17:56:20 absurd kernel: [  598.089270] kvm: disabling virtualization on CPU29
Aug  4 17:56:20 absurd kernel: [  598.089279] smpboot: CPU 29 is now offline
Aug  4 17:56:20 absurd kernel: [  598.089993] intel_pstate CPU 30 exiting
Aug  4 17:56:20 absurd kernel: [  598.091486] kvm: disabling virtualization on CPU30
Aug  4 17:56:20 absurd kernel: [  598.091521] smpboot: CPU 30 is now offline
Aug  4 17:56:20 absurd kernel: [  598.092241] intel_pstate CPU 31 exiting
Aug  4 17:56:20 absurd kernel: [  598.094351] kvm: disabling virtualization on CPU31
Aug  4 17:56:20 absurd kernel: [  598.194494] smpboot: CPU 31 is now offline
Aug  4 17:56:20 absurd kernel: [  598.195679] PM: Creating hibernation image:
Aug  4 17:56:20 absurd kernel: [  598.885319] PM: Need to copy 395610 pages
Aug  4 17:56:20 absurd kernel: [  598.885321] PM: Normal pages needed: 395610 + 1024, available pages: 16372042
Aug  4 17:56:20 absurd kernel: [  598.202971] Enabling non-boot CPUs ...
Aug  4 17:56:20 absurd kernel: [  598.203288] x86: Booting SMP configuration:
Aug  4 17:56:20 absurd kernel: [  598.203290] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:56:20 absurd kernel: [  598.215123] kvm: enabling virtualization on CPU1
Aug  4 17:56:20 absurd kernel: [  598.217510] Intel pstate controlling: cpu 1
Aug  4 17:56:20 absurd kernel: [  598.217592] CPU1 is up
Aug  4 17:56:20 absurd kernel: [  598.217741] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:56:20 absurd kernel: [  598.229544] kvm: enabling virtualization on CPU2
Aug  4 17:56:20 absurd kernel: [  598.231855] Intel pstate controlling: cpu 2
Aug  4 17:56:20 absurd kernel: [  598.231929] CPU2 is up
Aug  4 17:56:20 absurd kernel: [  598.232085] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:56:20 absurd kernel: [  598.243801] kvm: enabling virtualization on CPU3
Aug  4 17:56:20 absurd kernel: [  598.246072] Intel pstate controlling: cpu 3
Aug  4 17:56:20 absurd kernel: [  598.246139] CPU3 is up
Aug  4 17:56:20 absurd kernel: [  598.246270] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:56:20 absurd kernel: [  598.257966] kvm: enabling virtualization on CPU4
Aug  4 17:56:20 absurd kernel: [  598.260248] Intel pstate controlling: cpu 4
Aug  4 17:56:20 absurd kernel: [  598.260313] CPU4 is up
Aug  4 17:56:20 absurd kernel: [  598.260448] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:56:20 absurd kernel: [  598.272138] kvm: enabling virtualization on CPU5
Aug  4 17:56:20 absurd kernel: [  598.274426] Intel pstate controlling: cpu 5
Aug  4 17:56:20 absurd kernel: [  598.274492] CPU5 is up
Aug  4 17:56:20 absurd kernel: [  598.274629] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:56:20 absurd kernel: [  598.286317] kvm: enabling virtualization on CPU6
Aug  4 17:56:20 absurd kernel: [  598.288604] Intel pstate controlling: cpu 6
Aug  4 17:56:20 absurd kernel: [  598.288669] CPU6 is up
Aug  4 17:56:20 absurd kernel: [  598.288809] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:56:20 absurd kernel: [  598.300491] kvm: enabling virtualization on CPU7
Aug  4 17:56:20 absurd kernel: [  598.302799] Intel pstate controlling: cpu 7
Aug  4 17:56:20 absurd kernel: [  598.302865] CPU7 is up
Aug  4 17:56:20 absurd kernel: [  598.303282] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:56:20 absurd kernel: [  598.316586] kvm: enabling virtualization on CPU8
Aug  4 17:56:20 absurd kernel: [  598.336913] Intel pstate controlling: cpu 8
Aug  4 17:56:20 absurd kernel: [  598.336965] CPU8 is up
Aug  4 17:56:20 absurd kernel: [  598.337307] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:56:20 absurd kernel: [  598.350664] kvm: enabling virtualization on CPU9
Aug  4 17:56:20 absurd kernel: [  598.352940] Intel pstate controlling: cpu 9
Aug  4 17:56:20 absurd kernel: [  598.352990] CPU9 is up
Aug  4 17:56:20 absurd kernel: [  598.353254] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:56:20 absurd kernel: [  598.366624] kvm: enabling virtualization on CPU10
Aug  4 17:56:20 absurd kernel: [  598.368879] Intel pstate controlling: cpu 10
Aug  4 17:56:20 absurd kernel: [  598.368929] CPU10 is up
Aug  4 17:56:20 absurd kernel: [  598.369159] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:56:20 absurd kernel: [  598.382538] kvm: enabling virtualization on CPU11
Aug  4 17:56:20 absurd kernel: [  598.384796] Intel pstate controlling: cpu 11
Aug  4 17:56:20 absurd kernel: [  598.384844] CPU11 is up
Aug  4 17:56:20 absurd kernel: [  598.385048] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:56:20 absurd kernel: [  598.398405] kvm: enabling virtualization on CPU12
Aug  4 17:56:20 absurd kernel: [  598.400692] Intel pstate controlling: cpu 12
Aug  4 17:56:20 absurd kernel: [  598.400740] CPU12 is up
Aug  4 17:56:20 absurd kernel: [  598.400911] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:56:20 absurd kernel: [  598.414233] kvm: enabling virtualization on CPU13
Aug  4 17:56:20 absurd kernel: [  598.416566] Intel pstate controlling: cpu 13
Aug  4 17:56:20 absurd kernel: [  598.416615] CPU13 is up
Aug  4 17:56:20 absurd kernel: [  598.416797] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:56:20 absurd kernel: [  598.430113] kvm: enabling virtualization on CPU14
Aug  4 17:56:20 absurd kernel: [  598.432462] Intel pstate controlling: cpu 14
Aug  4 17:56:20 absurd kernel: [  598.432512] CPU14 is up
Aug  4 17:56:20 absurd kernel: [  598.432681] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:56:20 absurd kernel: [  598.446012] kvm: enabling virtualization on CPU15
Aug  4 17:56:20 absurd kernel: [  598.448355] Intel pstate controlling: cpu 15
Aug  4 17:56:20 absurd kernel: [  598.448404] CPU15 is up
Aug  4 17:56:20 absurd kernel: [  598.448533] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:56:20 absurd kernel: [  598.460274] kvm: enabling virtualization on CPU16
Aug  4 17:56:20 absurd kernel: [  598.462779] Intel pstate controlling: cpu 16
Aug  4 17:56:20 absurd kernel: [  598.462849] CPU16 is up
Aug  4 17:56:20 absurd kernel: [  598.462997] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:56:20 absurd kernel: [  598.474692] kvm: enabling virtualization on CPU17
Aug  4 17:56:20 absurd kernel: [  598.477173] Intel pstate controlling: cpu 17
Aug  4 17:56:20 absurd kernel: [  598.477244] CPU17 is up
Aug  4 17:56:20 absurd kernel: [  598.477393] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:56:20 absurd kernel: [  598.489092] kvm: enabling virtualization on CPU18
Aug  4 17:56:20 absurd kernel: [  598.491591] Intel pstate controlling: cpu 18
Aug  4 17:56:20 absurd kernel: [  598.491661] CPU18 is up
Aug  4 17:56:20 absurd kernel: [  598.491813] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:56:20 absurd kernel: [  598.503520] kvm: enabling virtualization on CPU19
Aug  4 17:56:20 absurd kernel: [  598.505981] Intel pstate controlling: cpu 19
Aug  4 17:56:20 absurd kernel: [  598.506050] CPU19 is up
Aug  4 17:56:20 absurd kernel: [  598.506196] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:56:20 absurd kernel: [  598.517884] kvm: enabling virtualization on CPU20
Aug  4 17:56:20 absurd kernel: [  598.520390] Intel pstate controlling: cpu 20
Aug  4 17:56:20 absurd kernel: [  598.520462] CPU20 is up
Aug  4 17:56:20 absurd kernel: [  598.520609] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:56:20 absurd kernel: [  598.532293] kvm: enabling virtualization on CPU21
Aug  4 17:56:20 absurd kernel: [  598.534770] Intel pstate controlling: cpu 21
Aug  4 17:56:20 absurd kernel: [  598.534838] CPU21 is up
Aug  4 17:56:20 absurd kernel: [  598.534980] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:56:20 absurd kernel: [  598.546661] kvm: enabling virtualization on CPU22
Aug  4 17:56:20 absurd kernel: [  598.549225] Intel pstate controlling: cpu 22
Aug  4 17:56:20 absurd kernel: [  598.549293] CPU22 is up
Aug  4 17:56:20 absurd kernel: [  598.549441] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:56:20 absurd kernel: [  598.561115] kvm: enabling virtualization on CPU23
Aug  4 17:56:20 absurd kernel: [  598.563713] Intel pstate controlling: cpu 23
Aug  4 17:56:20 absurd kernel: [  598.563779] CPU23 is up
Aug  4 17:56:20 absurd kernel: [  598.564086] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:56:20 absurd kernel: [  598.577391] kvm: enabling virtualization on CPU24
Aug  4 17:56:20 absurd kernel: [  598.579796] Intel pstate controlling: cpu 24
Aug  4 17:56:20 absurd kernel: [  598.579841] CPU24 is up
Aug  4 17:56:20 absurd kernel: [  598.580029] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:56:20 absurd kernel: [  598.593362] kvm: enabling virtualization on CPU25
Aug  4 17:56:20 absurd kernel: [  598.595811] Intel pstate controlling: cpu 25
Aug  4 17:56:20 absurd kernel: [  598.595858] CPU25 is up
Aug  4 17:56:20 absurd kernel: [  598.596039] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:56:20 absurd kernel: [  598.609409] kvm: enabling virtualization on CPU26
Aug  4 17:56:20 absurd kernel: [  598.611823] Intel pstate controlling: cpu 26
Aug  4 17:56:20 absurd kernel: [  598.611868] CPU26 is up
Aug  4 17:56:20 absurd kernel: [  598.612057] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:56:20 absurd kernel: [  598.625419] kvm: enabling virtualization on CPU27
Aug  4 17:56:20 absurd kernel: [  598.627850] Intel pstate controlling: cpu 27
Aug  4 17:56:20 absurd kernel: [  598.627897] CPU27 is up
Aug  4 17:56:20 absurd kernel: [  598.628081] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:56:20 absurd kernel: [  598.641425] kvm: enabling virtualization on CPU28
Aug  4 17:56:20 absurd kernel: [  598.643885] Intel pstate controlling: cpu 28
Aug  4 17:56:20 absurd kernel: [  598.643931] CPU28 is up
Aug  4 17:56:20 absurd kernel: [  598.644113] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:56:20 absurd kernel: [  598.657415] kvm: enabling virtualization on CPU29
Aug  4 17:56:20 absurd kernel: [  598.659850] Intel pstate controlling: cpu 29
Aug  4 17:56:20 absurd kernel: [  598.659897] CPU29 is up
Aug  4 17:56:20 absurd kernel: [  598.660066] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:56:20 absurd kernel: [  598.673360] kvm: enabling virtualization on CPU30
Aug  4 17:56:20 absurd kernel: [  598.675800] Intel pstate controlling: cpu 30
Aug  4 17:56:20 absurd kernel: [  598.675847] CPU30 is up
Aug  4 17:56:20 absurd kernel: [  598.676024] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:56:20 absurd kernel: [  598.689301] kvm: enabling virtualization on CPU31
Aug  4 17:56:20 absurd kernel: [  598.691798] Intel pstate controlling: cpu 31
Aug  4 17:56:20 absurd kernel: [  598.691845] CPU31 is up
Aug  4 17:56:20 absurd kernel: [  598.797752] PM: noirq restore of devices complete after 15.220 msecs
Aug  4 17:56:20 absurd kernel: [  598.798156] PM: early restore of devices complete after 0.345 msecs
Aug  4 17:56:20 absurd kernel: [  598.957801] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:56:20 absurd kernel: [  598.957947] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:56:20 absurd kernel: [  598.957988] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:56:20 absurd kernel: [  598.958005] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:56:20 absurd kernel: [  598.958055] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:56:20 absurd kernel: [  598.958120] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958127] igb 0000:02:00.1: irq 100 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958136] igb 0000:02:00.1: irq 101 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958141] igb 0000:02:00.1: irq 102 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958146] igb 0000:02:00.1: irq 103 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958151] igb 0000:02:00.1: irq 104 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958157] igb 0000:02:00.1: irq 105 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958163] igb 0000:02:00.1: irq 106 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958170] igb 0000:02:00.1: irq 107 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958199] igb 0000:02:00.0: irq 111 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958205] igb 0000:02:00.0: irq 112 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958214] igb 0000:02:00.0: irq 113 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958219] igb 0000:02:00.0: irq 114 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958228] igb 0000:02:00.0: irq 115 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958234] igb 0000:02:00.0: irq 116 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958239] igb 0000:02:00.0: irq 117 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958251] igb 0000:02:00.0: irq 118 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958256] igb 0000:02:00.0: irq 119 for MSI/MSI-X
Aug  4 17:56:20 absurd kernel: [  598.958443] serial 00:03: activated
Aug  4 17:56:20 absurd kernel: [  598.958769] serial 00:04: activated
Aug  4 17:56:20 absurd kernel: [  598.961885] ------------[ cut here ]------------
Aug  4 17:56:20 absurd kernel: [  598.961892] WARNING: CPU: 10 PID: 10463 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:56:20 absurd kernel: [  598.961924] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj raid1 usb_storage snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel nvidia(PO) kvm joydev hid_generic snd_hda_codec_ca0132 crct10dif_pclmul iTCO_wdt crc32_pclmul iTCO_vendor_support usbhid ghash_clmulni_intel hid mxm_wmi evdev aesni_intel snd_hda_intel aes_x86_64 ablk_helper cryptd glue_helper lrw snd_hda_controller gf128mul snd_hda_codec pcspkr snd_hwdep sb_edac snd_pcm edac_core snd_seq i2c_i801 snd_seq_device snd_timer snd lpc_ich mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler tpm_tis tpm processor wmi thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci libata scsi_transport_sas scsi_mod igb usbcore i2c_a
Aug  4 17:56:20 absurd kernel: lgo_bit usb_common i2c_core dca ptp pps_core [last unloaded: ehci_hcd]
Aug  4 17:56:20 absurd kernel: [  598.961938] CPU: 10 PID: 10463 Comm: kworker/u66:1 Tainted: P        W  O  3.16.0-vanilla.1 #1
Aug  4 17:56:20 absurd kernel: [  598.961939] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:56:20 absurd kernel: [  598.961943] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:56:20 absurd kernel: [  598.961945]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:56:20 absurd kernel: [  598.961946]  ffffffff810664f6 ffffffffa03ff09b ffff88105572c680 ffff88104734ddc0
Aug  4 17:56:20 absurd kernel: [  598.961947]  ffff88104fd0fc90 ffff88105796b000 ffffffff813a7d3b ffff881055182200
Aug  4 17:56:20 absurd kernel: [  598.961948] Call Trace:
Aug  4 17:56:20 absurd kernel: [  598.961954]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:56:20 absurd kernel: [  598.961957]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:56:20 absurd kernel: [  598.961959]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:56:20 absurd kernel: [  598.961961]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:56:20 absurd kernel: [  598.961964]  [<ffffffffa03fe03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:56:20 absurd kernel: [  598.961968]  [<ffffffffa02cfe21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:56:20 absurd kernel: [  598.961971]  [<ffffffffa02cff17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:56:20 absurd kernel: [  598.961975]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:56:20 absurd kernel: [  598.961978]  [<ffffffffa02cf951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:56:20 absurd kernel: [  598.961980]  [<ffffffffa02d1776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:56:20 absurd kernel: [  598.961983]  [<ffffffffa03ab070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:56:20 absurd kernel: [  598.961986]  [<ffffffffa0334c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:56:20 absurd kernel: [  598.961989]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:56:20 absurd kernel: [  598.961993]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:56:20 absurd kernel: [  598.961995]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:56:20 absurd kernel: [  598.961996]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:56:20 absurd kernel: [  598.961997]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:56:20 absurd kernel: [  598.962000]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:56:20 absurd kernel: [  598.962002]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:56:20 absurd kernel: [  598.962004]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:56:20 absurd kernel: [  598.962005]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:56:20 absurd kernel: [  598.962007]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:56:20 absurd kernel: [  598.962008]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:56:20 absurd kernel: [  598.962009]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:56:20 absurd kernel: [  598.962011]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:56:20 absurd kernel: [  598.962012] ---[ end trace db395c2b3c06720b ]---
Aug  4 17:56:20 absurd kernel: [  598.962013] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:56:20 absurd kernel: [  599.281161] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:56:20 absurd kernel: [  599.281706] ata1.00: configured for UDMA/133
Aug  4 17:56:20 absurd kernel: [  599.309143] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:56:20 absurd kernel: [  599.309171] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:56:20 absurd kernel: [  599.309190] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:56:20 absurd kernel: [  599.310685] ata4.00: configured for UDMA/100
Aug  4 17:56:20 absurd kernel: [  599.317137] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:56:20 absurd kernel: [  599.320376] ata5.00: configured for UDMA/133
Aug  4 17:56:20 absurd kernel: [  599.330740] ata2.00: configured for UDMA/133
Aug  4 17:56:20 absurd kernel: [  599.361296] PM: restore of devices complete after 403.854 msecs
Aug  4 17:56:20 absurd kernel: [  599.477046] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:56:20 absurd kernel: [  599.488445] ata6.00: configured for UDMA/133
Aug  4 17:56:20 absurd kernel: [  599.569941] Restarting kernel threads ... done.
Aug  4 17:56:20 absurd kernel: [  599.570808] PM: Basic memory bitmaps freed
Aug  4 17:56:20 absurd kernel: [  599.570872] Restarting tasks ... done.
Aug  4 17:56:20 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:56:20 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:56:20 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:56:20 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:56:20 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 17:56:20 absurd NetworkManager[4243]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:56:20 absurd kernel: [  599.698495] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Aug  4 17:56:20 absurd kernel: [  599.698907] ehci-pci: EHCI PCI platform driver
Aug  4 17:56:20 absurd kernel: [  599.699010] ehci-pci 0000:00:1a.0: EHCI Host Controller
Aug  4 17:56:20 absurd kernel: [  599.699019] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
Aug  4 17:56:20 absurd kernel: [  599.699032] ehci-pci 0000:00:1a.0: debug port 2
Aug  4 17:56:20 absurd kernel: [  599.702926] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:56:20 absurd kernel: [  599.702941] ehci-pci 0000:00:1a.0: irq 16, io mem 0xdf324000
Aug  4 17:56:20 absurd kernel: [  599.712895] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Aug  4 17:56:20 absurd kernel: [  599.712929] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Aug  4 17:56:20 absurd kernel: [  599.712930] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  4 17:56:20 absurd kernel: [  599.712932] usb usb1: Product: EHCI Host Controller
Aug  4 17:56:20 absurd kernel: [  599.712933] usb usb1: Manufacturer: Linux 3.16.0-vanilla.1 ehci_hcd
Aug  4 17:56:20 absurd kernel: [  599.712934] usb usb1: SerialNumber: 0000:00:1a.0
Aug  4 17:56:20 absurd kernel: [  599.713056] hub 1-0:1.0: USB hub found
Aug  4 17:56:20 absurd kernel: [  599.713060] hub 1-0:1.0: 2 ports detected
Aug  4 17:56:20 absurd kernel: [  599.740919] ehci-pci 0000:00:1d.0: EHCI Host Controller
Aug  4 17:56:20 absurd kernel: [  599.740925] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
Aug  4 17:56:20 absurd kernel: [  599.740935] ehci-pci 0000:00:1d.0: debug port 2
Aug  4 17:56:20 absurd kernel: [  599.744831] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:56:20 absurd kernel: [  599.744841] ehci-pci 0000:00:1d.0: irq 23, io mem 0xdf323000
Aug  4 17:56:20 absurd kernel: [  599.752872] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Aug  4 17:56:20 absurd kernel: [  599.752899] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Aug  4 17:56:20 absurd kernel: [  599.752900] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  4 17:56:20 absurd kernel: [  599.752901] usb usb2: Product: EHCI Host Controller
Aug  4 17:56:20 absurd kernel: [  599.752902] usb usb2: Manufacturer: Linux 3.16.0-vanilla.1 ehci_hcd
Aug  4 17:56:20 absurd kernel: [  599.752903] usb usb2: SerialNumber: 0000:00:1d.0
Aug  4 17:56:20 absurd kernel: [  599.752985] hub 2-0:1.0: USB hub found
Aug  4 17:56:20 absurd kernel: [  599.752991] hub 2-0:1.0: 2 ports detected
Aug  4 17:56:20 absurd acpid: client connected from 4432[0:0]
Aug  4 17:56:20 absurd acpid: 1 client rule loaded
Aug  4 17:56:20 absurd acpid: client connected from 4432[0:0]
Aug  4 17:56:20 absurd acpid: 1 client rule loaded
Aug  4 17:56:20 absurd kernel: [  600.032751] usb 1-1: new high-speed USB device number 2 using ehci-pci
Aug  4 17:56:20 absurd acpid: client connected from 4432[0:0]
Aug  4 17:56:20 absurd acpid: 1 client rule loaded
Aug  4 17:56:20 absurd kernel: [  600.164984] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
Aug  4 17:56:20 absurd kernel: [  600.164987] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Aug  4 17:56:20 absurd kernel: [  600.165442] hub 1-1:1.0: USB hub found
Aug  4 17:56:20 absurd kernel: [  600.165618] hub 1-1:1.0: 6 ports detected
Aug  4 17:56:21 absurd kernel: [  600.276645] usb 2-1: new high-speed USB device number 2 using ehci-pci
Aug  4 17:56:21 absurd acpid: client connected from 4432[0:0]
Aug  4 17:56:21 absurd acpid: 1 client rule loaded
Aug  4 17:56:21 absurd kernel: [  600.408829] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
Aug  4 17:56:21 absurd kernel: [  600.408834] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Aug  4 17:56:21 absurd kernel: [  600.409310] hub 2-1:1.0: USB hub found
Aug  4 17:56:21 absurd kernel: [  600.409443] hub 2-1:1.0: 8 ports detected
Aug  4 17:56:21 absurd kernel: [  600.480548] usb 1-1.6: new full-speed USB device number 3 using ehci-pci
Aug  4 17:56:21 absurd kernel: [  600.574164] usb 1-1.6: New USB device found, idVendor=0557, idProduct=2221
Aug  4 17:56:21 absurd kernel: [  600.574170] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Aug  4 17:56:21 absurd kernel: [  600.574173] usb 1-1.6: Product: Hermon USB hidmouse Device
Aug  4 17:56:21 absurd kernel: [  600.574175] usb 1-1.6: Manufacturer: Winbond Electronics Corp
Aug  4 17:56:21 absurd kernel: [  600.575730] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/0003:0557:2221.0022/input/input25
Aug  4 17:56:21 absurd kernel: [  600.576037] hid-generic 0003:0557:2221.0022: input,hidraw0: USB HID v1.00 Mouse [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.6/input0
Aug  4 17:56:21 absurd kernel: [  600.576797] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.1/0003:0557:2221.0023/input/input26
Aug  4 17:56:21 absurd kernel: [  600.576956] hid-generic 0003:0557:2221.0023: input,hidraw1: USB HID v1.00 Keyboard [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.6/input1
Aug  4 17:56:21 absurd mtp-probe: checking bus 1, device 3: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6"
Aug  4 17:56:21 absurd mtp-probe: bus: 1, device: 3 was not an MTP device
Aug  4 17:56:21 absurd kernel: [  600.680447] usb 2-1.1: new high-speed USB device number 3 using ehci-pci
Aug  4 17:56:21 absurd kernel: [  600.773761] usb 2-1.1: New USB device found, idVendor=0bc2, idProduct=3312
Aug  4 17:56:21 absurd kernel: [  600.773765] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 17:56:21 absurd kernel: [  600.773767] usb 2-1.1: Product: Expansion Desk
Aug  4 17:56:21 absurd kernel: [  600.773769] usb 2-1.1: Manufacturer: Seagate 
Aug  4 17:56:21 absurd kernel: [  600.773783] usb 2-1.1: SerialNumber: NA4M6A1L
Aug  4 17:56:21 absurd kernel: [  600.774184] usb-storage 2-1.1:1.0: USB Mass Storage device detected
Aug  4 17:56:21 absurd kernel: [  600.774421] scsi11 : usb-storage 2-1.1:1.0
Aug  4 17:56:21 absurd mtp-probe: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1"
Aug  4 17:56:21 absurd kernel: [  600.844318] usb 2-1.2: new low-speed USB device number 4 using ehci-pci
Aug  4 17:56:21 absurd kernel: [  600.942880] usb 2-1.2: New USB device found, idVendor=0665, idProduct=5161
Aug  4 17:56:21 absurd kernel: [  600.942883] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 17:56:21 absurd kernel: [  600.942885] usb 2-1.2: Product: USB to Serial
Aug  4 17:56:21 absurd kernel: [  600.942887] usb 2-1.2: Manufacturer: INNO TECH
Aug  4 17:56:21 absurd kernel: [  600.942889] usb 2-1.2: SerialNumber: 20100826
Aug  4 17:56:21 absurd kernel: [  600.949264] hid-generic 0003:0665:5161.0024: hiddev0,hidraw2: USB HID v1.00 Device [INNO TECH USB to Serial] on usb-0000:00:1d.0-1.2/input0
Aug  4 17:56:21 absurd mtp-probe: checking bus 2, device 4: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2"
Aug  4 17:56:21 absurd kernel: [  601.020219] usb 2-1.3: new high-speed USB device number 5 using ehci-pci
Aug  4 17:56:21 absurd mtp-probe: bus: 2, device: 3 was not an MTP device
Aug  4 17:56:21 absurd mtp-probe: bus: 2, device: 4 was not an MTP device
Aug  4 17:56:21 absurd kernel: [  601.112845] usb 2-1.3: New USB device found, idVendor=1a40, idProduct=0101
Aug  4 17:56:21 absurd kernel: [  601.112865] usb 2-1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Aug  4 17:56:21 absurd kernel: [  601.112867] usb 2-1.3: Product: USB 2.0 Hub
Aug  4 17:56:21 absurd kernel: [  601.113292] hub 2-1.3:1.0: USB hub found
Aug  4 17:56:21 absurd kernel: [  601.113430] hub 2-1.3:1.0: 4 ports detected
Aug  4 17:56:22 absurd kernel: [  601.384103] usb 2-1.3.1: new high-speed USB device number 6 using ehci-pci
Aug  4 17:56:22 absurd kernel: [  601.476901] usb 2-1.3.1: New USB device found, idVendor=1a40, idProduct=0101
Aug  4 17:56:22 absurd kernel: [  601.476906] usb 2-1.3.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Aug  4 17:56:22 absurd kernel: [  601.476908] usb 2-1.3.1: Product: USB 2.0 Hub
Aug  4 17:56:22 absurd kernel: [  601.477326] hub 2-1.3.1:1.0: USB hub found
Aug  4 17:56:22 absurd kernel: [  601.477505] hub 2-1.3.1:1.0: 4 ports detected
Aug  4 17:56:22 absurd kernel: [  601.564095] usb 2-1.3.3: new full-speed USB device number 7 using ehci-pci
Aug  4 17:56:22 absurd kernel: [  601.676392] usb 2-1.3.3: New USB device found, idVendor=046d, idProduct=c52b
Aug  4 17:56:22 absurd kernel: [  601.676399] usb 2-1.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Aug  4 17:56:22 absurd kernel: [  601.676402] usb 2-1.3.3: Product: USB Receiver
Aug  4 17:56:22 absurd kernel: [  601.676405] usb 2-1.3.3: Manufacturer: Logitech
Aug  4 17:56:22 absurd kernel: [  601.688082] logitech-djreceiver 0003:046D:C52B.0027: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1.3.3/input2
Aug  4 17:56:22 absurd mtp-probe: checking bus 2, device 7: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3"
Aug  4 17:56:22 absurd kernel: [  601.746229] input: Logitech Unifying Device. Wireless PID:101b as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3/2-1.3.3:1.2/0003:046D:C52B.0027/0003:046D:C52B.0028/input/input27
Aug  4 17:56:22 absurd kernel: [  601.746425] logitech-djdevice 0003:046D:C52B.0028: input,hidraw4: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:101b] on usb-0000:00:1d.0-1.3.3:1
Aug  4 17:56:22 absurd mtp-probe: bus: 2, device: 7 was not an MTP device
Aug  4 17:56:22 absurd kernel: [  601.748514] input: Logitech Unifying Device. Wireless PID:2011 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3/2-1.3.3:1.2/0003:046D:C52B.0027/0003:046D:C52B.0029/input/input28
Aug  4 17:56:22 absurd kernel: [  601.748716] logitech-djdevice 0003:046D:C52B.0029: input,hidraw5: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:2011] on usb-0000:00:1d.0-1.3.3:2
Aug  4 17:56:22 absurd kernel: [  601.772832] scsi 11:0:0:0: Direct-Access     Seagate  Expansion Desk   0737 PQ: 0 ANSI: 6
Aug  4 17:56:22 absurd kernel: [  601.773346] sd 11:0:0:0: Attached scsi generic sg5 type 0
Aug  4 17:56:22 absurd kernel: [  601.773772] sd 11:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:56:22 absurd kernel: [  601.774394] sd 11:0:0:0: [sde] Write Protect is off
Aug  4 17:56:22 absurd kernel: [  601.774395] sd 11:0:0:0: [sde] Mode Sense: 2b 00 10 08
Aug  4 17:56:22 absurd kernel: [  601.775087] sd 11:0:0:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
Aug  4 17:56:22 absurd kernel: [  601.776028] sd 11:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:56:23 absurd NetworkManager[4243]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:56:23 absurd kernel: [  602.279862] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 17:56:23 absurd upsd[4451]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 17:56:23 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:56:25 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:56:25 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="10708" x-info="http://www.rsyslog.com"] start
Aug  4 17:56:25 absurd salomea: ========== resume complete ===========
Aug  4 17:56:26 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:56:29 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:56:29 absurd kernel: [  608.715021]  sde: sde1
Aug  4 17:56:29 absurd kernel: [  608.716627] sd 11:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:56:29 absurd kernel: [  608.718277] sd 11:0:0:0: [sde] Attached SCSI disk
Aug  4 17:56:32 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:56:34 absurd kernel: [  613.250629] colord-sane[10750]: segfault at 9 ip 00007f27e57b4525 sp 00007f27e57a2ce0 error 4 in libdbus-1.so.3.7.2[7f27e57a4000+44000]
Aug  4 17:56:35 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:56:38 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:56:41 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:56:44 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:56:47 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:56:50 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:56:53 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:56:56 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_1_success5.txt

Aug  4 17:56:56 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:56:59 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:57:02 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:57:05 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:57:08 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:57:11 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:57:11 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:57:12 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:57:12 absurd kernel: [  651.924081] ehci-pci 0000:00:1d.0: remove, state 1
Aug  4 17:57:12 absurd kernel: [  651.924107] usb usb2: USB disconnect, device number 1
Aug  4 17:57:12 absurd kernel: [  651.924110] usb 2-1: USB disconnect, device number 2
Aug  4 17:57:12 absurd kernel: [  651.924113] usb 2-1.1: USB disconnect, device number 3
Aug  4 17:57:12 absurd kernel: [  651.925199] sd 11:0:0:0: [sde] Synchronizing SCSI cache
Aug  4 17:57:12 absurd kernel: [  651.925236] sd 11:0:0:0: [sde]  
Aug  4 17:57:12 absurd kernel: [  651.925238] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Aug  4 17:57:12 absurd kernel: [  651.925696] usb 2-1.2: USB disconnect, device number 4
Aug  4 17:57:12 absurd kernel: [  651.926115] usb 2-1.3: USB disconnect, device number 5
Aug  4 17:57:12 absurd kernel: [  651.926122] usb 2-1.3.1: USB disconnect, device number 6
Aug  4 17:57:12 absurd kernel: [  651.926593] usb 2-1.3.3: USB disconnect, device number 7
Aug  4 17:57:12 absurd acpid: input device has been disconnected, fd 19
Aug  4 17:57:12 absurd kernel: [  652.099789] ehci-pci 0000:00:1d.0: USB bus 2 deregistered
Aug  4 17:57:12 absurd kernel: [  652.099915] ehci-pci 0000:00:1a.0: remove, state 1
Aug  4 17:57:12 absurd kernel: [  652.099932] usb usb1: USB disconnect, device number 1
Aug  4 17:57:12 absurd kernel: [  652.099937] usb 1-1: USB disconnect, device number 2
Aug  4 17:57:12 absurd kernel: [  652.099942] usb 1-1.6: USB disconnect, device number 3
Aug  4 17:57:13 absurd kernel: [  652.357626] ehci-pci 0000:00:1a.0: USB bus 1 deregistered
Aug  4 17:58:28 absurd kernel: [  652.944156] Syncing filesystems ... done.
Aug  4 17:58:28 absurd kernel: [  652.946382] Freezing user space processes ... (elapsed 0.001 seconds) done.
Aug  4 17:58:28 absurd kernel: [  652.949251] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:58:28 absurd kernel: [  652.949313] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:58:28 absurd kernel: [  652.950385] PM: Basic memory bitmaps created
Aug  4 17:58:28 absurd kernel: [  652.950555] PM: Preallocating image memory... done (allocated 16301326 pages)
Aug  4 17:58:28 absurd kernel: [  658.154851] PM: Allocated 65205304 kbytes in 5.20 seconds (4279.92 MB/s)
Aug  4 17:58:28 absurd kernel: [  658.154914] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:58:28 absurd kernel: [  658.157086] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:58:28 absurd kernel: [  658.157585] serial 00:04: disabled
Aug  4 17:58:28 absurd kernel: [  658.157663] serial 00:03: disabled
Aug  4 17:58:28 absurd kernel: [  658.221666] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:58:28 absurd kernel: [  658.235106] PM: freeze of devices complete after 77.996 msecs
Aug  4 17:58:28 absurd kernel: [  658.235761] PM: late freeze of devices complete after 0.653 msecs
Aug  4 17:58:28 absurd kernel: [  658.237797] PM: noirq freeze of devices complete after 2.034 msecs
Aug  4 17:58:28 absurd kernel: [  658.237798] Disabling non-boot CPUs ...
Aug  4 17:58:28 absurd kernel: [  658.237976] intel_pstate CPU 1 exiting
Aug  4 17:58:28 absurd kernel: [  658.240001] kvm: disabling virtualization on CPU1
Aug  4 17:58:28 absurd kernel: [  658.241426] smpboot: CPU 1 is now offline
Aug  4 17:58:28 absurd kernel: [  658.242368] intel_pstate CPU 2 exiting
Aug  4 17:58:28 absurd kernel: [  658.244926] kvm: disabling virtualization on CPU2
Aug  4 17:58:28 absurd kernel: [  658.346855] smpboot: CPU 2 is now offline
Aug  4 17:58:28 absurd kernel: [  658.347442] intel_pstate CPU 3 exiting
Aug  4 17:58:28 absurd kernel: [  658.349631] kvm: disabling virtualization on CPU3
Aug  4 17:58:28 absurd kernel: [  658.450814] smpboot: CPU 3 is now offline
Aug  4 17:58:28 absurd kernel: [  658.451611] intel_pstate CPU 4 exiting
Aug  4 17:58:28 absurd kernel: [  658.453952] kvm: disabling virtualization on CPU4
Aug  4 17:58:28 absurd kernel: [  658.554736] smpboot: CPU 4 is now offline
Aug  4 17:58:28 absurd kernel: [  658.555271] intel_pstate CPU 5 exiting
Aug  4 17:58:28 absurd kernel: [  658.557281] kvm: disabling virtualization on CPU5
Aug  4 17:58:28 absurd kernel: [  658.557289] smpboot: CPU 5 is now offline
Aug  4 17:58:28 absurd kernel: [  658.558513] intel_pstate CPU 6 exiting
Aug  4 17:58:28 absurd kernel: [  658.560594] kvm: disabling virtualization on CPU6
Aug  4 17:58:28 absurd kernel: [  658.662670] smpboot: CPU 6 is now offline
Aug  4 17:58:28 absurd kernel: [  658.663083] intel_pstate CPU 7 exiting
Aug  4 17:58:28 absurd kernel: [  658.664770] kvm: disabling virtualization on CPU7
Aug  4 17:58:28 absurd kernel: [  658.664786] smpboot: CPU 7 is now offline
Aug  4 17:58:28 absurd kernel: [  658.665954] intel_pstate CPU 8 exiting
Aug  4 17:58:28 absurd kernel: [  658.667577] kvm: disabling virtualization on CPU8
Aug  4 17:58:28 absurd kernel: [  658.667595] smpboot: CPU 8 is now offline
Aug  4 17:58:28 absurd kernel: [  658.668766] intel_pstate CPU 9 exiting
Aug  4 17:58:28 absurd kernel: [  658.670387] kvm: disabling virtualization on CPU9
Aug  4 17:58:28 absurd kernel: [  658.670395] smpboot: CPU 9 is now offline
Aug  4 17:58:28 absurd kernel: [  658.671792] intel_pstate CPU 10 exiting
Aug  4 17:58:28 absurd kernel: [  658.673355] kvm: disabling virtualization on CPU10
Aug  4 17:58:28 absurd kernel: [  658.673367] smpboot: CPU 10 is now offline
Aug  4 17:58:28 absurd kernel: [  658.674339] intel_pstate CPU 11 exiting
Aug  4 17:58:28 absurd kernel: [  658.675943] kvm: disabling virtualization on CPU11
Aug  4 17:58:28 absurd kernel: [  658.675949] smpboot: CPU 11 is now offline
Aug  4 17:58:28 absurd kernel: [  658.676917] intel_pstate CPU 12 exiting
Aug  4 17:58:28 absurd kernel: [  658.678707] kvm: disabling virtualization on CPU12
Aug  4 17:58:28 absurd kernel: [  658.678727] smpboot: CPU 12 is now offline
Aug  4 17:58:28 absurd kernel: [  658.680429] intel_pstate CPU 13 exiting
Aug  4 17:58:28 absurd kernel: [  658.681934] kvm: disabling virtualization on CPU13
Aug  4 17:58:28 absurd kernel: [  658.782603] smpboot: CPU 13 is now offline
Aug  4 17:58:28 absurd kernel: [  658.783237] intel_pstate CPU 14 exiting
Aug  4 17:58:28 absurd kernel: [  658.784708] kvm: disabling virtualization on CPU14
Aug  4 17:58:28 absurd kernel: [  658.886543] smpboot: CPU 14 is now offline
Aug  4 17:58:28 absurd kernel: [  658.887178] intel_pstate CPU 15 exiting
Aug  4 17:58:28 absurd kernel: [  658.888664] kvm: disabling virtualization on CPU15
Aug  4 17:58:28 absurd kernel: [  658.990497] smpboot: CPU 15 is now offline
Aug  4 17:58:28 absurd kernel: [  658.990942] intel_pstate CPU 16 exiting
Aug  4 17:58:28 absurd kernel: [  658.992410] kvm: disabling virtualization on CPU16
Aug  4 17:58:28 absurd kernel: [  659.098410] smpboot: CPU 16 is now offline
Aug  4 17:58:28 absurd kernel: [  659.098749] intel_pstate CPU 17 exiting
Aug  4 17:58:28 absurd kernel: [  659.100235] kvm: disabling virtualization on CPU17
Aug  4 17:58:28 absurd kernel: [  659.100249] smpboot: CPU 17 is now offline
Aug  4 17:58:28 absurd kernel: [  659.100594] intel_pstate CPU 18 exiting
Aug  4 17:58:28 absurd kernel: [  659.102032] kvm: disabling virtualization on CPU18
Aug  4 17:58:28 absurd kernel: [  659.102045] smpboot: CPU 18 is now offline
Aug  4 17:58:28 absurd kernel: [  659.102377] intel_pstate CPU 19 exiting
Aug  4 17:58:28 absurd kernel: [  659.103900] kvm: disabling virtualization on CPU19
Aug  4 17:58:28 absurd kernel: [  659.206352] smpboot: CPU 19 is now offline
Aug  4 17:58:28 absurd kernel: [  659.206740] intel_pstate CPU 20 exiting
Aug  4 17:58:28 absurd kernel: [  659.208134] kvm: disabling virtualization on CPU20
Aug  4 17:58:28 absurd kernel: [  659.208138] smpboot: CPU 20 is now offline
Aug  4 17:58:28 absurd kernel: [  659.208385] intel_pstate CPU 21 exiting
Aug  4 17:58:28 absurd kernel: [  659.209727] kvm: disabling virtualization on CPU21
Aug  4 17:58:28 absurd kernel: [  659.310292] smpboot: CPU 21 is now offline
Aug  4 17:58:28 absurd kernel: [  659.310662] intel_pstate CPU 22 exiting
Aug  4 17:58:28 absurd kernel: [  659.312032] kvm: disabling virtualization on CPU22
Aug  4 17:58:28 absurd kernel: [  659.414230] smpboot: CPU 22 is now offline
Aug  4 17:58:28 absurd kernel: [  659.414624] intel_pstate CPU 23 exiting
Aug  4 17:58:28 absurd kernel: [  659.415982] kvm: disabling virtualization on CPU23
Aug  4 17:58:28 absurd kernel: [  659.522163] smpboot: CPU 23 is now offline
Aug  4 17:58:28 absurd kernel: [  659.522531] intel_pstate CPU 24 exiting
Aug  4 17:58:28 absurd kernel: [  659.523789] kvm: disabling virtualization on CPU24
Aug  4 17:58:28 absurd kernel: [  659.626128] smpboot: CPU 24 is now offline
Aug  4 17:58:28 absurd kernel: [  659.626777] intel_pstate CPU 25 exiting
Aug  4 17:58:28 absurd kernel: [  659.628114] kvm: disabling virtualization on CPU25
Aug  4 17:58:28 absurd kernel: [  659.734044] smpboot: CPU 25 is now offline
Aug  4 17:58:28 absurd kernel: [  659.734696] intel_pstate CPU 26 exiting
Aug  4 17:58:28 absurd kernel: [  659.736010] kvm: disabling virtualization on CPU26
Aug  4 17:58:28 absurd kernel: [  659.736014] smpboot: CPU 26 is now offline
Aug  4 17:58:28 absurd kernel: [  659.736334] intel_pstate CPU 27 exiting
Aug  4 17:58:28 absurd kernel: [  659.737593] kvm: disabling virtualization on CPU27
Aug  4 17:58:28 absurd kernel: [  659.838012] smpboot: CPU 27 is now offline
Aug  4 17:58:28 absurd kernel: [  659.838642] intel_pstate CPU 28 exiting
Aug  4 17:58:28 absurd kernel: [  659.839949] kvm: disabling virtualization on CPU28
Aug  4 17:58:28 absurd kernel: [  659.945918] smpboot: CPU 28 is now offline
Aug  4 17:58:28 absurd kernel: [  659.946486] intel_pstate CPU 29 exiting
Aug  4 17:58:28 absurd kernel: [  659.947790] kvm: disabling virtualization on CPU29
Aug  4 17:58:28 absurd kernel: [  660.049884] smpboot: CPU 29 is now offline
Aug  4 17:58:28 absurd kernel: [  660.050497] intel_pstate CPU 30 exiting
Aug  4 17:58:28 absurd kernel: [  660.051783] kvm: disabling virtualization on CPU30
Aug  4 17:58:28 absurd kernel: [  660.153853] smpboot: CPU 30 is now offline
Aug  4 17:58:28 absurd kernel: [  660.154547] intel_pstate CPU 31 exiting
Aug  4 17:58:28 absurd kernel: [  660.156574] kvm: disabling virtualization on CPU31
Aug  4 17:58:28 absurd kernel: [  660.257741] smpboot: CPU 31 is now offline
Aug  4 17:58:28 absurd kernel: [  660.259028] PM: Creating hibernation image:
Aug  4 17:58:28 absurd kernel: [  660.940820] PM: Need to copy 396104 pages
Aug  4 17:58:28 absurd kernel: [  660.940822] PM: Normal pages needed: 396104 + 1024, available pages: 16371565
Aug  4 17:58:28 absurd kernel: [  660.266293] Enabling non-boot CPUs ...
Aug  4 17:58:28 absurd kernel: [  660.266614] x86: Booting SMP configuration:
Aug  4 17:58:28 absurd kernel: [  660.266616] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:58:28 absurd kernel: [  660.279549] kvm: enabling virtualization on CPU1
Aug  4 17:58:28 absurd kernel: [  660.281852] Intel pstate controlling: cpu 1
Aug  4 17:58:28 absurd kernel: [  660.281923] CPU1 is up
Aug  4 17:58:28 absurd kernel: [  660.282054] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:58:28 absurd kernel: [  660.293769] kvm: enabling virtualization on CPU2
Aug  4 17:58:28 absurd kernel: [  660.296010] Intel pstate controlling: cpu 2
Aug  4 17:58:28 absurd kernel: [  660.296078] CPU2 is up
Aug  4 17:58:28 absurd kernel: [  660.296218] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:58:28 absurd kernel: [  660.307931] kvm: enabling virtualization on CPU3
Aug  4 17:58:28 absurd kernel: [  660.310203] Intel pstate controlling: cpu 3
Aug  4 17:58:28 absurd kernel: [  660.310267] CPU3 is up
Aug  4 17:58:28 absurd kernel: [  660.310402] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:58:28 absurd kernel: [  660.322101] kvm: enabling virtualization on CPU4
Aug  4 17:58:28 absurd kernel: [  660.324367] Intel pstate controlling: cpu 4
Aug  4 17:58:28 absurd kernel: [  660.324431] CPU4 is up
Aug  4 17:58:28 absurd kernel: [  660.324568] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:58:28 absurd kernel: [  660.336259] kvm: enabling virtualization on CPU5
Aug  4 17:58:28 absurd kernel: [  660.338551] Intel pstate controlling: cpu 5
Aug  4 17:58:28 absurd kernel: [  660.338622] CPU5 is up
Aug  4 17:58:28 absurd kernel: [  660.338760] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:58:28 absurd kernel: [  660.350447] kvm: enabling virtualization on CPU6
Aug  4 17:58:28 absurd kernel: [  660.352747] Intel pstate controlling: cpu 6
Aug  4 17:58:28 absurd kernel: [  660.352813] CPU6 is up
Aug  4 17:58:28 absurd kernel: [  660.352959] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:58:28 absurd kernel: [  660.364644] kvm: enabling virtualization on CPU7
Aug  4 17:58:28 absurd kernel: [  660.366960] Intel pstate controlling: cpu 7
Aug  4 17:58:28 absurd kernel: [  660.367026] CPU7 is up
Aug  4 17:58:28 absurd kernel: [  660.367430] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:58:28 absurd kernel: [  660.380733] kvm: enabling virtualization on CPU8
Aug  4 17:58:28 absurd kernel: [  660.401080] Intel pstate controlling: cpu 8
Aug  4 17:58:28 absurd kernel: [  660.401136] CPU8 is up
Aug  4 17:58:28 absurd kernel: [  660.401472] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:58:28 absurd kernel: [  660.414830] kvm: enabling virtualization on CPU9
Aug  4 17:58:28 absurd kernel: [  660.417102] Intel pstate controlling: cpu 9
Aug  4 17:58:28 absurd kernel: [  660.417153] CPU9 is up
Aug  4 17:58:28 absurd kernel: [  660.417405] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:58:28 absurd kernel: [  660.430771] kvm: enabling virtualization on CPU10
Aug  4 17:58:28 absurd kernel: [  660.433047] Intel pstate controlling: cpu 10
Aug  4 17:58:28 absurd kernel: [  660.433097] CPU10 is up
Aug  4 17:58:28 absurd kernel: [  660.433352] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:58:28 absurd kernel: [  660.446731] kvm: enabling virtualization on CPU11
Aug  4 17:58:28 absurd kernel: [  660.448997] Intel pstate controlling: cpu 11
Aug  4 17:58:28 absurd kernel: [  660.449047] CPU11 is up
Aug  4 17:58:28 absurd kernel: [  660.449258] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:58:28 absurd kernel: [  660.462633] kvm: enabling virtualization on CPU12
Aug  4 17:58:28 absurd kernel: [  660.464921] Intel pstate controlling: cpu 12
Aug  4 17:58:28 absurd kernel: [  660.464972] CPU12 is up
Aug  4 17:58:28 absurd kernel: [  660.465148] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:58:28 absurd kernel: [  660.478229] kvm: enabling virtualization on CPU13
Aug  4 17:58:28 absurd kernel: [  660.480498] Intel pstate controlling: cpu 13
Aug  4 17:58:28 absurd kernel: [  660.480550] CPU13 is up
Aug  4 17:58:28 absurd kernel: [  660.480727] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:58:28 absurd kernel: [  660.493806] kvm: enabling virtualization on CPU14
Aug  4 17:58:28 absurd kernel: [  660.496092] Intel pstate controlling: cpu 14
Aug  4 17:58:28 absurd kernel: [  660.496140] CPU14 is up
Aug  4 17:58:28 absurd kernel: [  660.496313] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:58:28 absurd kernel: [  660.509186] kvm: enabling virtualization on CPU15
Aug  4 17:58:28 absurd kernel: [  660.511481] Intel pstate controlling: cpu 15
Aug  4 17:58:28 absurd kernel: [  660.511529] CPU15 is up
Aug  4 17:58:28 absurd kernel: [  660.511653] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:58:28 absurd kernel: [  660.523378] kvm: enabling virtualization on CPU16
Aug  4 17:58:28 absurd kernel: [  660.525873] Intel pstate controlling: cpu 16
Aug  4 17:58:28 absurd kernel: [  660.525942] CPU16 is up
Aug  4 17:58:28 absurd kernel: [  660.526094] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:58:28 absurd kernel: [  660.537788] kvm: enabling virtualization on CPU17
Aug  4 17:58:28 absurd kernel: [  660.540277] Intel pstate controlling: cpu 17
Aug  4 17:58:28 absurd kernel: [  660.540345] CPU17 is up
Aug  4 17:58:28 absurd kernel: [  660.540488] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:58:28 absurd kernel: [  660.552183] kvm: enabling virtualization on CPU18
Aug  4 17:58:28 absurd kernel: [  660.554693] Intel pstate controlling: cpu 18
Aug  4 17:58:28 absurd kernel: [  660.554759] CPU18 is up
Aug  4 17:58:28 absurd kernel: [  660.554908] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:58:28 absurd kernel: [  660.566615] kvm: enabling virtualization on CPU19
Aug  4 17:58:28 absurd kernel: [  660.569096] Intel pstate controlling: cpu 19
Aug  4 17:58:28 absurd kernel: [  660.569161] CPU19 is up
Aug  4 17:58:28 absurd kernel: [  660.569303] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:58:28 absurd kernel: [  660.580992] kvm: enabling virtualization on CPU20
Aug  4 17:58:28 absurd kernel: [  660.583517] Intel pstate controlling: cpu 20
Aug  4 17:58:28 absurd kernel: [  660.583586] CPU20 is up
Aug  4 17:58:28 absurd kernel: [  660.583729] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:58:28 absurd kernel: [  660.595411] kvm: enabling virtualization on CPU21
Aug  4 17:58:28 absurd kernel: [  660.597956] Intel pstate controlling: cpu 21
Aug  4 17:58:28 absurd kernel: [  660.598019] CPU21 is up
Aug  4 17:58:28 absurd kernel: [  660.598162] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:58:28 absurd kernel: [  660.609840] kvm: enabling virtualization on CPU22
Aug  4 17:58:28 absurd kernel: [  660.612382] Intel pstate controlling: cpu 22
Aug  4 17:58:28 absurd kernel: [  660.612443] CPU22 is up
Aug  4 17:58:28 absurd kernel: [  660.612587] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:58:28 absurd kernel: [  660.624259] kvm: enabling virtualization on CPU23
Aug  4 17:58:28 absurd kernel: [  660.626849] Intel pstate controlling: cpu 23
Aug  4 17:58:28 absurd kernel: [  660.626912] CPU23 is up
Aug  4 17:58:28 absurd kernel: [  660.627205] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:58:28 absurd kernel: [  660.639477] kvm: enabling virtualization on CPU24
Aug  4 17:58:28 absurd kernel: [  660.641905] Intel pstate controlling: cpu 24
Aug  4 17:58:28 absurd kernel: [  660.641950] CPU24 is up
Aug  4 17:58:28 absurd kernel: [  660.642137] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:58:28 absurd kernel: [  660.654309] kvm: enabling virtualization on CPU25
Aug  4 17:58:28 absurd kernel: [  660.656733] Intel pstate controlling: cpu 25
Aug  4 17:58:28 absurd kernel: [  660.656784] CPU25 is up
Aug  4 17:58:28 absurd kernel: [  660.656964] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:58:28 absurd kernel: [  660.669146] kvm: enabling virtualization on CPU26
Aug  4 17:58:28 absurd kernel: [  660.671569] Intel pstate controlling: cpu 26
Aug  4 17:58:28 absurd kernel: [  660.671612] CPU26 is up
Aug  4 17:58:28 absurd kernel: [  660.671789] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:58:28 absurd kernel: [  660.683878] kvm: enabling virtualization on CPU27
Aug  4 17:58:28 absurd kernel: [  660.686346] Intel pstate controlling: cpu 27
Aug  4 17:58:28 absurd kernel: [  660.686389] CPU27 is up
Aug  4 17:58:28 absurd kernel: [  660.686559] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:58:28 absurd kernel: [  660.698552] kvm: enabling virtualization on CPU28
Aug  4 17:58:28 absurd kernel: [  660.700947] Intel pstate controlling: cpu 28
Aug  4 17:58:28 absurd kernel: [  660.700991] CPU28 is up
Aug  4 17:58:28 absurd kernel: [  660.701171] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:58:28 absurd kernel: [  660.713141] kvm: enabling virtualization on CPU29
Aug  4 17:58:28 absurd kernel: [  660.715588] Intel pstate controlling: cpu 29
Aug  4 17:58:28 absurd kernel: [  660.715632] CPU29 is up
Aug  4 17:58:28 absurd kernel: [  660.715796] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:58:28 absurd kernel: [  660.727733] kvm: enabling virtualization on CPU30
Aug  4 17:58:28 absurd kernel: [  660.730224] Intel pstate controlling: cpu 30
Aug  4 17:58:28 absurd kernel: [  660.730267] CPU30 is up
Aug  4 17:58:28 absurd kernel: [  660.730433] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:58:28 absurd kernel: [  660.742325] kvm: enabling virtualization on CPU31
Aug  4 17:58:28 absurd kernel: [  660.744794] Intel pstate controlling: cpu 31
Aug  4 17:58:28 absurd kernel: [  660.744835] CPU31 is up
Aug  4 17:58:28 absurd kernel: [  660.828722] PM: noirq restore of devices complete after 21.812 msecs
Aug  4 17:58:28 absurd kernel: [  660.829144] PM: early restore of devices complete after 0.362 msecs
Aug  4 17:58:28 absurd kernel: [  660.989142] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:58:28 absurd kernel: [  660.989144] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:58:28 absurd kernel: [  660.989151] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:58:28 absurd kernel: [  660.989152] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:58:28 absurd kernel: [  660.989163] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:58:28 absurd kernel: [  660.989408] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989417] igb 0000:02:00.0: irq 100 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989420] igb 0000:02:00.1: irq 101 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989426] igb 0000:02:00.0: irq 102 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989428] igb 0000:02:00.1: irq 103 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989435] igb 0000:02:00.0: irq 104 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989437] igb 0000:02:00.1: irq 105 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989443] igb 0000:02:00.0: irq 106 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989446] igb 0000:02:00.1: irq 107 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989452] igb 0000:02:00.0: irq 111 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989455] igb 0000:02:00.1: irq 112 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989464] igb 0000:02:00.0: irq 113 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989467] igb 0000:02:00.1: irq 114 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989475] igb 0000:02:00.0: irq 115 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989478] igb 0000:02:00.1: irq 116 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989483] igb 0000:02:00.0: irq 117 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989486] igb 0000:02:00.1: irq 118 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989491] igb 0000:02:00.0: irq 119 for MSI/MSI-X
Aug  4 17:58:28 absurd kernel: [  660.989782] serial 00:03: activated
Aug  4 17:58:28 absurd kernel: [  660.990109] serial 00:04: activated
Aug  4 17:58:28 absurd kernel: [  660.993238] ------------[ cut here ]------------
Aug  4 17:58:28 absurd kernel: [  660.993247] WARNING: CPU: 10 PID: 11371 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:58:28 absurd kernel: [  660.993291] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj raid1 usb_storage snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel nvidia(PO) kvm joydev hid_generic snd_hda_codec_ca0132 crct10dif_pclmul iTCO_wdt crc32_pclmul iTCO_vendor_support usbhid ghash_clmulni_intel hid mxm_wmi evdev aesni_intel snd_hda_intel aes_x86_64 ablk_helper cryptd glue_helper lrw snd_hda_controller gf128mul snd_hda_codec pcspkr snd_hwdep sb_edac snd_pcm edac_core snd_seq i2c_i801 snd_seq_device snd_timer snd lpc_ich mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler tpm_tis tpm processor wmi thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci libata scsi_transport_sas scsi_mod igb usbcore i2c_a
Aug  4 17:58:28 absurd kernel: lgo_bit usb_common i2c_core dca ptp pps_core [last unloaded: ehci_hcd]
Aug  4 17:58:28 absurd kernel: [  660.993309] CPU: 10 PID: 11371 Comm: kworker/u66:1 Tainted: P        W  O  3.16.0-vanilla.1 #1
Aug  4 17:58:28 absurd kernel: [  660.993310] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:58:28 absurd kernel: [  660.993316] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:58:28 absurd kernel: [  660.993318]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:58:28 absurd kernel: [  660.993319]  ffffffff810664f6 ffffffffa03ff09b ffff881056e35ae0 ffff881055168100
Aug  4 17:58:28 absurd kernel: [  660.993321]  ffff880882a2fc90 ffff88105796b000 ffffffff813a7d3b ffff881055182200
Aug  4 17:58:28 absurd kernel: [  660.993321] Call Trace:
Aug  4 17:58:28 absurd kernel: [  660.993329]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:58:28 absurd kernel: [  660.993334]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:58:28 absurd kernel: [  660.993337]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:58:28 absurd kernel: [  660.993339]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:58:28 absurd kernel: [  660.993343]  [<ffffffffa03fe03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:58:28 absurd kernel: [  660.993350]  [<ffffffffa02cfe21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:58:28 absurd kernel: [  660.993354]  [<ffffffffa02cff17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:58:28 absurd kernel: [  660.993359]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:58:28 absurd kernel: [  660.993363]  [<ffffffffa02cf951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:58:28 absurd kernel: [  660.993366]  [<ffffffffa02d1776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:58:28 absurd kernel: [  660.993370]  [<ffffffffa03ab070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:58:28 absurd kernel: [  660.993373]  [<ffffffffa0334c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:58:28 absurd kernel: [  660.993377]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:58:28 absurd kernel: [  660.993380]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:58:28 absurd kernel: [  660.993382]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:58:28 absurd kernel: [  660.993384]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:58:28 absurd kernel: [  660.993385]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:58:28 absurd kernel: [  660.993388]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:58:28 absurd kernel: [  660.993390]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:58:28 absurd kernel: [  660.993393]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:58:28 absurd kernel: [  660.993395]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:58:28 absurd kernel: [  660.993397]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:58:28 absurd kernel: [  660.993398]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:58:28 absurd kernel: [  660.993400]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:58:28 absurd kernel: [  660.993401]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:58:28 absurd kernel: [  660.993402] ---[ end trace db395c2b3c06720c ]---
Aug  4 17:58:28 absurd kernel: [  660.993404] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:58:28 absurd kernel: [  661.340417] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:58:28 absurd kernel: [  661.343743] ata5.00: configured for UDMA/133
Aug  4 17:58:28 absurd kernel: [  661.344404] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:58:28 absurd kernel: [  661.344437] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:58:28 absurd kernel: [  661.344461] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:58:28 absurd kernel: [  661.344484] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:58:28 absurd kernel: [  661.344865] ata1.00: configured for UDMA/133
Aug  4 17:58:28 absurd kernel: [  661.345774] ata4.00: configured for UDMA/100
Aug  4 17:58:28 absurd kernel: [  661.366070] ata2.00: configured for UDMA/133
Aug  4 17:58:28 absurd kernel: [  661.388593] PM: restore of devices complete after 399.927 msecs
Aug  4 17:58:28 absurd kernel: [  661.520297] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:58:28 absurd kernel: [  661.531699] ata6.00: configured for UDMA/133
Aug  4 17:58:28 absurd kernel: [  661.585297] Restarting kernel threads ... done.
Aug  4 17:58:28 absurd kernel: [  661.586267] PM: Basic memory bitmaps freed
Aug  4 17:58:28 absurd kernel: [  661.586331] Restarting tasks ... done.
Aug  4 17:58:28 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:58:28 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:58:28 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:58:28 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:58:28 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 17:58:28 absurd upsmon[4479]: UPS duo2pro@localhost is unavailable
Aug  4 17:58:28 absurd NetworkManager[4243]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:58:28 absurd kernel: [  661.760747] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Aug  4 17:58:28 absurd kernel: [  661.761140] ehci-pci: EHCI PCI platform driver
Aug  4 17:58:28 absurd kernel: [  661.761225] ehci-pci 0000:00:1a.0: EHCI Host Controller
Aug  4 17:58:28 absurd kernel: [  661.761229] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
Aug  4 17:58:28 absurd kernel: [  661.761241] ehci-pci 0000:00:1a.0: debug port 2
Aug  4 17:58:28 absurd kernel: [  661.765124] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:58:28 absurd kernel: [  661.765136] ehci-pci 0000:00:1a.0: irq 16, io mem 0xdf324000
Aug  4 17:58:28 absurd kernel: [  661.776123] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Aug  4 17:58:28 absurd kernel: [  661.776154] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Aug  4 17:58:28 absurd kernel: [  661.776155] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  4 17:58:28 absurd kernel: [  661.776156] usb usb1: Product: EHCI Host Controller
Aug  4 17:58:28 absurd kernel: [  661.776157] usb usb1: Manufacturer: Linux 3.16.0-vanilla.1 ehci_hcd
Aug  4 17:58:28 absurd kernel: [  661.776158] usb usb1: SerialNumber: 0000:00:1a.0
Aug  4 17:58:28 absurd kernel: [  661.776262] hub 1-0:1.0: USB hub found
Aug  4 17:58:28 absurd kernel: [  661.776267] hub 1-0:1.0: 2 ports detected
Aug  4 17:58:28 absurd kernel: [  661.784195] ehci-pci 0000:00:1d.0: EHCI Host Controller
Aug  4 17:58:28 absurd kernel: [  661.784199] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
Aug  4 17:58:28 absurd kernel: [  661.784210] ehci-pci 0000:00:1d.0: debug port 2
Aug  4 17:58:28 absurd kernel: [  661.788119] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:58:28 absurd kernel: [  661.788128] ehci-pci 0000:00:1d.0: irq 23, io mem 0xdf323000
Aug  4 17:58:28 absurd kernel: [  661.800101] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Aug  4 17:58:28 absurd kernel: [  661.800139] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Aug  4 17:58:28 absurd kernel: [  661.800141] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Aug  4 17:58:28 absurd kernel: [  661.800142] usb usb2: Product: EHCI Host Controller
Aug  4 17:58:28 absurd kernel: [  661.800143] usb usb2: Manufacturer: Linux 3.16.0-vanilla.1 ehci_hcd
Aug  4 17:58:28 absurd kernel: [  661.800144] usb usb2: SerialNumber: 0000:00:1d.0
Aug  4 17:58:28 absurd kernel: [  661.800265] hub 2-0:1.0: USB hub found
Aug  4 17:58:28 absurd kernel: [  661.800269] hub 2-0:1.0: 2 ports detected
Aug  4 17:58:28 absurd acpid: client connected from 4432[0:0]
Aug  4 17:58:28 absurd acpid: 1 client rule loaded
Aug  4 17:58:28 absurd acpid: client connected from 4432[0:0]
Aug  4 17:58:28 absurd acpid: 1 client rule loaded
Aug  4 17:58:28 absurd kernel: [  662.092061] usb 1-1: new high-speed USB device number 2 using ehci-pci
Aug  4 17:58:28 absurd acpid: client connected from 4432[0:0]
Aug  4 17:58:28 absurd acpid: 1 client rule loaded
Aug  4 17:58:28 absurd kernel: [  662.224348] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
Aug  4 17:58:28 absurd kernel: [  662.224354] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Aug  4 17:58:28 absurd kernel: [  662.224704] hub 1-1:1.0: USB hub found
Aug  4 17:58:28 absurd kernel: [  662.224779] hub 1-1:1.0: 6 ports detected
Aug  4 17:58:29 absurd kernel: [  662.335920] usb 2-1: new high-speed USB device number 2 using ehci-pci
Aug  4 17:58:29 absurd acpid: client connected from 4432[0:0]
Aug  4 17:58:29 absurd acpid: 1 client rule loaded
Aug  4 17:58:29 absurd kernel: [  662.468209] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
Aug  4 17:58:29 absurd kernel: [  662.468215] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Aug  4 17:58:29 absurd kernel: [  662.468570] hub 2-1:1.0: USB hub found
Aug  4 17:58:29 absurd kernel: [  662.468644] hub 2-1:1.0: 8 ports detected
Aug  4 17:58:29 absurd kernel: [  662.539894] usb 1-1.6: new full-speed USB device number 3 using ehci-pci
Aug  4 17:58:29 absurd kernel: [  662.633336] usb 1-1.6: New USB device found, idVendor=0557, idProduct=2221
Aug  4 17:58:29 absurd kernel: [  662.633342] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Aug  4 17:58:29 absurd kernel: [  662.633358] usb 1-1.6: Product: Hermon USB hidmouse Device
Aug  4 17:58:29 absurd kernel: [  662.633360] usb 1-1.6: Manufacturer: Winbond Electronics Corp
Aug  4 17:58:29 absurd kernel: [  662.634519] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/0003:0557:2221.002A/input/input29
Aug  4 17:58:29 absurd kernel: [  662.634710] hid-generic 0003:0557:2221.002A: input,hidraw0: USB HID v1.00 Mouse [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.6/input0
Aug  4 17:58:29 absurd kernel: [  662.635441] input: Winbond Electronics Corp Hermon USB hidmouse Device as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.1/0003:0557:2221.002B/input/input30
Aug  4 17:58:29 absurd kernel: [  662.635562] hid-generic 0003:0557:2221.002B: input,hidraw1: USB HID v1.00 Keyboard [Winbond Electronics Corp Hermon USB hidmouse Device] on usb-0000:00:1a.0-1.6/input1
Aug  4 17:58:29 absurd mtp-probe: checking bus 1, device 3: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6"
Aug  4 17:58:29 absurd mtp-probe: bus: 1, device: 3 was not an MTP device
Aug  4 17:58:29 absurd kernel: [  662.739626] usb 2-1.1: new high-speed USB device number 3 using ehci-pci
Aug  4 17:58:29 absurd kernel: [  662.832930] usb 2-1.1: New USB device found, idVendor=0bc2, idProduct=3312
Aug  4 17:58:29 absurd kernel: [  662.832935] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 17:58:29 absurd kernel: [  662.832938] usb 2-1.1: Product: Expansion Desk
Aug  4 17:58:29 absurd kernel: [  662.832941] usb 2-1.1: Manufacturer: Seagate 
Aug  4 17:58:29 absurd kernel: [  662.832943] usb 2-1.1: SerialNumber: NA4M6A1L
Aug  4 17:58:29 absurd kernel: [  662.833270] usb-storage 2-1.1:1.0: USB Mass Storage device detected
Aug  4 17:58:29 absurd kernel: [  662.833706] scsi12 : usb-storage 2-1.1:1.0
Aug  4 17:58:29 absurd mtp-probe: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1"
Aug  4 17:58:29 absurd kernel: [  662.903654] usb 2-1.2: new low-speed USB device number 4 using ehci-pci
Aug  4 17:58:29 absurd kernel: [  663.002091] usb 2-1.2: New USB device found, idVendor=0665, idProduct=5161
Aug  4 17:58:29 absurd kernel: [  663.002111] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Aug  4 17:58:29 absurd kernel: [  663.002114] usb 2-1.2: Product: USB to Serial
Aug  4 17:58:29 absurd kernel: [  663.002117] usb 2-1.2: Manufacturer: INNO TECH
Aug  4 17:58:29 absurd kernel: [  663.002120] usb 2-1.2: SerialNumber: 20100826
Aug  4 17:58:29 absurd kernel: [  663.008425] hid-generic 0003:0665:5161.002C: hiddev0,hidraw2: USB HID v1.00 Device [INNO TECH USB to Serial] on usb-0000:00:1d.0-1.2/input0
Aug  4 17:58:29 absurd mtp-probe: checking bus 2, device 4: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2"
Aug  4 17:58:29 absurd kernel: [  663.079543] usb 2-1.3: new high-speed USB device number 5 using ehci-pci
Aug  4 17:58:29 absurd mtp-probe: bus: 2, device: 3 was not an MTP device
Aug  4 17:58:29 absurd mtp-probe: bus: 2, device: 4 was not an MTP device
Aug  4 17:58:29 absurd kernel: [  663.172039] usb 2-1.3: New USB device found, idVendor=1a40, idProduct=0101
Aug  4 17:58:29 absurd kernel: [  663.172044] usb 2-1.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Aug  4 17:58:29 absurd kernel: [  663.172047] usb 2-1.3: Product: USB 2.0 Hub
Aug  4 17:58:29 absurd kernel: [  663.172420] hub 2-1.3:1.0: USB hub found
Aug  4 17:58:29 absurd kernel: [  663.172477] hub 2-1.3:1.0: 4 ports detected
Aug  4 17:58:30 absurd kernel: [  663.443396] usb 2-1.3.1: new high-speed USB device number 6 using ehci-pci
Aug  4 17:58:30 absurd kernel: [  663.535828] usb 2-1.3.1: New USB device found, idVendor=1a40, idProduct=0101
Aug  4 17:58:30 absurd kernel: [  663.535834] usb 2-1.3.1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Aug  4 17:58:30 absurd kernel: [  663.535837] usb 2-1.3.1: Product: USB 2.0 Hub
Aug  4 17:58:30 absurd kernel: [  663.536195] hub 2-1.3.1:1.0: USB hub found
Aug  4 17:58:30 absurd kernel: [  663.536263] hub 2-1.3.1:1.0: 4 ports detected
Aug  4 17:58:30 absurd kernel: [  663.623237] usb 2-1.3.3: new full-speed USB device number 7 using ehci-pci
Aug  4 17:58:30 absurd kernel: [  663.735876] usb 2-1.3.3: New USB device found, idVendor=046d, idProduct=c52b
Aug  4 17:58:30 absurd kernel: [  663.735882] usb 2-1.3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Aug  4 17:58:30 absurd kernel: [  663.735885] usb 2-1.3.3: Product: USB Receiver
Aug  4 17:58:30 absurd kernel: [  663.735887] usb 2-1.3.3: Manufacturer: Logitech
Aug  4 17:58:30 absurd kernel: [  663.747427] logitech-djreceiver 0003:046D:C52B.002F: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1.3.3/input2
Aug  4 17:58:30 absurd kernel: [  663.806626] input: Logitech Unifying Device. Wireless PID:101b as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3/2-1.3.3:1.2/0003:046D:C52B.002F/0003:046D:C52B.0030/input/input31
Aug  4 17:58:30 absurd kernel: [  663.806859] logitech-djdevice 0003:046D:C52B.0030: input,hidraw4: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:101b] on usb-0000:00:1d.0-1.3.3:1
Aug  4 17:58:30 absurd mtp-probe: checking bus 2, device 7: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3"
Aug  4 17:58:30 absurd mtp-probe: bus: 2, device: 7 was not an MTP device
Aug  4 17:58:30 absurd kernel: [  663.808678] input: Logitech Unifying Device. Wireless PID:2011 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.3/2-1.3.3:1.2/0003:046D:C52B.002F/0003:046D:C52B.0031/input/input32
Aug  4 17:58:30 absurd kernel: [  663.808860] logitech-djdevice 0003:046D:C52B.0031: input,hidraw5: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:2011] on usb-0000:00:1d.0-1.3.3:2
Aug  4 17:58:30 absurd kernel: [  663.832022] scsi 12:0:0:0: Direct-Access     Seagate  Expansion Desk   0737 PQ: 0 ANSI: 6
Aug  4 17:58:30 absurd kernel: [  663.832531] sd 12:0:0:0: Attached scsi generic sg5 type 0
Aug  4 17:58:30 absurd kernel: [  663.832982] sd 12:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:58:30 absurd kernel: [  663.833636] sd 12:0:0:0: [sde] Write Protect is off
Aug  4 17:58:30 absurd kernel: [  663.833643] sd 12:0:0:0: [sde] Mode Sense: 2b 00 10 08
Aug  4 17:58:30 absurd kernel: [  663.834358] sd 12:0:0:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
Aug  4 17:58:30 absurd kernel: [  663.835483] sd 12:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:58:31 absurd NetworkManager[4243]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:58:31 absurd kernel: [  664.323050] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 17:58:31 absurd upsd[4451]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 17:58:31 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:58:33 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:58:33 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="11607" x-info="http://www.rsyslog.com"] start
Aug  4 17:58:33 absurd salomea: ========== resume complete ===========
Aug  4 17:58:34 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:58:37 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:58:37 absurd kernel: [  670.771813]  sde: sde1
Aug  4 17:58:37 absurd kernel: [  670.772967] sd 12:0:0:0: [sde] 488378645 4096-byte logical blocks: (2.00 TB/1.81 TiB)
Aug  4 17:58:37 absurd kernel: [  670.774421] sd 12:0:0:0: [sde] Attached SCSI disk
Aug  4 17:58:40 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_2_success1.txt

Aug  4 17:28:55 absurd sshd[5725]: Server listening on :: port 22.
Aug  4 17:28:55 absurd sudo:  salomea : TTY=pts/0 ; PWD=/home/salomea ; USER=root ; COMMAND=/etc/init.d/ssh_backup restart
Aug  4 17:28:55 absurd sudo: pam_unix(sudo:session): session opened for user root by salomea(uid=0)
Aug  4 17:28:55 absurd sshd[5756]: Server listening on 192.168.16.108 port 20022.
Aug  4 17:28:59 absurd sudo:  salomea : TTY=pts/1 ; PWD=/home/salomea ; USER=root ; COMMAND=/bin/su
Aug  4 17:28:59 absurd sudo: pam_unix(sudo:session): session opened for user root by salomea(uid=0)
Aug  4 17:28:59 absurd su[5804]: Successful su for root by root
Aug  4 17:28:59 absurd su[5804]: + /dev/pts/1 root:root
Aug  4 17:28:59 absurd su[5804]: pam_unix(su:session): session opened for user root by salomea(uid=0)
unclutter: someone created a sub-window to my sub-window! giving up
Aug  4 17:29:07 absurd NetworkManager[4196]: <info> (eth0): IP6 addrconf timed out or failed.
Aug  4 17:29:07 absurd NetworkManager[4196]: <info> Activation (eth0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Aug  4 17:29:07 absurd NetworkManager[4196]: <info> Activation (eth0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Aug  4 17:29:07 absurd NetworkManager[4196]: <info> Activation (eth0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Aug  4 17:29:11 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:29:12 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:30:32 absurd kernel: [   55.160559] Syncing filesystems ... done.
Aug  4 17:30:32 absurd kernel: [   55.165167] Freezing user space processes ... (elapsed 0.001 seconds) done.
Aug  4 17:30:32 absurd kernel: [   55.169161] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:30:32 absurd kernel: [   55.169235] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:30:32 absurd kernel: [   55.171919] PM: Basic memory bitmaps created
Aug  4 17:30:32 absurd kernel: [   55.172122] PM: Preallocating image memory... done (allocated 16280552 pages)
Aug  4 17:30:32 absurd kernel: [   61.529088] PM: Allocated 65122208 kbytes in 6.36 seconds (3486.24 MB/s)
Aug  4 17:30:32 absurd kernel: [   61.529151] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:30:32 absurd kernel: [   61.531431] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:30:32 absurd kernel: [   61.532155] serial 00:04: disabled
Aug  4 17:30:32 absurd kernel: [   61.532243] serial 00:03: disabled
Aug  4 17:30:32 absurd kernel: [   61.597117] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:30:32 absurd kernel: [   61.609323] PM: freeze of devices complete after 77.867 msecs
Aug  4 17:30:32 absurd kernel: [   61.609965] PM: late freeze of devices complete after 0.641 msecs
Aug  4 17:30:32 absurd kernel: [   61.611941] PM: noirq freeze of devices complete after 1.975 msecs
Aug  4 17:30:32 absurd kernel: [   61.611942] Disabling non-boot CPUs ...
Aug  4 17:30:32 absurd kernel: [   61.612082] intel_pstate CPU 1 exiting
Aug  4 17:30:32 absurd kernel: [   61.613808] kvm: disabling virtualization on CPU1
Aug  4 17:30:32 absurd kernel: [   61.614491] smpboot: CPU 1 is now offline
Aug  4 17:30:32 absurd kernel: [   61.615074] intel_pstate CPU 2 exiting
Aug  4 17:30:32 absurd kernel: [   61.616806] kvm: disabling virtualization on CPU2
Aug  4 17:30:32 absurd kernel: [   61.717206] smpboot: CPU 2 is now offline
Aug  4 17:30:32 absurd kernel: [   61.717639] intel_pstate CPU 3 exiting
Aug  4 17:30:32 absurd kernel: [   61.719315] kvm: disabling virtualization on CPU3
Aug  4 17:30:32 absurd kernel: [   61.719331] smpboot: CPU 3 is now offline
Aug  4 17:30:32 absurd kernel: [   61.720011] intel_pstate CPU 4 exiting
Aug  4 17:30:32 absurd kernel: [   61.721766] kvm: disabling virtualization on CPU4
Aug  4 17:30:32 absurd kernel: [   61.722443] smpboot: CPU 4 is now offline
Aug  4 17:30:32 absurd kernel: [   61.722849] intel_pstate CPU 5 exiting
Aug  4 17:30:32 absurd kernel: [   61.724520] kvm: disabling virtualization on CPU5
Aug  4 17:30:32 absurd kernel: [   61.825145] smpboot: CPU 5 is now offline
Aug  4 17:30:32 absurd kernel: [   61.825533] intel_pstate CPU 6 exiting
Aug  4 17:30:32 absurd kernel: [   61.827165] kvm: disabling virtualization on CPU6
Aug  4 17:30:32 absurd kernel: [   61.929094] smpboot: CPU 6 is now offline
Aug  4 17:30:32 absurd kernel: [   61.929466] intel_pstate CPU 7 exiting
Aug  4 17:30:32 absurd kernel: [   61.931281] kvm: disabling virtualization on CPU7
Aug  4 17:30:32 absurd kernel: [   62.033061] smpboot: CPU 7 is now offline
Aug  4 17:30:32 absurd kernel: [   62.034019] intel_pstate CPU 8 exiting
Aug  4 17:30:32 absurd kernel: [   62.035912] kvm: disabling virtualization on CPU8
Aug  4 17:30:32 absurd kernel: [   62.137002] smpboot: CPU 8 is now offline
Aug  4 17:30:32 absurd kernel: [   62.138019] intel_pstate CPU 9 exiting
Aug  4 17:30:32 absurd kernel: [   62.139824] kvm: disabling virtualization on CPU9
Aug  4 17:30:32 absurd kernel: [   62.139839] smpboot: CPU 9 is now offline
Aug  4 17:30:32 absurd kernel: [   62.141428] intel_pstate CPU 10 exiting
Aug  4 17:30:32 absurd kernel: [   62.143261] kvm: disabling virtualization on CPU10
Aug  4 17:30:32 absurd kernel: [   62.143269] smpboot: CPU 10 is now offline
Aug  4 17:30:32 absurd kernel: [   62.144767] intel_pstate CPU 11 exiting
Aug  4 17:30:32 absurd kernel: [   62.146646] kvm: disabling virtualization on CPU11
Aug  4 17:30:32 absurd kernel: [   62.146660] smpboot: CPU 11 is now offline
Aug  4 17:30:32 absurd kernel: [   62.148133] intel_pstate CPU 12 exiting
Aug  4 17:30:32 absurd kernel: [   62.149968] kvm: disabling virtualization on CPU12
Aug  4 17:30:32 absurd kernel: [   62.149987] smpboot: CPU 12 is now offline
Aug  4 17:30:32 absurd kernel: [   62.152302] intel_pstate CPU 13 exiting
Aug  4 17:30:32 absurd kernel: [   62.154536] kvm: disabling virtualization on CPU13
Aug  4 17:30:32 absurd kernel: [   62.154549] smpboot: CPU 13 is now offline
Aug  4 17:30:32 absurd kernel: [   62.157088] intel_pstate CPU 14 exiting
Aug  4 17:30:32 absurd kernel: [   62.159299] kvm: disabling virtualization on CPU14
Aug  4 17:30:32 absurd kernel: [   62.159312] smpboot: CPU 14 is now offline
Aug  4 17:30:32 absurd kernel: [   62.161800] intel_pstate CPU 15 exiting
Aug  4 17:30:32 absurd kernel: [   62.163980] kvm: disabling virtualization on CPU15
Aug  4 17:30:32 absurd kernel: [   62.164004] smpboot: CPU 15 is now offline
Aug  4 17:30:32 absurd kernel: [   62.165862] intel_pstate CPU 16 exiting
Aug  4 17:30:32 absurd kernel: [   62.167844] kvm: disabling virtualization on CPU16
Aug  4 17:30:32 absurd kernel: [   62.268894] smpboot: CPU 16 is now offline
Aug  4 17:30:32 absurd kernel: [   62.269829] intel_pstate CPU 17 exiting
Aug  4 17:30:32 absurd kernel: [   62.271549] kvm: disabling virtualization on CPU17
Aug  4 17:30:32 absurd kernel: [   62.372832] smpboot: CPU 17 is now offline
Aug  4 17:30:32 absurd kernel: [   62.373445] intel_pstate CPU 18 exiting
Aug  4 17:30:32 absurd kernel: [   62.375184] kvm: disabling virtualization on CPU18
Aug  4 17:30:32 absurd kernel: [   62.476771] smpboot: CPU 18 is now offline
Aug  4 17:30:32 absurd kernel: [   62.477287] intel_pstate CPU 19 exiting
Aug  4 17:30:32 absurd kernel: [   62.479003] kvm: disabling virtualization on CPU19
Aug  4 17:30:32 absurd kernel: [   62.479011] smpboot: CPU 19 is now offline
Aug  4 17:30:32 absurd kernel: [   62.479556] intel_pstate CPU 20 exiting
Aug  4 17:30:32 absurd kernel: [   62.481266] kvm: disabling virtualization on CPU20
Aug  4 17:30:32 absurd kernel: [   62.481293] smpboot: CPU 20 is now offline
Aug  4 17:30:32 absurd kernel: [   62.481846] intel_pstate CPU 21 exiting
Aug  4 17:30:32 absurd kernel: [   62.483536] kvm: disabling virtualization on CPU21
Aug  4 17:30:32 absurd kernel: [   62.483544] smpboot: CPU 21 is now offline
Aug  4 17:30:32 absurd kernel: [   62.484157] intel_pstate CPU 22 exiting
Aug  4 17:30:32 absurd kernel: [   62.485802] kvm: disabling virtualization on CPU22
Aug  4 17:30:32 absurd kernel: [   62.485818] smpboot: CPU 22 is now offline
Aug  4 17:30:32 absurd kernel: [   62.486303] intel_pstate CPU 23 exiting
Aug  4 17:30:32 absurd kernel: [   62.487907] kvm: disabling virtualization on CPU23
Aug  4 17:30:32 absurd kernel: [   62.588708] smpboot: CPU 23 is now offline
Aug  4 17:30:32 absurd kernel: [   62.589599] intel_pstate CPU 24 exiting
Aug  4 17:30:32 absurd kernel: [   62.591181] kvm: disabling virtualization on CPU24
Aug  4 17:30:32 absurd kernel: [   62.692691] smpboot: CPU 24 is now offline
Aug  4 17:30:32 absurd kernel: [   62.693999] intel_pstate CPU 25 exiting
Aug  4 17:30:32 absurd kernel: [   62.695702] kvm: disabling virtualization on CPU25
Aug  4 17:30:32 absurd kernel: [   62.796610] smpboot: CPU 25 is now offline
Aug  4 17:30:32 absurd kernel: [   62.797773] intel_pstate CPU 26 exiting
Aug  4 17:30:32 absurd kernel: [   62.799470] kvm: disabling virtualization on CPU26
Aug  4 17:30:32 absurd kernel: [   62.799479] smpboot: CPU 26 is now offline
Aug  4 17:30:32 absurd kernel: [   62.800367] intel_pstate CPU 27 exiting
Aug  4 17:30:32 absurd kernel: [   62.802023] kvm: disabling virtualization on CPU27
Aug  4 17:30:32 absurd kernel: [   62.904535] smpboot: CPU 27 is now offline
Aug  4 17:30:32 absurd kernel: [   62.905701] intel_pstate CPU 28 exiting
Aug  4 17:30:32 absurd kernel: [   62.907372] kvm: disabling virtualization on CPU28
Aug  4 17:30:32 absurd kernel: [   62.907380] smpboot: CPU 28 is now offline
Aug  4 17:30:32 absurd kernel: [   62.908215] intel_pstate CPU 29 exiting
Aug  4 17:30:32 absurd kernel: [   62.909815] kvm: disabling virtualization on CPU29
Aug  4 17:30:32 absurd kernel: [   63.012468] smpboot: CPU 29 is now offline
Aug  4 17:30:32 absurd kernel: [   63.013527] intel_pstate CPU 30 exiting
Aug  4 17:30:32 absurd kernel: [   63.015156] kvm: disabling virtualization on CPU30
Aug  4 17:30:32 absurd kernel: [   63.015164] smpboot: CPU 30 is now offline
Aug  4 17:30:32 absurd kernel: [   63.015658] intel_pstate CPU 31 exiting
Aug  4 17:30:32 absurd kernel: [   63.016046] Broke affinity for irq 96
Aug  4 17:30:32 absurd kernel: [   63.016051] Broke affinity for irq 97
Aug  4 17:30:32 absurd kernel: [   63.016055] Broke affinity for irq 98
Aug  4 17:30:32 absurd kernel: [   63.016105] Broke affinity for irq 128
Aug  4 17:30:32 absurd kernel: [   63.016109] Broke affinity for irq 129
Aug  4 17:30:32 absurd kernel: [   63.016113] Broke affinity for irq 130
Aug  4 17:30:32 absurd kernel: [   63.016117] Broke affinity for irq 131
Aug  4 17:30:32 absurd kernel: [   63.016121] Broke affinity for irq 132
Aug  4 17:30:32 absurd kernel: [   63.016125] Broke affinity for irq 133
Aug  4 17:30:32 absurd kernel: [   63.016129] Broke affinity for irq 134
Aug  4 17:30:32 absurd kernel: [   63.016134] Broke affinity for irq 135
Aug  4 17:30:32 absurd kernel: [   63.017221] kvm: disabling virtualization on CPU31
Aug  4 17:30:32 absurd kernel: [   63.120389] smpboot: CPU 31 is now offline
Aug  4 17:30:32 absurd kernel: [   63.121749] PM: Creating hibernation image:
Aug  4 17:30:32 absurd kernel: [   63.807999] PM: Need to copy 409765 pages
Aug  4 17:30:32 absurd kernel: [   63.808000] PM: Normal pages needed: 409765 + 1024, available pages: 16357912
Aug  4 17:30:32 absurd kernel: [   63.129022] Enabling non-boot CPUs ...
Aug  4 17:30:32 absurd kernel: [   63.129338] x86: Booting SMP configuration:
Aug  4 17:30:32 absurd kernel: [   63.129340] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:30:32 absurd kernel: [   63.142702] kvm: enabling virtualization on CPU1
Aug  4 17:30:32 absurd kernel: [   63.145303] Intel pstate controlling: cpu 1
Aug  4 17:30:32 absurd kernel: [   63.145439] CPU1 is up
Aug  4 17:30:32 absurd kernel: [   63.145682] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:30:32 absurd kernel: [   63.159468] kvm: enabling virtualization on CPU2
Aug  4 17:30:32 absurd kernel: [   63.161888] Intel pstate controlling: cpu 2
Aug  4 17:30:32 absurd kernel: [   63.162013] CPU2 is up
Aug  4 17:30:32 absurd kernel: [   63.162250] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:30:32 absurd kernel: [   63.175037] kvm: enabling virtualization on CPU3
Aug  4 17:30:32 absurd kernel: [   63.177485] Intel pstate controlling: cpu 3
Aug  4 17:30:32 absurd kernel: [   63.177599] CPU3 is up
Aug  4 17:30:32 absurd kernel: [   63.177822] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:30:32 absurd kernel: [   63.190419] kvm: enabling virtualization on CPU4
Aug  4 17:30:32 absurd kernel: [   63.192838] Intel pstate controlling: cpu 4
Aug  4 17:30:32 absurd kernel: [   63.192937] CPU4 is up
Aug  4 17:30:32 absurd kernel: [   63.193143] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:30:32 absurd kernel: [   63.205717] kvm: enabling virtualization on CPU5
Aug  4 17:30:32 absurd kernel: [   63.208083] Intel pstate controlling: cpu 5
Aug  4 17:30:32 absurd kernel: [   63.208179] CPU5 is up
Aug  4 17:30:32 absurd kernel: [   63.208377] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:30:32 absurd kernel: [   63.220560] kvm: enabling virtualization on CPU6
Aug  4 17:30:32 absurd kernel: [   63.222959] Intel pstate controlling: cpu 6
Aug  4 17:30:32 absurd kernel: [   63.223049] CPU6 is up
Aug  4 17:30:32 absurd kernel: [   63.223240] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:30:32 absurd kernel: [   63.235316] kvm: enabling virtualization on CPU7
Aug  4 17:30:32 absurd kernel: [   63.237720] Intel pstate controlling: cpu 7
Aug  4 17:30:32 absurd kernel: [   63.237807] CPU7 is up
Aug  4 17:30:32 absurd kernel: [   63.238272] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:30:32 absurd kernel: [   63.251582] kvm: enabling virtualization on CPU8
Aug  4 17:30:32 absurd kernel: [   63.272075] Intel pstate controlling: cpu 8
Aug  4 17:30:32 absurd kernel: [   63.272142] CPU8 is up
Aug  4 17:30:32 absurd kernel: [   63.272532] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:30:32 absurd kernel: [   63.285888] kvm: enabling virtualization on CPU9
Aug  4 17:30:32 absurd kernel: [   63.288279] Intel pstate controlling: cpu 9
Aug  4 17:30:32 absurd kernel: [   63.288354] CPU9 is up
Aug  4 17:30:32 absurd kernel: [   63.288671] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:30:32 absurd kernel: [   63.302062] kvm: enabling virtualization on CPU10
Aug  4 17:30:32 absurd kernel: [   63.304367] Intel pstate controlling: cpu 10
Aug  4 17:30:32 absurd kernel: [   63.304427] CPU10 is up
Aug  4 17:30:32 absurd kernel: [   63.304726] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:30:32 absurd kernel: [   63.318103] kvm: enabling virtualization on CPU11
Aug  4 17:30:32 absurd kernel: [   63.320351] Intel pstate controlling: cpu 11
Aug  4 17:30:32 absurd kernel: [   63.320399] CPU11 is up
Aug  4 17:30:32 absurd kernel: [   63.320626] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:30:32 absurd kernel: [   63.333998] kvm: enabling virtualization on CPU12
Aug  4 17:30:32 absurd kernel: [   63.336256] Intel pstate controlling: cpu 12
Aug  4 17:30:32 absurd kernel: [   63.336301] CPU12 is up
Aug  4 17:30:32 absurd kernel: [   63.336488] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:30:32 absurd kernel: [   63.349806] kvm: enabling virtualization on CPU13
Aug  4 17:30:32 absurd kernel: [   63.352136] Intel pstate controlling: cpu 13
Aug  4 17:30:32 absurd kernel: [   63.352183] CPU13 is up
Aug  4 17:30:32 absurd kernel: [   63.352359] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:30:32 absurd kernel: [   63.365671] kvm: enabling virtualization on CPU14
Aug  4 17:30:32 absurd kernel: [   63.368006] Intel pstate controlling: cpu 14
Aug  4 17:30:32 absurd kernel: [   63.368051] CPU14 is up
Aug  4 17:30:32 absurd kernel: [   63.368228] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:30:32 absurd kernel: [   63.381554] kvm: enabling virtualization on CPU15
Aug  4 17:30:32 absurd kernel: [   63.383881] Intel pstate controlling: cpu 15
Aug  4 17:30:32 absurd kernel: [   63.383926] CPU15 is up
Aug  4 17:30:32 absurd kernel: [   63.384052] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:30:32 absurd kernel: [   63.395740] kvm: enabling virtualization on CPU16
Aug  4 17:30:32 absurd kernel: [   63.398164] Intel pstate controlling: cpu 16
Aug  4 17:30:32 absurd kernel: [   63.398224] CPU16 is up
Aug  4 17:30:32 absurd kernel: [   63.398370] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:30:32 absurd kernel: [   63.410085] kvm: enabling virtualization on CPU17
Aug  4 17:30:32 absurd kernel: [   63.412564] Intel pstate controlling: cpu 17
Aug  4 17:30:32 absurd kernel: [   63.412632] CPU17 is up
Aug  4 17:30:32 absurd kernel: [   63.412777] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:30:32 absurd kernel: [   63.424473] kvm: enabling virtualization on CPU18
Aug  4 17:30:32 absurd kernel: [   63.426958] Intel pstate controlling: cpu 18
Aug  4 17:30:32 absurd kernel: [   63.427021] CPU18 is up
Aug  4 17:30:32 absurd kernel: [   63.427165] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:30:32 absurd kernel: [   63.438868] kvm: enabling virtualization on CPU19
Aug  4 17:30:32 absurd kernel: [   63.441355] Intel pstate controlling: cpu 19
Aug  4 17:30:32 absurd kernel: [   63.441421] CPU19 is up
Aug  4 17:30:32 absurd kernel: [   63.441562] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:30:32 absurd kernel: [   63.453252] kvm: enabling virtualization on CPU20
Aug  4 17:30:32 absurd kernel: [   63.455788] Intel pstate controlling: cpu 20
Aug  4 17:30:32 absurd kernel: [   63.455848] CPU20 is up
Aug  4 17:30:32 absurd kernel: [   63.455995] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:30:32 absurd kernel: [   63.467676] kvm: enabling virtualization on CPU21
Aug  4 17:30:32 absurd kernel: [   63.470232] Intel pstate controlling: cpu 21
Aug  4 17:30:32 absurd kernel: [   63.470293] CPU21 is up
Aug  4 17:30:32 absurd kernel: [   63.470438] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:30:32 absurd kernel: [   63.482119] kvm: enabling virtualization on CPU22
Aug  4 17:30:32 absurd kernel: [   63.484695] Intel pstate controlling: cpu 22
Aug  4 17:30:32 absurd kernel: [   63.484757] CPU22 is up
Aug  4 17:30:32 absurd kernel: [   63.484905] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:30:32 absurd kernel: [   63.496574] kvm: enabling virtualization on CPU23
Aug  4 17:30:32 absurd kernel: [   63.499152] Intel pstate controlling: cpu 23
Aug  4 17:30:32 absurd kernel: [   63.499212] CPU23 is up
Aug  4 17:30:32 absurd kernel: [   63.499545] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:30:32 absurd kernel: [   63.512847] kvm: enabling virtualization on CPU24
Aug  4 17:30:32 absurd kernel: [   63.515234] Intel pstate controlling: cpu 24
Aug  4 17:30:32 absurd kernel: [   63.515278] CPU24 is up
Aug  4 17:30:32 absurd kernel: [   63.515502] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:30:32 absurd kernel: [   63.528834] kvm: enabling virtualization on CPU25
Aug  4 17:30:32 absurd kernel: [   63.531278] Intel pstate controlling: cpu 25
Aug  4 17:30:32 absurd kernel: [   63.531326] CPU25 is up
Aug  4 17:30:32 absurd kernel: [   63.531518] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:30:32 absurd kernel: [   63.544866] kvm: enabling virtualization on CPU26
Aug  4 17:30:32 absurd kernel: [   63.547295] Intel pstate controlling: cpu 26
Aug  4 17:30:32 absurd kernel: [   63.547340] CPU26 is up
Aug  4 17:30:32 absurd kernel: [   63.547526] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:30:32 absurd kernel: [   63.560885] kvm: enabling virtualization on CPU27
Aug  4 17:30:32 absurd kernel: [   63.563315] Intel pstate controlling: cpu 27
Aug  4 17:30:32 absurd kernel: [   63.563360] CPU27 is up
Aug  4 17:30:32 absurd kernel: [   63.563536] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:30:32 absurd kernel: [   63.576872] kvm: enabling virtualization on CPU28
Aug  4 17:30:32 absurd kernel: [   63.579353] Intel pstate controlling: cpu 28
Aug  4 17:30:32 absurd kernel: [   63.579401] CPU28 is up
Aug  4 17:30:32 absurd kernel: [   63.579571] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:30:32 absurd kernel: [   63.592872] kvm: enabling virtualization on CPU29
Aug  4 17:30:32 absurd kernel: [   63.595289] Intel pstate controlling: cpu 29
Aug  4 17:30:32 absurd kernel: [   63.595336] CPU29 is up
Aug  4 17:30:32 absurd kernel: [   63.595524] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:30:32 absurd kernel: [   63.608818] kvm: enabling virtualization on CPU30
Aug  4 17:30:32 absurd kernel: [   63.611255] Intel pstate controlling: cpu 30
Aug  4 17:30:32 absurd kernel: [   63.611301] CPU30 is up
Aug  4 17:30:32 absurd kernel: [   63.611489] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:30:32 absurd kernel: [   63.624766] kvm: enabling virtualization on CPU31
Aug  4 17:30:32 absurd kernel: [   63.627224] Intel pstate controlling: cpu 31
Aug  4 17:30:32 absurd kernel: [   63.627270] CPU31 is up
Aug  4 17:30:32 absurd kernel: [   63.731646] PM: noirq restore of devices complete after 14.403 msecs
Aug  4 17:30:32 absurd kernel: [   63.732159] PM: early restore of devices complete after 0.452 msecs
Aug  4 17:30:32 absurd kernel: [   63.892738] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:30:32 absurd kernel: [   63.892811] usb usb2: root hub lost power or was reset
Aug  4 17:30:32 absurd kernel: [   63.892812] usb usb1: root hub lost power or was reset
Aug  4 17:30:32 absurd kernel: [   63.893022] igb 0000:02:00.0: irq 100 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893026] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893028] igb 0000:02:00.0: irq 101 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893036] igb 0000:02:00.1: irq 102 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893038] igb 0000:02:00.0: irq 103 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893047] igb 0000:02:00.1: irq 104 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893049] igb 0000:02:00.0: irq 105 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893055] igb 0000:02:00.1: irq 106 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893057] igb 0000:02:00.0: irq 107 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893067] igb 0000:02:00.1: irq 111 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893068] igb 0000:02:00.0: irq 112 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893079] igb 0000:02:00.1: irq 113 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893081] igb 0000:02:00.0: irq 114 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893088] igb 0000:02:00.1: irq 115 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893090] igb 0000:02:00.0: irq 116 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893096] igb 0000:02:00.1: irq 117 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893098] igb 0000:02:00.0: irq 118 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893106] igb 0000:02:00.1: irq 119 for MSI/MSI-X
Aug  4 17:30:32 absurd kernel: [   63.893399] serial 00:03: activated
Aug  4 17:30:32 absurd kernel: [   63.893772] serial 00:04: activated
Aug  4 17:30:32 absurd kernel: [   63.896715] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:30:32 absurd kernel: [   63.896722] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:30:32 absurd kernel: [   63.896754] ------------[ cut here ]------------
Aug  4 17:30:32 absurd kernel: [   63.896760] WARNING: CPU: 27 PID: 5875 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:30:32 absurd kernel: [   63.896795] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj snd_hda_codec_hdmi snd_hda_codec_ca0132 x86_pkg_temp_thermal intel_powerclamp nvidia(PO) coretemp kvm_intel snd_hda_intel kvm iTCO_wdt snd_hda_controller iTCO_vendor_support crct10dif_pclmul crc32_pclmul ghash_clmulni_intel mxm_wmi snd_hda_codec aesni_intel aes_x86_64 ablk_helper evdev joydev cryptd glue_helper lrw gf128mul pcspkr snd_hwdep snd_pcm sb_edac edac_core i2c_i801 snd_seq snd_seq_device snd_timer lpc_ich mei_me mfd_core snd mei soundcore ioatdma tpm_tis tpm ipmi_si ipmi_msghandler wmi processor thermal_sys button ext4 mbcache crc16 jbd2 dm_mod usb_storage raid1 hid_generic usbhid hid md_mod sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common crc32c_intel isci ahci libsas libahci libata scsi_transport_sas ehci_pci ehci_hcd scsi_mod
Aug  4 17:30:32 absurd kernel: igb usbcore i2c_algo_bit usb_common i2c_core dca ptp pps_core
Aug  4 17:30:32 absurd kernel: [   63.896808] CPU: 27 PID: 5875 Comm: kworker/u66:7 Tainted: P           O  3.16.0-vanilla.1 #1
Aug  4 17:30:32 absurd kernel: [   63.896809] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:30:32 absurd kernel: [   63.896813] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:30:32 absurd kernel: [   63.896815]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:30:32 absurd kernel: [   63.896816]  ffffffff810664f6 ffffffffa03b509b ffff88105526ff00 ffff88105523d580
Aug  4 17:30:32 absurd kernel: [   63.896817]  ffff8810550efc90 ffff881057a91000 ffffffff813a7d3b ffff881054c42c00
Aug  4 17:30:32 absurd kernel: [   63.896817] Call Trace:
Aug  4 17:30:32 absurd kernel: [   63.896824]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:30:32 absurd kernel: [   63.896827]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:30:32 absurd kernel: [   63.896829]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:30:32 absurd kernel: [   63.896831]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:30:32 absurd kernel: [   63.896834]  [<ffffffffa03b403f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:30:32 absurd kernel: [   63.896837]  [<ffffffffa08a5e21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:30:32 absurd kernel: [   63.896840]  [<ffffffffa08a5f17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:30:32 absurd kernel: [   63.896844]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:30:32 absurd kernel: [   63.896846]  [<ffffffffa08a5951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:30:32 absurd kernel: [   63.896848]  [<ffffffffa08a7776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:30:32 absurd kernel: [   63.896850]  [<ffffffffa0323070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:30:32 absurd kernel: [   63.896852]  [<ffffffffa0375c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:30:32 absurd kernel: [   63.896856]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:30:32 absurd kernel: [   63.896859]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:30:32 absurd kernel: [   63.896861]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:30:32 absurd kernel: [   63.896863]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:30:32 absurd kernel: [   63.896864]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:30:32 absurd kernel: [   63.896867]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:30:32 absurd kernel: [   63.896868]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:30:32 absurd kernel: [   63.896872]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:30:32 absurd kernel: [   63.896873]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:30:32 absurd kernel: [   63.896875]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:30:32 absurd kernel: [   63.896876]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:30:32 absurd kernel: [   63.896878]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:30:32 absurd kernel: [   63.896879]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:30:32 absurd kernel: [   63.896880] ---[ end trace 0e3ffca01377c7cb ]---
Aug  4 17:30:32 absurd kernel: [   63.896881] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:30:32 absurd kernel: [   63.897432] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:30:32 absurd kernel: [   63.897474] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:30:32 absurd kernel: [   63.897519] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:30:32 absurd kernel: [   63.897546] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:30:32 absurd kernel: [   64.211101] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:30:32 absurd kernel: [   64.211618] ata1.00: configured for UDMA/133
Aug  4 17:30:32 absurd kernel: [   64.219080] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:30:32 absurd kernel: [   64.227063] usb 2-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:30:32 absurd kernel: [   64.227074] usb 1-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:30:32 absurd kernel: [   64.227086] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:30:32 absurd kernel: [   64.240905] ata2.00: configured for UDMA/133
Aug  4 17:30:32 absurd kernel: [   64.243069] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:30:32 absurd kernel: [   64.243094] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:30:32 absurd kernel: [   64.244477] ata4.00: configured for UDMA/100
Aug  4 17:30:32 absurd kernel: [   64.246289] ata5.00: configured for UDMA/133
Aug  4 17:30:32 absurd kernel: [   64.362987] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:30:32 absurd kernel: [   64.374741] ata6.00: configured for UDMA/133
Aug  4 17:30:32 absurd kernel: [   64.642893] usb 2-1.3: reset high-speed USB device number 5 using ehci-pci
Aug  4 17:30:32 absurd kernel: [   64.642913] usb 1-1.6: reset full-speed USB device number 3 using ehci-pci
Aug  4 17:30:32 absurd kernel: [   64.806924] usb 2-1.1: reset high-speed USB device number 3 using ehci-pci
Aug  4 17:30:32 absurd kernel: [   65.158592] usb 2-1.2: reset low-speed USB device number 4 using ehci-pci
Aug  4 17:30:32 absurd kernel: [   65.510402] usb 2-1.3.1: reset high-speed USB device number 6 using ehci-pci
Aug  4 17:30:32 absurd kernel: [   65.690294] usb 2-1.3.3: reset full-speed USB device number 7 using ehci-pci
Aug  4 17:30:32 absurd kernel: [   65.862187] PM: restore of devices complete after 1970.692 msecs
Aug  4 17:30:32 absurd kernel: [   65.889026] hid-generic 0003:0665:5161.0009: hiddev0,hidraw2: USB HID v1.00 Device [INNO TECH USB to Serial] on usb-0000:00:1d.0-1.2/input0
Aug  4 17:30:32 absurd kernel: [   66.019498] Restarting kernel threads ... done.
Aug  4 17:30:32 absurd kernel: [   66.020172] PM: Basic memory bitmaps freed
Aug  4 17:30:32 absurd kernel: [   66.020250] Restarting tasks ... done.
Aug  4 17:30:32 absurd acpid: client 4406[0:0] has disconnected
Aug  4 17:30:32 absurd upsd[4421]: Data for UPS [duo2pro] is stale - check driver
Aug  4 17:30:32 absurd acpid: client 4406[0:0] has disconnected
Aug  4 17:30:32 absurd acpid: client 4406[0:0] has disconnected
Aug  4 17:30:32 absurd acpid: client 4406[0:0] has disconnected
Aug  4 17:30:32 absurd kernel: [   66.038926] usb 2-1.2: usbfs: process 4418 (blazer_usb) did not claim interface 0 before use
Aug  4 17:30:32 absurd acpid: client connected from 4406[0:0]
Aug  4 17:30:32 absurd upsd[4421]: UPS [duo2pro] data is no longer stale
Aug  4 17:30:32 absurd acpid: 1 client rule loaded
Aug  4 17:30:32 absurd blazer_usb[4418]: Got disconnected by another driver: Device or resource busy
Aug  4 17:30:32 absurd upsd[4421]: Can't connect to UPS [duo2pro] (blazer_usb-duo2pro): No such file or directory
Aug  4 17:30:32 absurd upsmon[4460]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 17:30:32 absurd upsmon[4460]: Communications with UPS duo2pro@localhost lost
Aug  4 17:30:32 absurd NetworkManager[4196]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:30:33 absurd acpid: client connected from 4406[0:0]
Aug  4 17:30:33 absurd acpid: 1 client rule loaded
Aug  4 17:30:33 absurd acpid: client connected from 4406[0:0]
Aug  4 17:30:33 absurd acpid: 1 client rule loaded
Aug  4 17:30:33 absurd acpid: client connected from 4406[0:0]
Aug  4 17:30:33 absurd acpid: 1 client rule loaded
Aug  4 17:30:34 absurd NetworkManager[4196]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:30:34 absurd kernel: [   67.313634] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Warning:  meter MemMeter had a negative value of -19660800.000000 for field 4
Warning:  meter MemMeter had a negative value of -19066880.000000 for field 4
Aug  4 17:30:35 absurd upsd[4421]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 17:30:35 absurd upsmon[4460]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Warning:  meter MemMeter had a negative value of -19619840.000000 for field 4
Warning:  meter MemMeter had a negative value of -19542016.000000 for field 4
Aug  4 17:30:38 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:30:38 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="6032" x-info="http://www.rsyslog.com"] start
Aug  4 17:30:38 absurd salomea: ========== resume complete ===========
Future warnings from the MemMeter meter will not be displayed.
Aug  4 17:30:38 absurd upsmon[4460]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:30:41 absurd upsmon[4460]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:30:44 absurd upsmon[4460]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:30:47 absurd upsmon[4460]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:30:50 absurd upsmon[4460]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:30:53 absurd upsmon[4460]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_2_success2.txt

Aug  4 17:34:21 absurd sudo:  salomea : TTY=pts/0 ; PWD=/home/salomea ; USER=root ; COMMAND=/usr/bin/pkill -15 sshd
Aug  4 17:34:21 absurd sudo: pam_unix(sudo:session): session opened for user root by salomea(uid=0)
Aug  4 17:34:21 absurd sshd[5714]: Received signal 15; terminating.
Aug  4 17:34:21 absurd sudo:  salomea : TTY=pts/0 ; PWD=/home/salomea ; USER=root ; COMMAND=/etc/init.d/ssh restart
Aug  4 17:34:21 absurd sudo: pam_unix(sudo:session): session opened for user root by salomea(uid=0)
Aug  4 17:34:21 absurd sshd[5766]: Server listening on 0.0.0.0 port 22.
Aug  4 17:34:21 absurd sshd[5766]: Server listening on :: port 22.
Aug  4 17:34:21 absurd sudo:  salomea : TTY=pts/0 ; PWD=/home/salomea ; USER=root ; COMMAND=/etc/init.d/ssh_backup restart
Aug  4 17:34:21 absurd sudo: pam_unix(sudo:session): session opened for user root by salomea(uid=0)
Aug  4 17:34:21 absurd sshd[5797]: Server listening on 192.168.16.108 port 20022.
Aug  4 17:34:26 absurd sudo:  salomea : TTY=pts/1 ; PWD=/home/salomea ; USER=root ; COMMAND=/bin/su
Aug  4 17:34:26 absurd sudo: pam_unix(sudo:session): session opened for user root by salomea(uid=0)
Aug  4 17:34:26 absurd su[5844]: Successful su for root by root
Aug  4 17:34:26 absurd su[5844]: + /dev/pts/1 root:root
Aug  4 17:34:26 absurd su[5844]: pam_unix(su:session): session opened for user root by salomea(uid=0)
Aug  4 17:34:30 absurd NetworkManager[4243]: <info> (eth0): IP6 addrconf timed out or failed.
Aug  4 17:34:30 absurd NetworkManager[4243]: <info> Activation (eth0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Aug  4 17:34:30 absurd NetworkManager[4243]: <info> Activation (eth0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Aug  4 17:34:30 absurd NetworkManager[4243]: <info> Activation (eth0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
unclutter: someone created a sub-window to my sub-window! giving up
Aug  4 17:34:39 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:34:40 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:35:59 absurd kernel: [   57.576988] Syncing filesystems ... done.
Aug  4 17:35:59 absurd kernel: [   57.580853] Freezing user space processes ... (elapsed 0.001 seconds) done.
Aug  4 17:35:59 absurd kernel: [   57.584115] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:35:59 absurd kernel: [   57.584180] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:35:59 absurd kernel: [   57.585863] PM: Basic memory bitmaps created
Aug  4 17:35:59 absurd kernel: [   57.586037] PM: Preallocating image memory... done (allocated 16280770 pages)
Aug  4 17:35:59 absurd kernel: [   63.892425] PM: Allocated 65123080 kbytes in 6.30 seconds (3519.58 MB/s)
Aug  4 17:35:59 absurd kernel: [   63.892484] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:35:59 absurd kernel: [   63.894538] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:35:59 absurd kernel: [   63.895232] serial 00:04: disabled
Aug  4 17:35:59 absurd kernel: [   63.895309] serial 00:03: disabled
Aug  4 17:35:59 absurd kernel: [   63.965198] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:35:59 absurd kernel: [   63.978893] PM: freeze of devices complete after 84.341 msecs
Aug  4 17:35:59 absurd kernel: [   63.979525] PM: late freeze of devices complete after 0.631 msecs
Aug  4 17:35:59 absurd kernel: [   63.981518] PM: noirq freeze of devices complete after 1.993 msecs
Aug  4 17:35:59 absurd kernel: [   63.981519] Disabling non-boot CPUs ...
Aug  4 17:35:59 absurd kernel: [   63.981660] intel_pstate CPU 1 exiting
Aug  4 17:35:59 absurd kernel: [   63.983762] kvm: disabling virtualization on CPU1
Aug  4 17:35:59 absurd kernel: [   63.983856] smpboot: CPU 1 is now offline
Aug  4 17:35:59 absurd kernel: [   63.984941] intel_pstate CPU 2 exiting
Aug  4 17:35:59 absurd kernel: [   63.987292] kvm: disabling virtualization on CPU2
Aug  4 17:35:59 absurd kernel: [   63.987320] smpboot: CPU 2 is now offline
Aug  4 17:35:59 absurd kernel: [   63.987977] intel_pstate CPU 3 exiting
Aug  4 17:35:59 absurd kernel: [   63.990199] kvm: disabling virtualization on CPU3
Aug  4 17:35:59 absurd kernel: [   63.990212] smpboot: CPU 3 is now offline
Aug  4 17:35:59 absurd kernel: [   63.990837] intel_pstate CPU 4 exiting
Aug  4 17:35:59 absurd kernel: [   63.992655] kvm: disabling virtualization on CPU4
Aug  4 17:35:59 absurd kernel: [   63.992667] smpboot: CPU 4 is now offline
Aug  4 17:35:59 absurd kernel: [   63.993335] intel_pstate CPU 5 exiting
Aug  4 17:35:59 absurd kernel: [   63.995164] kvm: disabling virtualization on CPU5
Aug  4 17:35:59 absurd kernel: [   63.995199] smpboot: CPU 5 is now offline
Aug  4 17:35:59 absurd kernel: [   63.995817] intel_pstate CPU 6 exiting
Aug  4 17:35:59 absurd kernel: [   63.998022] kvm: disabling virtualization on CPU6
Aug  4 17:35:59 absurd kernel: [   63.998033] smpboot: CPU 6 is now offline
Aug  4 17:35:59 absurd kernel: [   63.998641] intel_pstate CPU 7 exiting
Aug  4 17:35:59 absurd kernel: [   64.000408] kvm: disabling virtualization on CPU7
Aug  4 17:35:59 absurd kernel: [   64.000426] smpboot: CPU 7 is now offline
Aug  4 17:35:59 absurd kernel: [   64.001798] intel_pstate CPU 8 exiting
Aug  4 17:35:59 absurd kernel: [   64.004053] kvm: disabling virtualization on CPU8
Aug  4 17:35:59 absurd kernel: [   64.106785] smpboot: CPU 8 is now offline
Aug  4 17:35:59 absurd kernel: [   64.108245] intel_pstate CPU 9 exiting
Aug  4 17:35:59 absurd kernel: [   64.110354] kvm: disabling virtualization on CPU9
Aug  4 17:35:59 absurd kernel: [   64.110366] smpboot: CPU 9 is now offline
Aug  4 17:35:59 absurd kernel: [   64.112706] intel_pstate CPU 10 exiting
Aug  4 17:35:59 absurd kernel: [   64.114871] kvm: disabling virtualization on CPU10
Aug  4 17:35:59 absurd kernel: [   64.114896] smpboot: CPU 10 is now offline
Aug  4 17:35:59 absurd kernel: [   64.117973] intel_pstate CPU 11 exiting
Aug  4 17:35:59 absurd kernel: [   64.120268] kvm: disabling virtualization on CPU11
Aug  4 17:35:59 absurd kernel: [   64.120293] smpboot: CPU 11 is now offline
Aug  4 17:35:59 absurd kernel: [   64.122900] intel_pstate CPU 12 exiting
Aug  4 17:35:59 absurd kernel: [   64.125157] kvm: disabling virtualization on CPU12
Aug  4 17:35:59 absurd kernel: [   64.125171] smpboot: CPU 12 is now offline
Aug  4 17:35:59 absurd kernel: [   64.127720] intel_pstate CPU 13 exiting
Aug  4 17:35:59 absurd kernel: [   64.129962] kvm: disabling virtualization on CPU13
Aug  4 17:35:59 absurd kernel: [   64.129973] smpboot: CPU 13 is now offline
Aug  4 17:35:59 absurd kernel: [   64.132468] intel_pstate CPU 14 exiting
Aug  4 17:35:59 absurd kernel: [   64.134638] kvm: disabling virtualization on CPU14
Aug  4 17:35:59 absurd kernel: [   64.134649] smpboot: CPU 14 is now offline
Aug  4 17:35:59 absurd kernel: [   64.137600] intel_pstate CPU 15 exiting
Aug  4 17:35:59 absurd kernel: [   64.139644] kvm: disabling virtualization on CPU15
Aug  4 17:35:59 absurd kernel: [   64.141336] smpboot: CPU 15 is now offline
Aug  4 17:35:59 absurd kernel: [   64.142211] intel_pstate CPU 16 exiting
Aug  4 17:35:59 absurd kernel: [   64.144111] kvm: disabling virtualization on CPU16
Aug  4 17:35:59 absurd kernel: [   64.144119] smpboot: CPU 16 is now offline
Aug  4 17:35:59 absurd kernel: [   64.144746] intel_pstate CPU 17 exiting
Aug  4 17:35:59 absurd kernel: [   64.146321] kvm: disabling virtualization on CPU17
Aug  4 17:35:59 absurd kernel: [   64.146328] smpboot: CPU 17 is now offline
Aug  4 17:35:59 absurd kernel: [   64.146873] intel_pstate CPU 18 exiting
Aug  4 17:35:59 absurd kernel: [   64.148697] kvm: disabling virtualization on CPU18
Aug  4 17:35:59 absurd kernel: [   64.148705] smpboot: CPU 18 is now offline
Aug  4 17:35:59 absurd kernel: [   64.149213] intel_pstate CPU 19 exiting
Aug  4 17:35:59 absurd kernel: [   64.150905] kvm: disabling virtualization on CPU19
Aug  4 17:35:59 absurd kernel: [   64.150930] smpboot: CPU 19 is now offline
Aug  4 17:35:59 absurd kernel: [   64.151382] intel_pstate CPU 20 exiting
Aug  4 17:35:59 absurd kernel: [   64.152999] kvm: disabling virtualization on CPU20
Aug  4 17:35:59 absurd kernel: [   64.254682] smpboot: CPU 20 is now offline
Aug  4 17:35:59 absurd kernel: [   64.255168] intel_pstate CPU 21 exiting
Aug  4 17:35:59 absurd kernel: [   64.256748] kvm: disabling virtualization on CPU21
Aug  4 17:35:59 absurd kernel: [   64.256755] smpboot: CPU 21 is now offline
Aug  4 17:35:59 absurd kernel: [   64.257198] intel_pstate CPU 22 exiting
Aug  4 17:35:59 absurd kernel: [   64.258756] kvm: disabling virtualization on CPU22
Aug  4 17:35:59 absurd kernel: [   64.258784] smpboot: CPU 22 is now offline
Aug  4 17:35:59 absurd kernel: [   64.259385] intel_pstate CPU 23 exiting
Aug  4 17:35:59 absurd kernel: [   64.261047] kvm: disabling virtualization on CPU23
Aug  4 17:35:59 absurd kernel: [   64.261054] smpboot: CPU 23 is now offline
Aug  4 17:35:59 absurd kernel: [   64.261849] intel_pstate CPU 24 exiting
Aug  4 17:35:59 absurd kernel: [   64.263491] kvm: disabling virtualization on CPU24
Aug  4 17:35:59 absurd kernel: [   64.263520] smpboot: CPU 24 is now offline
Aug  4 17:35:59 absurd kernel: [   64.264339] intel_pstate CPU 25 exiting
Aug  4 17:35:59 absurd kernel: [   64.265957] kvm: disabling virtualization on CPU25
Aug  4 17:35:59 absurd kernel: [   64.265974] smpboot: CPU 25 is now offline
Aug  4 17:35:59 absurd kernel: [   64.267139] intel_pstate CPU 26 exiting
Aug  4 17:35:59 absurd kernel: [   64.268944] kvm: disabling virtualization on CPU26
Aug  4 17:35:59 absurd kernel: [   64.268958] smpboot: CPU 26 is now offline
Aug  4 17:35:59 absurd kernel: [   64.269989] intel_pstate CPU 27 exiting
Aug  4 17:35:59 absurd kernel: [   64.271698] kvm: disabling virtualization on CPU27
Aug  4 17:35:59 absurd kernel: [   64.271734] smpboot: CPU 27 is now offline
Aug  4 17:35:59 absurd kernel: [   64.274428] intel_pstate CPU 28 exiting
Aug  4 17:35:59 absurd kernel: [   64.276050] kvm: disabling virtualization on CPU28
Aug  4 17:35:59 absurd kernel: [   64.276058] smpboot: CPU 28 is now offline
Aug  4 17:35:59 absurd kernel: [   64.276740] intel_pstate CPU 29 exiting
Aug  4 17:35:59 absurd kernel: [   64.278263] kvm: disabling virtualization on CPU29
Aug  4 17:35:59 absurd kernel: [   64.278279] smpboot: CPU 29 is now offline
Aug  4 17:35:59 absurd kernel: [   64.279198] intel_pstate CPU 30 exiting
Aug  4 17:35:59 absurd kernel: [   64.280800] kvm: disabling virtualization on CPU30
Aug  4 17:35:59 absurd kernel: [   64.382615] smpboot: CPU 30 is now offline
Aug  4 17:35:59 absurd kernel: [   64.383395] intel_pstate CPU 31 exiting
Aug  4 17:35:59 absurd kernel: [   64.384052] Broke affinity for irq 96
Aug  4 17:35:59 absurd kernel: [   64.384056] Broke affinity for irq 97
Aug  4 17:35:59 absurd kernel: [   64.384061] Broke affinity for irq 98
Aug  4 17:35:59 absurd kernel: [   64.384112] Broke affinity for irq 128
Aug  4 17:35:59 absurd kernel: [   64.384116] Broke affinity for irq 129
Aug  4 17:35:59 absurd kernel: [   64.384121] Broke affinity for irq 130
Aug  4 17:35:59 absurd kernel: [   64.384125] Broke affinity for irq 131
Aug  4 17:35:59 absurd kernel: [   64.384129] Broke affinity for irq 132
Aug  4 17:35:59 absurd kernel: [   64.384133] Broke affinity for irq 133
Aug  4 17:35:59 absurd kernel: [   64.384137] Broke affinity for irq 134
Aug  4 17:35:59 absurd kernel: [   64.384142] Broke affinity for irq 135
Aug  4 17:35:59 absurd kernel: [   64.385193] kvm: disabling virtualization on CPU31
Aug  4 17:35:59 absurd kernel: [   64.486538] smpboot: CPU 31 is now offline
Aug  4 17:35:59 absurd kernel: [   64.487798] PM: Creating hibernation image:
Aug  4 17:35:59 absurd kernel: [   65.088179] PM: Need to copy 409468 pages
Aug  4 17:35:59 absurd kernel: [   65.088180] PM: Normal pages needed: 409468 + 1024, available pages: 16358212
Aug  4 17:35:59 absurd kernel: [   64.495082] Enabling non-boot CPUs ...
Aug  4 17:35:59 absurd kernel: [   64.495397] x86: Booting SMP configuration:
Aug  4 17:35:59 absurd kernel: [   64.495399] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:35:59 absurd kernel: [   64.508765] kvm: enabling virtualization on CPU1
Aug  4 17:35:59 absurd kernel: [   64.511182] Intel pstate controlling: cpu 1
Aug  4 17:35:59 absurd kernel: [   64.511263] CPU1 is up
Aug  4 17:35:59 absurd kernel: [   64.511412] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:35:59 absurd kernel: [   64.523116] kvm: enabling virtualization on CPU2
Aug  4 17:35:59 absurd kernel: [   64.525422] Intel pstate controlling: cpu 2
Aug  4 17:35:59 absurd kernel: [   64.525490] CPU2 is up
Aug  4 17:35:59 absurd kernel: [   64.525621] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:35:59 absurd kernel: [   64.537336] kvm: enabling virtualization on CPU3
Aug  4 17:35:59 absurd kernel: [   64.539604] Intel pstate controlling: cpu 3
Aug  4 17:35:59 absurd kernel: [   64.539667] CPU3 is up
Aug  4 17:35:59 absurd kernel: [   64.539795] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:35:59 absurd kernel: [   64.551492] kvm: enabling virtualization on CPU4
Aug  4 17:35:59 absurd kernel: [   64.553755] Intel pstate controlling: cpu 4
Aug  4 17:35:59 absurd kernel: [   64.553831] CPU4 is up
Aug  4 17:35:59 absurd kernel: [   64.553965] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:35:59 absurd kernel: [   64.565654] kvm: enabling virtualization on CPU5
Aug  4 17:35:59 absurd kernel: [   64.567936] Intel pstate controlling: cpu 5
Aug  4 17:35:59 absurd kernel: [   64.568000] CPU5 is up
Aug  4 17:35:59 absurd kernel: [   64.568134] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:35:59 absurd kernel: [   64.579822] kvm: enabling virtualization on CPU6
Aug  4 17:35:59 absurd kernel: [   64.582118] Intel pstate controlling: cpu 6
Aug  4 17:35:59 absurd kernel: [   64.582184] CPU6 is up
Aug  4 17:35:59 absurd kernel: [   64.582319] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:35:59 absurd kernel: [   64.594000] kvm: enabling virtualization on CPU7
Aug  4 17:35:59 absurd kernel: [   64.596297] Intel pstate controlling: cpu 7
Aug  4 17:35:59 absurd kernel: [   64.596364] CPU7 is up
Aug  4 17:35:59 absurd kernel: [   64.596742] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:35:59 absurd kernel: [   64.610044] kvm: enabling virtualization on CPU8
Aug  4 17:35:59 absurd kernel: [   64.630366] Intel pstate controlling: cpu 8
Aug  4 17:35:59 absurd kernel: [   64.630413] CPU8 is up
Aug  4 17:35:59 absurd kernel: [   64.630747] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:35:59 absurd kernel: [   64.644101] kvm: enabling virtualization on CPU9
Aug  4 17:35:59 absurd kernel: [   64.646369] Intel pstate controlling: cpu 9
Aug  4 17:35:59 absurd kernel: [   64.646418] CPU9 is up
Aug  4 17:35:59 absurd kernel: [   64.646676] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:35:59 absurd kernel: [   64.660043] kvm: enabling virtualization on CPU10
Aug  4 17:35:59 absurd kernel: [   64.662297] Intel pstate controlling: cpu 10
Aug  4 17:35:59 absurd kernel: [   64.662344] CPU10 is up
Aug  4 17:35:59 absurd kernel: [   64.662580] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:35:59 absurd kernel: [   64.675956] kvm: enabling virtualization on CPU11
Aug  4 17:35:59 absurd kernel: [   64.678210] Intel pstate controlling: cpu 11
Aug  4 17:35:59 absurd kernel: [   64.678256] CPU11 is up
Aug  4 17:35:59 absurd kernel: [   64.678448] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:35:59 absurd kernel: [   64.691800] kvm: enabling virtualization on CPU12
Aug  4 17:35:59 absurd kernel: [   64.694095] Intel pstate controlling: cpu 12
Aug  4 17:35:59 absurd kernel: [   64.694141] CPU12 is up
Aug  4 17:35:59 absurd kernel: [   64.694322] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:35:59 absurd kernel: [   64.707640] kvm: enabling virtualization on CPU13
Aug  4 17:35:59 absurd kernel: [   64.709969] Intel pstate controlling: cpu 13
Aug  4 17:35:59 absurd kernel: [   64.710017] CPU13 is up
Aug  4 17:35:59 absurd kernel: [   64.710193] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:35:59 absurd kernel: [   64.723504] kvm: enabling virtualization on CPU14
Aug  4 17:35:59 absurd kernel: [   64.725852] Intel pstate controlling: cpu 14
Aug  4 17:35:59 absurd kernel: [   64.725899] CPU14 is up
Aug  4 17:35:59 absurd kernel: [   64.726067] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:35:59 absurd kernel: [   64.739361] kvm: enabling virtualization on CPU15
Aug  4 17:35:59 absurd kernel: [   64.741633] Intel pstate controlling: cpu 15
Aug  4 17:35:59 absurd kernel: [   64.741686] CPU15 is up
Aug  4 17:35:59 absurd kernel: [   64.741808] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:35:59 absurd kernel: [   64.753546] kvm: enabling virtualization on CPU16
Aug  4 17:35:59 absurd kernel: [   64.756032] Intel pstate controlling: cpu 16
Aug  4 17:35:59 absurd kernel: [   64.756099] CPU16 is up
Aug  4 17:35:59 absurd kernel: [   64.756247] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:35:59 absurd kernel: [   64.767944] kvm: enabling virtualization on CPU17
Aug  4 17:35:59 absurd kernel: [   64.770429] Intel pstate controlling: cpu 17
Aug  4 17:35:59 absurd kernel: [   64.770493] CPU17 is up
Aug  4 17:35:59 absurd kernel: [   64.770634] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:35:59 absurd kernel: [   64.782329] kvm: enabling virtualization on CPU18
Aug  4 17:35:59 absurd kernel: [   64.784817] Intel pstate controlling: cpu 18
Aug  4 17:35:59 absurd kernel: [   64.784885] CPU18 is up
Aug  4 17:35:59 absurd kernel: [   64.785029] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:35:59 absurd kernel: [   64.796735] kvm: enabling virtualization on CPU19
Aug  4 17:35:59 absurd kernel: [   64.799196] Intel pstate controlling: cpu 19
Aug  4 17:35:59 absurd kernel: [   64.799260] CPU19 is up
Aug  4 17:35:59 absurd kernel: [   64.799403] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:35:59 absurd kernel: [   64.811093] kvm: enabling virtualization on CPU20
Aug  4 17:35:59 absurd kernel: [   64.813629] Intel pstate controlling: cpu 20
Aug  4 17:35:59 absurd kernel: [   64.813691] CPU20 is up
Aug  4 17:35:59 absurd kernel: [   64.813841] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:35:59 absurd kernel: [   64.825524] kvm: enabling virtualization on CPU21
Aug  4 17:35:59 absurd kernel: [   64.828072] Intel pstate controlling: cpu 21
Aug  4 17:35:59 absurd kernel: [   64.828136] CPU21 is up
Aug  4 17:35:59 absurd kernel: [   64.828281] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:35:59 absurd kernel: [   64.839961] kvm: enabling virtualization on CPU22
Aug  4 17:35:59 absurd kernel: [   64.842523] Intel pstate controlling: cpu 22
Aug  4 17:35:59 absurd kernel: [   64.842587] CPU22 is up
Aug  4 17:35:59 absurd kernel: [   64.842728] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:35:59 absurd kernel: [   64.854397] kvm: enabling virtualization on CPU23
Aug  4 17:35:59 absurd kernel: [   64.856979] Intel pstate controlling: cpu 23
Aug  4 17:35:59 absurd kernel: [   64.857041] CPU23 is up
Aug  4 17:35:59 absurd kernel: [   64.857349] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:35:59 absurd kernel: [   64.870652] kvm: enabling virtualization on CPU24
Aug  4 17:35:59 absurd kernel: [   64.873039] Intel pstate controlling: cpu 24
Aug  4 17:35:59 absurd kernel: [   64.873086] CPU24 is up
Aug  4 17:35:59 absurd kernel: [   64.873272] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:35:59 absurd kernel: [   64.886605] kvm: enabling virtualization on CPU25
Aug  4 17:35:59 absurd kernel: [   64.889055] Intel pstate controlling: cpu 25
Aug  4 17:35:59 absurd kernel: [   64.889101] CPU25 is up
Aug  4 17:35:59 absurd kernel: [   64.889289] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:35:59 absurd kernel: [   64.902635] kvm: enabling virtualization on CPU26
Aug  4 17:35:59 absurd kernel: [   64.905069] Intel pstate controlling: cpu 26
Aug  4 17:35:59 absurd kernel: [   64.905115] CPU26 is up
Aug  4 17:35:59 absurd kernel: [   64.905297] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:35:59 absurd kernel: [   64.918658] kvm: enabling virtualization on CPU27
Aug  4 17:35:59 absurd kernel: [   64.921086] Intel pstate controlling: cpu 27
Aug  4 17:35:59 absurd kernel: [   64.921137] CPU27 is up
Aug  4 17:35:59 absurd kernel: [   64.921314] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:35:59 absurd kernel: [   64.934669] kvm: enabling virtualization on CPU28
Aug  4 17:35:59 absurd kernel: [   64.937120] Intel pstate controlling: cpu 28
Aug  4 17:35:59 absurd kernel: [   64.937167] CPU28 is up
Aug  4 17:35:59 absurd kernel: [   64.937347] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:35:59 absurd kernel: [   64.950648] kvm: enabling virtualization on CPU29
Aug  4 17:35:59 absurd kernel: [   64.953066] Intel pstate controlling: cpu 29
Aug  4 17:35:59 absurd kernel: [   64.953114] CPU29 is up
Aug  4 17:35:59 absurd kernel: [   64.953288] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:35:59 absurd kernel: [   64.966584] kvm: enabling virtualization on CPU30
Aug  4 17:35:59 absurd kernel: [   64.969011] Intel pstate controlling: cpu 30
Aug  4 17:35:59 absurd kernel: [   64.969057] CPU30 is up
Aug  4 17:35:59 absurd kernel: [   64.969228] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:35:59 absurd kernel: [   64.982512] kvm: enabling virtualization on CPU31
Aug  4 17:35:59 absurd kernel: [   64.984960] Intel pstate controlling: cpu 31
Aug  4 17:35:59 absurd kernel: [   64.985007] CPU31 is up
Aug  4 17:35:59 absurd kernel: [   65.089805] PM: noirq restore of devices complete after 14.369 msecs
Aug  4 17:35:59 absurd kernel: [   65.090327] PM: early restore of devices complete after 0.459 msecs
Aug  4 17:35:59 absurd kernel: [   65.251275] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:35:59 absurd kernel: [   65.251353] usb usb1: root hub lost power or was reset
Aug  4 17:35:59 absurd kernel: [   65.251354] usb usb2: root hub lost power or was reset
Aug  4 17:35:59 absurd kernel: [   65.251546] igb 0000:02:00.0: irq 100 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251548] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251557] igb 0000:02:00.0: irq 101 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251559] igb 0000:02:00.1: irq 102 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251564] igb 0000:02:00.0: irq 103 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251567] igb 0000:02:00.1: irq 104 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251572] igb 0000:02:00.0: irq 105 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251576] igb 0000:02:00.1: irq 106 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251578] igb 0000:02:00.0: irq 107 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251587] igb 0000:02:00.1: irq 111 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251589] igb 0000:02:00.0: irq 112 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251598] igb 0000:02:00.1: irq 113 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251600] igb 0000:02:00.0: irq 114 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251606] igb 0000:02:00.1: irq 115 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251608] igb 0000:02:00.0: irq 116 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251614] igb 0000:02:00.1: irq 117 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251616] igb 0000:02:00.0: irq 118 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251621] igb 0000:02:00.1: irq 119 for MSI/MSI-X
Aug  4 17:35:59 absurd kernel: [   65.251915] serial 00:03: activated
Aug  4 17:35:59 absurd kernel: [   65.252290] serial 00:04: activated
Aug  4 17:35:59 absurd kernel: [   65.253192] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:35:59 absurd kernel: [   65.253233] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:35:59 absurd kernel: [   65.253274] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:35:59 absurd kernel: [   65.253302] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:35:59 absurd kernel: [   65.255249] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:35:59 absurd kernel: [   65.255250] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:35:59 absurd kernel: [   65.255315] ------------[ cut here ]------------
Aug  4 17:35:59 absurd kernel: [   65.255322] WARNING: CPU: 13 PID: 5909 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:35:59 absurd kernel: [   65.255354] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj raid1 usb_storage snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel nvidia(PO) kvm joydev hid_generic snd_hda_codec_ca0132 crct10dif_pclmul iTCO_wdt crc32_pclmul iTCO_vendor_support usbhid ghash_clmulni_intel hid mxm_wmi evdev aesni_intel snd_hda_intel aes_x86_64 ablk_helper cryptd glue_helper lrw snd_hda_controller gf128mul snd_hda_codec pcspkr snd_hwdep sb_edac snd_pcm edac_core snd_seq i2c_i801 snd_seq_device snd_timer snd lpc_ich mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler tpm_tis tpm processor wmi thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci libata ehci_pci scsi_transport_sas ehci_hcd scsi_mod
Aug  4 17:35:59 absurd kernel: igb usbcore i2c_algo_bit usb_common i2c_core dca ptp pps_core
Aug  4 17:35:59 absurd kernel: [   65.255369] CPU: 13 PID: 5909 Comm: kworker/u66:12 Tainted: P           O  3.16.0-vanilla.1 #1
Aug  4 17:35:59 absurd kernel: [   65.255370] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:35:59 absurd kernel: [   65.255375] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:35:59 absurd kernel: [   65.255377]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:35:59 absurd kernel: [   65.255378]  ffffffff810664f6 ffffffffa03ff09b ffff88105215ac20 ffff881057be8880
Aug  4 17:35:59 absurd kernel: [   65.255379]  ffff881052e57c90 ffff88105796b000 ffffffff813a7d3b ffff881055182200
Aug  4 17:35:59 absurd kernel: [   65.255379] Call Trace:
Aug  4 17:35:59 absurd kernel: [   65.255385]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:35:59 absurd kernel: [   65.255389]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:35:59 absurd kernel: [   65.255391]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:35:59 absurd kernel: [   65.255393]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:35:59 absurd kernel: [   65.255396]  [<ffffffffa03fe03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:35:59 absurd kernel: [   65.255401]  [<ffffffffa02cfe21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:35:59 absurd kernel: [   65.255403]  [<ffffffffa02cff17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:35:59 absurd kernel: [   65.255407]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:35:59 absurd kernel: [   65.255410]  [<ffffffffa02cf951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:35:59 absurd kernel: [   65.255412]  [<ffffffffa02d1776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:35:59 absurd kernel: [   65.255415]  [<ffffffffa03ab070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:35:59 absurd kernel: [   65.255418]  [<ffffffffa0334c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:35:59 absurd kernel: [   65.255421]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:35:59 absurd kernel: [   65.255424]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:35:59 absurd kernel: [   65.255426]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:35:59 absurd kernel: [   65.255427]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:35:59 absurd kernel: [   65.255428]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:35:59 absurd kernel: [   65.255430]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:35:59 absurd kernel: [   65.255432]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:35:59 absurd kernel: [   65.255434]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:35:59 absurd kernel: [   65.255435]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:35:59 absurd kernel: [   65.255437]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:35:59 absurd kernel: [   65.255438]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:35:59 absurd kernel: [   65.255439]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:35:59 absurd kernel: [   65.255441]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:35:59 absurd kernel: [   65.255441] ---[ end trace db395c2b3c067201 ]---
Aug  4 17:35:59 absurd kernel: [   65.255443] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:35:59 absurd kernel: [   65.565196] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:35:59 absurd kernel: [   65.565672] ata1.00: configured for UDMA/133
Aug  4 17:35:59 absurd kernel: [   65.585261] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:35:59 absurd kernel: [   65.585298] usb 1-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:35:59 absurd kernel: [   65.585300] usb 2-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:35:59 absurd kernel: [   65.593228] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:35:59 absurd kernel: [   65.594556] ata4.00: configured for UDMA/100
Aug  4 17:35:59 absurd kernel: [   65.601181] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:35:59 absurd kernel: [   65.604405] ata5.00: configured for UDMA/133
Aug  4 17:35:59 absurd kernel: [   65.605170] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:35:59 absurd kernel: [   65.606656] ata2.00: configured for UDMA/133
Aug  4 17:35:59 absurd kernel: [   65.721110] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:35:59 absurd kernel: [   65.731753] ata6.00: configured for UDMA/133
Aug  4 17:35:59 absurd kernel: [   65.997030] usb 1-1.6: reset full-speed USB device number 3 using ehci-pci
Aug  4 17:35:59 absurd kernel: [   65.997167] usb 2-1.1: reset high-speed USB device number 3 using ehci-pci
Aug  4 17:35:59 absurd kernel: [   66.348978] usb 2-1.2: reset low-speed USB device number 4 using ehci-pci
Aug  4 17:35:59 absurd kernel: [   66.700790] usb 2-1.3: reset high-speed USB device number 5 using ehci-pci
Aug  4 17:35:59 absurd kernel: [   67.072558] usb 2-1.3.1: reset high-speed USB device number 6 using ehci-pci
Aug  4 17:35:59 absurd kernel: [   67.252453] usb 2-1.3.3: reset full-speed USB device number 7 using ehci-pci
Aug  4 17:35:59 absurd kernel: [   67.424347] PM: restore of devices complete after 2174.435 msecs
Aug  4 17:35:59 absurd kernel: [   67.454891] hid-generic 0003:0665:5161.0009: hiddev0,hidraw2: USB HID v1.00 Device [INNO TECH USB to Serial] on usb-0000:00:1d.0-1.2/input0
Aug  4 17:35:59 absurd kernel: [   67.585389] Restarting kernel threads ... done.
Aug  4 17:35:59 absurd kernel: [   67.586099] PM: Basic memory bitmaps freed
Aug  4 17:35:59 absurd kernel: [   67.586157] Restarting tasks ... done.
Aug  4 17:35:59 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:35:59 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:35:59 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:35:59 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:35:59 absurd acpid: client connected from 4432[0:0]
Aug  4 17:35:59 absurd acpid: 1 client rule loaded
Aug  4 17:35:59 absurd upsd[4451]: Data for UPS [duo2pro] is stale - check driver
Aug  4 17:35:59 absurd upsd[4451]: UPS [duo2pro] data is no longer stale
Aug  4 17:35:59 absurd NetworkManager[4243]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:35:59 absurd blazer_usb[4448]: Got disconnected by another driver: Device or resource busy
Aug  4 17:35:59 absurd upsd[4451]: Can't connect to UPS [duo2pro] (blazer_usb-duo2pro): No such file or directory
Aug  4 17:35:59 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 17:35:59 absurd upsmon[4479]: Communications with UPS duo2pro@localhost lost
Aug  4 17:35:59 absurd kernel: [   67.628710] usb 2-1.2: usbfs: process 4448 (blazer_usb) did not claim interface 0 before use
Aug  4 17:35:59 absurd acpid: client connected from 4432[0:0]
Aug  4 17:35:59 absurd acpid: 1 client rule loaded
Aug  4 17:35:59 absurd acpid: client connected from 4432[0:0]
Aug  4 17:35:59 absurd acpid: 1 client rule loaded
Aug  4 17:35:59 absurd NetworkManager[4243]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:35:59 absurd kernel: [   68.132043] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 17:35:59 absurd acpid: client connected from 4432[0:0]
Aug  4 17:35:59 absurd acpid: 1 client rule loaded
Warning:  meter MemMeter had a negative value of -19378176.000000 for field 4
Warning:  meter MemMeter had a negative value of -20029440.000000 for field 4
Aug  4 17:36:02 absurd upsd[4451]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 17:36:02 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Warning:  meter MemMeter had a negative value of -19320832.000000 for field 4
Warning:  meter MemMeter had a negative value of -19611648.000000 for field 4
Aug  4 17:36:04 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:36:04 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="6063" x-info="http://www.rsyslog.com"] start
Aug  4 17:36:04 absurd salomea: ========== resume complete ===========
Future warnings from the MemMeter meter will not be displayed.
Aug  4 17:36:05 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:36:08 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:36:11 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:36:14 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:36:17 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_2_success3.txt

Aug  4 17:36:23 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:36:26 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:36:29 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:36:32 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:36:35 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:36:38 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:36:41 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:36:44 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:36:44 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:36:45 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:38:03 absurd kernel: [  113.964991] Syncing filesystems ... done.
Aug  4 17:38:03 absurd kernel: [  113.968291] Freezing user space processes ... (elapsed 0.001 seconds) done.
Aug  4 17:38:03 absurd kernel: [  113.971203] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:38:03 absurd kernel: [  113.971265] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:38:03 absurd kernel: [  113.972328] PM: Basic memory bitmaps created
Aug  4 17:38:03 absurd kernel: [  113.972496] PM: Preallocating image memory... done (allocated 16299968 pages)
Aug  4 17:38:03 absurd kernel: [  119.558775] PM: Allocated 65199872 kbytes in 5.58 seconds (3987.49 MB/s)
Aug  4 17:38:03 absurd kernel: [  119.558834] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:38:03 absurd kernel: [  119.560930] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:38:03 absurd kernel: [  119.561481] serial 00:04: disabled
Aug  4 17:38:03 absurd kernel: [  119.561558] serial 00:03: disabled
Aug  4 17:38:03 absurd kernel: [  119.625395] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:38:03 absurd kernel: [  119.637839] PM: freeze of devices complete after 76.891 msecs
Aug  4 17:38:03 absurd kernel: [  119.638528] PM: late freeze of devices complete after 0.687 msecs
Aug  4 17:38:03 absurd kernel: [  119.640553] PM: noirq freeze of devices complete after 2.024 msecs
Aug  4 17:38:03 absurd kernel: [  119.640553] Disabling non-boot CPUs ...
Aug  4 17:38:03 absurd kernel: [  119.640711] intel_pstate CPU 1 exiting
Aug  4 17:38:03 absurd kernel: [  119.643324] kvm: disabling virtualization on CPU1
Aug  4 17:38:03 absurd kernel: [  119.643356] smpboot: CPU 1 is now offline
Aug  4 17:38:03 absurd kernel: [  119.644307] intel_pstate CPU 2 exiting
Aug  4 17:38:03 absurd kernel: [  119.646224] kvm: disabling virtualization on CPU2
Aug  4 17:38:03 absurd kernel: [  119.646315] smpboot: CPU 2 is now offline
Aug  4 17:38:03 absurd kernel: [  119.646991] intel_pstate CPU 3 exiting
Aug  4 17:38:03 absurd kernel: [  119.649468] kvm: disabling virtualization on CPU3
Aug  4 17:38:03 absurd kernel: [  119.649477] smpboot: CPU 3 is now offline
Aug  4 17:38:03 absurd kernel: [  119.650119] intel_pstate CPU 4 exiting
Aug  4 17:38:03 absurd kernel: [  119.652319] kvm: disabling virtualization on CPU4
Aug  4 17:38:03 absurd kernel: [  119.652342] smpboot: CPU 4 is now offline
Aug  4 17:38:03 absurd kernel: [  119.652949] intel_pstate CPU 5 exiting
Aug  4 17:38:03 absurd kernel: [  119.654794] kvm: disabling virtualization on CPU5
Aug  4 17:38:03 absurd kernel: [  119.654828] smpboot: CPU 5 is now offline
Aug  4 17:38:03 absurd kernel: [  119.655458] intel_pstate CPU 6 exiting
Aug  4 17:38:03 absurd kernel: [  119.657240] kvm: disabling virtualization on CPU6
Aug  4 17:38:03 absurd kernel: [  119.657249] smpboot: CPU 6 is now offline
Aug  4 17:38:03 absurd kernel: [  119.657884] intel_pstate CPU 7 exiting
Aug  4 17:38:03 absurd kernel: [  119.659631] kvm: disabling virtualization on CPU7
Aug  4 17:38:03 absurd kernel: [  119.659648] smpboot: CPU 7 is now offline
Aug  4 17:38:03 absurd kernel: [  119.661003] intel_pstate CPU 8 exiting
Aug  4 17:38:03 absurd kernel: [  119.663285] kvm: disabling virtualization on CPU8
Aug  4 17:38:03 absurd kernel: [  119.663298] smpboot: CPU 8 is now offline
Aug  4 17:38:03 absurd kernel: [  119.666039] intel_pstate CPU 9 exiting
Aug  4 17:38:03 absurd kernel: [  119.668169] kvm: disabling virtualization on CPU9
Aug  4 17:38:03 absurd kernel: [  119.668180] smpboot: CPU 9 is now offline
Aug  4 17:38:03 absurd kernel: [  119.670507] intel_pstate CPU 10 exiting
Aug  4 17:38:03 absurd kernel: [  119.672652] kvm: disabling virtualization on CPU10
Aug  4 17:38:03 absurd kernel: [  119.672663] smpboot: CPU 10 is now offline
Aug  4 17:38:03 absurd kernel: [  119.674936] intel_pstate CPU 11 exiting
Aug  4 17:38:03 absurd kernel: [  119.677019] kvm: disabling virtualization on CPU11
Aug  4 17:38:03 absurd kernel: [  119.677031] smpboot: CPU 11 is now offline
Aug  4 17:38:03 absurd kernel: [  119.679247] intel_pstate CPU 12 exiting
Aug  4 17:38:03 absurd kernel: [  119.681263] kvm: disabling virtualization on CPU12
Aug  4 17:38:03 absurd kernel: [  119.681274] smpboot: CPU 12 is now offline
Aug  4 17:38:03 absurd kernel: [  119.683356] intel_pstate CPU 13 exiting
Aug  4 17:38:03 absurd kernel: [  119.685353] kvm: disabling virtualization on CPU13
Aug  4 17:38:03 absurd kernel: [  119.685364] smpboot: CPU 13 is now offline
Aug  4 17:38:03 absurd kernel: [  119.687405] intel_pstate CPU 14 exiting
Aug  4 17:38:03 absurd kernel: [  119.689365] kvm: disabling virtualization on CPU14
Aug  4 17:38:03 absurd kernel: [  119.789707] smpboot: CPU 14 is now offline
Aug  4 17:38:03 absurd kernel: [  119.790616] intel_pstate CPU 15 exiting
Aug  4 17:38:03 absurd kernel: [  119.792499] kvm: disabling virtualization on CPU15
Aug  4 17:38:03 absurd kernel: [  119.792511] smpboot: CPU 15 is now offline
Aug  4 17:38:03 absurd kernel: [  119.794044] intel_pstate CPU 16 exiting
Aug  4 17:38:03 absurd kernel: [  119.795900] kvm: disabling virtualization on CPU16
Aug  4 17:38:03 absurd kernel: [  119.897639] smpboot: CPU 16 is now offline
Aug  4 17:38:03 absurd kernel: [  119.898252] intel_pstate CPU 17 exiting
Aug  4 17:38:03 absurd kernel: [  119.899768] kvm: disabling virtualization on CPU17
Aug  4 17:38:03 absurd kernel: [  120.001576] smpboot: CPU 17 is now offline
Aug  4 17:38:03 absurd kernel: [  120.001933] intel_pstate CPU 18 exiting
Aug  4 17:38:03 absurd kernel: [  120.003525] kvm: disabling virtualization on CPU18
Aug  4 17:38:03 absurd kernel: [  120.003544] smpboot: CPU 18 is now offline
Aug  4 17:38:03 absurd kernel: [  120.003952] intel_pstate CPU 19 exiting
Aug  4 17:38:03 absurd kernel: [  120.005492] kvm: disabling virtualization on CPU19
Aug  4 17:38:03 absurd kernel: [  120.105533] smpboot: CPU 19 is now offline
Aug  4 17:38:03 absurd kernel: [  120.106113] intel_pstate CPU 20 exiting
Aug  4 17:38:03 absurd kernel: [  120.107904] kvm: disabling virtualization on CPU20
Aug  4 17:38:03 absurd kernel: [  120.107913] smpboot: CPU 20 is now offline
Aug  4 17:38:03 absurd kernel: [  120.108444] intel_pstate CPU 21 exiting
Aug  4 17:38:03 absurd kernel: [  120.110188] kvm: disabling virtualization on CPU21
Aug  4 17:38:03 absurd kernel: [  120.110236] smpboot: CPU 21 is now offline
Aug  4 17:38:03 absurd kernel: [  120.110833] intel_pstate CPU 22 exiting
Aug  4 17:38:03 absurd kernel: [  120.112677] kvm: disabling virtualization on CPU22
Aug  4 17:38:03 absurd kernel: [  120.213467] smpboot: CPU 22 is now offline
Aug  4 17:38:03 absurd kernel: [  120.214090] intel_pstate CPU 23 exiting
Aug  4 17:38:03 absurd kernel: [  120.215782] kvm: disabling virtualization on CPU23
Aug  4 17:38:03 absurd kernel: [  120.317464] smpboot: CPU 23 is now offline
Aug  4 17:38:03 absurd kernel: [  120.318525] intel_pstate CPU 24 exiting
Aug  4 17:38:03 absurd kernel: [  120.320189] kvm: disabling virtualization on CPU24
Aug  4 17:38:03 absurd kernel: [  120.421341] smpboot: CPU 24 is now offline
Aug  4 17:38:03 absurd kernel: [  120.422076] intel_pstate CPU 25 exiting
Aug  4 17:38:03 absurd kernel: [  120.423508] kvm: disabling virtualization on CPU25
Aug  4 17:38:03 absurd kernel: [  120.423513] smpboot: CPU 25 is now offline
Aug  4 17:38:03 absurd kernel: [  120.424266] intel_pstate CPU 26 exiting
Aug  4 17:38:03 absurd kernel: [  120.425664] kvm: disabling virtualization on CPU26
Aug  4 17:38:03 absurd kernel: [  120.425696] smpboot: CPU 26 is now offline
Aug  4 17:38:03 absurd kernel: [  120.426591] intel_pstate CPU 27 exiting
Aug  4 17:38:03 absurd kernel: [  120.428066] kvm: disabling virtualization on CPU27
Aug  4 17:38:03 absurd kernel: [  120.529286] smpboot: CPU 27 is now offline
Aug  4 17:38:03 absurd kernel: [  120.530244] intel_pstate CPU 28 exiting
Aug  4 17:38:03 absurd kernel: [  120.531877] kvm: disabling virtualization on CPU28
Aug  4 17:38:03 absurd kernel: [  120.531886] smpboot: CPU 28 is now offline
Aug  4 17:38:03 absurd kernel: [  120.532604] intel_pstate CPU 29 exiting
Aug  4 17:38:03 absurd kernel: [  120.534140] kvm: disabling virtualization on CPU29
Aug  4 17:38:03 absurd kernel: [  120.534184] smpboot: CPU 29 is now offline
Aug  4 17:38:03 absurd kernel: [  120.535143] intel_pstate CPU 30 exiting
Aug  4 17:38:03 absurd kernel: [  120.536742] kvm: disabling virtualization on CPU30
Aug  4 17:38:03 absurd kernel: [  120.637251] smpboot: CPU 30 is now offline
Aug  4 17:38:03 absurd kernel: [  120.637898] intel_pstate CPU 31 exiting
Aug  4 17:38:03 absurd kernel: [  120.640806] kvm: disabling virtualization on CPU31
Aug  4 17:38:03 absurd kernel: [  120.741148] smpboot: CPU 31 is now offline
Aug  4 17:38:03 absurd kernel: [  120.742275] PM: Creating hibernation image:
Aug  4 17:38:03 absurd kernel: [  121.684193] PM: Need to copy 397518 pages
Aug  4 17:38:03 absurd kernel: [  121.684195] PM: Normal pages needed: 397518 + 1024, available pages: 16370160
Aug  4 17:38:03 absurd kernel: [  120.749543] Enabling non-boot CPUs ...
Aug  4 17:38:03 absurd kernel: [  120.749855] x86: Booting SMP configuration:
Aug  4 17:38:03 absurd kernel: [  120.749857] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:38:03 absurd kernel: [  120.763221] kvm: enabling virtualization on CPU1
Aug  4 17:38:03 absurd kernel: [  120.765803] Intel pstate controlling: cpu 1
Aug  4 17:38:03 absurd kernel: [  120.765934] CPU1 is up
Aug  4 17:38:03 absurd kernel: [  120.766179] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:38:03 absurd kernel: [  120.777885] kvm: enabling virtualization on CPU2
Aug  4 17:38:03 absurd kernel: [  120.780173] Intel pstate controlling: cpu 2
Aug  4 17:38:03 absurd kernel: [  120.780240] CPU2 is up
Aug  4 17:38:03 absurd kernel: [  120.780376] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:38:03 absurd kernel: [  120.792091] kvm: enabling virtualization on CPU3
Aug  4 17:38:03 absurd kernel: [  120.794362] Intel pstate controlling: cpu 3
Aug  4 17:38:03 absurd kernel: [  120.794429] CPU3 is up
Aug  4 17:38:03 absurd kernel: [  120.794561] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:38:03 absurd kernel: [  120.806258] kvm: enabling virtualization on CPU4
Aug  4 17:38:03 absurd kernel: [  120.808558] Intel pstate controlling: cpu 4
Aug  4 17:38:03 absurd kernel: [  120.808623] CPU4 is up
Aug  4 17:38:03 absurd kernel: [  120.808758] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:38:03 absurd kernel: [  120.820447] kvm: enabling virtualization on CPU5
Aug  4 17:38:03 absurd kernel: [  120.822729] Intel pstate controlling: cpu 5
Aug  4 17:38:03 absurd kernel: [  120.822795] CPU5 is up
Aug  4 17:38:03 absurd kernel: [  120.822927] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:38:03 absurd kernel: [  120.834614] kvm: enabling virtualization on CPU6
Aug  4 17:38:03 absurd kernel: [  120.836915] Intel pstate controlling: cpu 6
Aug  4 17:38:03 absurd kernel: [  120.836980] CPU6 is up
Aug  4 17:38:03 absurd kernel: [  120.837118] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:38:03 absurd kernel: [  120.848798] kvm: enabling virtualization on CPU7
Aug  4 17:38:03 absurd kernel: [  120.851098] Intel pstate controlling: cpu 7
Aug  4 17:38:03 absurd kernel: [  120.851166] CPU7 is up
Aug  4 17:38:03 absurd kernel: [  120.851550] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:38:03 absurd kernel: [  120.864854] kvm: enabling virtualization on CPU8
Aug  4 17:38:03 absurd kernel: [  120.885243] Intel pstate controlling: cpu 8
Aug  4 17:38:03 absurd kernel: [  120.885293] CPU8 is up
Aug  4 17:38:03 absurd kernel: [  120.885630] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:38:03 absurd kernel: [  120.898980] kvm: enabling virtualization on CPU9
Aug  4 17:38:03 absurd kernel: [  120.901270] Intel pstate controlling: cpu 9
Aug  4 17:38:03 absurd kernel: [  120.901319] CPU9 is up
Aug  4 17:38:03 absurd kernel: [  120.901575] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:38:03 absurd kernel: [  120.914938] kvm: enabling virtualization on CPU10
Aug  4 17:38:03 absurd kernel: [  120.917207] Intel pstate controlling: cpu 10
Aug  4 17:38:03 absurd kernel: [  120.917256] CPU10 is up
Aug  4 17:38:03 absurd kernel: [  120.917510] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:38:03 absurd kernel: [  120.930886] kvm: enabling virtualization on CPU11
Aug  4 17:38:03 absurd kernel: [  120.933147] Intel pstate controlling: cpu 11
Aug  4 17:38:03 absurd kernel: [  120.933199] CPU11 is up
Aug  4 17:38:03 absurd kernel: [  120.933394] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:38:03 absurd kernel: [  120.946768] kvm: enabling virtualization on CPU12
Aug  4 17:38:03 absurd kernel: [  120.949036] Intel pstate controlling: cpu 12
Aug  4 17:38:03 absurd kernel: [  120.949082] CPU12 is up
Aug  4 17:38:03 absurd kernel: [  120.949264] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:38:03 absurd kernel: [  120.962578] kvm: enabling virtualization on CPU13
Aug  4 17:38:03 absurd kernel: [  120.964973] Intel pstate controlling: cpu 13
Aug  4 17:38:03 absurd kernel: [  120.965027] CPU13 is up
Aug  4 17:38:03 absurd kernel: [  120.965213] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:38:03 absurd kernel: [  120.978527] kvm: enabling virtualization on CPU14
Aug  4 17:38:03 absurd kernel: [  120.980875] Intel pstate controlling: cpu 14
Aug  4 17:38:03 absurd kernel: [  120.980923] CPU14 is up
Aug  4 17:38:03 absurd kernel: [  120.981100] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:38:03 absurd kernel: [  120.994395] kvm: enabling virtualization on CPU15
Aug  4 17:38:03 absurd kernel: [  120.996774] Intel pstate controlling: cpu 15
Aug  4 17:38:03 absurd kernel: [  120.996822] CPU15 is up
Aug  4 17:38:03 absurd kernel: [  120.996951] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:38:03 absurd kernel: [  121.008639] kvm: enabling virtualization on CPU16
Aug  4 17:38:03 absurd kernel: [  121.011112] Intel pstate controlling: cpu 16
Aug  4 17:38:03 absurd kernel: [  121.011174] CPU16 is up
Aug  4 17:38:03 absurd kernel: [  121.011322] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:38:03 absurd kernel: [  121.023050] kvm: enabling virtualization on CPU17
Aug  4 17:38:03 absurd kernel: [  121.025526] Intel pstate controlling: cpu 17
Aug  4 17:38:03 absurd kernel: [  121.025591] CPU17 is up
Aug  4 17:38:03 absurd kernel: [  121.025741] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:38:03 absurd kernel: [  121.037440] kvm: enabling virtualization on CPU18
Aug  4 17:38:03 absurd kernel: [  121.039921] Intel pstate controlling: cpu 18
Aug  4 17:38:03 absurd kernel: [  121.039983] CPU18 is up
Aug  4 17:38:03 absurd kernel: [  121.040134] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:38:03 absurd kernel: [  121.051840] kvm: enabling virtualization on CPU19
Aug  4 17:38:03 absurd kernel: [  121.054328] Intel pstate controlling: cpu 19
Aug  4 17:38:03 absurd kernel: [  121.054392] CPU19 is up
Aug  4 17:38:03 absurd kernel: [  121.054540] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:38:03 absurd kernel: [  121.066231] kvm: enabling virtualization on CPU20
Aug  4 17:38:03 absurd kernel: [  121.068758] Intel pstate controlling: cpu 20
Aug  4 17:38:03 absurd kernel: [  121.068820] CPU20 is up
Aug  4 17:38:03 absurd kernel: [  121.068971] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:38:03 absurd kernel: [  121.080652] kvm: enabling virtualization on CPU21
Aug  4 17:38:03 absurd kernel: [  121.083207] Intel pstate controlling: cpu 21
Aug  4 17:38:03 absurd kernel: [  121.083270] CPU21 is up
Aug  4 17:38:03 absurd kernel: [  121.083412] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:38:03 absurd kernel: [  121.095092] kvm: enabling virtualization on CPU22
Aug  4 17:38:03 absurd kernel: [  121.097664] Intel pstate controlling: cpu 22
Aug  4 17:38:03 absurd kernel: [  121.097728] CPU22 is up
Aug  4 17:38:03 absurd kernel: [  121.097871] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:38:03 absurd kernel: [  121.109545] kvm: enabling virtualization on CPU23
Aug  4 17:38:03 absurd kernel: [  121.112138] Intel pstate controlling: cpu 23
Aug  4 17:38:03 absurd kernel: [  121.112207] CPU23 is up
Aug  4 17:38:03 absurd kernel: [  121.112513] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:38:03 absurd kernel: [  121.125816] kvm: enabling virtualization on CPU24
Aug  4 17:38:03 absurd kernel: [  121.128207] Intel pstate controlling: cpu 24
Aug  4 17:38:03 absurd kernel: [  121.128251] CPU24 is up
Aug  4 17:38:03 absurd kernel: [  121.128428] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:38:03 absurd kernel: [  121.141761] kvm: enabling virtualization on CPU25
Aug  4 17:38:03 absurd kernel: [  121.144227] Intel pstate controlling: cpu 25
Aug  4 17:38:03 absurd kernel: [  121.144274] CPU25 is up
Aug  4 17:38:03 absurd kernel: [  121.144452] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:38:03 absurd kernel: [  121.157821] kvm: enabling virtualization on CPU26
Aug  4 17:38:03 absurd kernel: [  121.160239] Intel pstate controlling: cpu 26
Aug  4 17:38:03 absurd kernel: [  121.160287] CPU26 is up
Aug  4 17:38:03 absurd kernel: [  121.160462] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:38:03 absurd kernel: [  121.173823] kvm: enabling virtualization on CPU27
Aug  4 17:38:03 absurd kernel: [  121.176256] Intel pstate controlling: cpu 27
Aug  4 17:38:03 absurd kernel: [  121.176304] CPU27 is up
Aug  4 17:38:03 absurd kernel: [  121.176484] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:38:03 absurd kernel: [  121.189842] kvm: enabling virtualization on CPU28
Aug  4 17:38:03 absurd kernel: [  121.192294] Intel pstate controlling: cpu 28
Aug  4 17:38:03 absurd kernel: [  121.192339] CPU28 is up
Aug  4 17:38:03 absurd kernel: [  121.192511] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:38:03 absurd kernel: [  121.205815] kvm: enabling virtualization on CPU29
Aug  4 17:38:03 absurd kernel: [  121.208233] Intel pstate controlling: cpu 29
Aug  4 17:38:03 absurd kernel: [  121.208281] CPU29 is up
Aug  4 17:38:03 absurd kernel: [  121.208460] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:38:03 absurd kernel: [  121.221757] kvm: enabling virtualization on CPU30
Aug  4 17:38:03 absurd kernel: [  121.224201] Intel pstate controlling: cpu 30
Aug  4 17:38:03 absurd kernel: [  121.224248] CPU30 is up
Aug  4 17:38:03 absurd kernel: [  121.224406] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:38:03 absurd kernel: [  121.237689] kvm: enabling virtualization on CPU31
Aug  4 17:38:03 absurd kernel: [  121.240159] Intel pstate controlling: cpu 31
Aug  4 17:38:03 absurd kernel: [  121.240205] CPU31 is up
Aug  4 17:38:03 absurd kernel: [  121.344387] PM: noirq restore of devices complete after 15.165 msecs
Aug  4 17:38:03 absurd kernel: [  121.344902] PM: early restore of devices complete after 0.455 msecs
Aug  4 17:38:03 absurd kernel: [  121.505069] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:38:03 absurd kernel: [  121.505148] usb usb2: root hub lost power or was reset
Aug  4 17:38:03 absurd kernel: [  121.505150] usb usb1: root hub lost power or was reset
Aug  4 17:38:03 absurd kernel: [  121.505330] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505331] igb 0000:02:00.0: irq 100 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505340] igb 0000:02:00.1: irq 101 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505343] igb 0000:02:00.0: irq 102 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505346] igb 0000:02:00.1: irq 103 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505350] igb 0000:02:00.0: irq 104 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505352] igb 0000:02:00.1: irq 105 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505356] igb 0000:02:00.0: irq 106 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505358] igb 0000:02:00.1: irq 107 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505365] igb 0000:02:00.0: irq 111 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505367] igb 0000:02:00.1: irq 112 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505374] igb 0000:02:00.0: irq 113 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505376] igb 0000:02:00.1: irq 114 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505379] igb 0000:02:00.0: irq 115 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505382] igb 0000:02:00.1: irq 116 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505385] igb 0000:02:00.0: irq 117 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505387] igb 0000:02:00.1: irq 118 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505390] igb 0000:02:00.0: irq 119 for MSI/MSI-X
Aug  4 17:38:03 absurd kernel: [  121.505797] serial 00:03: activated
Aug  4 17:38:03 absurd kernel: [  121.506268] serial 00:04: activated
Aug  4 17:38:03 absurd kernel: [  121.506626] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:38:03 absurd kernel: [  121.506656] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:38:03 absurd kernel: [  121.506686] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:38:03 absurd kernel: [  121.506708] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:38:03 absurd kernel: [  121.509039] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:38:03 absurd kernel: [  121.509040] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:38:03 absurd kernel: [  121.509125] ------------[ cut here ]------------
Aug  4 17:38:03 absurd kernel: [  121.509130] WARNING: CPU: 4 PID: 5881 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:38:03 absurd kernel: [  121.509162] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj raid1 usb_storage snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel nvidia(PO) kvm joydev hid_generic snd_hda_codec_ca0132 crct10dif_pclmul iTCO_wdt crc32_pclmul iTCO_vendor_support usbhid ghash_clmulni_intel hid mxm_wmi evdev aesni_intel snd_hda_intel aes_x86_64 ablk_helper cryptd glue_helper lrw snd_hda_controller gf128mul snd_hda_codec pcspkr snd_hwdep sb_edac snd_pcm edac_core snd_seq i2c_i801 snd_seq_device snd_timer snd lpc_ich mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler tpm_tis tpm processor wmi thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci libata ehci_pci scsi_transport_sas ehci_hcd scsi_mod
Aug  4 17:38:03 absurd kernel: igb usbcore i2c_algo_bit usb_common i2c_core dca ptp pps_core
Aug  4 17:38:03 absurd kernel: [  121.509175] CPU: 4 PID: 5881 Comm: kworker/u65:19 Tainted: P        W  O  3.16.0-vanilla.1 #1
Aug  4 17:38:03 absurd kernel: [  121.509176] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:38:03 absurd kernel: [  121.509179] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:38:03 absurd kernel: [  121.509180]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:38:03 absurd kernel: [  121.509181]  ffffffff810664f6 ffffffffa03ff09b ffff8808554cbdc0 ffff8808535e0dc0
Aug  4 17:38:03 absurd kernel: [  121.509183]  ffff880856b8fc90 ffff88105796b000 ffffffff813a7d3b ffff881055182200
Aug  4 17:38:03 absurd kernel: [  121.509183] Call Trace:
Aug  4 17:38:03 absurd kernel: [  121.509187]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:38:03 absurd kernel: [  121.509190]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:38:03 absurd kernel: [  121.509192]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:38:03 absurd kernel: [  121.509193]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:38:03 absurd kernel: [  121.509196]  [<ffffffffa03fe03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:38:03 absurd kernel: [  121.509201]  [<ffffffffa02cfe21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:38:03 absurd kernel: [  121.509203]  [<ffffffffa02cff17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:38:03 absurd kernel: [  121.509206]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:38:03 absurd kernel: [  121.509208]  [<ffffffffa02cf951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:38:03 absurd kernel: [  121.509211]  [<ffffffffa02d1776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:38:03 absurd kernel: [  121.509214]  [<ffffffffa03ab070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:38:03 absurd kernel: [  121.509216]  [<ffffffffa0334c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:38:03 absurd kernel: [  121.509218]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:38:03 absurd kernel: [  121.509221]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:38:03 absurd kernel: [  121.509222]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:38:03 absurd kernel: [  121.509223]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:38:03 absurd kernel: [  121.509225]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:38:03 absurd kernel: [  121.509227]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:38:03 absurd kernel: [  121.509229]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:38:03 absurd kernel: [  121.509231]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:38:03 absurd kernel: [  121.509232]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:38:03 absurd kernel: [  121.509234]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:38:03 absurd kernel: [  121.509235]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:38:03 absurd kernel: [  121.509236]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:38:03 absurd kernel: [  121.509237]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:38:03 absurd kernel: [  121.509238] ---[ end trace db395c2b3c067202 ]---
Aug  4 17:38:03 absurd kernel: [  121.509240] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:38:03 absurd kernel: [  121.823858] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:38:03 absurd kernel: [  121.824367] ata1.00: configured for UDMA/133
Aug  4 17:38:03 absurd kernel: [  121.831835] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:38:03 absurd kernel: [  121.839837] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:38:03 absurd kernel: [  121.839849] usb 2-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:38:03 absurd kernel: [  121.839885] usb 1-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:38:03 absurd kernel: [  121.841155] ata4.00: configured for UDMA/100
Aug  4 17:38:03 absurd kernel: [  121.853070] ata2.00: configured for UDMA/133
Aug  4 17:38:03 absurd kernel: [  121.855824] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:38:03 absurd kernel: [  121.855846] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:38:03 absurd kernel: [  121.859055] ata5.00: configured for UDMA/133
Aug  4 17:38:03 absurd kernel: [  121.975750] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:38:03 absurd kernel: [  121.987046] ata6.00: configured for UDMA/133
Aug  4 17:38:03 absurd kernel: [  122.251706] usb 2-1.3: reset high-speed USB device number 5 using ehci-pci
Aug  4 17:38:03 absurd kernel: [  122.251714] usb 1-1.6: reset full-speed USB device number 3 using ehci-pci
Aug  4 17:38:03 absurd kernel: [  122.415572] usb 2-1.1: reset high-speed USB device number 3 using ehci-pci
Aug  4 17:38:03 absurd kernel: [  122.767363] usb 2-1.2: reset low-speed USB device number 4 using ehci-pci
Aug  4 17:38:03 absurd kernel: [  123.119184] usb 2-1.3.1: reset high-speed USB device number 6 using ehci-pci
Aug  4 17:38:03 absurd kernel: [  123.299075] usb 2-1.3.3: reset full-speed USB device number 7 using ehci-pci
Aug  4 17:38:03 absurd kernel: [  123.471068] PM: restore of devices complete after 1967.231 msecs
Aug  4 17:38:03 absurd kernel: [  123.673244] Restarting kernel threads ... done.
Aug  4 17:38:03 absurd kernel: [  123.673959] PM: Basic memory bitmaps freed
Aug  4 17:38:03 absurd kernel: [  123.674017] Restarting tasks ... done.
Aug  4 17:38:03 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:38:03 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:38:03 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:38:03 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:38:03 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 17:38:03 absurd acpid: client connected from 4432[0:0]
Aug  4 17:38:03 absurd acpid: 1 client rule loaded
Aug  4 17:38:03 absurd NetworkManager[4243]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:38:04 absurd acpid: client connected from 4432[0:0]
Aug  4 17:38:04 absurd acpid: 1 client rule loaded
Aug  4 17:38:04 absurd acpid: client connected from 4432[0:0]
Aug  4 17:38:04 absurd acpid: 1 client rule loaded
Aug  4 17:38:04 absurd acpid: client connected from 4432[0:0]
Aug  4 17:38:04 absurd acpid: 1 client rule loaded
Aug  4 17:38:05 absurd NetworkManager[4243]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:38:05 absurd kernel: [  124.926373] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 17:38:06 absurd upsd[4451]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 17:38:06 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:38:09 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:38:09 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="6245" x-info="http://www.rsyslog.com"] start
Aug  4 17:38:09 absurd salomea: ========== resume complete ===========
Aug  4 17:38:09 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:38:12 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:38:15 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_2_success4.txt

ug  4 17:38:15 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:38:18 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:38:21 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:38:24 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:38:27 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:38:30 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:38:33 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:38:33 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:38:34 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:40:02 absurd kernel: [  154.561172] Syncing filesystems ... done.
Aug  4 17:40:02 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:40:02 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:40:02 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:40:02 absurd kernel: [  154.563386] Freezing user space processes ... (elapsed 0.001 seconds) done.
Aug  4 17:40:02 absurd kernel: [  154.566924] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:40:02 absurd kernel: [  154.566995] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:40:02 absurd kernel: [  154.569346] PM: Basic memory bitmaps created
Aug  4 17:40:02 absurd kernel: [  154.569535] PM: Preallocating image memory... done (allocated 16303223 pages)
Aug  4 17:40:02 absurd kernel: [  160.058913] PM: Allocated 65212892 kbytes in 5.49 seconds (4055.23 MB/s)
Aug  4 17:40:02 absurd kernel: [  160.058973] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:40:02 absurd kernel: [  160.061038] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:40:02 absurd kernel: [  160.061596] serial 00:04: disabled
Aug  4 17:40:02 absurd kernel: [  160.061673] serial 00:03: disabled
Aug  4 17:40:02 absurd kernel: [  160.124338] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:40:02 absurd kernel: [  160.137593] PM: freeze of devices complete after 76.536 msecs
Aug  4 17:40:02 absurd kernel: [  160.138206] PM: late freeze of devices complete after 0.612 msecs
Aug  4 17:40:02 absurd kernel: [  160.140199] PM: noirq freeze of devices complete after 1.993 msecs
Aug  4 17:40:02 absurd kernel: [  160.140200] Disabling non-boot CPUs ...
Aug  4 17:40:02 absurd kernel: [  160.140334] intel_pstate CPU 1 exiting
Aug  4 17:40:02 absurd kernel: [  160.142363] kvm: disabling virtualization on CPU1
Aug  4 17:40:02 absurd kernel: [  160.142411] smpboot: CPU 1 is now offline
Aug  4 17:40:02 absurd kernel: [  160.143214] intel_pstate CPU 2 exiting
Aug  4 17:40:02 absurd kernel: [  160.145007] kvm: disabling virtualization on CPU2
Aug  4 17:40:02 absurd kernel: [  160.145013] smpboot: CPU 2 is now offline
Aug  4 17:40:02 absurd kernel: [  160.145687] intel_pstate CPU 3 exiting
Aug  4 17:40:02 absurd kernel: [  160.147455] kvm: disabling virtualization on CPU3
Aug  4 17:40:02 absurd kernel: [  160.147469] smpboot: CPU 3 is now offline
Aug  4 17:40:02 absurd kernel: [  160.148096] intel_pstate CPU 4 exiting
Aug  4 17:40:02 absurd kernel: [  160.149806] kvm: disabling virtualization on CPU4
Aug  4 17:40:02 absurd kernel: [  160.149822] smpboot: CPU 4 is now offline
Aug  4 17:40:02 absurd kernel: [  160.150469] intel_pstate CPU 5 exiting
Aug  4 17:40:02 absurd kernel: [  160.152160] kvm: disabling virtualization on CPU5
Aug  4 17:40:02 absurd kernel: [  160.152174] smpboot: CPU 5 is now offline
Aug  4 17:40:02 absurd kernel: [  160.152795] intel_pstate CPU 6 exiting
Aug  4 17:40:02 absurd kernel: [  160.154442] kvm: disabling virtualization on CPU6
Aug  4 17:40:02 absurd kernel: [  160.155062] smpboot: CPU 6 is now offline
Aug  4 17:40:02 absurd kernel: [  160.155447] intel_pstate CPU 7 exiting
Aug  4 17:40:02 absurd kernel: [  160.157040] kvm: disabling virtualization on CPU7
Aug  4 17:40:02 absurd kernel: [  160.157045] smpboot: CPU 7 is now offline
Aug  4 17:40:02 absurd kernel: [  160.158071] intel_pstate CPU 8 exiting
Aug  4 17:40:02 absurd kernel: [  160.159710] kvm: disabling virtualization on CPU8
Aug  4 17:40:02 absurd kernel: [  160.159715] smpboot: CPU 8 is now offline
Aug  4 17:40:02 absurd kernel: [  160.160899] intel_pstate CPU 9 exiting
Aug  4 17:40:02 absurd kernel: [  160.162516] kvm: disabling virtualization on CPU9
Aug  4 17:40:02 absurd kernel: [  160.162531] smpboot: CPU 9 is now offline
Aug  4 17:40:02 absurd kernel: [  160.163606] intel_pstate CPU 10 exiting
Aug  4 17:40:02 absurd kernel: [  160.165200] kvm: disabling virtualization on CPU10
Aug  4 17:40:02 absurd kernel: [  160.165209] smpboot: CPU 10 is now offline
Aug  4 17:40:02 absurd kernel: [  160.166313] intel_pstate CPU 11 exiting
Aug  4 17:40:02 absurd kernel: [  160.167875] kvm: disabling virtualization on CPU11
Aug  4 17:40:02 absurd kernel: [  160.167882] smpboot: CPU 11 is now offline
Aug  4 17:40:02 absurd kernel: [  160.168913] intel_pstate CPU 12 exiting
Aug  4 17:40:02 absurd kernel: [  160.170472] kvm: disabling virtualization on CPU12
Aug  4 17:40:02 absurd kernel: [  160.170488] smpboot: CPU 12 is now offline
Aug  4 17:40:02 absurd kernel: [  160.171498] intel_pstate CPU 13 exiting
Aug  4 17:40:02 absurd kernel: [  160.173038] kvm: disabling virtualization on CPU13
Aug  4 17:40:02 absurd kernel: [  160.273470] smpboot: CPU 13 is now offline
Aug  4 17:40:02 absurd kernel: [  160.274203] intel_pstate CPU 14 exiting
Aug  4 17:40:02 absurd kernel: [  160.275683] kvm: disabling virtualization on CPU14
Aug  4 17:40:02 absurd kernel: [  160.275698] smpboot: CPU 14 is now offline
Aug  4 17:40:02 absurd kernel: [  160.276659] intel_pstate CPU 15 exiting
Aug  4 17:40:02 absurd kernel: [  160.278158] kvm: disabling virtualization on CPU15
Aug  4 17:40:02 absurd kernel: [  160.278814] smpboot: CPU 15 is now offline
Aug  4 17:40:02 absurd kernel: [  160.279299] intel_pstate CPU 16 exiting
Aug  4 17:40:02 absurd kernel: [  160.280830] kvm: disabling virtualization on CPU16
Aug  4 17:40:02 absurd kernel: [  160.381403] smpboot: CPU 16 is now offline
Aug  4 17:40:02 absurd kernel: [  160.381755] intel_pstate CPU 17 exiting
Aug  4 17:40:02 absurd kernel: [  160.383376] kvm: disabling virtualization on CPU17
Aug  4 17:40:02 absurd kernel: [  160.485346] smpboot: CPU 17 is now offline
Aug  4 17:40:02 absurd kernel: [  160.485800] intel_pstate CPU 18 exiting
Aug  4 17:40:02 absurd kernel: [  160.487319] kvm: disabling virtualization on CPU18
Aug  4 17:40:02 absurd kernel: [  160.589320] smpboot: CPU 18 is now offline
Aug  4 17:40:02 absurd kernel: [  160.589840] intel_pstate CPU 19 exiting
Aug  4 17:40:02 absurd kernel: [  160.591370] kvm: disabling virtualization on CPU19
Aug  4 17:40:02 absurd kernel: [  160.591385] smpboot: CPU 19 is now offline
Aug  4 17:40:02 absurd kernel: [  160.591753] intel_pstate CPU 20 exiting
Aug  4 17:40:02 absurd kernel: [  160.593165] kvm: disabling virtualization on CPU20
Aug  4 17:40:02 absurd kernel: [  160.693221] smpboot: CPU 20 is now offline
Aug  4 17:40:02 absurd kernel: [  160.693510] intel_pstate CPU 21 exiting
Aug  4 17:40:02 absurd kernel: [  160.694973] kvm: disabling virtualization on CPU21
Aug  4 17:40:02 absurd kernel: [  160.797163] smpboot: CPU 21 is now offline
Aug  4 17:40:02 absurd kernel: [  160.797504] intel_pstate CPU 22 exiting
Aug  4 17:40:02 absurd kernel: [  160.798905] kvm: disabling virtualization on CPU22
Aug  4 17:40:02 absurd kernel: [  160.901151] smpboot: CPU 22 is now offline
Aug  4 17:40:02 absurd kernel: [  160.901597] intel_pstate CPU 23 exiting
Aug  4 17:40:02 absurd kernel: [  160.903339] kvm: disabling virtualization on CPU23
Aug  4 17:40:02 absurd kernel: [  161.005088] smpboot: CPU 23 is now offline
Aug  4 17:40:02 absurd kernel: [  161.006120] intel_pstate CPU 24 exiting
Aug  4 17:40:02 absurd kernel: [  161.007764] kvm: disabling virtualization on CPU24
Aug  4 17:40:02 absurd kernel: [  161.108989] smpboot: CPU 24 is now offline
Aug  4 17:40:02 absurd kernel: [  161.109873] intel_pstate CPU 25 exiting
Aug  4 17:40:02 absurd kernel: [  161.111407] kvm: disabling virtualization on CPU25
Aug  4 17:40:02 absurd kernel: [  161.111413] smpboot: CPU 25 is now offline
Aug  4 17:40:02 absurd kernel: [  161.112221] intel_pstate CPU 26 exiting
Aug  4 17:40:02 absurd kernel: [  161.113721] kvm: disabling virtualization on CPU26
Aug  4 17:40:02 absurd kernel: [  161.113751] smpboot: CPU 26 is now offline
Aug  4 17:40:02 absurd kernel: [  161.114396] intel_pstate CPU 27 exiting
Aug  4 17:40:02 absurd kernel: [  161.115851] kvm: disabling virtualization on CPU27
Aug  4 17:40:02 absurd kernel: [  161.216926] smpboot: CPU 27 is now offline
Aug  4 17:40:02 absurd kernel: [  161.217699] intel_pstate CPU 28 exiting
Aug  4 17:40:02 absurd kernel: [  161.219208] kvm: disabling virtualization on CPU28
Aug  4 17:40:02 absurd kernel: [  161.320864] smpboot: CPU 28 is now offline
Aug  4 17:40:02 absurd kernel: [  161.321660] intel_pstate CPU 29 exiting
Aug  4 17:40:02 absurd kernel: [  161.323093] kvm: disabling virtualization on CPU29
Aug  4 17:40:02 absurd kernel: [  161.424804] smpboot: CPU 29 is now offline
Aug  4 17:40:02 absurd kernel: [  161.425447] intel_pstate CPU 30 exiting
Aug  4 17:40:02 absurd kernel: [  161.426851] kvm: disabling virtualization on CPU30
Aug  4 17:40:02 absurd kernel: [  161.528742] smpboot: CPU 30 is now offline
Aug  4 17:40:02 absurd kernel: [  161.529251] intel_pstate CPU 31 exiting
Aug  4 17:40:02 absurd kernel: [  161.530842] kvm: disabling virtualization on CPU31
Aug  4 17:40:02 absurd kernel: [  161.632679] smpboot: CPU 31 is now offline
Aug  4 17:40:02 absurd kernel: [  161.633961] PM: Creating hibernation image:
Aug  4 17:40:02 absurd kernel: [  163.555460] PM: Need to copy 395628 pages
Aug  4 17:40:02 absurd kernel: [  163.555464] PM: Normal pages needed: 395628 + 1024, available pages: 16372024
Aug  4 17:40:02 absurd kernel: [  161.641239] Enabling non-boot CPUs ...
Aug  4 17:40:02 absurd kernel: [  161.641560] x86: Booting SMP configuration:
Aug  4 17:40:02 absurd kernel: [  161.641562] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:40:02 absurd kernel: [  161.654195] kvm: enabling virtualization on CPU1
Aug  4 17:40:02 absurd kernel: [  161.656461] Intel pstate controlling: cpu 1
Aug  4 17:40:02 absurd kernel: [  161.656531] CPU1 is up
Aug  4 17:40:02 absurd kernel: [  161.656662] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:40:02 absurd kernel: [  161.668366] kvm: enabling virtualization on CPU2
Aug  4 17:40:02 absurd kernel: [  161.670616] Intel pstate controlling: cpu 2
Aug  4 17:40:02 absurd kernel: [  161.670685] CPU2 is up
Aug  4 17:40:02 absurd kernel: [  161.670819] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:40:02 absurd kernel: [  161.682533] kvm: enabling virtualization on CPU3
Aug  4 17:40:02 absurd kernel: [  161.684784] Intel pstate controlling: cpu 3
Aug  4 17:40:02 absurd kernel: [  161.684850] CPU3 is up
Aug  4 17:40:02 absurd kernel: [  161.684978] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:40:02 absurd kernel: [  161.696675] kvm: enabling virtualization on CPU4
Aug  4 17:40:02 absurd kernel: [  161.698936] Intel pstate controlling: cpu 4
Aug  4 17:40:02 absurd kernel: [  161.699004] CPU4 is up
Aug  4 17:40:02 absurd kernel: [  161.699142] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:40:02 absurd kernel: [  161.710834] kvm: enabling virtualization on CPU5
Aug  4 17:40:02 absurd kernel: [  161.713127] Intel pstate controlling: cpu 5
Aug  4 17:40:02 absurd kernel: [  161.713190] CPU5 is up
Aug  4 17:40:02 absurd kernel: [  161.713326] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:40:02 absurd kernel: [  161.725011] kvm: enabling virtualization on CPU6
Aug  4 17:40:02 absurd kernel: [  161.727294] Intel pstate controlling: cpu 6
Aug  4 17:40:02 absurd kernel: [  161.727360] CPU6 is up
Aug  4 17:40:02 absurd kernel: [  161.727499] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:40:02 absurd kernel: [  161.739179] kvm: enabling virtualization on CPU7
Aug  4 17:40:02 absurd kernel: [  161.741494] Intel pstate controlling: cpu 7
Aug  4 17:40:02 absurd kernel: [  161.741560] CPU7 is up
Aug  4 17:40:02 absurd kernel: [  161.741941] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:40:02 absurd kernel: [  161.755243] kvm: enabling virtualization on CPU8
Aug  4 17:40:02 absurd kernel: [  161.775571] Intel pstate controlling: cpu 8
Aug  4 17:40:02 absurd kernel: [  161.775620] CPU8 is up
Aug  4 17:40:02 absurd kernel: [  161.775966] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:40:02 absurd kernel: [  161.789321] kvm: enabling virtualization on CPU9
Aug  4 17:40:02 absurd kernel: [  161.791589] Intel pstate controlling: cpu 9
Aug  4 17:40:02 absurd kernel: [  161.791639] CPU9 is up
Aug  4 17:40:02 absurd kernel: [  161.791903] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:40:02 absurd kernel: [  161.805266] kvm: enabling virtualization on CPU10
Aug  4 17:40:02 absurd kernel: [  161.807532] Intel pstate controlling: cpu 10
Aug  4 17:40:02 absurd kernel: [  161.807585] CPU10 is up
Aug  4 17:40:02 absurd kernel: [  161.807837] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:40:02 absurd kernel: [  161.821216] kvm: enabling virtualization on CPU11
Aug  4 17:40:02 absurd kernel: [  161.823471] Intel pstate controlling: cpu 11
Aug  4 17:40:02 absurd kernel: [  161.823521] CPU11 is up
Aug  4 17:40:02 absurd kernel: [  161.823707] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:40:02 absurd kernel: [  161.837078] kvm: enabling virtualization on CPU12
Aug  4 17:40:02 absurd kernel: [  161.839349] Intel pstate controlling: cpu 12
Aug  4 17:40:02 absurd kernel: [  161.839398] CPU12 is up
Aug  4 17:40:02 absurd kernel: [  161.839580] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:40:02 absurd kernel: [  161.852896] kvm: enabling virtualization on CPU13
Aug  4 17:40:02 absurd kernel: [  161.855227] Intel pstate controlling: cpu 13
Aug  4 17:40:02 absurd kernel: [  161.855276] CPU13 is up
Aug  4 17:40:02 absurd kernel: [  161.855445] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:40:02 absurd kernel: [  161.868757] kvm: enabling virtualization on CPU14
Aug  4 17:40:02 absurd kernel: [  161.871013] Intel pstate controlling: cpu 14
Aug  4 17:40:02 absurd kernel: [  161.871059] CPU14 is up
Aug  4 17:40:02 absurd kernel: [  161.871236] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:40:02 absurd kernel: [  161.884531] kvm: enabling virtualization on CPU15
Aug  4 17:40:02 absurd kernel: [  161.886800] Intel pstate controlling: cpu 15
Aug  4 17:40:02 absurd kernel: [  161.886845] CPU15 is up
Aug  4 17:40:02 absurd kernel: [  161.886950] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:40:02 absurd kernel: [  161.898693] kvm: enabling virtualization on CPU16
Aug  4 17:40:02 absurd kernel: [  161.901176] Intel pstate controlling: cpu 16
Aug  4 17:40:02 absurd kernel: [  161.901243] CPU16 is up
Aug  4 17:40:02 absurd kernel: [  161.901390] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:40:02 absurd kernel: [  161.913085] kvm: enabling virtualization on CPU17
Aug  4 17:40:02 absurd kernel: [  161.915577] Intel pstate controlling: cpu 17
Aug  4 17:40:02 absurd kernel: [  161.915640] CPU17 is up
Aug  4 17:40:02 absurd kernel: [  161.915797] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:40:02 absurd kernel: [  161.927494] kvm: enabling virtualization on CPU18
Aug  4 17:40:02 absurd kernel: [  161.930012] Intel pstate controlling: cpu 18
Aug  4 17:40:02 absurd kernel: [  161.930072] CPU18 is up
Aug  4 17:40:02 absurd kernel: [  161.930220] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:40:02 absurd kernel: [  161.941927] kvm: enabling virtualization on CPU19
Aug  4 17:40:02 absurd kernel: [  161.944437] Intel pstate controlling: cpu 19
Aug  4 17:40:02 absurd kernel: [  161.944499] CPU19 is up
Aug  4 17:40:02 absurd kernel: [  161.944648] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:40:02 absurd kernel: [  161.956337] kvm: enabling virtualization on CPU20
Aug  4 17:40:02 absurd kernel: [  161.958883] Intel pstate controlling: cpu 20
Aug  4 17:40:02 absurd kernel: [  161.958947] CPU20 is up
Aug  4 17:40:02 absurd kernel: [  161.959088] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:40:02 absurd kernel: [  161.970771] kvm: enabling virtualization on CPU21
Aug  4 17:40:02 absurd kernel: [  161.973236] Intel pstate controlling: cpu 21
Aug  4 17:40:02 absurd kernel: [  161.973303] CPU21 is up
Aug  4 17:40:02 absurd kernel: [  161.973448] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:40:02 absurd kernel: [  161.985129] kvm: enabling virtualization on CPU22
Aug  4 17:40:02 absurd kernel: [  161.987614] Intel pstate controlling: cpu 22
Aug  4 17:40:02 absurd kernel: [  161.987677] CPU22 is up
Aug  4 17:40:02 absurd kernel: [  161.987836] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:40:02 absurd kernel: [  161.999508] kvm: enabling virtualization on CPU23
Aug  4 17:40:02 absurd kernel: [  162.002018] Intel pstate controlling: cpu 23
Aug  4 17:40:02 absurd kernel: [  162.002080] CPU23 is up
Aug  4 17:40:02 absurd kernel: [  162.002391] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:40:02 absurd kernel: [  162.015695] kvm: enabling virtualization on CPU24
Aug  4 17:40:02 absurd kernel: [  162.018089] Intel pstate controlling: cpu 24
Aug  4 17:40:02 absurd kernel: [  162.018134] CPU24 is up
Aug  4 17:40:02 absurd kernel: [  162.018314] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:40:02 absurd kernel: [  162.031645] kvm: enabling virtualization on CPU25
Aug  4 17:40:02 absurd kernel: [  162.034096] Intel pstate controlling: cpu 25
Aug  4 17:40:02 absurd kernel: [  162.034141] CPU25 is up
Aug  4 17:40:02 absurd kernel: [  162.034314] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:40:02 absurd kernel: [  162.047681] kvm: enabling virtualization on CPU26
Aug  4 17:40:02 absurd kernel: [  162.050097] Intel pstate controlling: cpu 26
Aug  4 17:40:02 absurd kernel: [  162.050142] CPU26 is up
Aug  4 17:40:02 absurd kernel: [  162.050316] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:40:02 absurd kernel: [  162.063676] kvm: enabling virtualization on CPU27
Aug  4 17:40:02 absurd kernel: [  162.066120] Intel pstate controlling: cpu 27
Aug  4 17:40:02 absurd kernel: [  162.066167] CPU27 is up
Aug  4 17:40:02 absurd kernel: [  162.066346] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:40:02 absurd kernel: [  162.079680] kvm: enabling virtualization on CPU28
Aug  4 17:40:02 absurd kernel: [  162.082164] Intel pstate controlling: cpu 28
Aug  4 17:40:02 absurd kernel: [  162.082210] CPU28 is up
Aug  4 17:40:02 absurd kernel: [  162.082387] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:40:02 absurd kernel: [  162.095690] kvm: enabling virtualization on CPU29
Aug  4 17:40:02 absurd kernel: [  162.098114] Intel pstate controlling: cpu 29
Aug  4 17:40:02 absurd kernel: [  162.098159] CPU29 is up
Aug  4 17:40:02 absurd kernel: [  162.098328] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:40:02 absurd kernel: [  162.111626] kvm: enabling virtualization on CPU30
Aug  4 17:40:02 absurd kernel: [  162.114061] Intel pstate controlling: cpu 30
Aug  4 17:40:02 absurd kernel: [  162.114108] CPU30 is up
Aug  4 17:40:02 absurd kernel: [  162.114265] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:40:02 absurd kernel: [  162.127544] kvm: enabling virtualization on CPU31
Aug  4 17:40:02 absurd kernel: [  162.130005] Intel pstate controlling: cpu 31
Aug  4 17:40:02 absurd kernel: [  162.130051] CPU31 is up
Aug  4 17:40:02 absurd kernel: [  162.235948] PM: noirq restore of devices complete after 16.941 msecs
Aug  4 17:40:02 absurd kernel: [  162.236455] PM: early restore of devices complete after 0.444 msecs
Aug  4 17:40:02 absurd kernel: [  162.396106] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:40:02 absurd kernel: [  162.396179] usb usb1: root hub lost power or was reset
Aug  4 17:40:02 absurd kernel: [  162.396180] usb usb2: root hub lost power or was reset
Aug  4 17:40:02 absurd kernel: [  162.396378] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396383] igb 0000:02:00.0: irq 100 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396389] igb 0000:02:00.1: irq 101 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396392] igb 0000:02:00.0: irq 102 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396396] igb 0000:02:00.1: irq 103 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396400] igb 0000:02:00.0: irq 104 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396403] igb 0000:02:00.1: irq 105 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396411] igb 0000:02:00.0: irq 106 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396412] igb 0000:02:00.1: irq 107 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396423] igb 0000:02:00.0: irq 111 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396424] igb 0000:02:00.1: irq 112 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396434] igb 0000:02:00.0: irq 113 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396436] igb 0000:02:00.1: irq 114 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396444] igb 0000:02:00.0: irq 115 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396446] igb 0000:02:00.1: irq 116 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396453] igb 0000:02:00.0: irq 117 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396455] igb 0000:02:00.1: irq 118 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396461] igb 0000:02:00.0: irq 119 for MSI/MSI-X
Aug  4 17:40:02 absurd kernel: [  162.396768] serial 00:03: activated
Aug  4 17:40:02 absurd kernel: [  162.397143] serial 00:04: activated
Aug  4 17:40:02 absurd kernel: [  162.397651] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:40:02 absurd kernel: [  162.397686] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:40:02 absurd kernel: [  162.397721] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:40:02 absurd kernel: [  162.397746] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:40:02 absurd kernel: [  162.400056] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:40:02 absurd kernel: [  162.400057] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:40:02 absurd kernel: [  162.400134] ------------[ cut here ]------------
Aug  4 17:40:02 absurd kernel: [  162.400141] WARNING: CPU: 28 PID: 6290 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:40:02 absurd kernel: [  162.400172] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj raid1 usb_storage snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel nvidia(PO) kvm joydev hid_generic snd_hda_codec_ca0132 crct10dif_pclmul iTCO_wdt crc32_pclmul iTCO_vendor_support usbhid ghash_clmulni_intel hid mxm_wmi evdev aesni_intel snd_hda_intel aes_x86_64 ablk_helper cryptd glue_helper lrw snd_hda_controller gf128mul snd_hda_codec pcspkr snd_hwdep sb_edac snd_pcm edac_core snd_seq i2c_i801 snd_seq_device snd_timer snd lpc_ich mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler tpm_tis tpm processor wmi thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci libata ehci_pci scsi_transport_sas ehci_hcd scsi_mod
Aug  4 17:40:02 absurd kernel: igb usbcore i2c_algo_bit usb_common i2c_core dca ptp pps_core
Aug  4 17:40:02 absurd kernel: [  162.400187] CPU: 28 PID: 6290 Comm: kworker/u66:2 Tainted: P        W  O  3.16.0-vanilla.1 #1
Aug  4 17:40:02 absurd kernel: [  162.400188] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:40:02 absurd kernel: [  162.400192] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:40:02 absurd kernel: [  162.400194]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:40:02 absurd kernel: [  162.400195]  ffffffff810664f6 ffffffffa03ff09b ffff881057ab2bc0 ffff88105034b940
Aug  4 17:40:02 absurd kernel: [  162.400196]  ffff880880a83c90 ffff88105796b000 ffffffff813a7d3b ffff881055182200
Aug  4 17:40:02 absurd kernel: [  162.400196] Call Trace:
Aug  4 17:40:02 absurd kernel: [  162.400202]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:40:02 absurd kernel: [  162.400206]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:40:02 absurd kernel: [  162.400209]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:40:02 absurd kernel: [  162.400211]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:40:02 absurd kernel: [  162.400214]  [<ffffffffa03fe03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:40:02 absurd kernel: [  162.400218]  [<ffffffffa02cfe21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:40:02 absurd kernel: [  162.400221]  [<ffffffffa02cff17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:40:02 absurd kernel: [  162.400225]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:40:02 absurd kernel: [  162.400228]  [<ffffffffa02cf951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:40:02 absurd kernel: [  162.400230]  [<ffffffffa02d1776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:40:02 absurd kernel: [  162.400233]  [<ffffffffa03ab070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:40:02 absurd kernel: [  162.400235]  [<ffffffffa0334c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:40:02 absurd kernel: [  162.400239]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:40:02 absurd kernel: [  162.400241]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:40:02 absurd kernel: [  162.400243]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:40:02 absurd kernel: [  162.400244]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:40:02 absurd kernel: [  162.400245]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:40:02 absurd kernel: [  162.400248]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:40:02 absurd kernel: [  162.400249]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:40:02 absurd kernel: [  162.400251]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:40:02 absurd kernel: [  162.400253]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:40:02 absurd kernel: [  162.400254]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:40:02 absurd kernel: [  162.400256]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:40:02 absurd kernel: [  162.400257]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:40:02 absurd kernel: [  162.400258]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:40:02 absurd kernel: [  162.400259] ---[ end trace db395c2b3c067203 ]---
Aug  4 17:40:02 absurd kernel: [  162.400260] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:40:02 absurd kernel: [  162.715429] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:40:02 absurd kernel: [  162.715949] ata1.00: configured for UDMA/133
Aug  4 17:40:02 absurd kernel: [  162.723396] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:40:02 absurd kernel: [  162.727562] usb 1-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:40:02 absurd kernel: [  162.727579] usb 2-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:40:02 absurd kernel: [  162.731412] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:40:02 absurd kernel: [  162.745371] ata2.00: configured for UDMA/133
Aug  4 17:40:02 absurd kernel: [  162.747387] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:40:02 absurd kernel: [  162.747412] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:40:02 absurd kernel: [  162.748926] ata4.00: configured for UDMA/100
Aug  4 17:40:02 absurd kernel: [  162.750698] ata5.00: configured for UDMA/133
Aug  4 17:40:02 absurd kernel: [  162.923308] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:40:02 absurd kernel: [  163.139409] usb 2-1.1: reset high-speed USB device number 3 using ehci-pci
Aug  4 17:40:02 absurd kernel: [  163.139425] usb 1-1.6: reset full-speed USB device number 3 using ehci-pci
Aug  4 17:40:02 absurd kernel: [  163.289910] ata6.00: configured for UDMA/133
Aug  4 17:40:02 absurd kernel: [  163.491205] usb 2-1.2: reset low-speed USB device number 4 using ehci-pci
Aug  4 17:40:02 absurd kernel: [  163.842996] usb 2-1.3: reset high-speed USB device number 5 using ehci-pci
Aug  4 17:40:02 absurd kernel: [  164.230775] usb 2-1.3.3: reset full-speed USB device number 7 using ehci-pci
Aug  4 17:40:02 absurd kernel: [  164.410677] usb 2-1.3.1: reset high-speed USB device number 6 using ehci-pci
Aug  4 17:40:02 absurd kernel: [  164.607307] PM: restore of devices complete after 2212.586 msecs
Aug  4 17:40:02 absurd kernel: [  164.836436] Restarting kernel threads ... done.
Aug  4 17:40:02 absurd kernel: [  164.837451] PM: Basic memory bitmaps freed
Aug  4 17:40:02 absurd kernel: [  164.837514] Restarting tasks ... done.
Aug  4 17:40:02 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:40:02 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 17:40:02 absurd upsmon[4479]: UPS duo2pro@localhost is unavailable
Aug  4 17:40:02 absurd acpid: client connected from 4432[0:0]
Aug  4 17:40:02 absurd acpid: 1 client rule loaded
Aug  4 17:40:02 absurd NetworkManager[4243]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:40:02 absurd acpid: client connected from 4432[0:0]
Aug  4 17:40:02 absurd acpid: 1 client rule loaded
Aug  4 17:40:02 absurd acpid: client connected from 4432[0:0]
Aug  4 17:40:02 absurd acpid: 1 client rule loaded
Aug  4 17:40:02 absurd acpid: client connected from 4432[0:0]
Aug  4 17:40:02 absurd acpid: 1 client rule loaded
Aug  4 17:40:03 absurd NetworkManager[4243]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:40:03 absurd kernel: [  165.718005] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 17:40:05 absurd upsd[4451]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 17:40:05 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:40:06 atak /USR/SBIN/CRON[1088]: (janek) CMD (cryptmount -u sejf     > /dev/null 2>&1)
Aug  4 17:40:06 atak /USR/SBIN/CRON[1089]: (janek) CMD (/home/janek/usr/rrd/rrd-feed)
Aug  4 17:40:13 atak /USR/SBIN/CRON[1088]: (janek) CMD (cryptmount -u sejf     > /dev/null 2>&1)
Aug  4 17:40:13 atak /USR/SBIN/CRON[1089]: (janek) CMD (/home/janek/usr/rrd/rrd-feed)
Aug  4 17:40:07 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:40:07 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="6451" x-info="http://www.rsyslog.com"] start
Aug  4 17:40:07 absurd salomea: ========== resume complete ===========
Aug  4 17:40:08 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:40:11 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:40:11 atak /USR/SBIN/CRON[1086]: (CRON) error (grandchild #1088 failed with exit status 1)
Aug  4 17:40:18 atak /USR/SBIN/CRON[1086]: (CRON) error (grandchild #1088 failed with exit status 1)
Aug  4 17:40:14 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:40:17 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_2_success5.txt

Aug  4 17:40:26 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:40:29 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:40:32 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:40:35 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:40:38 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:40:40 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:40:41 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:40:41 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:40:41 absurd kernel: [  204.606718] Syncing filesystems ... done.
Aug  4 17:42:01 absurd kernel: [  204.610437] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  4 17:42:01 absurd kernel: [  204.614660] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:42:01 absurd kernel: [  204.614732] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:42:01 absurd kernel: [  204.617644] PM: Basic memory bitmaps created
Aug  4 17:42:01 absurd kernel: [  204.617848] PM: Preallocating image memory... done (allocated 16303646 pages)
Aug  4 17:42:01 absurd kernel: [  210.610987] PM: Allocated 65214584 kbytes in 5.99 seconds (3717.01 MB/s)
Aug  4 17:42:01 absurd kernel: [  210.611047] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:42:01 absurd kernel: [  210.613519] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:42:01 absurd kernel: [  210.614284] serial 00:04: disabled
Aug  4 17:42:01 absurd kernel: [  210.614361] serial 00:03: disabled
Aug  4 17:42:01 absurd kernel: [  210.677890] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:42:01 absurd kernel: [  210.691515] PM: freeze of devices complete after 77.970 msecs
Aug  4 17:42:01 absurd kernel: [  210.692147] PM: late freeze of devices complete after 0.630 msecs
Aug  4 17:42:01 absurd kernel: [  210.694094] PM: noirq freeze of devices complete after 1.946 msecs
Aug  4 17:42:01 absurd kernel: [  210.694095] Disabling non-boot CPUs ...
Aug  4 17:42:01 absurd kernel: [  210.694220] intel_pstate CPU 1 exiting
Aug  4 17:42:01 absurd kernel: [  210.696108] kvm: disabling virtualization on CPU1
Aug  4 17:42:01 absurd kernel: [  210.696140] smpboot: CPU 1 is now offline
Aug  4 17:42:01 absurd kernel: [  210.697044] intel_pstate CPU 2 exiting
Aug  4 17:42:01 absurd kernel: [  210.698956] kvm: disabling virtualization on CPU2
Aug  4 17:42:01 absurd kernel: [  210.698988] smpboot: CPU 2 is now offline
Aug  4 17:42:01 absurd kernel: [  210.699855] intel_pstate CPU 3 exiting
Aug  4 17:42:01 absurd kernel: [  210.702341] kvm: disabling virtualization on CPU3
Aug  4 17:42:01 absurd kernel: [  210.702373] smpboot: CPU 3 is now offline
Aug  4 17:42:01 absurd kernel: [  210.702987] intel_pstate CPU 4 exiting
Aug  4 17:42:01 absurd kernel: [  210.705204] kvm: disabling virtualization on CPU4
Aug  4 17:42:01 absurd kernel: [  210.705215] smpboot: CPU 4 is now offline
Aug  4 17:42:01 absurd kernel: [  210.705837] intel_pstate CPU 5 exiting
Aug  4 17:42:01 absurd kernel: [  210.707707] kvm: disabling virtualization on CPU5
Aug  4 17:42:01 absurd kernel: [  210.707740] smpboot: CPU 5 is now offline
Aug  4 17:42:01 absurd kernel: [  210.708379] intel_pstate CPU 6 exiting
Aug  4 17:42:01 absurd kernel: [  210.710595] kvm: disabling virtualization on CPU6
Aug  4 17:42:01 absurd kernel: [  210.710606] smpboot: CPU 6 is now offline
Aug  4 17:42:01 absurd kernel: [  210.711216] intel_pstate CPU 7 exiting
Aug  4 17:42:01 absurd kernel: [  210.712993] kvm: disabling virtualization on CPU7
Aug  4 17:42:01 absurd kernel: [  210.815405] smpboot: CPU 7 is now offline
Aug  4 17:42:01 absurd kernel: [  210.816270] intel_pstate CPU 8 exiting
Aug  4 17:42:01 absurd kernel: [  210.818154] kvm: disabling virtualization on CPU8
Aug  4 17:42:01 absurd kernel: [  210.818167] smpboot: CPU 8 is now offline
Aug  4 17:42:01 absurd kernel: [  210.820075] intel_pstate CPU 9 exiting
Aug  4 17:42:01 absurd kernel: [  210.822167] kvm: disabling virtualization on CPU9
Aug  4 17:42:01 absurd kernel: [  210.822178] smpboot: CPU 9 is now offline
Aug  4 17:42:01 absurd kernel: [  210.824336] intel_pstate CPU 10 exiting
Aug  4 17:42:01 absurd kernel: [  210.826455] kvm: disabling virtualization on CPU10
Aug  4 17:42:01 absurd kernel: [  210.826466] smpboot: CPU 10 is now offline
Aug  4 17:42:01 absurd kernel: [  210.828616] intel_pstate CPU 11 exiting
Aug  4 17:42:01 absurd kernel: [  210.830673] kvm: disabling virtualization on CPU11
Aug  4 17:42:01 absurd kernel: [  210.830683] smpboot: CPU 11 is now offline
Aug  4 17:42:01 absurd kernel: [  210.832883] intel_pstate CPU 12 exiting
Aug  4 17:42:01 absurd kernel: [  210.835073] kvm: disabling virtualization on CPU12
Aug  4 17:42:01 absurd kernel: [  210.935341] smpboot: CPU 12 is now offline
Aug  4 17:42:01 absurd kernel: [  210.936705] intel_pstate CPU 13 exiting
Aug  4 17:42:01 absurd kernel: [  210.938779] kvm: disabling virtualization on CPU13
Aug  4 17:42:01 absurd kernel: [  211.039317] smpboot: CPU 13 is now offline
Aug  4 17:42:01 absurd kernel: [  211.040652] intel_pstate CPU 14 exiting
Aug  4 17:42:01 absurd kernel: [  211.042688] kvm: disabling virtualization on CPU14
Aug  4 17:42:01 absurd kernel: [  211.042699] smpboot: CPU 14 is now offline
Aug  4 17:42:01 absurd kernel: [  211.045026] intel_pstate CPU 15 exiting
Aug  4 17:42:01 absurd kernel: [  211.047062] kvm: disabling virtualization on CPU15
Aug  4 17:42:01 absurd kernel: [  211.147255] smpboot: CPU 15 is now offline
Aug  4 17:42:01 absurd kernel: [  211.148030] intel_pstate CPU 16 exiting
Aug  4 17:42:01 absurd kernel: [  211.149838] kvm: disabling virtualization on CPU16
Aug  4 17:42:01 absurd kernel: [  211.149859] smpboot: CPU 16 is now offline
Aug  4 17:42:01 absurd kernel: [  211.150473] intel_pstate CPU 17 exiting
Aug  4 17:42:01 absurd kernel: [  211.152001] kvm: disabling virtualization on CPU17
Aug  4 17:42:01 absurd kernel: [  211.152035] smpboot: CPU 17 is now offline
Aug  4 17:42:01 absurd kernel: [  211.152797] intel_pstate CPU 18 exiting
Aug  4 17:42:01 absurd kernel: [  211.154672] kvm: disabling virtualization on CPU18
Aug  4 17:42:01 absurd kernel: [  211.154692] smpboot: CPU 18 is now offline
Aug  4 17:42:01 absurd kernel: [  211.155319] intel_pstate CPU 19 exiting
Aug  4 17:42:01 absurd kernel: [  211.157016] kvm: disabling virtualization on CPU19
Aug  4 17:42:01 absurd kernel: [  211.157026] smpboot: CPU 19 is now offline
Aug  4 17:42:01 absurd kernel: [  211.157571] intel_pstate CPU 20 exiting
Aug  4 17:42:01 absurd kernel: [  211.159234] kvm: disabling virtualization on CPU20
Aug  4 17:42:01 absurd kernel: [  211.159259] smpboot: CPU 20 is now offline
Aug  4 17:42:01 absurd kernel: [  211.159764] intel_pstate CPU 21 exiting
Aug  4 17:42:01 absurd kernel: [  211.161374] kvm: disabling virtualization on CPU21
Aug  4 17:42:01 absurd kernel: [  211.263138] smpboot: CPU 21 is now offline
Aug  4 17:42:01 absurd kernel: [  211.263529] intel_pstate CPU 22 exiting
Aug  4 17:42:01 absurd kernel: [  211.265174] kvm: disabling virtualization on CPU22
Aug  4 17:42:01 absurd kernel: [  211.367091] smpboot: CPU 22 is now offline
Aug  4 17:42:01 absurd kernel: [  211.367700] intel_pstate CPU 23 exiting
Aug  4 17:42:01 absurd kernel: [  211.369430] kvm: disabling virtualization on CPU23
Aug  4 17:42:01 absurd kernel: [  211.471069] smpboot: CPU 23 is now offline
Aug  4 17:42:01 absurd kernel: [  211.472161] intel_pstate CPU 24 exiting
Aug  4 17:42:01 absurd kernel: [  211.473825] kvm: disabling virtualization on CPU24
Aug  4 17:42:01 absurd kernel: [  211.574964] smpboot: CPU 24 is now offline
Aug  4 17:42:01 absurd kernel: [  211.575852] intel_pstate CPU 25 exiting
Aug  4 17:42:01 absurd kernel: [  211.577379] kvm: disabling virtualization on CPU25
Aug  4 17:42:01 absurd kernel: [  211.678904] smpboot: CPU 25 is now offline
Aug  4 17:42:01 absurd kernel: [  211.679509] intel_pstate CPU 26 exiting
Aug  4 17:42:01 absurd kernel: [  211.681191] kvm: disabling virtualization on CPU26
Aug  4 17:42:01 absurd kernel: [  211.681201] smpboot: CPU 26 is now offline
Aug  4 17:42:01 absurd kernel: [  211.681991] intel_pstate CPU 27 exiting
Aug  4 17:42:01 absurd kernel: [  211.683579] kvm: disabling virtualization on CPU27
Aug  4 17:42:01 absurd kernel: [  211.683620] smpboot: CPU 27 is now offline
Aug  4 17:42:01 absurd kernel: [  211.684689] intel_pstate CPU 28 exiting
Aug  4 17:42:01 absurd kernel: [  211.686377] kvm: disabling virtualization on CPU28
Aug  4 17:42:01 absurd kernel: [  211.786851] smpboot: CPU 28 is now offline
Aug  4 17:42:01 absurd kernel: [  211.787724] intel_pstate CPU 29 exiting
Aug  4 17:42:01 absurd kernel: [  211.789307] kvm: disabling virtualization on CPU29
Aug  4 17:42:01 absurd kernel: [  211.789316] smpboot: CPU 29 is now offline
Aug  4 17:42:01 absurd kernel: [  211.789993] intel_pstate CPU 30 exiting
Aug  4 17:42:01 absurd kernel: [  211.791487] kvm: disabling virtualization on CPU30
Aug  4 17:42:01 absurd kernel: [  211.791521] smpboot: CPU 30 is now offline
Aug  4 17:42:01 absurd kernel: [  211.792156] intel_pstate CPU 31 exiting
Aug  4 17:42:01 absurd kernel: [  211.793938] kvm: disabling virtualization on CPU31
Aug  4 17:42:01 absurd kernel: [  211.794802] smpboot: CPU 31 is now offline
Aug  4 17:42:01 absurd kernel: [  211.795900] PM: Creating hibernation image:
Aug  4 17:42:01 absurd kernel: [  212.907185] PM: Need to copy 390797 pages
Aug  4 17:42:01 absurd kernel: [  212.907187] PM: Normal pages needed: 390797 + 1024, available pages: 16376870
Aug  4 17:42:01 absurd kernel: [  211.803184] Enabling non-boot CPUs ...
Aug  4 17:42:01 absurd kernel: [  211.803499] x86: Booting SMP configuration:
Aug  4 17:42:01 absurd kernel: [  211.803501] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:42:01 absurd kernel: [  211.815206] kvm: enabling virtualization on CPU1
Aug  4 17:42:01 absurd kernel: [  211.817486] Intel pstate controlling: cpu 1
Aug  4 17:42:01 absurd kernel: [  211.817556] CPU1 is up
Aug  4 17:42:01 absurd kernel: [  211.817687] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:42:01 absurd kernel: [  211.829393] kvm: enabling virtualization on CPU2
Aug  4 17:42:01 absurd kernel: [  211.831655] Intel pstate controlling: cpu 2
Aug  4 17:42:01 absurd kernel: [  211.831724] CPU2 is up
Aug  4 17:42:01 absurd kernel: [  211.831860] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:42:01 absurd kernel: [  211.843581] kvm: enabling virtualization on CPU3
Aug  4 17:42:01 absurd kernel: [  211.845876] Intel pstate controlling: cpu 3
Aug  4 17:42:01 absurd kernel: [  211.845943] CPU3 is up
Aug  4 17:42:01 absurd kernel: [  211.846091] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:42:01 absurd kernel: [  211.857791] kvm: enabling virtualization on CPU4
Aug  4 17:42:01 absurd kernel: [  211.860058] Intel pstate controlling: cpu 4
Aug  4 17:42:01 absurd kernel: [  211.860127] CPU4 is up
Aug  4 17:42:01 absurd kernel: [  211.860228] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:42:01 absurd kernel: [  211.871918] kvm: enabling virtualization on CPU5
Aug  4 17:42:01 absurd kernel: [  211.874232] Intel pstate controlling: cpu 5
Aug  4 17:42:01 absurd kernel: [  211.874298] CPU5 is up
Aug  4 17:42:01 absurd kernel: [  211.874441] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:42:01 absurd kernel: [  211.886124] kvm: enabling virtualization on CPU6
Aug  4 17:42:01 absurd kernel: [  211.888420] Intel pstate controlling: cpu 6
Aug  4 17:42:01 absurd kernel: [  211.888489] CPU6 is up
Aug  4 17:42:01 absurd kernel: [  211.888626] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:42:01 absurd kernel: [  211.900305] kvm: enabling virtualization on CPU7
Aug  4 17:42:01 absurd kernel: [  211.902623] Intel pstate controlling: cpu 7
Aug  4 17:42:01 absurd kernel: [  211.902689] CPU7 is up
Aug  4 17:42:01 absurd kernel: [  211.903087] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:42:01 absurd kernel: [  211.916391] kvm: enabling virtualization on CPU8
Aug  4 17:42:01 absurd kernel: [  211.936814] Intel pstate controlling: cpu 8
Aug  4 17:42:01 absurd kernel: [  211.936864] CPU8 is up
Aug  4 17:42:01 absurd kernel: [  211.937210] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:42:01 absurd kernel: [  211.950566] kvm: enabling virtualization on CPU9
Aug  4 17:42:01 absurd kernel: [  211.952832] Intel pstate controlling: cpu 9
Aug  4 17:42:01 absurd kernel: [  211.952882] CPU9 is up
Aug  4 17:42:01 absurd kernel: [  211.953130] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:42:01 absurd kernel: [  211.966492] kvm: enabling virtualization on CPU10
Aug  4 17:42:01 absurd kernel: [  211.968762] Intel pstate controlling: cpu 10
Aug  4 17:42:01 absurd kernel: [  211.968814] CPU10 is up
Aug  4 17:42:01 absurd kernel: [  211.969060] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:42:01 absurd kernel: [  211.982440] kvm: enabling virtualization on CPU11
Aug  4 17:42:01 absurd kernel: [  211.984702] Intel pstate controlling: cpu 11
Aug  4 17:42:01 absurd kernel: [  211.984752] CPU11 is up
Aug  4 17:42:01 absurd kernel: [  211.984958] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:42:01 absurd kernel: [  211.998331] kvm: enabling virtualization on CPU12
Aug  4 17:42:01 absurd kernel: [  212.000612] Intel pstate controlling: cpu 12
Aug  4 17:42:01 absurd kernel: [  212.000663] CPU12 is up
Aug  4 17:42:01 absurd kernel: [  212.000845] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:42:01 absurd kernel: [  212.014162] kvm: enabling virtualization on CPU13
Aug  4 17:42:01 absurd kernel: [  212.016499] Intel pstate controlling: cpu 13
Aug  4 17:42:01 absurd kernel: [  212.016547] CPU13 is up
Aug  4 17:42:01 absurd kernel: [  212.016730] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:42:01 absurd kernel: [  212.028416] kvm: enabling virtualization on CPU14
Aug  4 17:42:01 absurd kernel: [  212.030688] Intel pstate controlling: cpu 14
Aug  4 17:42:01 absurd kernel: [  212.030731] CPU14 is up
Aug  4 17:42:01 absurd kernel: [  212.030892] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:42:01 absurd kernel: [  212.042570] kvm: enabling virtualization on CPU15
Aug  4 17:42:01 absurd kernel: [  212.044864] Intel pstate controlling: cpu 15
Aug  4 17:42:01 absurd kernel: [  212.044907] CPU15 is up
Aug  4 17:42:01 absurd kernel: [  212.045029] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:42:01 absurd kernel: [  212.056734] kvm: enabling virtualization on CPU16
Aug  4 17:42:01 absurd kernel: [  212.059210] Intel pstate controlling: cpu 16
Aug  4 17:42:01 absurd kernel: [  212.059273] CPU16 is up
Aug  4 17:42:01 absurd kernel: [  212.059417] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:42:01 absurd kernel: [  212.071110] kvm: enabling virtualization on CPU17
Aug  4 17:42:01 absurd kernel: [  212.073577] Intel pstate controlling: cpu 17
Aug  4 17:42:01 absurd kernel: [  212.073639] CPU17 is up
Aug  4 17:42:01 absurd kernel: [  212.073777] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:42:01 absurd kernel: [  212.085471] kvm: enabling virtualization on CPU18
Aug  4 17:42:01 absurd kernel: [  212.087944] Intel pstate controlling: cpu 18
Aug  4 17:42:01 absurd kernel: [  212.088008] CPU18 is up
Aug  4 17:42:01 absurd kernel: [  212.088150] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:42:01 absurd kernel: [  212.099853] kvm: enabling virtualization on CPU19
Aug  4 17:42:01 absurd kernel: [  212.102294] Intel pstate controlling: cpu 19
Aug  4 17:42:01 absurd kernel: [  212.102356] CPU19 is up
Aug  4 17:42:01 absurd kernel: [  212.102495] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:42:01 absurd kernel: [  212.114181] kvm: enabling virtualization on CPU20
Aug  4 17:42:01 absurd kernel: [  212.116666] Intel pstate controlling: cpu 20
Aug  4 17:42:01 absurd kernel: [  212.116728] CPU20 is up
Aug  4 17:42:01 absurd kernel: [  212.116868] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:42:01 absurd kernel: [  212.128549] kvm: enabling virtualization on CPU21
Aug  4 17:42:01 absurd kernel: [  212.130992] Intel pstate controlling: cpu 21
Aug  4 17:42:01 absurd kernel: [  212.131052] CPU21 is up
Aug  4 17:42:01 absurd kernel: [  212.131188] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:42:01 absurd kernel: [  212.142870] kvm: enabling virtualization on CPU22
Aug  4 17:42:01 absurd kernel: [  212.145404] Intel pstate controlling: cpu 22
Aug  4 17:42:01 absurd kernel: [  212.145466] CPU22 is up
Aug  4 17:42:01 absurd kernel: [  212.145605] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:42:01 absurd kernel: [  212.157275] kvm: enabling virtualization on CPU23
Aug  4 17:42:01 absurd kernel: [  212.159844] Intel pstate controlling: cpu 23
Aug  4 17:42:01 absurd kernel: [  212.159906] CPU23 is up
Aug  4 17:42:01 absurd kernel: [  212.160178] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:42:01 absurd kernel: [  212.171854] kvm: enabling virtualization on CPU24
Aug  4 17:42:01 absurd kernel: [  212.174271] Intel pstate controlling: cpu 24
Aug  4 17:42:01 absurd kernel: [  212.174313] CPU24 is up
Aug  4 17:42:01 absurd kernel: [  212.174485] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:42:01 absurd kernel: [  212.186169] kvm: enabling virtualization on CPU25
Aug  4 17:42:01 absurd kernel: [  212.188556] Intel pstate controlling: cpu 25
Aug  4 17:42:01 absurd kernel: [  212.188599] CPU25 is up
Aug  4 17:42:01 absurd kernel: [  212.188768] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:42:01 absurd kernel: [  212.200455] kvm: enabling virtualization on CPU26
Aug  4 17:42:01 absurd kernel: [  212.202841] Intel pstate controlling: cpu 26
Aug  4 17:42:01 absurd kernel: [  212.202883] CPU26 is up
Aug  4 17:42:01 absurd kernel: [  212.203059] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:42:01 absurd kernel: [  212.214756] kvm: enabling virtualization on CPU27
Aug  4 17:42:01 absurd kernel: [  212.217142] Intel pstate controlling: cpu 27
Aug  4 17:42:01 absurd kernel: [  212.217186] CPU27 is up
Aug  4 17:42:01 absurd kernel: [  212.217352] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:42:01 absurd kernel: [  212.229038] kvm: enabling virtualization on CPU28
Aug  4 17:42:01 absurd kernel: [  212.231461] Intel pstate controlling: cpu 28
Aug  4 17:42:01 absurd kernel: [  212.231505] CPU28 is up
Aug  4 17:42:01 absurd kernel: [  212.231669] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:42:01 absurd kernel: [  212.243348] kvm: enabling virtualization on CPU29
Aug  4 17:42:01 absurd kernel: [  212.245779] Intel pstate controlling: cpu 29
Aug  4 17:42:01 absurd kernel: [  212.245822] CPU29 is up
Aug  4 17:42:01 absurd kernel: [  212.245988] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:42:01 absurd kernel: [  212.257663] kvm: enabling virtualization on CPU30
Aug  4 17:42:01 absurd kernel: [  212.260107] Intel pstate controlling: cpu 30
Aug  4 17:42:01 absurd kernel: [  212.260150] CPU30 is up
Aug  4 17:42:01 absurd kernel: [  212.260316] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:42:01 absurd kernel: [  212.271985] kvm: enabling virtualization on CPU31
Aug  4 17:42:01 absurd kernel: [  212.274452] Intel pstate controlling: cpu 31
Aug  4 17:42:01 absurd kernel: [  212.274494] CPU31 is up
Aug  4 17:42:01 absurd kernel: [  212.342105] PM: noirq restore of devices complete after 16.522 msecs
Aug  4 17:42:01 absurd kernel: [  212.342608] PM: early restore of devices complete after 0.444 msecs
Aug  4 17:42:01 absurd kernel: [  212.501996] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:42:01 absurd kernel: [  212.502062] usb usb1: root hub lost power or was reset
Aug  4 17:42:01 absurd kernel: [  212.502063] usb usb2: root hub lost power or was reset
Aug  4 17:42:01 absurd kernel: [  212.502242] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502248] igb 0000:02:00.1: irq 100 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502256] igb 0000:02:00.1: irq 101 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502261] igb 0000:02:00.1: irq 102 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502265] igb 0000:02:00.1: irq 103 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502269] igb 0000:02:00.1: irq 104 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502274] igb 0000:02:00.1: irq 105 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502280] igb 0000:02:00.1: irq 106 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502285] igb 0000:02:00.1: irq 107 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502364] igb 0000:02:00.0: irq 111 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502369] igb 0000:02:00.0: irq 112 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502377] igb 0000:02:00.0: irq 113 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502381] igb 0000:02:00.0: irq 114 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502385] igb 0000:02:00.0: irq 115 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502390] igb 0000:02:00.0: irq 116 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502394] igb 0000:02:00.0: irq 117 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502398] igb 0000:02:00.0: irq 118 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502402] igb 0000:02:00.0: irq 119 for MSI/MSI-X
Aug  4 17:42:01 absurd kernel: [  212.502492] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:42:01 absurd kernel: [  212.502494] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:42:01 absurd kernel: [  212.502503] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:42:01 absurd kernel: [  212.502503] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:42:01 absurd kernel: [  212.502648] serial 00:03: activated
Aug  4 17:42:01 absurd kernel: [  212.503021] serial 00:04: activated
Aug  4 17:42:01 absurd kernel: [  212.505949] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:42:01 absurd kernel: [  212.505949] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:42:01 absurd kernel: [  212.505958] ------------[ cut here ]------------
Aug  4 17:42:01 absurd kernel: [  212.505964] WARNING: CPU: 4 PID: 6165 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:42:01 absurd kernel: [  212.505998] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj raid1 usb_storage snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel nvidia(PO) kvm joydev hid_generic snd_hda_codec_ca0132 crct10dif_pclmul iTCO_wdt crc32_pclmul iTCO_vendor_support usbhid ghash_clmulni_intel hid mxm_wmi evdev aesni_intel snd_hda_intel aes_x86_64 ablk_helper cryptd glue_helper lrw snd_hda_controller gf128mul snd_hda_codec pcspkr snd_hwdep sb_edac snd_pcm edac_core snd_seq i2c_i801 snd_seq_device snd_timer snd lpc_ich mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler tpm_tis tpm processor wmi thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci libata ehci_pci scsi_transport_sas ehci_hcd scsi_mod
Aug  4 17:42:01 absurd kernel: igb usbcore i2c_algo_bit usb_common i2c_core dca ptp pps_core
Aug  4 17:42:01 absurd kernel: [  212.506010] CPU: 4 PID: 6165 Comm: kworker/u65:83 Tainted: P        W  O  3.16.0-vanilla.1 #1
Aug  4 17:42:01 absurd kernel: [  212.506011] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:42:01 absurd kernel: [  212.506014] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:42:01 absurd kernel: [  212.506016]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:42:01 absurd kernel: [  212.506017]  ffffffff810664f6 ffffffffa03ff09b ffff88081a946c40 ffff88084f380040
Aug  4 17:42:01 absurd kernel: [  212.506018]  ffff880856827c90 ffff88105796b000 ffffffff813a7d3b ffff881055182200
Aug  4 17:42:01 absurd kernel: [  212.506018] Call Trace:
Aug  4 17:42:01 absurd kernel: [  212.506023]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:42:01 absurd kernel: [  212.506025]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:42:01 absurd kernel: [  212.506027]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:42:01 absurd kernel: [  212.506029]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:42:01 absurd kernel: [  212.506032]  [<ffffffffa03fe03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:42:01 absurd kernel: [  212.506036]  [<ffffffffa02cfe21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:42:01 absurd kernel: [  212.506038]  [<ffffffffa02cff17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:42:01 absurd kernel: [  212.506041]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:42:01 absurd kernel: [  212.506044]  [<ffffffffa02cf951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:42:01 absurd kernel: [  212.506046]  [<ffffffffa02d1776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:42:01 absurd kernel: [  212.506049]  [<ffffffffa03ab070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:42:01 absurd kernel: [  212.506051]  [<ffffffffa0334c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:42:01 absurd kernel: [  212.506053]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:42:01 absurd kernel: [  212.506055]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:42:01 absurd kernel: [  212.506057]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:42:01 absurd kernel: [  212.506058]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:42:01 absurd kernel: [  212.506059]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:42:01 absurd kernel: [  212.506061]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:42:01 absurd kernel: [  212.506062]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:42:01 absurd kernel: [  212.506064]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:42:01 absurd kernel: [  212.506066]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:42:01 absurd kernel: [  212.506067]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:42:01 absurd kernel: [  212.506068]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:42:01 absurd kernel: [  212.506069]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:42:01 absurd kernel: [  212.506070]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:42:01 absurd kernel: [  212.506071] ---[ end trace db395c2b3c067204 ]---
Aug  4 17:42:01 absurd kernel: [  212.506073] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:42:01 absurd kernel: [  212.821571] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:42:01 absurd kernel: [  212.822092] ata1.00: configured for UDMA/133
Aug  4 17:42:01 absurd kernel: [  212.829569] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:42:01 absurd kernel: [  212.833598] usb 2-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:42:01 absurd kernel: [  212.833626] usb 1-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:42:01 absurd kernel: [  212.851143] ata2.00: configured for UDMA/133
Aug  4 17:42:01 absurd kernel: [  212.853551] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:42:01 absurd kernel: [  212.853576] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:42:01 absurd kernel: [  212.856093] ata4.00: configured for UDMA/100
Aug  4 17:42:01 absurd kernel: [  212.856877] ata5.00: configured for UDMA/133
Aug  4 17:42:01 absurd kernel: [  212.861531] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:42:01 absurd kernel: [  212.965485] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:42:01 absurd kernel: [  212.976855] ata6.00: configured for UDMA/133
Aug  4 17:42:01 absurd kernel: [  213.245499] usb 1-1.6: reset full-speed USB device number 3 using ehci-pci
Aug  4 17:42:01 absurd kernel: [  213.433401] usb 2-1.2: reset low-speed USB device number 4 using ehci-pci
Aug  4 17:42:01 absurd kernel: [  213.785188] usb 2-1.3: reset high-speed USB device number 5 using ehci-pci
Aug  4 17:42:01 absurd kernel: [  213.949087] usb 2-1.1: reset high-speed USB device number 3 using ehci-pci
Aug  4 17:42:01 absurd kernel: [  214.172967] usb 2-1.3.3: reset full-speed USB device number 7 using ehci-pci
Aug  4 17:42:01 absurd kernel: [  214.352876] usb 2-1.3.1: reset high-speed USB device number 6 using ehci-pci
Aug  4 17:42:01 absurd kernel: [  214.549193] PM: restore of devices complete after 2048.480 msecs
Aug  4 17:42:01 absurd kernel: [  214.701180] Restarting kernel threads ... done.
Aug  4 17:42:01 absurd kernel: [  214.702058] PM: Basic memory bitmaps freed
Aug  4 17:42:01 absurd kernel: [  214.702120] Restarting tasks ... done.
Aug  4 17:42:01 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:42:01 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:42:01 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:42:01 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:42:01 absurd upsd[4451]: Can't connect to UPS [duo2pro] (blazer_usb-duo2pro): No such file or directory
Aug  4 17:42:01 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 17:42:01 absurd acpid: client connected from 4432[0:0]
Aug  4 17:42:01 absurd acpid: 1 client rule loaded
Aug  4 17:42:01 absurd NetworkManager[4243]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:42:02 absurd acpid: client connected from 4432[0:0]
Aug  4 17:42:02 absurd acpid: 1 client rule loaded
Aug  4 17:42:02 absurd acpid: client connected from 4432[0:0]
Aug  4 17:42:02 absurd acpid: 1 client rule loaded
Aug  4 17:42:02 absurd NetworkManager[4243]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:42:02 absurd kernel: [  215.276480] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 17:42:02 absurd acpid: client connected from 4432[0:0]
Aug  4 17:42:02 absurd acpid: 1 client rule loaded
Aug  4 17:42:04 absurd upsd[4451]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 17:42:04 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:42:07 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:42:07 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="6564" x-info="http://www.rsyslog.com"] start
Aug  4 17:42:07 absurd salomea: ========== resume complete ===========
Aug  4 17:42:07 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:42:10 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:42:13 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:42:16 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:42:19 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:42:22 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_2_success6.txt

Aug  4 17:42:22 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:42:25 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:42:28 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:42:31 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:42:34 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:42:37 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:42:37 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:42:38 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:43:58 absurd kernel: [  251.424240] Syncing filesystems ... done.
Aug  4 17:43:58 absurd kernel: [  251.427592] Freezing user space processes ... (elapsed 0.001 seconds) done.
Aug  4 17:43:58 absurd kernel: [  251.430696] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:43:58 absurd kernel: [  251.430760] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:43:58 absurd kernel: [  251.432068] PM: Basic memory bitmaps created
Aug  4 17:43:58 absurd kernel: [  251.432241] PM: Preallocating image memory... done (allocated 16303995 pages)
Aug  4 17:43:58 absurd kernel: [  257.114446] PM: Allocated 65215980 kbytes in 5.68 seconds (3920.12 MB/s)
Aug  4 17:43:58 absurd kernel: [  257.114506] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:43:58 absurd kernel: [  257.116556] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:43:58 absurd kernel: [  257.117150] serial 00:04: disabled
Aug  4 17:43:58 absurd kernel: [  257.117227] serial 00:03: disabled
Aug  4 17:43:58 absurd kernel: [  257.183713] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:43:58 absurd kernel: [  257.195792] PM: freeze of devices complete after 79.218 msecs
Aug  4 17:43:58 absurd kernel: [  257.196457] PM: late freeze of devices complete after 0.664 msecs
Aug  4 17:43:58 absurd kernel: [  257.198418] PM: noirq freeze of devices complete after 1.960 msecs
Aug  4 17:43:58 absurd kernel: [  257.198419] Disabling non-boot CPUs ...
Aug  4 17:43:58 absurd kernel: [  257.198552] intel_pstate CPU 1 exiting
Aug  4 17:43:58 absurd kernel: [  257.200532] kvm: disabling virtualization on CPU1
Aug  4 17:43:58 absurd kernel: [  257.200608] smpboot: CPU 1 is now offline
Aug  4 17:43:58 absurd kernel: [  257.201576] intel_pstate CPU 2 exiting
Aug  4 17:43:58 absurd kernel: [  257.203874] kvm: disabling virtualization on CPU2
Aug  4 17:43:58 absurd kernel: [  257.203900] smpboot: CPU 2 is now offline
Aug  4 17:43:58 absurd kernel: [  257.204519] intel_pstate CPU 3 exiting
Aug  4 17:43:58 absurd kernel: [  257.206421] kvm: disabling virtualization on CPU3
Aug  4 17:43:58 absurd kernel: [  257.206446] smpboot: CPU 3 is now offline
Aug  4 17:43:58 absurd kernel: [  257.207089] intel_pstate CPU 4 exiting
Aug  4 17:43:58 absurd kernel: [  257.209546] kvm: disabling virtualization on CPU4
Aug  4 17:43:58 absurd kernel: [  257.209557] smpboot: CPU 4 is now offline
Aug  4 17:43:58 absurd kernel: [  257.210162] intel_pstate CPU 5 exiting
Aug  4 17:43:58 absurd kernel: [  257.212312] kvm: disabling virtualization on CPU5
Aug  4 17:43:58 absurd kernel: [  257.212345] smpboot: CPU 5 is now offline
Aug  4 17:43:58 absurd kernel: [  257.212963] intel_pstate CPU 6 exiting
Aug  4 17:43:58 absurd kernel: [  257.214988] kvm: disabling virtualization on CPU6
Aug  4 17:43:58 absurd kernel: [  257.214996] smpboot: CPU 6 is now offline
Aug  4 17:43:58 absurd kernel: [  257.215615] intel_pstate CPU 7 exiting
Aug  4 17:43:58 absurd kernel: [  257.217407] kvm: disabling virtualization on CPU7
Aug  4 17:43:58 absurd kernel: [  257.217425] smpboot: CPU 7 is now offline
Aug  4 17:43:58 absurd kernel: [  257.218794] intel_pstate CPU 8 exiting
Aug  4 17:43:58 absurd kernel: [  257.221048] kvm: disabling virtualization on CPU8
Aug  4 17:43:58 absurd kernel: [  257.221058] smpboot: CPU 8 is now offline
Aug  4 17:43:58 absurd kernel: [  257.223865] intel_pstate CPU 9 exiting
Aug  4 17:43:58 absurd kernel: [  257.226110] kvm: disabling virtualization on CPU9
Aug  4 17:43:58 absurd kernel: [  257.226128] smpboot: CPU 9 is now offline
Aug  4 17:43:58 absurd kernel: [  257.228633] intel_pstate CPU 10 exiting
Aug  4 17:43:58 absurd kernel: [  257.230880] kvm: disabling virtualization on CPU10
Aug  4 17:43:58 absurd kernel: [  257.230897] smpboot: CPU 10 is now offline
Aug  4 17:43:58 absurd kernel: [  257.233356] intel_pstate CPU 11 exiting
Aug  4 17:43:58 absurd kernel: [  257.235473] kvm: disabling virtualization on CPU11
Aug  4 17:43:58 absurd kernel: [  257.335667] smpboot: CPU 11 is now offline
Aug  4 17:43:58 absurd kernel: [  257.336718] intel_pstate CPU 12 exiting
Aug  4 17:43:58 absurd kernel: [  257.338457] kvm: disabling virtualization on CPU12
Aug  4 17:43:58 absurd kernel: [  257.338465] smpboot: CPU 12 is now offline
Aug  4 17:43:58 absurd kernel: [  257.340103] intel_pstate CPU 13 exiting
Aug  4 17:43:58 absurd kernel: [  257.341878] kvm: disabling virtualization on CPU13
Aug  4 17:43:58 absurd kernel: [  257.443617] smpboot: CPU 13 is now offline
Aug  4 17:43:58 absurd kernel: [  257.444940] intel_pstate CPU 14 exiting
Aug  4 17:43:58 absurd kernel: [  257.446937] kvm: disabling virtualization on CPU14
Aug  4 17:43:58 absurd kernel: [  257.547583] smpboot: CPU 14 is now offline
Aug  4 17:43:58 absurd kernel: [  257.548877] intel_pstate CPU 15 exiting
Aug  4 17:43:58 absurd kernel: [  257.550870] kvm: disabling virtualization on CPU15
Aug  4 17:43:58 absurd kernel: [  257.550882] smpboot: CPU 15 is now offline
Aug  4 17:43:58 absurd kernel: [  257.552641] intel_pstate CPU 16 exiting
Aug  4 17:43:58 absurd kernel: [  257.554502] kvm: disabling virtualization on CPU16
Aug  4 17:43:58 absurd kernel: [  257.554510] smpboot: CPU 16 is now offline
Aug  4 17:43:58 absurd kernel: [  257.555267] intel_pstate CPU 17 exiting
Aug  4 17:43:58 absurd kernel: [  257.556946] kvm: disabling virtualization on CPU17
Aug  4 17:43:58 absurd kernel: [  257.556965] smpboot: CPU 17 is now offline
Aug  4 17:43:58 absurd kernel: [  257.557398] intel_pstate CPU 18 exiting
Aug  4 17:43:58 absurd kernel: [  257.558936] kvm: disabling virtualization on CPU18
Aug  4 17:43:58 absurd kernel: [  257.558955] smpboot: CPU 18 is now offline
Aug  4 17:43:58 absurd kernel: [  257.559518] intel_pstate CPU 19 exiting
Aug  4 17:43:58 absurd kernel: [  257.561261] kvm: disabling virtualization on CPU19
Aug  4 17:43:58 absurd kernel: [  257.561274] smpboot: CPU 19 is now offline
Aug  4 17:43:58 absurd kernel: [  257.561802] intel_pstate CPU 20 exiting
Aug  4 17:43:58 absurd kernel: [  257.563339] kvm: disabling virtualization on CPU20
Aug  4 17:43:58 absurd kernel: [  257.563346] smpboot: CPU 20 is now offline
Aug  4 17:43:58 absurd kernel: [  257.563830] intel_pstate CPU 21 exiting
Aug  4 17:43:58 absurd kernel: [  257.565465] kvm: disabling virtualization on CPU21
Aug  4 17:43:58 absurd kernel: [  257.667473] smpboot: CPU 21 is now offline
Aug  4 17:43:58 absurd kernel: [  257.667868] intel_pstate CPU 22 exiting
Aug  4 17:43:58 absurd kernel: [  257.669268] kvm: disabling virtualization on CPU22
Aug  4 17:43:58 absurd kernel: [  257.771407] smpboot: CPU 22 is now offline
Aug  4 17:43:58 absurd kernel: [  257.771683] intel_pstate CPU 23 exiting
Aug  4 17:43:58 absurd kernel: [  257.773052] kvm: disabling virtualization on CPU23
Aug  4 17:43:58 absurd kernel: [  257.773064] smpboot: CPU 23 is now offline
Aug  4 17:43:58 absurd kernel: [  257.773500] intel_pstate CPU 24 exiting
Aug  4 17:43:58 absurd kernel: [  257.775049] kvm: disabling virtualization on CPU24
Aug  4 17:43:58 absurd kernel: [  257.875350] smpboot: CPU 24 is now offline
Aug  4 17:43:58 absurd kernel: [  257.876354] intel_pstate CPU 25 exiting
Aug  4 17:43:58 absurd kernel: [  257.877900] kvm: disabling virtualization on CPU25
Aug  4 17:43:58 absurd kernel: [  257.983288] smpboot: CPU 25 is now offline
Aug  4 17:43:58 absurd kernel: [  257.984028] intel_pstate CPU 26 exiting
Aug  4 17:43:58 absurd kernel: [  257.985427] kvm: disabling virtualization on CPU26
Aug  4 17:43:58 absurd kernel: [  258.087227] smpboot: CPU 26 is now offline
Aug  4 17:43:58 absurd kernel: [  258.087824] intel_pstate CPU 27 exiting
Aug  4 17:43:58 absurd kernel: [  258.089177] kvm: disabling virtualization on CPU27
Aug  4 17:43:58 absurd kernel: [  258.191171] smpboot: CPU 27 is now offline
Aug  4 17:43:58 absurd kernel: [  258.191713] intel_pstate CPU 28 exiting
Aug  4 17:43:58 absurd kernel: [  258.193031] kvm: disabling virtualization on CPU28
Aug  4 17:43:58 absurd kernel: [  258.295113] smpboot: CPU 28 is now offline
Aug  4 17:43:58 absurd kernel: [  258.295621] intel_pstate CPU 29 exiting
Aug  4 17:43:58 absurd kernel: [  258.296906] kvm: disabling virtualization on CPU29
Aug  4 17:43:58 absurd kernel: [  258.399053] smpboot: CPU 29 is now offline
Aug  4 17:43:58 absurd kernel: [  258.399588] intel_pstate CPU 30 exiting
Aug  4 17:43:58 absurd kernel: [  258.400861] kvm: disabling virtualization on CPU30
Aug  4 17:43:58 absurd kernel: [  258.506982] smpboot: CPU 30 is now offline
Aug  4 17:43:58 absurd kernel: [  258.507401] intel_pstate CPU 31 exiting
Aug  4 17:43:58 absurd kernel: [  258.509081] kvm: disabling virtualization on CPU31
Aug  4 17:43:58 absurd kernel: [  258.610919] smpboot: CPU 31 is now offline
Aug  4 17:43:58 absurd kernel: [  258.612105] PM: Creating hibernation image:
Aug  4 17:43:58 absurd kernel: [  259.212875] PM: Need to copy 393353 pages
Aug  4 17:43:58 absurd kernel: [  259.212876] PM: Normal pages needed: 393353 + 1024, available pages: 16374311
Aug  4 17:43:58 absurd kernel: [  258.619379] Enabling non-boot CPUs ...
Aug  4 17:43:58 absurd kernel: [  258.619695] x86: Booting SMP configuration:
Aug  4 17:43:58 absurd kernel: [  258.619697] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:43:58 absurd kernel: [  258.633068] kvm: enabling virtualization on CPU1
Aug  4 17:43:58 absurd kernel: [  258.635646] Intel pstate controlling: cpu 1
Aug  4 17:43:58 absurd kernel: [  258.635788] CPU1 is up
Aug  4 17:43:58 absurd kernel: [  258.636055] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:43:58 absurd kernel: [  258.647762] kvm: enabling virtualization on CPU2
Aug  4 17:43:58 absurd kernel: [  258.650010] Intel pstate controlling: cpu 2
Aug  4 17:43:58 absurd kernel: [  258.650078] CPU2 is up
Aug  4 17:43:58 absurd kernel: [  258.650226] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:43:58 absurd kernel: [  258.661944] kvm: enabling virtualization on CPU3
Aug  4 17:43:58 absurd kernel: [  258.664215] Intel pstate controlling: cpu 3
Aug  4 17:43:58 absurd kernel: [  258.664284] CPU3 is up
Aug  4 17:43:58 absurd kernel: [  258.664418] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:43:58 absurd kernel: [  258.676115] kvm: enabling virtualization on CPU4
Aug  4 17:43:58 absurd kernel: [  258.678394] Intel pstate controlling: cpu 4
Aug  4 17:43:58 absurd kernel: [  258.678462] CPU4 is up
Aug  4 17:43:58 absurd kernel: [  258.678600] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:43:58 absurd kernel: [  258.690291] kvm: enabling virtualization on CPU5
Aug  4 17:43:58 absurd kernel: [  258.692571] Intel pstate controlling: cpu 5
Aug  4 17:43:58 absurd kernel: [  258.692637] CPU5 is up
Aug  4 17:43:58 absurd kernel: [  258.692773] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:43:58 absurd kernel: [  258.704462] kvm: enabling virtualization on CPU6
Aug  4 17:43:58 absurd kernel: [  258.706765] Intel pstate controlling: cpu 6
Aug  4 17:43:58 absurd kernel: [  258.706831] CPU6 is up
Aug  4 17:43:58 absurd kernel: [  258.706974] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:43:58 absurd kernel: [  258.718656] kvm: enabling virtualization on CPU7
Aug  4 17:43:58 absurd kernel: [  258.720958] Intel pstate controlling: cpu 7
Aug  4 17:43:58 absurd kernel: [  258.721025] CPU7 is up
Aug  4 17:43:58 absurd kernel: [  258.721415] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:43:58 absurd kernel: [  258.734718] kvm: enabling virtualization on CPU8
Aug  4 17:43:58 absurd kernel: [  258.755023] Intel pstate controlling: cpu 8
Aug  4 17:43:58 absurd kernel: [  258.755077] CPU8 is up
Aug  4 17:43:58 absurd kernel: [  258.755420] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:43:58 absurd kernel: [  258.768772] kvm: enabling virtualization on CPU9
Aug  4 17:43:58 absurd kernel: [  258.771048] Intel pstate controlling: cpu 9
Aug  4 17:43:58 absurd kernel: [  258.771100] CPU9 is up
Aug  4 17:43:58 absurd kernel: [  258.771362] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:43:58 absurd kernel: [  258.784737] kvm: enabling virtualization on CPU10
Aug  4 17:43:58 absurd kernel: [  258.786991] Intel pstate controlling: cpu 10
Aug  4 17:43:58 absurd kernel: [  258.787041] CPU10 is up
Aug  4 17:43:58 absurd kernel: [  258.787290] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:43:58 absurd kernel: [  258.800671] kvm: enabling virtualization on CPU11
Aug  4 17:43:58 absurd kernel: [  258.802925] Intel pstate controlling: cpu 11
Aug  4 17:43:58 absurd kernel: [  258.802974] CPU11 is up
Aug  4 17:43:58 absurd kernel: [  258.803178] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:43:58 absurd kernel: [  258.816552] kvm: enabling virtualization on CPU12
Aug  4 17:43:58 absurd kernel: [  258.818830] Intel pstate controlling: cpu 12
Aug  4 17:43:58 absurd kernel: [  258.818883] CPU12 is up
Aug  4 17:43:58 absurd kernel: [  258.819060] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:43:58 absurd kernel: [  258.832382] kvm: enabling virtualization on CPU13
Aug  4 17:43:58 absurd kernel: [  258.834716] Intel pstate controlling: cpu 13
Aug  4 17:43:58 absurd kernel: [  258.834766] CPU13 is up
Aug  4 17:43:58 absurd kernel: [  258.834942] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:43:58 absurd kernel: [  258.848257] kvm: enabling virtualization on CPU14
Aug  4 17:43:58 absurd kernel: [  258.850601] Intel pstate controlling: cpu 14
Aug  4 17:43:58 absurd kernel: [  258.850650] CPU14 is up
Aug  4 17:43:58 absurd kernel: [  258.850828] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:43:58 absurd kernel: [  258.864129] kvm: enabling virtualization on CPU15
Aug  4 17:43:58 absurd kernel: [  258.866398] Intel pstate controlling: cpu 15
Aug  4 17:43:58 absurd kernel: [  258.866445] CPU15 is up
Aug  4 17:43:58 absurd kernel: [  258.866571] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:43:58 absurd kernel: [  258.878310] kvm: enabling virtualization on CPU16
Aug  4 17:43:58 absurd kernel: [  258.880800] Intel pstate controlling: cpu 16
Aug  4 17:43:58 absurd kernel: [  258.880867] CPU16 is up
Aug  4 17:43:58 absurd kernel: [  258.881018] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:43:58 absurd kernel: [  258.892720] kvm: enabling virtualization on CPU17
Aug  4 17:43:58 absurd kernel: [  258.895228] Intel pstate controlling: cpu 17
Aug  4 17:43:58 absurd kernel: [  258.895290] CPU17 is up
Aug  4 17:43:58 absurd kernel: [  258.895439] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:43:58 absurd kernel: [  258.907137] kvm: enabling virtualization on CPU18
Aug  4 17:43:58 absurd kernel: [  258.909632] Intel pstate controlling: cpu 18
Aug  4 17:43:58 absurd kernel: [  258.909694] CPU18 is up
Aug  4 17:43:58 absurd kernel: [  258.909842] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:43:58 absurd kernel: [  258.921550] kvm: enabling virtualization on CPU19
Aug  4 17:43:58 absurd kernel: [  258.924066] Intel pstate controlling: cpu 19
Aug  4 17:43:58 absurd kernel: [  258.924130] CPU19 is up
Aug  4 17:43:58 absurd kernel: [  258.924275] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:43:58 absurd kernel: [  258.935967] kvm: enabling virtualization on CPU20
Aug  4 17:43:58 absurd kernel: [  258.938517] Intel pstate controlling: cpu 20
Aug  4 17:43:58 absurd kernel: [  258.938579] CPU20 is up
Aug  4 17:43:58 absurd kernel: [  258.938726] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:43:58 absurd kernel: [  258.950409] kvm: enabling virtualization on CPU21
Aug  4 17:43:58 absurd kernel: [  258.952879] Intel pstate controlling: cpu 21
Aug  4 17:43:58 absurd kernel: [  258.952941] CPU21 is up
Aug  4 17:43:58 absurd kernel: [  258.953090] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:43:58 absurd kernel: [  258.964771] kvm: enabling virtualization on CPU22
Aug  4 17:43:58 absurd kernel: [  258.967262] Intel pstate controlling: cpu 22
Aug  4 17:43:58 absurd kernel: [  258.967326] CPU22 is up
Aug  4 17:43:58 absurd kernel: [  258.967477] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:43:58 absurd kernel: [  258.979151] kvm: enabling virtualization on CPU23
Aug  4 17:43:58 absurd kernel: [  258.981660] Intel pstate controlling: cpu 23
Aug  4 17:43:58 absurd kernel: [  258.981728] CPU23 is up
Aug  4 17:43:58 absurd kernel: [  258.982051] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:43:58 absurd kernel: [  258.995355] kvm: enabling virtualization on CPU24
Aug  4 17:43:58 absurd kernel: [  258.997773] Intel pstate controlling: cpu 24
Aug  4 17:43:58 absurd kernel: [  258.997825] CPU24 is up
Aug  4 17:43:58 absurd kernel: [  258.998019] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:43:58 absurd kernel: [  259.011353] kvm: enabling virtualization on CPU25
Aug  4 17:43:58 absurd kernel: [  259.013813] Intel pstate controlling: cpu 25
Aug  4 17:43:58 absurd kernel: [  259.013858] CPU25 is up
Aug  4 17:43:58 absurd kernel: [  259.014058] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:43:58 absurd kernel: [  259.027409] kvm: enabling virtualization on CPU26
Aug  4 17:43:58 absurd kernel: [  259.029849] Intel pstate controlling: cpu 26
Aug  4 17:43:58 absurd kernel: [  259.029896] CPU26 is up
Aug  4 17:43:58 absurd kernel: [  259.030092] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:43:58 absurd kernel: [  259.043455] kvm: enabling virtualization on CPU27
Aug  4 17:43:58 absurd kernel: [  259.045894] Intel pstate controlling: cpu 27
Aug  4 17:43:58 absurd kernel: [  259.045946] CPU27 is up
Aug  4 17:43:58 absurd kernel: [  259.046122] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:43:58 absurd kernel: [  259.059479] kvm: enabling virtualization on CPU28
Aug  4 17:43:58 absurd kernel: [  259.061964] Intel pstate controlling: cpu 28
Aug  4 17:43:58 absurd kernel: [  259.062012] CPU28 is up
Aug  4 17:43:58 absurd kernel: [  259.062187] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:43:58 absurd kernel: [  259.075487] kvm: enabling virtualization on CPU29
Aug  4 17:43:58 absurd kernel: [  259.077927] Intel pstate controlling: cpu 29
Aug  4 17:43:58 absurd kernel: [  259.077975] CPU29 is up
Aug  4 17:43:58 absurd kernel: [  259.078151] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:43:58 absurd kernel: [  259.091446] kvm: enabling virtualization on CPU30
Aug  4 17:43:58 absurd kernel: [  259.093884] Intel pstate controlling: cpu 30
Aug  4 17:43:58 absurd kernel: [  259.093937] CPU30 is up
Aug  4 17:43:58 absurd kernel: [  259.094108] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:43:58 absurd kernel: [  259.107390] kvm: enabling virtualization on CPU31
Aug  4 17:43:58 absurd kernel: [  259.109859] Intel pstate controlling: cpu 31
Aug  4 17:43:58 absurd kernel: [  259.109913] CPU31 is up
Aug  4 17:43:58 absurd kernel: [  259.217901] PM: noirq restore of devices complete after 17.750 msecs
Aug  4 17:43:58 absurd kernel: [  259.218410] PM: early restore of devices complete after 0.451 msecs
Aug  4 17:43:58 absurd kernel: [  259.378874] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:43:58 absurd kernel: [  259.378957] usb usb2: root hub lost power or was reset
Aug  4 17:43:58 absurd kernel: [  259.378958] usb usb1: root hub lost power or was reset
Aug  4 17:43:58 absurd kernel: [  259.379141] igb 0000:02:00.0: irq 100 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379144] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379150] igb 0000:02:00.0: irq 101 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379154] igb 0000:02:00.1: irq 102 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379157] igb 0000:02:00.0: irq 103 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379161] igb 0000:02:00.1: irq 104 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379163] igb 0000:02:00.0: irq 105 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379169] igb 0000:02:00.1: irq 106 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379170] igb 0000:02:00.0: irq 107 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379179] igb 0000:02:00.1: irq 111 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379180] igb 0000:02:00.0: irq 112 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379189] igb 0000:02:00.1: irq 113 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379191] igb 0000:02:00.0: irq 114 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379197] igb 0000:02:00.1: irq 115 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379199] igb 0000:02:00.0: irq 116 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379205] igb 0000:02:00.0: irq 118 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379209] igb 0000:02:00.1: irq 117 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379215] igb 0000:02:00.1: irq 119 for MSI/MSI-X
Aug  4 17:43:58 absurd kernel: [  259.379513] serial 00:03: activated
Aug  4 17:43:58 absurd kernel: [  259.379882] serial 00:04: activated
Aug  4 17:43:58 absurd kernel: [  259.381983] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:43:58 absurd kernel: [  259.381985] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:43:58 absurd kernel: [  259.381990] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:43:58 absurd kernel: [  259.381992] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:43:58 absurd kernel: [  259.382838] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:43:58 absurd kernel: [  259.382839] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:43:58 absurd kernel: [  259.382945] ------------[ cut here ]------------
Aug  4 17:43:58 absurd kernel: [  259.382950] WARNING: CPU: 0 PID: 6116 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:43:58 absurd kernel: [  259.382983] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj raid1 usb_storage snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel nvidia(PO) kvm joydev hid_generic snd_hda_codec_ca0132 crct10dif_pclmul iTCO_wdt crc32_pclmul iTCO_vendor_support usbhid ghash_clmulni_intel hid mxm_wmi evdev aesni_intel snd_hda_intel aes_x86_64 ablk_helper cryptd glue_helper lrw snd_hda_controller gf128mul snd_hda_codec pcspkr snd_hwdep sb_edac snd_pcm edac_core snd_seq i2c_i801 snd_seq_device snd_timer snd lpc_ich mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler tpm_tis tpm processor wmi thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci libata ehci_pci scsi_transport_sas ehci_hcd scsi_mod
Aug  4 17:43:58 absurd kernel: igb usbcore i2c_algo_bit usb_common i2c_core dca ptp pps_core
Aug  4 17:43:58 absurd kernel: [  259.382995] CPU: 0 PID: 6116 Comm: kworker/u65:34 Tainted: P        W  O  3.16.0-vanilla.1 #1
Aug  4 17:43:58 absurd kernel: [  259.382996] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:43:58 absurd kernel: [  259.383000] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:43:58 absurd kernel: [  259.383001]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:43:58 absurd kernel: [  259.383002]  ffffffff810664f6 ffffffffa03ff09b ffff8808556ead80 ffff88084e493ac0
Aug  4 17:43:58 absurd kernel: [  259.383003]  ffff880851953c90 ffff88105796b000 ffffffff813a7d3b ffff881055182200
Aug  4 17:43:58 absurd kernel: [  259.383003] Call Trace:
Aug  4 17:43:58 absurd kernel: [  259.383007]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:43:58 absurd kernel: [  259.383010]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:43:58 absurd kernel: [  259.383012]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:43:58 absurd kernel: [  259.383014]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:43:58 absurd kernel: [  259.383017]  [<ffffffffa03fe03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:43:58 absurd kernel: [  259.383021]  [<ffffffffa02cfe21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:43:58 absurd kernel: [  259.383023]  [<ffffffffa02cff17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:43:58 absurd kernel: [  259.383026]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:43:58 absurd kernel: [  259.383029]  [<ffffffffa02cf951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:43:58 absurd kernel: [  259.383031]  [<ffffffffa02d1776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:43:58 absurd kernel: [  259.383034]  [<ffffffffa03ab070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:43:58 absurd kernel: [  259.383036]  [<ffffffffa0334c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:43:58 absurd kernel: [  259.383039]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:43:58 absurd kernel: [  259.383041]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:43:58 absurd kernel: [  259.383043]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:43:58 absurd kernel: [  259.383044]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:43:58 absurd kernel: [  259.383045]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:43:58 absurd kernel: [  259.383047]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:43:58 absurd kernel: [  259.383049]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:43:58 absurd kernel: [  259.383051]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:43:58 absurd kernel: [  259.383053]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:43:58 absurd kernel: [  259.383054]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:43:58 absurd kernel: [  259.383055]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:43:58 absurd kernel: [  259.383056]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:43:58 absurd kernel: [  259.383058]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:43:58 absurd kernel: [  259.383058] ---[ end trace db395c2b3c067205 ]---
Aug  4 17:43:58 absurd kernel: [  259.383060] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:43:58 absurd kernel: [  259.701560] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:43:58 absurd kernel: [  259.713561] usb 1-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:43:58 absurd kernel: [  259.713580] usb 2-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:43:58 absurd kernel: [  259.717548] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:43:58 absurd kernel: [  259.718932] ata4.00: configured for UDMA/100
Aug  4 17:43:58 absurd kernel: [  259.723557] ata2.00: configured for UDMA/133
Aug  4 17:43:58 absurd kernel: [  259.733539] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:43:58 absurd kernel: [  259.733554] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:43:58 absurd kernel: [  259.733570] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:43:58 absurd kernel: [  259.734049] ata1.00: configured for UDMA/133
Aug  4 17:43:58 absurd kernel: [  259.736755] ata5.00: configured for UDMA/133
Aug  4 17:43:58 absurd kernel: [  259.909485] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:43:58 absurd kernel: [  259.919436] ata6.00: configured for UDMA/133
Aug  4 17:43:58 absurd kernel: [  260.125483] usb 2-1.1: reset high-speed USB device number 3 using ehci-pci
Aug  4 17:43:58 absurd kernel: [  260.125528] usb 1-1.6: reset full-speed USB device number 3 using ehci-pci
Aug  4 17:43:58 absurd kernel: [  260.477287] usb 2-1.2: reset low-speed USB device number 4 using ehci-pci
Aug  4 17:43:58 absurd kernel: [  260.829228] usb 2-1.3: reset high-speed USB device number 5 using ehci-pci
Aug  4 17:43:58 absurd kernel: [  261.200854] usb 2-1.3.1: reset high-speed USB device number 6 using ehci-pci
Aug  4 17:43:58 absurd kernel: [  261.380803] usb 2-1.3.3: reset full-speed USB device number 7 using ehci-pci
Aug  4 17:43:58 absurd kernel: [  261.552673] PM: restore of devices complete after 2175.146 msecs
Aug  4 17:43:58 absurd kernel: [  261.755807] Restarting kernel threads ... done.
Aug  4 17:43:58 absurd kernel: [  261.756493] PM: Basic memory bitmaps freed
Aug  4 17:43:58 absurd kernel: [  261.756550] Restarting tasks ... done.
Aug  4 17:43:58 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:43:58 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:43:58 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:43:58 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:43:58 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 17:43:58 absurd acpid: client connected from 4432[0:0]
Aug  4 17:43:58 absurd acpid: 1 client rule loaded
Aug  4 17:43:58 absurd NetworkManager[4243]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:43:58 absurd acpid: client connected from 4432[0:0]
Aug  4 17:43:58 absurd acpid: 1 client rule loaded
Aug  4 17:43:58 absurd acpid: client connected from 4432[0:0]
Aug  4 17:43:58 absurd acpid: 1 client rule loaded
Aug  4 17:43:58 absurd acpid: client connected from 4432[0:0]
Aug  4 17:43:58 absurd acpid: 1 client rule loaded
Aug  4 17:43:59 absurd NetworkManager[4243]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:43:59 absurd kernel: [  262.700198] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 17:44:01 absurd upsd[4451]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 17:44:01 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:17 router dhcpd: DHCPDISCOVER from 00:25:90:ce:a1:20 via eth0
Aug  4 17:44:03 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:44:03 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="6680" x-info="http://www.rsyslog.com"] start
Aug  4 17:44:03 absurd salomea: ========== resume complete ===========
Aug  4 17:44:18 router dhcpd: DHCPOFFER on 192.168.16.231 to 00:25:90:ce:a1:20 via eth0
Aug  4 17:44:04 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:18 router dhcpd: DHCPREQUEST for 192.168.16.231 (192.168.16.1) from 00:25:90:ce:a1:20 via eth0
Aug  4 17:44:18 router dhcpd: DHCPACK on 192.168.16.231 to 00:25:90:ce:a1:20 via eth0
Aug  4 17:44:07 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:10 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:13 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:16 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:19 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:22 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:25 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:28 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_2_success7.txt

Aug  4 17:44:40 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:43 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:46 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:49 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:52 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:55 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:44:56 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:44:57 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:46:14 absurd kernel: [  321.601733] Syncing filesystems ... done.
Aug  4 17:46:14 atak /USR/SBIN/CRON[1436]: (janek) CMD (/home/janek/usr/rrd/rrd-feed)
Aug  4 17:45:10 atak /USR/SBIN/CRON[1436]: (janek) CMD (/home/janek/usr/rrd/rrd-feed)
Aug  4 17:46:14 absurd kernel: [  321.603959] Freezing user space processes ... (elapsed 0.001 seconds) done.
Aug  4 17:46:14 absurd kernel: [  321.606867] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:46:14 absurd kernel: [  321.606929] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:46:14 absurd kernel: [  321.608088] PM: Basic memory bitmaps created
Aug  4 17:46:14 absurd kernel: [  321.608261] PM: Preallocating image memory... done (allocated 16304408 pages)
Aug  4 17:46:14 absurd kernel: [  327.453888] PM: Allocated 65217632 kbytes in 5.84 seconds (3813.00 MB/s)
Aug  4 17:46:14 absurd kernel: [  327.453947] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:46:14 absurd kernel: [  327.456334] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:46:14 absurd kernel: [  327.456990] serial 00:04: disabled
Aug  4 17:46:14 absurd kernel: [  327.457067] serial 00:03: disabled
Aug  4 17:46:14 absurd kernel: [  327.519737] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:46:14 absurd kernel: [  327.534318] PM: freeze of devices complete after 77.958 msecs
Aug  4 17:46:14 absurd kernel: [  327.535019] PM: late freeze of devices complete after 0.699 msecs
Aug  4 17:46:14 absurd kernel: [  327.537108] PM: noirq freeze of devices complete after 2.088 msecs
Aug  4 17:46:14 absurd kernel: [  327.537109] Disabling non-boot CPUs ...
Aug  4 17:46:14 absurd kernel: [  327.537270] intel_pstate CPU 1 exiting
Aug  4 17:46:14 absurd kernel: [  327.539842] kvm: disabling virtualization on CPU1
Aug  4 17:46:14 absurd kernel: [  327.539853] smpboot: CPU 1 is now offline
Aug  4 17:46:14 absurd kernel: [  327.540738] intel_pstate CPU 2 exiting
Aug  4 17:46:14 absurd kernel: [  327.542959] kvm: disabling virtualization on CPU2
Aug  4 17:46:14 absurd kernel: [  327.543047] smpboot: CPU 2 is now offline
Aug  4 17:46:14 absurd kernel: [  327.543629] intel_pstate CPU 3 exiting
Aug  4 17:46:14 absurd kernel: [  327.545779] kvm: disabling virtualization on CPU3
Aug  4 17:46:14 absurd kernel: [  327.545800] smpboot: CPU 3 is now offline
Aug  4 17:46:14 absurd kernel: [  327.546407] intel_pstate CPU 4 exiting
Aug  4 17:46:14 absurd kernel: [  327.548229] kvm: disabling virtualization on CPU4
Aug  4 17:46:14 absurd kernel: [  327.548238] smpboot: CPU 4 is now offline
Aug  4 17:46:14 absurd kernel: [  327.548902] intel_pstate CPU 5 exiting
Aug  4 17:46:14 absurd kernel: [  327.550657] kvm: disabling virtualization on CPU5
Aug  4 17:46:14 absurd kernel: [  327.550712] smpboot: CPU 5 is now offline
Aug  4 17:46:14 absurd kernel: [  327.551290] intel_pstate CPU 6 exiting
Aug  4 17:46:14 absurd kernel: [  327.553371] kvm: disabling virtualization on CPU6
Aug  4 17:46:14 absurd kernel: [  327.553390] smpboot: CPU 6 is now offline
Aug  4 17:46:14 absurd kernel: [  327.553990] intel_pstate CPU 7 exiting
Aug  4 17:46:14 absurd kernel: [  327.555741] kvm: disabling virtualization on CPU7
Aug  4 17:46:14 absurd kernel: [  327.555748] smpboot: CPU 7 is now offline
Aug  4 17:46:14 absurd kernel: [  327.557023] intel_pstate CPU 8 exiting
Aug  4 17:46:14 absurd kernel: [  327.559020] kvm: disabling virtualization on CPU8
Aug  4 17:46:14 absurd kernel: [  327.560631] smpboot: CPU 8 is now offline
Aug  4 17:46:14 absurd kernel: [  327.561805] intel_pstate CPU 9 exiting
Aug  4 17:46:14 absurd kernel: [  327.563772] kvm: disabling virtualization on CPU9
Aug  4 17:46:14 absurd kernel: [  327.563782] smpboot: CPU 9 is now offline
Aug  4 17:46:14 absurd kernel: [  327.565724] intel_pstate CPU 10 exiting
Aug  4 17:46:14 absurd kernel: [  327.567732] kvm: disabling virtualization on CPU10
Aug  4 17:46:14 absurd kernel: [  327.567741] smpboot: CPU 10 is now offline
Aug  4 17:46:14 absurd kernel: [  327.569647] intel_pstate CPU 11 exiting
Aug  4 17:46:14 absurd kernel: [  327.571612] kvm: disabling virtualization on CPU11
Aug  4 17:46:14 absurd kernel: [  327.571621] smpboot: CPU 11 is now offline
Aug  4 17:46:14 absurd kernel: [  327.573499] intel_pstate CPU 12 exiting
Aug  4 17:46:14 absurd kernel: [  327.575442] kvm: disabling virtualization on CPU12
Aug  4 17:46:14 absurd kernel: [  327.575451] smpboot: CPU 12 is now offline
Aug  4 17:46:14 absurd kernel: [  327.577300] intel_pstate CPU 13 exiting
Aug  4 17:46:14 absurd kernel: [  327.579200] kvm: disabling virtualization on CPU13
Aug  4 17:46:14 absurd kernel: [  327.579225] smpboot: CPU 13 is now offline
Aug  4 17:46:14 absurd kernel: [  327.581499] intel_pstate CPU 14 exiting
Aug  4 17:46:14 absurd kernel: [  327.583283] kvm: disabling virtualization on CPU14
Aug  4 17:46:14 absurd kernel: [  327.583318] smpboot: CPU 14 is now offline
Aug  4 17:46:14 absurd kernel: [  327.585015] intel_pstate CPU 15 exiting
Aug  4 17:46:14 absurd kernel: [  327.586812] kvm: disabling virtualization on CPU15
Aug  4 17:46:14 absurd kernel: [  327.586838] smpboot: CPU 15 is now offline
Aug  4 17:46:14 absurd kernel: [  327.588081] intel_pstate CPU 16 exiting
Aug  4 17:46:14 absurd kernel: [  327.589783] kvm: disabling virtualization on CPU16
Aug  4 17:46:14 absurd kernel: [  327.589795] smpboot: CPU 16 is now offline
Aug  4 17:46:14 absurd kernel: [  327.590434] intel_pstate CPU 17 exiting
Aug  4 17:46:14 absurd kernel: [  327.591929] kvm: disabling virtualization on CPU17
Aug  4 17:46:14 absurd kernel: [  327.591933] smpboot: CPU 17 is now offline
Aug  4 17:46:14 absurd kernel: [  327.592328] intel_pstate CPU 18 exiting
Aug  4 17:46:14 absurd kernel: [  327.593907] kvm: disabling virtualization on CPU18
Aug  4 17:46:14 absurd kernel: [  327.593919] smpboot: CPU 18 is now offline
Aug  4 17:46:14 absurd kernel: [  327.594519] intel_pstate CPU 19 exiting
Aug  4 17:46:14 absurd kernel: [  327.595996] kvm: disabling virtualization on CPU19
Aug  4 17:46:14 absurd kernel: [  327.596001] smpboot: CPU 19 is now offline
Aug  4 17:46:14 absurd kernel: [  327.596340] intel_pstate CPU 20 exiting
Aug  4 17:46:14 absurd kernel: [  327.597775] kvm: disabling virtualization on CPU20
Aug  4 17:46:14 absurd kernel: [  327.597780] smpboot: CPU 20 is now offline
Aug  4 17:46:14 absurd kernel: [  327.598102] intel_pstate CPU 21 exiting
Aug  4 17:46:14 absurd kernel: [  327.599518] kvm: disabling virtualization on CPU21
Aug  4 17:46:14 absurd kernel: [  327.599525] smpboot: CPU 21 is now offline
Aug  4 17:46:14 absurd kernel: [  327.599895] intel_pstate CPU 22 exiting
Aug  4 17:46:14 absurd kernel: [  327.601328] kvm: disabling virtualization on CPU22
Aug  4 17:46:14 absurd kernel: [  327.601344] smpboot: CPU 22 is now offline
Aug  4 17:46:14 absurd kernel: [  327.601840] intel_pstate CPU 23 exiting
Aug  4 17:46:14 absurd kernel: [  327.603250] kvm: disabling virtualization on CPU23
Aug  4 17:46:14 absurd kernel: [  327.603254] smpboot: CPU 23 is now offline
Aug  4 17:46:14 absurd kernel: [  327.603802] intel_pstate CPU 24 exiting
Aug  4 17:46:14 absurd kernel: [  327.605292] kvm: disabling virtualization on CPU24
Aug  4 17:46:14 absurd kernel: [  327.706076] smpboot: CPU 24 is now offline
Aug  4 17:46:14 absurd kernel: [  327.706797] intel_pstate CPU 25 exiting
Aug  4 17:46:14 absurd kernel: [  327.708220] kvm: disabling virtualization on CPU25
Aug  4 17:46:14 absurd kernel: [  327.708226] smpboot: CPU 25 is now offline
Aug  4 17:46:14 absurd kernel: [  327.708742] intel_pstate CPU 26 exiting
Aug  4 17:46:14 absurd kernel: [  327.710098] kvm: disabling virtualization on CPU26
Aug  4 17:46:14 absurd kernel: [  327.710119] smpboot: CPU 26 is now offline
Aug  4 17:46:14 absurd kernel: [  327.711722] intel_pstate CPU 27 exiting
Aug  4 17:46:14 absurd kernel: [  327.713359] kvm: disabling virtualization on CPU27
Aug  4 17:46:14 absurd kernel: [  327.713369] smpboot: CPU 27 is now offline
Aug  4 17:46:14 absurd kernel: [  327.714118] intel_pstate CPU 28 exiting
Aug  4 17:46:14 absurd kernel: [  327.715654] kvm: disabling virtualization on CPU28
Aug  4 17:46:14 absurd kernel: [  327.818040] smpboot: CPU 28 is now offline
Aug  4 17:46:14 absurd kernel: [  327.819026] intel_pstate CPU 29 exiting
Aug  4 17:46:14 absurd kernel: [  327.820599] kvm: disabling virtualization on CPU29
Aug  4 17:46:14 absurd kernel: [  327.820610] smpboot: CPU 29 is now offline
Aug  4 17:46:14 absurd kernel: [  327.821288] intel_pstate CPU 30 exiting
Aug  4 17:46:14 absurd kernel: [  327.822775] kvm: disabling virtualization on CPU30
Aug  4 17:46:14 absurd kernel: [  327.822809] smpboot: CPU 30 is now offline
Aug  4 17:46:14 absurd kernel: [  327.823472] intel_pstate CPU 31 exiting
Aug  4 17:46:14 absurd kernel: [  327.825250] kvm: disabling virtualization on CPU31
Aug  4 17:46:14 absurd kernel: [  327.925931] smpboot: CPU 31 is now offline
Aug  4 17:46:14 absurd kernel: [  327.926963] PM: Creating hibernation image:
Aug  4 17:46:14 absurd kernel: [  328.527700] PM: Need to copy 390339 pages
Aug  4 17:46:14 absurd kernel: [  328.527701] PM: Normal pages needed: 390339 + 1024, available pages: 16377323
Aug  4 17:46:14 absurd kernel: [  327.934246] Enabling non-boot CPUs ...
Aug  4 17:46:14 absurd kernel: [  327.934564] x86: Booting SMP configuration:
Aug  4 17:46:14 absurd kernel: [  327.934566] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:46:14 absurd kernel: [  327.947935] kvm: enabling virtualization on CPU1
Aug  4 17:46:14 absurd kernel: [  327.950526] Intel pstate controlling: cpu 1
Aug  4 17:46:14 absurd kernel: [  327.950671] CPU1 is up
Aug  4 17:46:14 absurd kernel: [  327.950932] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:46:14 absurd kernel: [  327.962638] kvm: enabling virtualization on CPU2
Aug  4 17:46:14 absurd kernel: [  327.964876] Intel pstate controlling: cpu 2
Aug  4 17:46:14 absurd kernel: [  327.964946] CPU2 is up
Aug  4 17:46:14 absurd kernel: [  327.965076] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:46:14 absurd kernel: [  327.976791] kvm: enabling virtualization on CPU3
Aug  4 17:46:14 absurd kernel: [  327.979062] Intel pstate controlling: cpu 3
Aug  4 17:46:14 absurd kernel: [  327.979131] CPU3 is up
Aug  4 17:46:14 absurd kernel: [  327.979265] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:46:14 absurd kernel: [  327.990964] kvm: enabling virtualization on CPU4
Aug  4 17:46:14 absurd kernel: [  327.993242] Intel pstate controlling: cpu 4
Aug  4 17:46:14 absurd kernel: [  327.993313] CPU4 is up
Aug  4 17:46:14 absurd kernel: [  327.993452] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:46:14 absurd kernel: [  328.005144] kvm: enabling virtualization on CPU5
Aug  4 17:46:14 absurd kernel: [  328.007422] Intel pstate controlling: cpu 5
Aug  4 17:46:14 absurd kernel: [  328.007486] CPU5 is up
Aug  4 17:46:14 absurd kernel: [  328.007621] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:46:14 absurd kernel: [  328.019311] kvm: enabling virtualization on CPU6
Aug  4 17:46:14 absurd kernel: [  328.021611] Intel pstate controlling: cpu 6
Aug  4 17:46:14 absurd kernel: [  328.021677] CPU6 is up
Aug  4 17:46:14 absurd kernel: [  328.021816] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:46:14 absurd kernel: [  328.033497] kvm: enabling virtualization on CPU7
Aug  4 17:46:14 absurd kernel: [  328.035802] Intel pstate controlling: cpu 7
Aug  4 17:46:14 absurd kernel: [  328.035868] CPU7 is up
Aug  4 17:46:14 absurd kernel: [  328.036253] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:46:14 absurd kernel: [  328.049557] kvm: enabling virtualization on CPU8
Aug  4 17:46:14 absurd kernel: [  328.069893] Intel pstate controlling: cpu 8
Aug  4 17:46:14 absurd kernel: [  328.069944] CPU8 is up
Aug  4 17:46:14 absurd kernel: [  328.070281] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:46:14 absurd kernel: [  328.083639] kvm: enabling virtualization on CPU9
Aug  4 17:46:14 absurd kernel: [  328.085912] Intel pstate controlling: cpu 9
Aug  4 17:46:14 absurd kernel: [  328.085965] CPU9 is up
Aug  4 17:46:14 absurd kernel: [  328.086232] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:46:14 absurd kernel: [  328.099598] kvm: enabling virtualization on CPU10
Aug  4 17:46:14 absurd kernel: [  328.101864] Intel pstate controlling: cpu 10
Aug  4 17:46:14 absurd kernel: [  328.101913] CPU10 is up
Aug  4 17:46:14 absurd kernel: [  328.102162] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:46:14 absurd kernel: [  328.115539] kvm: enabling virtualization on CPU11
Aug  4 17:46:14 absurd kernel: [  328.117801] Intel pstate controlling: cpu 11
Aug  4 17:46:14 absurd kernel: [  328.117850] CPU11 is up
Aug  4 17:46:14 absurd kernel: [  328.118045] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:46:14 absurd kernel: [  328.131415] kvm: enabling virtualization on CPU12
Aug  4 17:46:14 absurd kernel: [  328.133692] Intel pstate controlling: cpu 12
Aug  4 17:46:14 absurd kernel: [  328.133743] CPU12 is up
Aug  4 17:46:14 absurd kernel: [  328.133929] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:46:14 absurd kernel: [  328.147251] kvm: enabling virtualization on CPU13
Aug  4 17:46:14 absurd kernel: [  328.149581] Intel pstate controlling: cpu 13
Aug  4 17:46:14 absurd kernel: [  328.149634] CPU13 is up
Aug  4 17:46:14 absurd kernel: [  328.149812] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:46:14 absurd kernel: [  328.163126] kvm: enabling virtualization on CPU14
Aug  4 17:46:14 absurd kernel: [  328.165472] Intel pstate controlling: cpu 14
Aug  4 17:46:14 absurd kernel: [  328.165522] CPU14 is up
Aug  4 17:46:14 absurd kernel: [  328.165706] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:46:14 absurd kernel: [  328.179003] kvm: enabling virtualization on CPU15
Aug  4 17:46:14 absurd kernel: [  328.181284] Intel pstate controlling: cpu 15
Aug  4 17:46:14 absurd kernel: [  328.181333] CPU15 is up
Aug  4 17:46:14 absurd kernel: [  328.181464] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:46:14 absurd kernel: [  328.193200] kvm: enabling virtualization on CPU16
Aug  4 17:46:14 absurd kernel: [  328.195678] Intel pstate controlling: cpu 16
Aug  4 17:46:14 absurd kernel: [  328.195745] CPU16 is up
Aug  4 17:46:14 absurd kernel: [  328.195895] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:46:14 absurd kernel: [  328.207591] kvm: enabling virtualization on CPU17
Aug  4 17:46:14 absurd kernel: [  328.210069] Intel pstate controlling: cpu 17
Aug  4 17:46:14 absurd kernel: [  328.210138] CPU17 is up
Aug  4 17:46:14 absurd kernel: [  328.210290] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:46:14 absurd kernel: [  328.221987] kvm: enabling virtualization on CPU18
Aug  4 17:46:14 absurd kernel: [  328.224437] Intel pstate controlling: cpu 18
Aug  4 17:46:14 absurd kernel: [  328.224501] CPU18 is up
Aug  4 17:46:14 absurd kernel: [  328.224652] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:46:14 absurd kernel: [  328.236360] kvm: enabling virtualization on CPU19
Aug  4 17:46:14 absurd kernel: [  328.238826] Intel pstate controlling: cpu 19
Aug  4 17:46:14 absurd kernel: [  328.238893] CPU19 is up
Aug  4 17:46:14 absurd kernel: [  328.239041] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:46:14 absurd kernel: [  328.250738] kvm: enabling virtualization on CPU20
Aug  4 17:46:14 absurd kernel: [  328.253216] Intel pstate controlling: cpu 20
Aug  4 17:46:14 absurd kernel: [  328.253280] CPU20 is up
Aug  4 17:46:14 absurd kernel: [  328.253428] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:46:14 absurd kernel: [  328.265110] kvm: enabling virtualization on CPU21
Aug  4 17:46:14 absurd kernel: [  328.267684] Intel pstate controlling: cpu 21
Aug  4 17:46:14 absurd kernel: [  328.267750] CPU21 is up
Aug  4 17:46:14 absurd kernel: [  328.267898] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:46:14 absurd kernel: [  328.279580] kvm: enabling virtualization on CPU22
Aug  4 17:46:14 absurd kernel: [  328.282147] Intel pstate controlling: cpu 22
Aug  4 17:46:14 absurd kernel: [  328.282211] CPU22 is up
Aug  4 17:46:14 absurd kernel: [  328.282360] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:46:14 absurd kernel: [  328.294033] kvm: enabling virtualization on CPU23
Aug  4 17:46:14 absurd kernel: [  328.296621] Intel pstate controlling: cpu 23
Aug  4 17:46:14 absurd kernel: [  328.296687] CPU23 is up
Aug  4 17:46:14 absurd kernel: [  328.297009] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:46:14 absurd kernel: [  328.310314] kvm: enabling virtualization on CPU24
Aug  4 17:46:14 absurd kernel: [  328.312715] Intel pstate controlling: cpu 24
Aug  4 17:46:14 absurd kernel: [  328.312761] CPU24 is up
Aug  4 17:46:14 absurd kernel: [  328.312957] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:46:14 absurd kernel: [  328.326291] kvm: enabling virtualization on CPU25
Aug  4 17:46:14 absurd kernel: [  328.328742] Intel pstate controlling: cpu 25
Aug  4 17:46:14 absurd kernel: [  328.328790] CPU25 is up
Aug  4 17:46:14 absurd kernel: [  328.328985] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:46:14 absurd kernel: [  328.342334] kvm: enabling virtualization on CPU26
Aug  4 17:46:14 absurd kernel: [  328.344777] Intel pstate controlling: cpu 26
Aug  4 17:46:14 absurd kernel: [  328.344823] CPU26 is up
Aug  4 17:46:14 absurd kernel: [  328.345013] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:46:14 absurd kernel: [  328.358382] kvm: enabling virtualization on CPU27
Aug  4 17:46:14 absurd kernel: [  328.360811] Intel pstate controlling: cpu 27
Aug  4 17:46:14 absurd kernel: [  328.360856] CPU27 is up
Aug  4 17:46:14 absurd kernel: [  328.361035] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:46:14 absurd kernel: [  328.374391] kvm: enabling virtualization on CPU28
Aug  4 17:46:14 absurd kernel: [  328.376844] Intel pstate controlling: cpu 28
Aug  4 17:46:14 absurd kernel: [  328.376891] CPU28 is up
Aug  4 17:46:14 absurd kernel: [  328.377070] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:46:14 absurd kernel: [  328.390372] kvm: enabling virtualization on CPU29
Aug  4 17:46:14 absurd kernel: [  328.392796] Intel pstate controlling: cpu 29
Aug  4 17:46:14 absurd kernel: [  328.392842] CPU29 is up
Aug  4 17:46:14 absurd kernel: [  328.393015] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:46:14 absurd kernel: [  328.406311] kvm: enabling virtualization on CPU30
Aug  4 17:46:14 absurd kernel: [  328.408736] Intel pstate controlling: cpu 30
Aug  4 17:46:14 absurd kernel: [  328.408783] CPU30 is up
Aug  4 17:46:14 absurd kernel: [  328.408961] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:46:14 absurd kernel: [  328.422238] kvm: enabling virtualization on CPU31
Aug  4 17:46:14 absurd kernel: [  328.424713] Intel pstate controlling: cpu 31
Aug  4 17:46:14 absurd kernel: [  328.424760] CPU31 is up
Aug  4 17:46:14 absurd kernel: [  328.532930] PM: noirq restore of devices complete after 17.745 msecs
Aug  4 17:46:14 absurd kernel: [  328.533440] PM: early restore of devices complete after 0.447 msecs
Aug  4 17:46:14 absurd kernel: [  328.692356] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:46:14 absurd kernel: [  328.692428] usb usb2: root hub lost power or was reset
Aug  4 17:46:14 absurd kernel: [  328.692429] usb usb1: root hub lost power or was reset
Aug  4 17:46:14 absurd kernel: [  328.692636] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692637] igb 0000:02:00.0: irq 100 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692646] igb 0000:02:00.1: irq 101 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692649] igb 0000:02:00.0: irq 102 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692654] igb 0000:02:00.1: irq 103 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692657] igb 0000:02:00.0: irq 104 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692662] igb 0000:02:00.1: irq 105 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692665] igb 0000:02:00.0: irq 106 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692670] igb 0000:02:00.1: irq 107 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692675] igb 0000:02:00.0: irq 111 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692677] igb 0000:02:00.1: irq 112 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692685] igb 0000:02:00.0: irq 113 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692687] igb 0000:02:00.1: irq 114 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692692] igb 0000:02:00.0: irq 115 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692694] igb 0000:02:00.1: irq 116 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692700] igb 0000:02:00.0: irq 117 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692702] igb 0000:02:00.1: irq 118 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.692706] igb 0000:02:00.0: irq 119 for MSI/MSI-X
Aug  4 17:46:14 absurd kernel: [  328.693022] serial 00:03: activated
Aug  4 17:46:14 absurd kernel: [  328.693398] serial 00:04: activated
Aug  4 17:46:14 absurd kernel: [  328.695620] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:46:14 absurd kernel: [  328.695653] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:46:14 absurd kernel: [  328.695688] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:46:14 absurd kernel: [  328.695711] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:46:14 absurd kernel: [  328.696322] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:46:14 absurd kernel: [  328.696322] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:46:14 absurd kernel: [  328.696364] ------------[ cut here ]------------
Aug  4 17:46:14 absurd kernel: [  328.696370] WARNING: CPU: 10 PID: 6735 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:46:14 absurd kernel: [  328.696403] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj raid1 usb_storage snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel nvidia(PO) kvm joydev hid_generic snd_hda_codec_ca0132 crct10dif_pclmul iTCO_wdt crc32_pclmul iTCO_vendor_support usbhid ghash_clmulni_intel hid mxm_wmi evdev aesni_intel snd_hda_intel aes_x86_64 ablk_helper cryptd glue_helper lrw snd_hda_controller gf128mul snd_hda_codec pcspkr snd_hwdep sb_edac snd_pcm edac_core snd_seq i2c_i801 snd_seq_device snd_timer snd lpc_ich mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler tpm_tis tpm processor wmi thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci libata ehci_pci scsi_transport_sas ehci_hcd scsi_mod
Aug  4 17:46:14 absurd kernel: igb usbcore i2c_algo_bit usb_common i2c_core dca ptp pps_core
Aug  4 17:46:14 absurd kernel: [  328.696418] CPU: 10 PID: 6735 Comm: kworker/u66:8 Tainted: P        W  O  3.16.0-vanilla.1 #1
Aug  4 17:46:14 absurd kernel: [  328.696418] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:46:14 absurd kernel: [  328.696423] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:46:14 absurd kernel: [  328.696425]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:46:14 absurd kernel: [  328.696426]  ffffffff810664f6 ffffffffa03ff09b ffff8810550a5240 ffff88105666dd00
Aug  4 17:46:14 absurd kernel: [  328.696427]  ffff88104b0cfc90 ffff88105796b000 ffffffff813a7d3b ffff881055182200
Aug  4 17:46:14 absurd kernel: [  328.696427] Call Trace:
Aug  4 17:46:14 absurd kernel: [  328.696433]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:46:14 absurd kernel: [  328.696437]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:46:14 absurd kernel: [  328.696439]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:46:14 absurd kernel: [  328.696440]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:46:14 absurd kernel: [  328.696444]  [<ffffffffa03fe03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:46:14 absurd kernel: [  328.696449]  [<ffffffffa02cfe21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:46:14 absurd kernel: [  328.696451]  [<ffffffffa02cff17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:46:14 absurd kernel: [  328.696455]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:46:14 absurd kernel: [  328.696457]  [<ffffffffa02cf951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:46:14 absurd kernel: [  328.696460]  [<ffffffffa02d1776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:46:14 absurd kernel: [  328.696463]  [<ffffffffa03ab070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:46:14 absurd kernel: [  328.696465]  [<ffffffffa0334c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:46:14 absurd kernel: [  328.696469]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:46:14 absurd kernel: [  328.696472]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:46:14 absurd kernel: [  328.696474]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:46:14 absurd kernel: [  328.696476]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:46:14 absurd kernel: [  328.696476]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:46:14 absurd kernel: [  328.696479]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:46:14 absurd kernel: [  328.696481]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:46:14 absurd kernel: [  328.696483]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:46:14 absurd kernel: [  328.696484]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:46:14 absurd kernel: [  328.696486]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:46:14 absurd kernel: [  328.696487]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:46:14 absurd kernel: [  328.696488]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:46:14 absurd kernel: [  328.696489]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:46:14 absurd kernel: [  328.696490] ---[ end trace db395c2b3c067206 ]---
Aug  4 17:46:14 absurd kernel: [  328.696492] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:46:14 absurd kernel: [  329.020664] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:46:14 absurd kernel: [  329.024724] usb 1-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:46:14 absurd kernel: [  329.024727] usb 2-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:46:14 absurd kernel: [  329.028666] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:46:14 absurd kernel: [  329.042630] ata2.00: configured for UDMA/133
Aug  4 17:46:14 absurd kernel: [  329.044607] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:46:14 absurd kernel: [  329.044631] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:46:14 absurd kernel: [  329.044654] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:46:14 absurd kernel: [  329.045237] ata1.00: configured for UDMA/133
Aug  4 17:46:14 absurd kernel: [  329.045887] ata4.00: configured for UDMA/100
Aug  4 17:46:14 absurd kernel: [  329.047836] ata5.00: configured for UDMA/133
Aug  4 17:46:14 absurd kernel: [  329.164530] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:46:14 absurd kernel: [  329.175565] ata6.00: configured for UDMA/133
Aug  4 17:46:14 absurd kernel: [  329.436688] usb 2-1.1: reset high-speed USB device number 3 using ehci-pci
Aug  4 17:46:14 absurd kernel: [  329.436705] usb 1-1.6: reset full-speed USB device number 3 using ehci-pci
Aug  4 17:46:14 absurd kernel: [  329.600613] usb 2-1.3: reset high-speed USB device number 5 using ehci-pci
Aug  4 17:46:14 absurd kernel: [  329.952378] usb 2-1.2: reset low-speed USB device number 4 using ehci-pci
Aug  4 17:46:14 absurd kernel: [  330.304186] usb 2-1.3.1: reset high-speed USB device number 6 using ehci-pci
Aug  4 17:46:14 absurd kernel: [  330.483936] usb 2-1.3.3: reset full-speed USB device number 7 using ehci-pci
Aug  4 17:46:14 absurd kernel: [  330.656001] PM: restore of devices complete after 1964.879 msecs
Aug  4 17:46:14 absurd kernel: [  330.882856] Restarting kernel threads ... done.
Aug  4 17:46:14 absurd kernel: [  330.883769] PM: Basic memory bitmaps freed
Aug  4 17:46:14 absurd kernel: [  330.883831] Restarting tasks ... done.
Aug  4 17:46:14 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:46:14 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:46:14 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:46:14 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:46:14 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 17:46:14 absurd upsmon[4479]: UPS duo2pro@localhost is unavailable
Aug  4 17:46:14 absurd acpid: client connected from 4432[0:0]
Aug  4 17:46:14 absurd acpid: 1 client rule loaded
Aug  4 17:46:14 absurd NetworkManager[4243]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:46:15 absurd acpid: client connected from 4432[0:0]
Aug  4 17:46:15 absurd acpid: 1 client rule loaded
Aug  4 17:46:15 absurd acpid: client connected from 4432[0:0]
Aug  4 17:46:15 absurd acpid: 1 client rule loaded
Aug  4 17:46:15 absurd acpid: client connected from 4432[0:0]
Aug  4 17:46:15 absurd acpid: 1 client rule loaded
Aug  4 17:46:16 absurd NetworkManager[4243]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:46:16 absurd kernel: [  332.015229] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 17:46:17 absurd upsd[4451]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 17:46:17 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:46:20 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:46:20 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="6890" x-info="http://www.rsyslog.com"] start
Aug  4 17:46:20 absurd salomea: ========== resume complete ===========
Aug  4 17:46:20 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:46:23 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:46:26 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:46:29 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_2_success8.txt

Aug  4 17:46:38 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:46:41 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:46:44 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:46:47 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:46:50 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:46:51 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:46:52 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:46:53 absurd kernel: [  369.126808] Syncing filesystems ... done.
Aug  4 17:48:13 absurd kernel: [  369.129316] Freezing user space processes ... (elapsed 0.002 seconds) done.
Aug  4 17:48:13 absurd kernel: [  369.133559] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:48:13 absurd kernel: [  369.133630] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:48:13 absurd kernel: [  369.136126] PM: Basic memory bitmaps created
Aug  4 17:48:13 absurd kernel: [  369.136320] PM: Preallocating image memory... done (allocated 16304434 pages)
Aug  4 17:48:13 absurd kernel: [  375.313896] PM: Allocated 65217736 kbytes in 6.18 seconds (3603.24 MB/s)
Aug  4 17:48:13 absurd kernel: [  375.313960] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:48:13 absurd kernel: [  375.316451] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:48:13 absurd kernel: [  375.317169] serial 00:04: disabled
Aug  4 17:48:13 absurd kernel: [  375.317247] serial 00:03: disabled
Aug  4 17:48:13 absurd kernel: [  375.381002] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:48:13 absurd kernel: [  375.393679] PM: freeze of devices complete after 77.196 msecs
Aug  4 17:48:13 absurd kernel: [  375.394359] PM: late freeze of devices complete after 0.678 msecs
Aug  4 17:48:13 absurd kernel: [  375.396335] PM: noirq freeze of devices complete after 1.976 msecs
Aug  4 17:48:13 absurd kernel: [  375.396336] Disabling non-boot CPUs ...
Aug  4 17:48:13 absurd kernel: [  375.396482] intel_pstate CPU 1 exiting
Aug  4 17:48:13 absurd kernel: [  375.398317] kvm: disabling virtualization on CPU1
Aug  4 17:48:13 absurd kernel: [  375.399040] smpboot: CPU 1 is now offline
Aug  4 17:48:13 absurd kernel: [  375.399536] intel_pstate CPU 2 exiting
Aug  4 17:48:13 absurd kernel: [  375.401291] kvm: disabling virtualization on CPU2
Aug  4 17:48:13 absurd kernel: [  375.501579] smpboot: CPU 2 is now offline
Aug  4 17:48:13 absurd kernel: [  375.502030] intel_pstate CPU 3 exiting
Aug  4 17:48:13 absurd kernel: [  375.503752] kvm: disabling virtualization on CPU3
Aug  4 17:48:13 absurd kernel: [  375.503769] smpboot: CPU 3 is now offline
Aug  4 17:48:13 absurd kernel: [  375.504444] intel_pstate CPU 4 exiting
Aug  4 17:48:13 absurd kernel: [  375.506181] kvm: disabling virtualization on CPU4
Aug  4 17:48:13 absurd kernel: [  375.506199] smpboot: CPU 4 is now offline
Aug  4 17:48:13 absurd kernel: [  375.506981] intel_pstate CPU 5 exiting
Aug  4 17:48:13 absurd kernel: [  375.508978] kvm: disabling virtualization on CPU5
Aug  4 17:48:13 absurd kernel: [  375.508986] smpboot: CPU 5 is now offline
Aug  4 17:48:13 absurd kernel: [  375.510028] intel_pstate CPU 6 exiting
Aug  4 17:48:13 absurd kernel: [  375.512023] kvm: disabling virtualization on CPU6
Aug  4 17:48:13 absurd kernel: [  375.512029] smpboot: CPU 6 is now offline
Aug  4 17:48:13 absurd kernel: [  375.513122] intel_pstate CPU 7 exiting
Aug  4 17:48:13 absurd kernel: [  375.515000] kvm: disabling virtualization on CPU7
Aug  4 17:48:13 absurd kernel: [  375.617519] smpboot: CPU 7 is now offline
Aug  4 17:48:13 absurd kernel: [  375.618993] intel_pstate CPU 8 exiting
Aug  4 17:48:13 absurd kernel: [  375.621084] kvm: disabling virtualization on CPU8
Aug  4 17:48:13 absurd kernel: [  375.721455] smpboot: CPU 8 is now offline
Aug  4 17:48:13 absurd kernel: [  375.722819] intel_pstate CPU 9 exiting
Aug  4 17:48:13 absurd kernel: [  375.724814] kvm: disabling virtualization on CPU9
Aug  4 17:48:13 absurd kernel: [  375.724823] smpboot: CPU 9 is now offline
Aug  4 17:48:13 absurd kernel: [  375.725919] intel_pstate CPU 10 exiting
Aug  4 17:48:13 absurd kernel: [  375.727658] kvm: disabling virtualization on CPU10
Aug  4 17:48:13 absurd kernel: [  375.829399] smpboot: CPU 10 is now offline
Aug  4 17:48:13 absurd kernel: [  375.830236] intel_pstate CPU 11 exiting
Aug  4 17:48:13 absurd kernel: [  375.831818] kvm: disabling virtualization on CPU11
Aug  4 17:48:13 absurd kernel: [  375.933344] smpboot: CPU 11 is now offline
Aug  4 17:48:13 absurd kernel: [  375.934174] intel_pstate CPU 12 exiting
Aug  4 17:48:13 absurd kernel: [  375.935748] kvm: disabling virtualization on CPU12
Aug  4 17:48:13 absurd kernel: [  375.935753] smpboot: CPU 12 is now offline
Aug  4 17:48:13 absurd kernel: [  375.936912] intel_pstate CPU 13 exiting
Aug  4 17:48:13 absurd kernel: [  375.938548] kvm: disabling virtualization on CPU13
Aug  4 17:48:13 absurd kernel: [  376.041268] smpboot: CPU 13 is now offline
Aug  4 17:48:13 absurd kernel: [  376.042098] intel_pstate CPU 14 exiting
Aug  4 17:48:13 absurd kernel: [  376.043665] kvm: disabling virtualization on CPU14
Aug  4 17:48:13 absurd kernel: [  376.145240] smpboot: CPU 14 is now offline
Aug  4 17:48:13 absurd kernel: [  376.146064] intel_pstate CPU 15 exiting
Aug  4 17:48:13 absurd kernel: [  376.147606] kvm: disabling virtualization on CPU15
Aug  4 17:48:13 absurd kernel: [  376.147625] smpboot: CPU 15 is now offline
Aug  4 17:48:13 absurd kernel: [  376.148307] intel_pstate CPU 16 exiting
Aug  4 17:48:13 absurd kernel: [  376.149944] kvm: disabling virtualization on CPU16
Aug  4 17:48:13 absurd kernel: [  376.151589] smpboot: CPU 16 is now offline
Aug  4 17:48:13 absurd kernel: [  376.152371] intel_pstate CPU 17 exiting
Aug  4 17:48:13 absurd kernel: [  376.154442] kvm: disabling virtualization on CPU17
Aug  4 17:48:13 absurd kernel: [  376.257152] smpboot: CPU 17 is now offline
Aug  4 17:48:13 absurd kernel: [  376.257780] intel_pstate CPU 18 exiting
Aug  4 17:48:13 absurd kernel: [  376.259554] kvm: disabling virtualization on CPU18
Aug  4 17:48:13 absurd kernel: [  376.361128] smpboot: CPU 18 is now offline
Aug  4 17:48:13 absurd kernel: [  376.361972] intel_pstate CPU 19 exiting
Aug  4 17:48:13 absurd kernel: [  376.363858] kvm: disabling virtualization on CPU19
Aug  4 17:48:13 absurd kernel: [  376.363878] smpboot: CPU 19 is now offline
Aug  4 17:48:13 absurd kernel: [  376.364304] intel_pstate CPU 20 exiting
Aug  4 17:48:13 absurd kernel: [  376.366121] kvm: disabling virtualization on CPU20
Aug  4 17:48:13 absurd kernel: [  376.366159] smpboot: CPU 20 is now offline
Aug  4 17:48:13 absurd kernel: [  376.366820] intel_pstate CPU 21 exiting
Aug  4 17:48:13 absurd kernel: [  376.368644] kvm: disabling virtualization on CPU21
Aug  4 17:48:13 absurd kernel: [  376.469031] smpboot: CPU 21 is now offline
Aug  4 17:48:13 absurd kernel: [  376.469790] intel_pstate CPU 22 exiting
Aug  4 17:48:13 absurd kernel: [  376.471608] kvm: disabling virtualization on CPU22
Aug  4 17:48:13 absurd kernel: [  376.572967] smpboot: CPU 22 is now offline
Aug  4 17:48:13 absurd kernel: [  376.573715] intel_pstate CPU 23 exiting
Aug  4 17:48:13 absurd kernel: [  376.575454] kvm: disabling virtualization on CPU23
Aug  4 17:48:13 absurd kernel: [  376.676906] smpboot: CPU 23 is now offline
Aug  4 17:48:13 absurd kernel: [  376.677972] intel_pstate CPU 24 exiting
Aug  4 17:48:13 absurd kernel: [  376.679618] kvm: disabling virtualization on CPU24
Aug  4 17:48:13 absurd kernel: [  376.780871] smpboot: CPU 24 is now offline
Aug  4 17:48:13 absurd kernel: [  376.781740] intel_pstate CPU 25 exiting
Aug  4 17:48:13 absurd kernel: [  376.783278] kvm: disabling virtualization on CPU25
Aug  4 17:48:13 absurd kernel: [  376.884777] smpboot: CPU 25 is now offline
Aug  4 17:48:13 absurd kernel: [  376.885348] intel_pstate CPU 26 exiting
Aug  4 17:48:13 absurd kernel: [  376.886755] kvm: disabling virtualization on CPU26
Aug  4 17:48:13 absurd kernel: [  376.988743] smpboot: CPU 26 is now offline
Aug  4 17:48:13 absurd kernel: [  376.989261] intel_pstate CPU 27 exiting
Aug  4 17:48:13 absurd kernel: [  376.990590] kvm: disabling virtualization on CPU27
Aug  4 17:48:13 absurd kernel: [  377.092660] smpboot: CPU 27 is now offline
Aug  4 17:48:13 absurd kernel: [  377.093094] intel_pstate CPU 28 exiting
Aug  4 17:48:13 absurd kernel: [  377.094389] kvm: disabling virtualization on CPU28
Aug  4 17:48:13 absurd kernel: [  377.196616] smpboot: CPU 28 is now offline
Aug  4 17:48:13 absurd kernel: [  377.197113] intel_pstate CPU 29 exiting
Aug  4 17:48:13 absurd kernel: [  377.198409] kvm: disabling virtualization on CPU29
Aug  4 17:48:13 absurd kernel: [  377.300554] smpboot: CPU 29 is now offline
Aug  4 17:48:13 absurd kernel: [  377.301031] intel_pstate CPU 30 exiting
Aug  4 17:48:13 absurd kernel: [  377.302310] kvm: disabling virtualization on CPU30
Aug  4 17:48:13 absurd kernel: [  377.404550] smpboot: CPU 30 is now offline
Aug  4 17:48:13 absurd kernel: [  377.404968] intel_pstate CPU 31 exiting
Aug  4 17:48:13 absurd kernel: [  377.406759] kvm: disabling virtualization on CPU31
Aug  4 17:48:13 absurd kernel: [  377.407465] smpboot: CPU 31 is now offline
Aug  4 17:48:13 absurd kernel: [  377.408396] PM: Creating hibernation image:
Aug  4 17:48:13 absurd kernel: [  378.091947] PM: Need to copy 394314 pages
Aug  4 17:48:13 absurd kernel: [  378.091949] PM: Normal pages needed: 394314 + 1024, available pages: 16373346
Aug  4 17:48:13 absurd kernel: [  377.415660] Enabling non-boot CPUs ...
Aug  4 17:48:13 absurd kernel: [  377.416022] x86: Booting SMP configuration:
Aug  4 17:48:13 absurd kernel: [  377.416024] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:48:13 absurd kernel: [  377.429394] kvm: enabling virtualization on CPU1
Aug  4 17:48:13 absurd kernel: [  377.432576] Intel pstate controlling: cpu 1
Aug  4 17:48:13 absurd kernel: [  377.432719] CPU1 is up
Aug  4 17:48:13 absurd kernel: [  377.432986] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:48:13 absurd kernel: [  377.446205] kvm: enabling virtualization on CPU2
Aug  4 17:48:13 absurd kernel: [  377.448671] Intel pstate controlling: cpu 2
Aug  4 17:48:13 absurd kernel: [  377.448802] CPU2 is up
Aug  4 17:48:13 absurd kernel: [  377.449039] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:48:13 absurd kernel: [  377.462117] kvm: enabling virtualization on CPU3
Aug  4 17:48:13 absurd kernel: [  377.464517] Intel pstate controlling: cpu 3
Aug  4 17:48:13 absurd kernel: [  377.464640] CPU3 is up
Aug  4 17:48:13 absurd kernel: [  377.464867] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:48:13 absurd kernel: [  377.477478] kvm: enabling virtualization on CPU4
Aug  4 17:48:13 absurd kernel: [  377.479886] Intel pstate controlling: cpu 4
Aug  4 17:48:13 absurd kernel: [  377.479998] CPU4 is up
Aug  4 17:48:13 absurd kernel: [  377.480221] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:48:13 absurd kernel: [  377.492655] kvm: enabling virtualization on CPU5
Aug  4 17:48:13 absurd kernel: [  377.495020] Intel pstate controlling: cpu 5
Aug  4 17:48:13 absurd kernel: [  377.495125] CPU5 is up
Aug  4 17:48:13 absurd kernel: [  377.495335] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:48:13 absurd kernel: [  377.507644] kvm: enabling virtualization on CPU6
Aug  4 17:48:13 absurd kernel: [  377.510021] Intel pstate controlling: cpu 6
Aug  4 17:48:13 absurd kernel: [  377.510118] CPU6 is up
Aug  4 17:48:13 absurd kernel: [  377.510318] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:48:13 absurd kernel: [  377.522399] kvm: enabling virtualization on CPU7
Aug  4 17:48:13 absurd kernel: [  377.524808] Intel pstate controlling: cpu 7
Aug  4 17:48:13 absurd kernel: [  377.524901] CPU7 is up
Aug  4 17:48:13 absurd kernel: [  377.525375] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:48:13 absurd kernel: [  377.538689] kvm: enabling virtualization on CPU8
Aug  4 17:48:13 absurd kernel: [  377.559229] Intel pstate controlling: cpu 8
Aug  4 17:48:13 absurd kernel: [  377.559304] CPU8 is up
Aug  4 17:48:13 absurd kernel: [  377.559737] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:48:13 absurd kernel: [  377.573096] kvm: enabling virtualization on CPU9
Aug  4 17:48:13 absurd kernel: [  377.575383] Intel pstate controlling: cpu 9
Aug  4 17:48:13 absurd kernel: [  377.575441] CPU9 is up
Aug  4 17:48:13 absurd kernel: [  377.575744] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:48:13 absurd kernel: [  377.589110] kvm: enabling virtualization on CPU10
Aug  4 17:48:13 absurd kernel: [  377.591387] Intel pstate controlling: cpu 10
Aug  4 17:48:13 absurd kernel: [  377.591444] CPU10 is up
Aug  4 17:48:13 absurd kernel: [  377.591744] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:48:13 absurd kernel: [  377.605125] kvm: enabling virtualization on CPU11
Aug  4 17:48:13 absurd kernel: [  377.607384] Intel pstate controlling: cpu 11
Aug  4 17:48:13 absurd kernel: [  377.607440] CPU11 is up
Aug  4 17:48:13 absurd kernel: [  377.607679] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:48:13 absurd kernel: [  377.621056] kvm: enabling virtualization on CPU12
Aug  4 17:48:13 absurd kernel: [  377.623319] Intel pstate controlling: cpu 12
Aug  4 17:48:13 absurd kernel: [  377.623371] CPU12 is up
Aug  4 17:48:13 absurd kernel: [  377.623552] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:48:13 absurd kernel: [  377.636874] kvm: enabling virtualization on CPU13
Aug  4 17:48:13 absurd kernel: [  377.639210] Intel pstate controlling: cpu 13
Aug  4 17:48:13 absurd kernel: [  377.639263] CPU13 is up
Aug  4 17:48:13 absurd kernel: [  377.639450] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:48:13 absurd kernel: [  377.652766] kvm: enabling virtualization on CPU14
Aug  4 17:48:13 absurd kernel: [  377.655113] Intel pstate controlling: cpu 14
Aug  4 17:48:13 absurd kernel: [  377.655163] CPU14 is up
Aug  4 17:48:13 absurd kernel: [  377.655340] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:48:13 absurd kernel: [  377.668637] kvm: enabling virtualization on CPU15
Aug  4 17:48:13 absurd kernel: [  377.670914] Intel pstate controlling: cpu 15
Aug  4 17:48:13 absurd kernel: [  377.670967] CPU15 is up
Aug  4 17:48:13 absurd kernel: [  377.671092] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:48:13 absurd kernel: [  377.682829] kvm: enabling virtualization on CPU16
Aug  4 17:48:13 absurd kernel: [  377.685325] Intel pstate controlling: cpu 16
Aug  4 17:48:13 absurd kernel: [  377.685393] CPU16 is up
Aug  4 17:48:13 absurd kernel: [  377.685542] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:48:13 absurd kernel: [  377.697238] kvm: enabling virtualization on CPU17
Aug  4 17:48:13 absurd kernel: [  377.699744] Intel pstate controlling: cpu 17
Aug  4 17:48:13 absurd kernel: [  377.699810] CPU17 is up
Aug  4 17:48:13 absurd kernel: [  377.699959] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:48:13 absurd kernel: [  377.711657] kvm: enabling virtualization on CPU18
Aug  4 17:48:13 absurd kernel: [  377.714182] Intel pstate controlling: cpu 18
Aug  4 17:48:13 absurd kernel: [  377.714245] CPU18 is up
Aug  4 17:48:13 absurd kernel: [  377.714393] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:48:13 absurd kernel: [  377.726100] kvm: enabling virtualization on CPU19
Aug  4 17:48:13 absurd kernel: [  377.728591] Intel pstate controlling: cpu 19
Aug  4 17:48:13 absurd kernel: [  377.728659] CPU19 is up
Aug  4 17:48:13 absurd kernel: [  377.728811] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:48:13 absurd kernel: [  377.740516] kvm: enabling virtualization on CPU20
Aug  4 17:48:13 absurd kernel: [  377.743021] Intel pstate controlling: cpu 20
Aug  4 17:48:13 absurd kernel: [  377.743088] CPU20 is up
Aug  4 17:48:13 absurd kernel: [  377.743238] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:48:13 absurd kernel: [  377.754922] kvm: enabling virtualization on CPU21
Aug  4 17:48:13 absurd kernel: [  377.757434] Intel pstate controlling: cpu 21
Aug  4 17:48:13 absurd kernel: [  377.757499] CPU21 is up
Aug  4 17:48:13 absurd kernel: [  377.757650] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:48:13 absurd kernel: [  377.769331] kvm: enabling virtualization on CPU22
Aug  4 17:48:13 absurd kernel: [  377.771842] Intel pstate controlling: cpu 22
Aug  4 17:48:13 absurd kernel: [  377.771908] CPU22 is up
Aug  4 17:48:13 absurd kernel: [  377.772052] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:48:13 absurd kernel: [  377.783723] kvm: enabling virtualization on CPU23
Aug  4 17:48:13 absurd kernel: [  377.786237] Intel pstate controlling: cpu 23
Aug  4 17:48:13 absurd kernel: [  377.786302] CPU23 is up
Aug  4 17:48:13 absurd kernel: [  377.786610] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:48:13 absurd kernel: [  377.799915] kvm: enabling virtualization on CPU24
Aug  4 17:48:13 absurd kernel: [  377.802320] Intel pstate controlling: cpu 24
Aug  4 17:48:13 absurd kernel: [  377.802366] CPU24 is up
Aug  4 17:48:13 absurd kernel: [  377.802548] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:48:13 absurd kernel: [  377.815881] kvm: enabling virtualization on CPU25
Aug  4 17:48:13 absurd kernel: [  377.818333] Intel pstate controlling: cpu 25
Aug  4 17:48:13 absurd kernel: [  377.818381] CPU25 is up
Aug  4 17:48:13 absurd kernel: [  377.818562] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:48:13 absurd kernel: [  377.831933] kvm: enabling virtualization on CPU26
Aug  4 17:48:13 absurd kernel: [  377.834347] Intel pstate controlling: cpu 26
Aug  4 17:48:13 absurd kernel: [  377.834395] CPU26 is up
Aug  4 17:48:13 absurd kernel: [  377.834578] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:48:13 absurd kernel: [  377.847939] kvm: enabling virtualization on CPU27
Aug  4 17:48:13 absurd kernel: [  377.850372] Intel pstate controlling: cpu 27
Aug  4 17:48:13 absurd kernel: [  377.850420] CPU27 is up
Aug  4 17:48:13 absurd kernel: [  377.850606] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:48:13 absurd kernel: [  377.863963] kvm: enabling virtualization on CPU28
Aug  4 17:48:13 absurd kernel: [  377.866414] Intel pstate controlling: cpu 28
Aug  4 17:48:13 absurd kernel: [  377.866462] CPU28 is up
Aug  4 17:48:13 absurd kernel: [  377.866645] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:48:13 absurd kernel: [  377.879946] kvm: enabling virtualization on CPU29
Aug  4 17:48:13 absurd kernel: [  377.882373] Intel pstate controlling: cpu 29
Aug  4 17:48:13 absurd kernel: [  377.882421] CPU29 is up
Aug  4 17:48:13 absurd kernel: [  377.882593] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:48:13 absurd kernel: [  377.895892] kvm: enabling virtualization on CPU30
Aug  4 17:48:13 absurd kernel: [  377.898316] Intel pstate controlling: cpu 30
Aug  4 17:48:13 absurd kernel: [  377.898369] CPU30 is up
Aug  4 17:48:13 absurd kernel: [  377.898550] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:48:13 absurd kernel: [  377.911829] kvm: enabling virtualization on CPU31
Aug  4 17:48:13 absurd kernel: [  377.914305] Intel pstate controlling: cpu 31
Aug  4 17:48:13 absurd kernel: [  377.914353] CPU31 is up
Aug  4 17:48:13 absurd kernel: [  378.019712] PM: noirq restore of devices complete after 16.105 msecs
Aug  4 17:48:13 absurd kernel: [  378.020199] PM: early restore of devices complete after 0.424 msecs
Aug  4 17:48:13 absurd kernel: [  378.179547] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:48:13 absurd kernel: [  378.179621] usb usb1: root hub lost power or was reset
Aug  4 17:48:13 absurd kernel: [  378.179622] usb usb2: root hub lost power or was reset
Aug  4 17:48:13 absurd kernel: [  378.179836] igb 0000:02:00.0: irq 100 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179838] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179847] igb 0000:02:00.0: irq 101 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179850] igb 0000:02:00.1: irq 102 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179856] igb 0000:02:00.0: irq 103 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179859] igb 0000:02:00.1: irq 104 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179863] igb 0000:02:00.0: irq 105 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179868] igb 0000:02:00.1: irq 106 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179876] igb 0000:02:00.1: irq 111 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179881] igb 0000:02:00.0: irq 107 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179884] igb 0000:02:00.1: irq 112 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179892] igb 0000:02:00.0: irq 113 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179895] igb 0000:02:00.1: irq 114 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179900] igb 0000:02:00.0: irq 115 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179905] igb 0000:02:00.1: irq 116 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179908] igb 0000:02:00.0: irq 117 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179914] igb 0000:02:00.1: irq 118 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.179916] igb 0000:02:00.0: irq 119 for MSI/MSI-X
Aug  4 17:48:13 absurd kernel: [  378.180245] serial 00:03: activated
Aug  4 17:48:13 absurd kernel: [  378.180621] serial 00:04: activated
Aug  4 17:48:13 absurd kernel: [  378.181111] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:48:13 absurd kernel: [  378.181150] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:48:13 absurd kernel: [  378.181190] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:48:13 absurd kernel: [  378.181215] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:48:13 absurd kernel: [  378.183506] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:48:13 absurd kernel: [  378.183508] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:48:13 absurd kernel: [  378.183546] ------------[ cut here ]------------
Aug  4 17:48:13 absurd kernel: [  378.183553] WARNING: CPU: 13 PID: 6940 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:48:13 absurd kernel: [  378.183586] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj raid1 usb_storage snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel nvidia(PO) kvm joydev hid_generic snd_hda_codec_ca0132 crct10dif_pclmul iTCO_wdt crc32_pclmul iTCO_vendor_support usbhid ghash_clmulni_intel hid mxm_wmi evdev aesni_intel snd_hda_intel aes_x86_64 ablk_helper cryptd glue_helper lrw snd_hda_controller gf128mul snd_hda_codec pcspkr snd_hwdep sb_edac snd_pcm edac_core snd_seq i2c_i801 snd_seq_device snd_timer snd lpc_ich mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler tpm_tis tpm processor wmi thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci libata ehci_pci scsi_transport_sas ehci_hcd scsi_mod
Aug  4 17:48:13 absurd kernel: igb usbcore i2c_algo_bit usb_common i2c_core dca ptp pps_core
Aug  4 17:48:13 absurd kernel: [  378.183600] CPU: 13 PID: 6940 Comm: kworker/u66:8 Tainted: P        W  O  3.16.0-vanilla.1 #1
Aug  4 17:48:13 absurd kernel: [  378.183600] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:48:13 absurd kernel: [  378.183605] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:48:13 absurd kernel: [  378.183607]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:48:13 absurd kernel: [  378.183608]  ffffffff810664f6 ffffffffa03ff09b ffff881057bbe8e0 ffff881055e80f40
Aug  4 17:48:13 absurd kernel: [  378.183609]  ffff881055c2bc90 ffff88105796b000 ffffffff813a7d3b ffff881055182200
Aug  4 17:48:13 absurd kernel: [  378.183609] Call Trace:
Aug  4 17:48:13 absurd kernel: [  378.183616]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:48:13 absurd kernel: [  378.183620]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:48:13 absurd kernel: [  378.183622]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:48:13 absurd kernel: [  378.183623]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:48:13 absurd kernel: [  378.183627]  [<ffffffffa03fe03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:48:13 absurd kernel: [  378.183632]  [<ffffffffa02cfe21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:48:13 absurd kernel: [  378.183634]  [<ffffffffa02cff17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:48:13 absurd kernel: [  378.183638]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:48:13 absurd kernel: [  378.183641]  [<ffffffffa02cf951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:48:13 absurd kernel: [  378.183643]  [<ffffffffa02d1776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:48:13 absurd kernel: [  378.183646]  [<ffffffffa03ab070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:48:13 absurd kernel: [  378.183648]  [<ffffffffa0334c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:48:13 absurd kernel: [  378.183652]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:48:13 absurd kernel: [  378.183654]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:48:13 absurd kernel: [  378.183656]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:48:13 absurd kernel: [  378.183657]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:48:13 absurd kernel: [  378.183658]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:48:13 absurd kernel: [  378.183661]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:48:13 absurd kernel: [  378.183662]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:48:13 absurd kernel: [  378.183664]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:48:13 absurd kernel: [  378.183666]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:48:13 absurd kernel: [  378.183667]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:48:13 absurd kernel: [  378.183669]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:48:13 absurd kernel: [  378.183670]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:48:13 absurd kernel: [  378.183671]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:48:13 absurd kernel: [  378.183672] ---[ end trace db395c2b3c067207 ]---
Aug  4 17:48:13 absurd kernel: [  378.183673] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:48:13 absurd kernel: [  378.503182] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:48:13 absurd kernel: [  378.503791] ata1.00: configured for UDMA/133
Aug  4 17:48:13 absurd kernel: [  378.507152] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:48:13 absurd kernel: [  378.511212] usb 2-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:48:13 absurd kernel: [  378.511216] usb 1-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:48:13 absurd kernel: [  378.515166] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:48:13 absurd kernel: [  378.529187] ata2.00: configured for UDMA/133
Aug  4 17:48:13 absurd kernel: [  378.531162] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:48:13 absurd kernel: [  378.534548] ata5.00: configured for UDMA/133
Aug  4 17:48:13 absurd kernel: [  378.539149] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:48:13 absurd kernel: [  378.540725] ata4.00: configured for UDMA/100
Aug  4 17:48:13 absurd kernel: [  378.643104] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:48:13 absurd kernel: [  378.654685] ata6.00: configured for UDMA/133
Aug  4 17:48:13 absurd kernel: [  378.923166] usb 1-1.6: reset full-speed USB device number 3 using ehci-pci
Aug  4 17:48:13 absurd kernel: [  378.923182] usb 2-1.3: reset high-speed USB device number 5 using ehci-pci
Aug  4 17:48:13 absurd kernel: [  379.087010] usb 2-1.1: reset high-speed USB device number 3 using ehci-pci
Aug  4 17:48:13 absurd kernel: [  379.438785] usb 2-1.2: reset low-speed USB device number 4 using ehci-pci
Aug  4 17:48:13 absurd kernel: [  379.790595] usb 2-1.3.1: reset high-speed USB device number 6 using ehci-pci
Aug  4 17:48:13 absurd kernel: [  379.970482] usb 2-1.3.3: reset full-speed USB device number 7 using ehci-pci
Aug  4 17:48:13 absurd kernel: [  380.142394] PM: restore of devices complete after 1964.085 msecs
Aug  4 17:48:13 absurd kernel: [  380.371738] Restarting kernel threads ... done.
Aug  4 17:48:13 absurd kernel: [  380.372685] PM: Basic memory bitmaps freed
Aug  4 17:48:13 absurd kernel: [  380.372747] Restarting tasks ... done.
Aug  4 17:48:13 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:48:13 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:48:13 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:48:13 absurd acpid: client 4432[0:0] has disconnected
Aug  4 17:48:13 absurd upsd[4451]: Can't connect to UPS [duo2pro] (blazer_usb-duo2pro): No such file or directory
Aug  4 17:48:13 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 17:48:13 absurd acpid: client connected from 4432[0:0]
Aug  4 17:48:13 absurd acpid: 1 client rule loaded
Aug  4 17:48:13 absurd NetworkManager[4243]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:48:14 absurd acpid: client connected from 4432[0:0]
Aug  4 17:48:14 absurd acpid: 1 client rule loaded
Aug  4 17:48:14 absurd acpid: client connected from 4432[0:0]
Aug  4 17:48:14 absurd acpid: 1 client rule loaded
Aug  4 17:48:14 absurd acpid: client connected from 4432[0:0]
Aug  4 17:48:14 absurd acpid: 1 client rule loaded
Aug  4 17:48:15 absurd NetworkManager[4243]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:48:15 absurd kernel: [  381.521704] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 17:48:16 absurd upsd[4451]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 17:48:16 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:48:19 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:48:19 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="7094" x-info="http://www.rsyslog.com"] start
Aug  4 17:48:19 absurd salomea: ========== resume complete ===========
Aug  4 17:48:19 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:48:22 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:48:25 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:48:28 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:48:31 absurd upsmon[4479]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_4_success1.txt

Aug  4 16:48:58 absurd sudo: pam_unix(sudo:session): session opened for user root by salomea(uid=0)
Aug  4 16:48:58 absurd su[5856]: Successful su for root by root
Aug  4 16:48:58 absurd su[5856]: + /dev/pts/0 root:root
Aug  4 16:48:58 absurd su[5856]: pam_unix(su:session): session opened for user root by salomea(uid=0)
Aug  4 16:49:03 absurd NetworkManager[4255]: <info> (eth0): IP6 addrconf timed out or failed.
Aug  4 16:49:03 absurd NetworkManager[4255]: <info> Activation (eth0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Aug  4 16:49:03 absurd NetworkManager[4255]: <info> Activation (eth0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Aug  4 16:49:03 absurd NetworkManager[4255]: <info> Activation (eth0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Aug  4 16:49:23 absurd salomea: ========== touch forcefsck ===========
Aug  4 16:49:24 absurd salomea: ========== START HIBERNATION =========
Aug  4 16:49:24 absurd kernel: [   72.474592] PM: Hibernation mode set to 'shutdown'
Aug  4 16:51:03 absurd kernel: [   73.282132] PM: Syncing filesystems ... done.
Aug  4 16:51:03 absurd kernel: [   73.290390] Freezing user space processes ... (elapsed 0.001 seconds) done.
Aug  4 16:51:03 absurd kernel: [   73.293118] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 16:51:03 absurd kernel: [   73.293121] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 16:51:03 absurd kernel: [   73.294123] PM: Basic memory bitmaps created
Aug  4 16:51:03 absurd kernel: [   73.294124] PM: Preallocating image memory... done (allocated 575392 pages)
Aug  4 16:51:03 absurd kernel: [   74.077424] PM: Allocated 2301568 kbytes in 0.78 seconds (2950.72 MB/s)
Aug  4 16:51:03 absurd kernel: [   74.077426] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 16:51:03 absurd kernel: [   74.079225] Suspending console(s) (use no_console_suspend to debug)
Aug  4 16:51:03 absurd kernel: [   74.079749] serial 00:04: disabled
Aug  4 16:51:03 absurd kernel: [   74.079843] serial 00:03: disabled
Aug  4 16:51:03 absurd kernel: [   74.148048] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 16:51:03 absurd kernel: [   74.162794] PM: freeze of devices complete after 83.614 msecs
Aug  4 16:51:03 absurd kernel: [   74.163500] PM: late freeze of devices complete after 0.704 msecs
Aug  4 16:51:03 absurd kernel: [   74.165625] PM: noirq freeze of devices complete after 2.125 msecs
Aug  4 16:51:03 absurd kernel: [   74.165626] Disabling non-boot CPUs ...
Aug  4 16:51:03 absurd kernel: [   74.165787] intel_pstate CPU 1 exiting
Aug  4 16:51:03 absurd kernel: [   74.168291] kvm: disabling virtualization on CPU1
Aug  4 16:51:03 absurd kernel: [   74.168302] smpboot: CPU 1 is now offline
Aug  4 16:51:03 absurd kernel: [   74.169275] intel_pstate CPU 2 exiting
Aug  4 16:51:03 absurd kernel: [   74.171576] kvm: disabling virtualization on CPU2
Aug  4 16:51:03 absurd kernel: [   74.172242] smpboot: CPU 2 is now offline
Aug  4 16:51:03 absurd kernel: [   74.172775] intel_pstate CPU 3 exiting
Aug  4 16:51:03 absurd kernel: [   74.174596] kvm: disabling virtualization on CPU3
Aug  4 16:51:03 absurd kernel: [   74.174623] smpboot: CPU 3 is now offline
Aug  4 16:51:03 absurd kernel: [   74.175352] intel_pstate CPU 4 exiting
Aug  4 16:51:03 absurd kernel: [   74.177789] kvm: disabling virtualization on CPU4
Aug  4 16:51:03 absurd kernel: [   74.278697] smpboot: CPU 4 is now offline
Aug  4 16:51:03 absurd kernel: [   74.279379] intel_pstate CPU 5 exiting
Aug  4 16:51:03 absurd kernel: [   74.281513] kvm: disabling virtualization on CPU5
Aug  4 16:51:03 absurd kernel: [   74.281525] smpboot: CPU 5 is now offline
Aug  4 16:51:03 absurd kernel: [   74.282178] intel_pstate CPU 6 exiting
Aug  4 16:51:03 absurd kernel: [   74.284036] kvm: disabling virtualization on CPU6
Aug  4 16:51:03 absurd kernel: [   74.284044] smpboot: CPU 6 is now offline
Aug  4 16:51:03 absurd kernel: [   74.284742] intel_pstate CPU 7 exiting
Aug  4 16:51:03 absurd kernel: [   74.286538] kvm: disabling virtualization on CPU7
Aug  4 16:51:03 absurd kernel: [   74.286546] smpboot: CPU 7 is now offline
Aug  4 16:51:03 absurd kernel: [   74.287977] intel_pstate CPU 8 exiting
Aug  4 16:51:03 absurd kernel: [   74.290395] kvm: disabling virtualization on CPU8
Aug  4 16:51:03 absurd kernel: [   74.290407] smpboot: CPU 8 is now offline
Aug  4 16:51:03 absurd kernel: [   74.293323] intel_pstate CPU 9 exiting
Aug  4 16:51:03 absurd kernel: [   74.295641] kvm: disabling virtualization on CPU9
Aug  4 16:51:03 absurd kernel: [   74.295663] smpboot: CPU 9 is now offline
Aug  4 16:51:03 absurd kernel: [   74.298113] intel_pstate CPU 10 exiting
Aug  4 16:51:03 absurd kernel: [   74.300396] kvm: disabling virtualization on CPU10
Aug  4 16:51:03 absurd kernel: [   74.300408] smpboot: CPU 10 is now offline
Aug  4 16:51:03 absurd kernel: [   74.302894] intel_pstate CPU 11 exiting
Aug  4 16:51:03 absurd kernel: [   74.305071] kvm: disabling virtualization on CPU11
Aug  4 16:51:03 absurd kernel: [   74.305093] smpboot: CPU 11 is now offline
Aug  4 16:51:03 absurd kernel: [   74.307317] intel_pstate CPU 12 exiting
Aug  4 16:51:03 absurd kernel: [   74.309407] kvm: disabling virtualization on CPU12
Aug  4 16:51:03 absurd kernel: [   74.309418] smpboot: CPU 12 is now offline
Aug  4 16:51:03 absurd kernel: [   74.311502] intel_pstate CPU 13 exiting
Aug  4 16:51:03 absurd kernel: [   74.313553] kvm: disabling virtualization on CPU13
Aug  4 16:51:03 absurd kernel: [   74.313565] smpboot: CPU 13 is now offline
Aug  4 16:51:03 absurd kernel: [   74.315622] intel_pstate CPU 14 exiting
Aug  4 16:51:03 absurd kernel: [   74.317661] kvm: disabling virtualization on CPU14
Aug  4 16:51:03 absurd kernel: [   74.418630] smpboot: CPU 14 is now offline
Aug  4 16:51:03 absurd kernel: [   74.419679] intel_pstate CPU 15 exiting
Aug  4 16:51:03 absurd kernel: [   74.421477] kvm: disabling virtualization on CPU15
Aug  4 16:51:03 absurd kernel: [   74.421492] smpboot: CPU 15 is now offline
Aug  4 16:51:03 absurd kernel: [   74.422701] intel_pstate CPU 16 exiting
Aug  4 16:51:03 absurd kernel: [   74.424431] kvm: disabling virtualization on CPU16
Aug  4 16:51:03 absurd kernel: [   74.424445] smpboot: CPU 16 is now offline
Aug  4 16:51:03 absurd kernel: [   74.425137] intel_pstate CPU 17 exiting
Aug  4 16:51:03 absurd kernel: [   74.426698] kvm: disabling virtualization on CPU17
Aug  4 16:51:03 absurd kernel: [   74.426712] smpboot: CPU 17 is now offline
Aug  4 16:51:03 absurd kernel: [   74.428119] intel_pstate CPU 18 exiting
Aug  4 16:51:03 absurd kernel: [   74.429876] kvm: disabling virtualization on CPU18
Aug  4 16:51:03 absurd kernel: [   74.429888] smpboot: CPU 18 is now offline
Aug  4 16:51:03 absurd kernel: [   74.430273] intel_pstate CPU 19 exiting
Aug  4 16:51:03 absurd kernel: [   74.431937] kvm: disabling virtualization on CPU19
Aug  4 16:51:03 absurd kernel: [   74.534536] smpboot: CPU 19 is now offline
Aug  4 16:51:03 absurd kernel: [   74.535220] intel_pstate CPU 20 exiting
Aug  4 16:51:03 absurd kernel: [   74.536854] kvm: disabling virtualization on CPU20
Aug  4 16:51:03 absurd kernel: [   74.638480] smpboot: CPU 20 is now offline
Aug  4 16:51:03 absurd kernel: [   74.639031] intel_pstate CPU 21 exiting
Aug  4 16:51:03 absurd kernel: [   74.641020] kvm: disabling virtualization on CPU21
Aug  4 16:51:03 absurd kernel: [   74.641040] smpboot: CPU 21 is now offline
Aug  4 16:51:03 absurd kernel: [   74.641806] intel_pstate CPU 22 exiting
Aug  4 16:51:03 absurd kernel: [   74.643607] kvm: disabling virtualization on CPU22
Aug  4 16:51:03 absurd kernel: [   74.643650] smpboot: CPU 22 is now offline
Aug  4 16:51:03 absurd kernel: [   74.644532] intel_pstate CPU 23 exiting
Aug  4 16:51:03 absurd kernel: [   74.646376] kvm: disabling virtualization on CPU23
Aug  4 16:51:03 absurd kernel: [   74.746432] smpboot: CPU 23 is now offline
Aug  4 16:51:03 absurd kernel: [   74.747621] intel_pstate CPU 24 exiting
Aug  4 16:51:03 absurd kernel: [   74.749424] kvm: disabling virtualization on CPU24
Aug  4 16:51:03 absurd kernel: [   74.749447] smpboot: CPU 24 is now offline
Aug  4 16:51:03 absurd kernel: [   74.750564] intel_pstate CPU 25 exiting
Aug  4 16:51:03 absurd kernel: [   74.752383] kvm: disabling virtualization on CPU25
Aug  4 16:51:03 absurd kernel: [   74.854357] smpboot: CPU 25 is now offline
Aug  4 16:51:03 absurd kernel: [   74.855430] intel_pstate CPU 26 exiting
Aug  4 16:51:03 absurd kernel: [   74.857002] kvm: disabling virtualization on CPU26
Aug  4 16:51:03 absurd kernel: [   74.958296] smpboot: CPU 26 is now offline
Aug  4 16:51:03 absurd kernel: [   74.959096] intel_pstate CPU 27 exiting
Aug  4 16:51:03 absurd kernel: [   74.960591] kvm: disabling virtualization on CPU27
Aug  4 16:51:03 absurd kernel: [   75.062235] smpboot: CPU 27 is now offline
Aug  4 16:51:03 absurd kernel: [   75.063089] intel_pstate CPU 28 exiting
Aug  4 16:51:03 absurd kernel: [   75.064797] kvm: disabling virtualization on CPU28
Aug  4 16:51:03 absurd kernel: [   75.166181] smpboot: CPU 28 is now offline
Aug  4 16:51:03 absurd kernel: [   75.167260] intel_pstate CPU 29 exiting
Aug  4 16:51:03 absurd kernel: [   75.169014] kvm: disabling virtualization on CPU29
Aug  4 16:51:03 absurd kernel: [   75.270127] smpboot: CPU 29 is now offline
Aug  4 16:51:03 absurd kernel: [   75.271252] intel_pstate CPU 30 exiting
Aug  4 16:51:03 absurd kernel: [   75.272867] kvm: disabling virtualization on CPU30
Aug  4 16:51:03 absurd kernel: [   75.374066] smpboot: CPU 30 is now offline
Aug  4 16:51:03 absurd kernel: [   75.374838] intel_pstate CPU 31 exiting
Aug  4 16:51:03 absurd kernel: [   75.375521] Broke affinity for irq 96
Aug  4 16:51:03 absurd kernel: [   75.375526] Broke affinity for irq 97
Aug  4 16:51:03 absurd kernel: [   75.375530] Broke affinity for irq 98
Aug  4 16:51:03 absurd kernel: [   75.375590] Broke affinity for irq 128
Aug  4 16:51:03 absurd kernel: [   75.375594] Broke affinity for irq 129
Aug  4 16:51:03 absurd kernel: [   75.375598] Broke affinity for irq 130
Aug  4 16:51:03 absurd kernel: [   75.375602] Broke affinity for irq 131
Aug  4 16:51:03 absurd kernel: [   75.375607] Broke affinity for irq 132
Aug  4 16:51:03 absurd kernel: [   75.375611] Broke affinity for irq 133
Aug  4 16:51:03 absurd kernel: [   75.375615] Broke affinity for irq 134
Aug  4 16:51:03 absurd kernel: [   75.375620] Broke affinity for irq 135
Aug  4 16:51:03 absurd kernel: [   75.376670] kvm: disabling virtualization on CPU31
Aug  4 16:51:03 absurd kernel: [   75.477993] smpboot: CPU 31 is now offline
Aug  4 16:51:03 absurd kernel: [   75.479074] PM: Creating hibernation image:
Aug  4 16:51:03 absurd kernel: [   76.378531] PM: Need to copy 561834 pages
Aug  4 16:51:03 absurd kernel: [   76.378533] PM: Normal pages needed: 561834 + 1024, available pages: 16205822
Aug  4 16:51:03 absurd kernel: [   75.486361] Enabling non-boot CPUs ...
Aug  4 16:51:03 absurd kernel: [   75.486670] x86: Booting SMP configuration:
Aug  4 16:51:03 absurd kernel: [   75.486671] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 16:51:03 absurd kernel: [   75.499305] kvm: enabling virtualization on CPU1
Aug  4 16:51:03 absurd kernel: [   75.501598] Intel pstate controlling: cpu 1
Aug  4 16:51:03 absurd kernel: [   75.501673] CPU1 is up
Aug  4 16:51:03 absurd kernel: [   75.501807] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 16:51:03 absurd kernel: [   75.513511] kvm: enabling virtualization on CPU2
Aug  4 16:51:03 absurd kernel: [   75.515738] Intel pstate controlling: cpu 2
Aug  4 16:51:03 absurd kernel: [   75.515806] CPU2 is up
Aug  4 16:51:03 absurd kernel: [   75.515943] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 16:51:03 absurd kernel: [   75.527657] kvm: enabling virtualization on CPU3
Aug  4 16:51:03 absurd kernel: [   75.529940] Intel pstate controlling: cpu 3
Aug  4 16:51:03 absurd kernel: [   75.530009] CPU3 is up
Aug  4 16:51:03 absurd kernel: [   75.530138] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 16:51:03 absurd kernel: [   75.541836] kvm: enabling virtualization on CPU4
Aug  4 16:51:03 absurd kernel: [   75.544104] Intel pstate controlling: cpu 4
Aug  4 16:51:03 absurd kernel: [   75.544172] CPU4 is up
Aug  4 16:51:03 absurd kernel: [   75.544310] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 16:51:03 absurd kernel: [   75.556001] kvm: enabling virtualization on CPU5
Aug  4 16:51:03 absurd kernel: [   75.558285] Intel pstate controlling: cpu 5
Aug  4 16:51:03 absurd kernel: [   75.558353] CPU5 is up
Aug  4 16:51:03 absurd kernel: [   75.558498] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 16:51:03 absurd kernel: [   75.570192] kvm: enabling virtualization on CPU6
Aug  4 16:51:03 absurd kernel: [   75.572469] Intel pstate controlling: cpu 6
Aug  4 16:51:03 absurd kernel: [   75.572535] CPU6 is up
Aug  4 16:51:03 absurd kernel: [   75.572677] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 16:51:03 absurd kernel: [   75.584359] kvm: enabling virtualization on CPU7
Aug  4 16:51:03 absurd kernel: [   75.586666] Intel pstate controlling: cpu 7
Aug  4 16:51:03 absurd kernel: [   75.586736] CPU7 is up
Aug  4 16:51:03 absurd kernel: [   75.587129] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 16:51:03 absurd kernel: [   75.600434] kvm: enabling virtualization on CPU8
Aug  4 16:51:03 absurd kernel: [   75.620835] Intel pstate controlling: cpu 8
Aug  4 16:51:03 absurd kernel: [   75.620883] CPU8 is up
Aug  4 16:51:03 absurd kernel: [   75.621225] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 16:51:03 absurd kernel: [   75.634575] kvm: enabling virtualization on CPU9
Aug  4 16:51:03 absurd kernel: [   75.636840] Intel pstate controlling: cpu 9
Aug  4 16:51:03 absurd kernel: [   75.636886] CPU9 is up
Aug  4 16:51:03 absurd kernel: [   75.637147] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 16:51:03 absurd kernel: [   75.650509] kvm: enabling virtualization on CPU10
Aug  4 16:51:03 absurd kernel: [   75.652772] Intel pstate controlling: cpu 10
Aug  4 16:51:03 absurd kernel: [   75.652820] CPU10 is up
Aug  4 16:51:03 absurd kernel: [   75.653076] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 16:51:03 absurd kernel: [   75.666452] kvm: enabling virtualization on CPU11
Aug  4 16:51:03 absurd kernel: [   75.668704] Intel pstate controlling: cpu 11
Aug  4 16:51:03 absurd kernel: [   75.668750] CPU11 is up
Aug  4 16:51:03 absurd kernel: [   75.668977] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 16:51:03 absurd kernel: [   75.682346] kvm: enabling virtualization on CPU12
Aug  4 16:51:03 absurd kernel: [   75.684617] Intel pstate controlling: cpu 12
Aug  4 16:51:03 absurd kernel: [   75.684663] CPU12 is up
Aug  4 16:51:03 absurd kernel: [   75.684837] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 16:51:03 absurd kernel: [   75.698157] kvm: enabling virtualization on CPU13
Aug  4 16:51:03 absurd kernel: [   75.700487] Intel pstate controlling: cpu 13
Aug  4 16:51:03 absurd kernel: [   75.700533] CPU13 is up
Aug  4 16:51:03 absurd kernel: [   75.700716] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 16:51:03 absurd kernel: [   75.714030] kvm: enabling virtualization on CPU14
Aug  4 16:51:03 absurd kernel: [   75.716380] Intel pstate controlling: cpu 14
Aug  4 16:51:03 absurd kernel: [   75.716427] CPU14 is up
Aug  4 16:51:03 absurd kernel: [   75.716599] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 16:51:03 absurd kernel: [   75.729900] kvm: enabling virtualization on CPU15
Aug  4 16:51:03 absurd kernel: [   75.732168] Intel pstate controlling: cpu 15
Aug  4 16:51:03 absurd kernel: [   75.732215] CPU15 is up
Aug  4 16:51:03 absurd kernel: [   75.732341] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 16:51:03 absurd kernel: [   75.744081] kvm: enabling virtualization on CPU16
Aug  4 16:51:03 absurd kernel: [   75.746556] Intel pstate controlling: cpu 16
Aug  4 16:51:03 absurd kernel: [   75.746627] CPU16 is up
Aug  4 16:51:03 absurd kernel: [   75.746772] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 16:51:03 absurd kernel: [   75.758467] kvm: enabling virtualization on CPU17
Aug  4 16:51:03 absurd kernel: [   75.760950] Intel pstate controlling: cpu 17
Aug  4 16:51:03 absurd kernel: [   75.761016] CPU17 is up
Aug  4 16:51:03 absurd kernel: [   75.761167] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 16:51:03 absurd kernel: [   75.772866] kvm: enabling virtualization on CPU18
Aug  4 16:51:03 absurd kernel: [   75.775370] Intel pstate controlling: cpu 18
Aug  4 16:51:03 absurd kernel: [   75.775435] CPU18 is up
Aug  4 16:51:03 absurd kernel: [   75.775575] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 16:51:03 absurd kernel: [   75.787281] kvm: enabling virtualization on CPU19
Aug  4 16:51:03 absurd kernel: [   75.789780] Intel pstate controlling: cpu 19
Aug  4 16:51:03 absurd kernel: [   75.789844] CPU19 is up
Aug  4 16:51:03 absurd kernel: [   75.789991] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 16:51:03 absurd kernel: [   75.801680] kvm: enabling virtualization on CPU20
Aug  4 16:51:03 absurd kernel: [   75.804127] Intel pstate controlling: cpu 20
Aug  4 16:51:03 absurd kernel: [   75.804193] CPU20 is up
Aug  4 16:51:03 absurd kernel: [   75.804336] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 16:51:03 absurd kernel: [   75.816019] kvm: enabling virtualization on CPU21
Aug  4 16:51:03 absurd kernel: [   75.818480] Intel pstate controlling: cpu 21
Aug  4 16:51:03 absurd kernel: [   75.818544] CPU21 is up
Aug  4 16:51:03 absurd kernel: [   75.818688] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 16:51:03 absurd kernel: [   75.830368] kvm: enabling virtualization on CPU22
Aug  4 16:51:03 absurd kernel: [   75.832841] Intel pstate controlling: cpu 22
Aug  4 16:51:03 absurd kernel: [   75.832906] CPU22 is up
Aug  4 16:51:03 absurd kernel: [   75.833046] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 16:51:03 absurd kernel: [   75.844719] kvm: enabling virtualization on CPU23
Aug  4 16:51:03 absurd kernel: [   75.847212] Intel pstate controlling: cpu 23
Aug  4 16:51:03 absurd kernel: [   75.847278] CPU23 is up
Aug  4 16:51:03 absurd kernel: [   75.847620] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 16:51:03 absurd kernel: [   75.860923] kvm: enabling virtualization on CPU24
Aug  4 16:51:03 absurd kernel: [   75.863332] Intel pstate controlling: cpu 24
Aug  4 16:51:03 absurd kernel: [   75.863378] CPU24 is up
Aug  4 16:51:03 absurd kernel: [   75.863584] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 16:51:03 absurd kernel: [   75.876916] kvm: enabling virtualization on CPU25
Aug  4 16:51:03 absurd kernel: [   75.879371] Intel pstate controlling: cpu 25
Aug  4 16:51:03 absurd kernel: [   75.879417] CPU25 is up
Aug  4 16:51:03 absurd kernel: [   75.879603] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 16:51:03 absurd kernel: [   75.892951] kvm: enabling virtualization on CPU26
Aug  4 16:51:03 absurd kernel: [   75.895387] Intel pstate controlling: cpu 26
Aug  4 16:51:03 absurd kernel: [   75.895432] CPU26 is up
Aug  4 16:51:03 absurd kernel: [   75.895608] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 16:51:03 absurd kernel: [   75.908967] kvm: enabling virtualization on CPU27
Aug  4 16:51:03 absurd kernel: [   75.911407] Intel pstate controlling: cpu 27
Aug  4 16:51:03 absurd kernel: [   75.911453] CPU27 is up
Aug  4 16:51:03 absurd kernel: [   75.911634] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 16:51:03 absurd kernel: [   75.924995] kvm: enabling virtualization on CPU28
Aug  4 16:51:03 absurd kernel: [   75.927487] Intel pstate controlling: cpu 28
Aug  4 16:51:03 absurd kernel: [   75.927536] CPU28 is up
Aug  4 16:51:03 absurd kernel: [   75.927709] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 16:51:03 absurd kernel: [   75.940772] kvm: enabling virtualization on CPU29
Aug  4 16:51:03 absurd kernel: [   75.943214] Intel pstate controlling: cpu 29
Aug  4 16:51:03 absurd kernel: [   75.943260] CPU29 is up
Aug  4 16:51:03 absurd kernel: [   75.943442] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 16:51:03 absurd kernel: [   75.956506] kvm: enabling virtualization on CPU30
Aug  4 16:51:03 absurd kernel: [   75.958980] Intel pstate controlling: cpu 30
Aug  4 16:51:03 absurd kernel: [   75.959026] CPU30 is up
Aug  4 16:51:03 absurd kernel: [   75.959202] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 16:51:03 absurd kernel: [   75.972041] kvm: enabling virtualization on CPU31
Aug  4 16:51:03 absurd kernel: [   75.974547] Intel pstate controlling: cpu 31
Aug  4 16:51:03 absurd kernel: [   75.974598] CPU31 is up
Aug  4 16:51:03 absurd kernel: [   76.073261] PM: noirq restore of devices complete after 16.572 msecs
Aug  4 16:51:03 absurd kernel: [   76.073759] PM: early restore of devices complete after 0.436 msecs
Aug  4 16:51:03 absurd kernel: [   76.246019] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 16:51:03 absurd kernel: [   76.246088] usb usb2: root hub lost power or was reset
Aug  4 16:51:03 absurd kernel: [   76.246089] usb usb1: root hub lost power or was reset
Aug  4 16:51:03 absurd kernel: [   76.246298] igb 0000:02:00.0: irq 100 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246300] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246308] igb 0000:02:00.0: irq 101 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246311] igb 0000:02:00.1: irq 102 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246315] igb 0000:02:00.0: irq 103 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246320] igb 0000:02:00.1: irq 104 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246322] igb 0000:02:00.0: irq 105 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246329] igb 0000:02:00.1: irq 106 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246331] igb 0000:02:00.0: irq 107 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246341] igb 0000:02:00.1: irq 111 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246342] igb 0000:02:00.0: irq 112 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246352] igb 0000:02:00.1: irq 113 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246354] igb 0000:02:00.0: irq 114 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246361] igb 0000:02:00.1: irq 115 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246363] igb 0000:02:00.0: irq 116 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246369] igb 0000:02:00.1: irq 117 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246371] igb 0000:02:00.0: irq 118 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246377] igb 0000:02:00.1: irq 119 for MSI/MSI-X
Aug  4 16:51:03 absurd kernel: [   76.246693] serial 00:03: activated
Aug  4 16:51:03 absurd kernel: [   76.247065] serial 00:04: activated
Aug  4 16:51:03 absurd kernel: [   76.247654] sd 1:0:0:0: [sda] Starting disk
Aug  4 16:51:03 absurd kernel: [   76.247693] sd 2:0:0:0: [sdb] Starting disk
Aug  4 16:51:03 absurd kernel: [   76.247730] sd 5:0:0:0: [sdc] Starting disk
Aug  4 16:51:03 absurd kernel: [   76.247755] sd 6:0:0:0: [sdd] Starting disk
Aug  4 16:51:03 absurd kernel: [   76.249974] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 16:51:03 absurd kernel: [   76.249975] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 16:51:03 absurd kernel: [   76.250051] ------------[ cut here ]------------
Aug  4 16:51:03 absurd kernel: [   76.250058] WARNING: CPU: 10 PID: 5908 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 16:51:03 absurd kernel: [   76.250089] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj snd_hda_codec_hdmi nvidia(PO) x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support crct10dif_pclmul crc32_pclmul ghash_clmulni_intel mxm_wmi snd_hda_codec_ca0132 aesni_intel joydev evdev aes_x86_64 ablk_helper cryptd glue_helper snd_hda_intel lrw gf128mul snd_hda_controller snd_hda_codec pcspkr sb_edac snd_hwdep edac_core snd_pcm i2c_i801 snd_seq snd_seq_device snd_timer lpc_ich snd mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler wmi processor thermal_sys tpm_tis tpm button ext4 mbcache crc16 jbd2 dm_mod usb_storage raid1 hid_generic usbhid hid md_mod sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common crc32c_intel isci ahci libsas libahci ehci_pci libata scsi_transport_sas ehci_hcd igb usbc
Aug  4 16:51:03 absurd kernel: ore i2c_algo_bit scsi_mod usb_common i2c_core dca ptp pps_core
Aug  4 16:51:03 absurd kernel: [   76.250102] CPU: 10 PID: 5908 Comm: kworker/u66:3 Tainted: P           O  3.16.0-vanilla.1 #1
Aug  4 16:51:03 absurd kernel: [   76.250103] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 16:51:03 absurd kernel: [   76.250107] Workqueue: events_unbound async_run_entry_fn
Aug  4 16:51:03 absurd kernel: [   76.250109]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 16:51:03 absurd kernel: [   76.250110]  ffffffff810664f6 ffffffffa089f09b ffff8810550a6fe0 ffff881054ee4400
Aug  4 16:51:03 absurd kernel: [   76.250111]  ffff881055257c90 ffff88105796b000 ffffffff813a7d3b ffff8810565eac00
Aug  4 16:51:03 absurd kernel: [   76.250112] Call Trace:
Aug  4 16:51:03 absurd kernel: [   76.250118]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 16:51:03 absurd kernel: [   76.250121]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 16:51:03 absurd kernel: [   76.250123]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 16:51:03 absurd kernel: [   76.250125]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 16:51:03 absurd kernel: [   76.250128]  [<ffffffffa089e03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 16:51:03 absurd kernel: [   76.250132]  [<ffffffffa02e3e21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 16:51:03 absurd kernel: [   76.250135]  [<ffffffffa02e3f17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 16:51:03 absurd kernel: [   76.250138]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 16:51:03 absurd kernel: [   76.250141]  [<ffffffffa02e3951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 16:51:03 absurd kernel: [   76.250144]  [<ffffffffa02e5776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 16:51:03 absurd kernel: [   76.250146]  [<ffffffffa0355070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 16:51:03 absurd kernel: [   76.250148]  [<ffffffffa02fec91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 16:51:03 absurd kernel: [   76.250152]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 16:51:03 absurd kernel: [   76.250155]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 16:51:03 absurd kernel: [   76.250157]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 16:51:03 absurd kernel: [   76.250158]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 16:51:03 absurd kernel: [   76.250159]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 16:51:03 absurd kernel: [   76.250163]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 16:51:03 absurd kernel: [   76.250164]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 16:51:03 absurd kernel: [   76.250167]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 16:51:03 absurd kernel: [   76.250169]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 16:51:03 absurd kernel: [   76.250170]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 16:51:03 absurd kernel: [   76.250171]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 16:51:03 absurd kernel: [   76.250173]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 16:51:03 absurd kernel: [   76.250174]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 16:51:03 absurd kernel: [   76.250175] ---[ end trace 2b1f2cad5baddc2e ]---
Aug  4 16:51:03 absurd kernel: [   76.250176] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 16:51:03 absurd kernel: [   76.572731] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 16:51:03 absurd kernel: [   76.580715] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 16:51:03 absurd kernel: [   76.584738] usb 1-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 16:51:03 absurd kernel: [   76.584742] usb 2-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 16:51:03 absurd kernel: [   76.588674] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 16:51:03 absurd kernel: [   76.590186] ata4.00: configured for UDMA/100
Aug  4 16:51:03 absurd kernel: [   76.594368] ata2.00: configured for UDMA/133
Aug  4 16:51:03 absurd kernel: [   76.596671] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 16:51:03 absurd kernel: [   76.596702] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 16:51:03 absurd kernel: [   76.597204] ata1.00: configured for UDMA/133
Aug  4 16:51:03 absurd kernel: [   76.599887] ata5.00: configured for UDMA/133
Aug  4 16:51:03 absurd kernel: [   76.716625] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 16:51:03 absurd kernel: [   76.728031] ata6.00: configured for UDMA/133
Aug  4 16:51:03 absurd kernel: [   76.996711] usb 1-1.6: reset full-speed USB device number 3 using ehci-pci
Aug  4 16:51:03 absurd kernel: [   77.184575] usb 2-1.2: reset low-speed USB device number 4 using ehci-pci
Aug  4 16:51:03 absurd kernel: [   77.536386] usb 2-1.3: reset high-speed USB device number 5 using ehci-pci
Aug  4 16:51:03 absurd kernel: [   77.700278] usb 2-1.1: reset high-speed USB device number 3 using ehci-pci
Aug  4 16:51:03 absurd kernel: [   77.908115] usb 2-1.3.1: reset high-speed USB device number 6 using ehci-pci
Aug  4 16:51:03 absurd kernel: [   78.088056] usb 2-1.3.3: reset full-speed USB device number 7 using ehci-pci
Aug  4 16:51:03 absurd kernel: [   78.259877] PM: restore of devices complete after 2015.137 msecs
Aug  4 16:51:03 absurd kernel: [   78.264392] hid-generic 0003:0665:5161.0009: hiddev0,hidraw2: USB HID v1.00 Device [INNO TECH USB to Serial] on usb-0000:00:1d.0-1.2/input0
Aug  4 16:51:03 absurd kernel: [   78.265001] PM: Image restored successfully.
Aug  4 16:51:03 absurd kernel: [   78.265381] PM: Basic memory bitmaps freed
Aug  4 16:51:03 absurd kernel: [   78.265383] Restarting tasks ... 
Aug  4 16:51:03 absurd kernel: [   78.266034] usb 2-1.2: usbfs: process 4463 (blazer_usb) did not claim interface 0 before use
Aug  4 16:51:03 absurd acpid: client 4450[0:0] has disconnected
Aug  4 16:51:03 absurd acpid: client 4450[0:0] has disconnected
Aug  4 16:51:03 absurd upsd[4466]: Data for UPS [duo2pro] is stale - check driver
Aug  4 16:51:03 absurd acpid: client 4450[0:0] has disconnected
Aug  4 16:51:03 absurd acpid: client 4450[0:0] has disconnected
Aug  4 16:51:03 absurd NetworkManager[4255]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 16:51:03 absurd upsd[4466]: UPS [duo2pro] data is no longer stale
Aug  4 16:51:03 absurd blazer_usb[4463]: Got disconnected by another driver: Device or resource busy
Aug  4 16:51:03 absurd upsmon[4495]: Poll UPS [duo2pro@localhost] failed - Write error: Broken pipe
Aug  4 16:51:03 absurd upsmon[4495]: Communications with UPS duo2pro@localhost lost
Aug  4 16:51:03 absurd upsd[4466]: Can't connect to UPS [duo2pro] (blazer_usb-duo2pro): No such file or directory
Aug  4 16:51:03 absurd kernel: [   78.267710] done.
Aug  4 16:51:03 absurd acpid: client connected from 4450[0:0]
Aug  4 16:51:03 absurd acpid: 1 client rule loaded
Aug  4 16:51:03 absurd acpid: client connected from 4450[0:0]
Aug  4 16:51:03 absurd acpid: 1 client rule loaded
Aug  4 16:51:04 absurd acpid: client connected from 4450[0:0]
Aug  4 16:51:04 absurd acpid: 1 client rule loaded
Aug  4 16:51:04 absurd acpid: client connected from 4450[0:0]
Aug  4 16:51:04 absurd acpid: 1 client rule loaded
Aug  4 16:51:05 absurd NetworkManager[4255]: <info> (eth0): carrier now ON (device state 100)
Aug  4 16:51:05 absurd kernel: [   79.567284] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 16:51:06 absurd upsd[4466]: User upsmon@127.0.0.1 logged into UPS [duo2pro]
Aug  4 16:51:06 absurd upsmon[4495]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 16:51:08 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 16:51:08 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="6043" x-info="http://www.rsyslog.com"] start
Aug  4 16:51:08 absurd salomea: ========== resume complete ===========

--MP_/cEJe+m.7nh.4DHL/+fQKd3_
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=method_4_success2.txt

ug  4 17:03:05 absurd lightdm: pam_unix(lightdm:session): session closed for user lightdm
Aug  4 17:03:05 absurd lightdm: pam_unix(lightdm:session): session opened for user salomea by (uid=0)
Aug  4 17:03:05 absurd lightdm: pam_ck_connector(lightdm:session): nox11 mode, ignoring PAM_TTY :0
Aug  4 17:03:12 absurd sudo:  salomea : TTY=pts/0 ; PWD=/home/salomea ; USER=root ; COMMAND=/usr/bin/pkill -15 sshd
Aug  4 17:03:12 absurd sudo: pam_unix(sudo:session): session opened for user root by salomea(uid=0)
Aug  4 17:03:12 absurd sshd[5476]: Received signal 15; terminating.
Aug  4 17:03:12 absurd sudo:  salomea : TTY=pts/0 ; PWD=/home/salomea ; USER=root ; COMMAND=/etc/init.d/ssh restart
Aug  4 17:03:12 absurd sudo: pam_unix(sudo:session): session opened for user root by salomea(uid=0)
Aug  4 17:03:12 absurd sshd[5730]: Server listening on 0.0.0.0 port 22.
Aug  4 17:03:12 absurd sshd[5730]: Server listening on :: port 22.
Aug  4 17:03:12 absurd sudo:  salomea : TTY=pts/0 ; PWD=/home/salomea ; USER=root ; COMMAND=/etc/init.d/ssh_backup restart
Aug  4 17:03:12 absurd sudo: pam_unix(sudo:session): session opened for user root by salomea(uid=0)
Aug  4 17:03:12 absurd sshd[5761]: Server listening on 192.168.16.108 port 20022.
Aug  4 17:03:15 absurd sudo:  salomea : TTY=pts/1 ; PWD=/home/salomea ; USER=root ; COMMAND=/bin/su
Aug  4 17:03:15 absurd sudo: pam_unix(sudo:session): session opened for user root by salomea(uid=0)
Aug  4 17:03:15 absurd su[5796]: Successful su for root by root
Aug  4 17:03:15 absurd su[5796]: + /dev/pts/1 root:root
Aug  4 17:03:15 absurd su[5796]: pam_unix(su:session): session opened for user root by salomea(uid=0)
unclutter: someone created a sub-window to my sub-window! giving up
Aug  4 17:03:35 absurd salomea: ========== touch forcefsck ===========
Aug  4 17:03:36 absurd salomea: ========== START HIBERNATION =========
Aug  4 17:03:36 absurd kernel: [  271.747467] PM: Hibernation mode set to 'shutdown'
Aug  4 17:03:37 absurd kernel: [  272.547682] PM: Syncing filesystems ... done.
Aug  4 17:05:12 absurd kernel: [  272.554434] Freezing user space processes ... (elapsed 0.001 seconds) done.
Aug  4 17:05:12 absurd kernel: [  272.557154] PM: Marking nosave pages: [mem 0x0009a000-0x000fffff]
Aug  4 17:05:12 absurd acpid: client 4387[0:0] has disconnected
Aug  4 17:05:12 absurd acpid: client 4387[0:0] has disconnected
Aug  4 17:05:12 absurd acpid: client 4387[0:0] has disconnected
Aug  4 17:05:12 absurd acpid: client 4387[0:0] has disconnected
Aug  4 17:05:12 absurd NetworkManager[4201]: <info> (eth0): carrier now OFF (device state 100, deferring action for 4 seconds)
Aug  4 17:05:12 absurd kernel: [  272.557157] PM: Marking nosave pages: [mem 0x7df5d000-0xffffffff]
Aug  4 17:05:12 absurd upsd[4401]: Data for UPS [duo2pro] is stale - check driver
Aug  4 17:05:12 absurd kernel: [  272.558160] PM: Basic memory bitmaps created
Aug  4 17:05:12 absurd kernel: [  272.558162] PM: Preallocating image memory... done (allocated 574174 pages)
Aug  4 17:05:12 absurd kernel: [  273.422074] PM: Allocated 2296696 kbytes in 0.86 seconds (2670.57 MB/s)
Aug  4 17:05:12 absurd kernel: [  273.422075] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Aug  4 17:05:12 absurd kernel: [  273.423882] Suspending console(s) (use no_console_suspend to debug)
Aug  4 17:05:12 absurd kernel: [  273.424419] serial 00:04: disabled
Aug  4 17:05:12 absurd kernel: [  273.424500] serial 00:03: disabled
Aug  4 17:05:12 absurd kernel: [  273.487599] pcieport 0000:00:01.1: System wakeup enabled by ACPI
Aug  4 17:05:12 absurd kernel: [  273.502271] PM: freeze of devices complete after 78.431 msecs
Aug  4 17:05:12 absurd kernel: [  273.502985] PM: late freeze of devices complete after 0.712 msecs
Aug  4 17:05:12 absurd kernel: [  273.505108] PM: noirq freeze of devices complete after 2.122 msecs
Aug  4 17:05:12 absurd kernel: [  273.505109] Disabling non-boot CPUs ...
Aug  4 17:05:12 absurd kernel: [  273.505272] intel_pstate CPU 1 exiting
Aug  4 17:05:12 absurd kernel: [  273.507806] kvm: disabling virtualization on CPU1
Aug  4 17:05:12 absurd kernel: [  273.507816] smpboot: CPU 1 is now offline
Aug  4 17:05:12 absurd kernel: [  273.508690] intel_pstate CPU 2 exiting
Aug  4 17:05:12 absurd kernel: [  273.510624] kvm: disabling virtualization on CPU2
Aug  4 17:05:12 absurd kernel: [  273.511337] smpboot: CPU 2 is now offline
Aug  4 17:05:12 absurd kernel: [  273.511850] intel_pstate CPU 3 exiting
Aug  4 17:05:12 absurd kernel: [  273.513608] kvm: disabling virtualization on CPU3
Aug  4 17:05:12 absurd kernel: [  273.513626] smpboot: CPU 3 is now offline
Aug  4 17:05:12 absurd kernel: [  273.514304] intel_pstate CPU 4 exiting
Aug  4 17:05:12 absurd kernel: [  273.516325] kvm: disabling virtualization on CPU4
Aug  4 17:05:12 absurd kernel: [  273.618163] smpboot: CPU 4 is now offline
Aug  4 17:05:12 absurd kernel: [  273.618710] intel_pstate CPU 5 exiting
Aug  4 17:05:12 absurd kernel: [  273.620811] kvm: disabling virtualization on CPU5
Aug  4 17:05:12 absurd kernel: [  273.620822] smpboot: CPU 5 is now offline
Aug  4 17:05:12 absurd kernel: [  273.621583] intel_pstate CPU 6 exiting
Aug  4 17:05:12 absurd kernel: [  273.623522] kvm: disabling virtualization on CPU6
Aug  4 17:05:12 absurd upsd[4401]: UPS [duo2pro] data is no longer stale
Aug  4 17:05:12 absurd kernel: [  273.623530] smpboot: CPU 6 is now offline
Aug  4 17:05:12 absurd kernel: [  273.624760] intel_pstate CPU 7 exiting
Aug  4 17:05:12 absurd kernel: [  273.626852] kvm: disabling virtualization on CPU7
Aug  4 17:05:12 absurd kernel: [  273.626883] smpboot: CPU 7 is now offline
Aug  4 17:05:12 absurd kernel: [  273.629651] intel_pstate CPU 8 exiting
Aug  4 17:05:12 absurd kernel: [  273.632174] kvm: disabling virtualization on CPU8
Aug  4 17:05:12 absurd kernel: [  273.734119] smpboot: CPU 8 is now offline
Aug  4 17:05:12 absurd blazer_usb[4398]: Got disconnected by another driver: Device or resource busy
Aug  4 17:05:12 absurd kernel: [  273.735800] intel_pstate CPU 9 exiting
Aug  4 17:05:12 absurd kernel: [  273.738185] kvm: disabling virtualization on CPU9
Aug  4 17:05:12 absurd upsd[4401]: Can't connect to UPS [duo2pro] (blazer_usb-duo2pro): No such file or directory
Aug  4 17:05:12 absurd kernel: [  273.738237] smpboot: CPU 9 is now offline
Aug  4 17:05:12 absurd kernel: [  273.741047] intel_pstate CPU 10 exiting
Aug  4 17:05:12 absurd kernel: [  273.743469] kvm: disabling virtualization on CPU10
Aug  4 17:05:12 absurd kernel: [  273.743483] smpboot: CPU 10 is now offline
Aug  4 17:05:12 absurd kernel: [  273.746223] intel_pstate CPU 11 exiting
Aug  4 17:05:12 absurd kernel: [  273.748617] kvm: disabling virtualization on CPU11
Aug  4 17:05:12 absurd kernel: [  273.748643] smpboot: CPU 11 is now offline
Aug  4 17:05:12 absurd kernel: [  273.751320] intel_pstate CPU 12 exiting
Aug  4 17:05:12 absurd kernel: [  273.753686] kvm: disabling virtualization on CPU12
Aug  4 17:05:12 absurd kernel: [  273.753700] smpboot: CPU 12 is now offline
Aug  4 17:05:12 absurd kernel: [  273.756584] intel_pstate CPU 13 exiting
Aug  4 17:05:12 absurd kernel: [  273.758893] kvm: disabling virtualization on CPU13
Aug  4 17:05:12 absurd kernel: [  273.758921] smpboot: CPU 13 is now offline
Aug  4 17:05:12 absurd kernel: [  273.762110] intel_pstate CPU 14 exiting
Aug  4 17:05:12 absurd kernel: [  273.764232] kvm: disabling virtualization on CPU14
Aug  4 17:05:12 absurd kernel: [  273.764246] smpboot: CPU 14 is now offline
Aug  4 17:05:12 absurd kernel: [  273.766687] intel_pstate CPU 15 exiting
Aug  4 17:05:12 absurd kernel: [  273.768843] kvm: disabling virtualization on CPU15
Aug  4 17:05:12 absurd kernel: [  273.768865] smpboot: CPU 15 is now offline
Aug  4 17:05:12 absurd kernel: [  273.770597] intel_pstate CPU 16 exiting
Aug  4 17:05:12 absurd kernel: [  273.772757] kvm: disabling virtualization on CPU16
Aug  4 17:05:12 absurd kernel: [  273.772776] smpboot: CPU 16 is now offline
Aug  4 17:05:12 absurd kernel: [  273.774357] intel_pstate CPU 17 exiting
Aug  4 17:05:12 absurd kernel: [  273.776322] kvm: disabling virtualization on CPU17
Aug  4 17:05:12 absurd kernel: [  273.776332] smpboot: CPU 17 is now offline
Aug  4 17:05:12 absurd kernel: [  273.777030] intel_pstate CPU 18 exiting
Aug  4 17:05:12 absurd kernel: [  273.778910] kvm: disabling virtualization on CPU18
Aug  4 17:05:12 absurd kernel: [  273.778942] smpboot: CPU 18 is now offline
Aug  4 17:05:12 absurd kernel: [  273.780956] intel_pstate CPU 19 exiting
Aug  4 17:05:12 absurd kernel: [  273.782791] kvm: disabling virtualization on CPU19
Aug  4 17:05:12 absurd kernel: [  273.782811] smpboot: CPU 19 is now offline
Aug  4 17:05:12 absurd kernel: [  273.783250] intel_pstate CPU 20 exiting
Aug  4 17:05:12 absurd kernel: [  273.784951] kvm: disabling virtualization on CPU20
Aug  4 17:05:12 absurd kernel: [  273.886004] smpboot: CPU 20 is now offline
Aug  4 17:05:12 absurd kernel: [  273.886590] intel_pstate CPU 21 exiting
Aug  4 17:05:12 absurd kernel: [  273.888241] kvm: disabling virtualization on CPU21
Aug  4 17:05:12 absurd kernel: [  273.989940] smpboot: CPU 21 is now offline
Aug  4 17:05:12 absurd kernel: [  273.990419] intel_pstate CPU 22 exiting
Aug  4 17:05:12 absurd kernel: [  273.991910] kvm: disabling virtualization on CPU22
Aug  4 17:05:12 absurd kernel: [  273.991929] smpboot: CPU 22 is now offline
Aug  4 17:05:12 absurd kernel: [  273.992429] intel_pstate CPU 23 exiting
Aug  4 17:05:12 absurd kernel: [  273.993974] kvm: disabling virtualization on CPU23
Aug  4 17:05:12 absurd kernel: [  273.993999] smpboot: CPU 23 is now offline
Aug  4 17:05:12 absurd kernel: [  273.994621] intel_pstate CPU 24 exiting
Aug  4 17:05:12 absurd kernel: [  273.996312] kvm: disabling virtualization on CPU24
Aug  4 17:05:12 absurd kernel: [  274.097889] smpboot: CPU 24 is now offline
Aug  4 17:05:12 absurd kernel: [  274.098882] intel_pstate CPU 25 exiting
Aug  4 17:05:12 absurd kernel: [  274.100510] kvm: disabling virtualization on CPU25
Aug  4 17:05:12 absurd kernel: [  274.100518] smpboot: CPU 25 is now offline
Aug  4 17:05:12 absurd kernel: [  274.101325] intel_pstate CPU 26 exiting
Aug  4 17:05:12 absurd kernel: [  274.102888] kvm: disabling virtualization on CPU26
Aug  4 17:05:12 absurd kernel: [  274.102918] smpboot: CPU 26 is now offline
Aug  4 17:05:12 absurd kernel: [  274.105505] intel_pstate CPU 27 exiting
Aug  4 17:05:12 absurd kernel: [  274.108358] kvm: disabling virtualization on CPU27
Aug  4 17:05:12 absurd kernel: [  274.108367] smpboot: CPU 27 is now offline
Aug  4 17:05:12 absurd kernel: [  274.109200] intel_pstate CPU 28 exiting
Aug  4 17:05:12 absurd kernel: [  274.110794] kvm: disabling virtualization on CPU28
Aug  4 17:05:12 absurd kernel: [  274.110827] smpboot: CPU 28 is now offline
Aug  4 17:05:12 absurd kernel: [  274.111890] intel_pstate CPU 29 exiting
Aug  4 17:05:12 absurd kernel: [  274.113600] kvm: disabling virtualization on CPU29
Aug  4 17:05:12 absurd kernel: [  274.113618] smpboot: CPU 29 is now offline
Aug  4 17:05:12 absurd kernel: [  274.116163] intel_pstate CPU 30 exiting
Aug  4 17:05:12 absurd kernel: [  274.117820] kvm: disabling virtualization on CPU30
Aug  4 17:05:12 absurd kernel: [  274.117829] smpboot: CPU 30 is now offline
Aug  4 17:05:12 absurd kernel: [  274.120250] intel_pstate CPU 31 exiting
Aug  4 17:05:12 absurd kernel: [  274.120969] Broke affinity for irq 96
Aug  4 17:05:12 absurd kernel: [  274.120974] Broke affinity for irq 97
Aug  4 17:05:12 absurd kernel: [  274.120978] Broke affinity for irq 98
Aug  4 17:05:12 absurd kernel: [  274.121036] Broke affinity for irq 128
Aug  4 17:05:12 absurd kernel: [  274.121040] Broke affinity for irq 129
Aug  4 17:05:12 absurd kernel: [  274.121044] Broke affinity for irq 130
Aug  4 17:05:12 absurd kernel: [  274.121049] Broke affinity for irq 131
Aug  4 17:05:12 absurd kernel: [  274.121053] Broke affinity for irq 132
Aug  4 17:05:12 absurd kernel: [  274.121057] Broke affinity for irq 133
Aug  4 17:05:12 absurd kernel: [  274.121061] Broke affinity for irq 134
Aug  4 17:05:12 absurd kernel: [  274.121066] Broke affinity for irq 135
Aug  4 17:05:12 absurd kernel: [  274.122115] kvm: disabling virtualization on CPU31
Aug  4 17:05:12 absurd kernel: [  274.122128] smpboot: CPU 31 is now offline
Aug  4 17:05:12 absurd kernel: [  274.123155] PM: Creating hibernation image:
Aug  4 17:05:12 absurd kernel: [  274.817900] PM: Need to copy 562725 pages
Aug  4 17:05:12 absurd kernel: [  274.817901] PM: Normal pages needed: 562725 + 1024, available pages: 16204949
Aug  4 17:05:12 absurd kernel: [  274.129083] Enabling non-boot CPUs ...
Aug  4 17:05:12 absurd kernel: [  274.129358] x86: Booting SMP configuration:
Aug  4 17:05:12 absurd kernel: [  274.129359] smpboot: Booting Node 0 Processor 1 APIC 0x4
Aug  4 17:05:12 absurd kernel: [  274.141651] kvm: enabling virtualization on CPU1
Aug  4 17:05:12 absurd kernel: [  274.143953] Intel pstate controlling: cpu 1
Aug  4 17:05:12 absurd kernel: [  274.144024] CPU1 is up
Aug  4 17:05:12 absurd kernel: [  274.144160] smpboot: Booting Node 0 Processor 2 APIC 0x6
Aug  4 17:05:12 absurd kernel: [  274.155863] kvm: enabling virtualization on CPU2
Aug  4 17:05:12 absurd kernel: [  274.158115] Intel pstate controlling: cpu 2
Aug  4 17:05:12 absurd kernel: [  274.158190] CPU2 is up
Aug  4 17:05:12 absurd kernel: [  274.158324] smpboot: Booting Node 0 Processor 3 APIC 0x8
Aug  4 17:05:12 absurd kernel: [  274.170039] kvm: enabling virtualization on CPU3
Aug  4 17:05:12 absurd kernel: [  274.172368] Intel pstate controlling: cpu 3
Aug  4 17:05:12 absurd kernel: [  274.172432] CPU3 is up
Aug  4 17:05:12 absurd kernel: [  274.172567] smpboot: Booting Node 0 Processor 4 APIC 0x10
Aug  4 17:05:12 absurd kernel: [  274.184265] kvm: enabling virtualization on CPU4
Aug  4 17:05:12 absurd kernel: [  274.186508] Intel pstate controlling: cpu 4
Aug  4 17:05:12 absurd kernel: [  274.186574] CPU4 is up
Aug  4 17:05:12 absurd kernel: [  274.186709] smpboot: Booting Node 0 Processor 5 APIC 0x12
Aug  4 17:05:12 absurd kernel: [  274.198399] kvm: enabling virtualization on CPU5
Aug  4 17:05:12 absurd kernel: [  274.200671] Intel pstate controlling: cpu 5
Aug  4 17:05:12 absurd kernel: [  274.200739] CPU5 is up
Aug  4 17:05:12 absurd kernel: [  274.200871] smpboot: Booting Node 0 Processor 6 APIC 0x14
Aug  4 17:05:12 absurd kernel: [  274.212552] kvm: enabling virtualization on CPU6
Aug  4 17:05:12 absurd kernel: [  274.214818] Intel pstate controlling: cpu 6
Aug  4 17:05:12 absurd kernel: [  274.214881] CPU6 is up
Aug  4 17:05:12 absurd kernel: [  274.215023] smpboot: Booting Node 0 Processor 7 APIC 0x16
Aug  4 17:05:12 absurd kernel: [  274.226705] kvm: enabling virtualization on CPU7
Aug  4 17:05:12 absurd kernel: [  274.228984] Intel pstate controlling: cpu 7
Aug  4 17:05:12 absurd kernel: [  274.229049] CPU7 is up
Aug  4 17:05:12 absurd kernel: [  274.229435] smpboot: Booting Node 1 Processor 8 APIC 0x22
Aug  4 17:05:12 absurd kernel: [  274.242736] kvm: enabling virtualization on CPU8
Aug  4 17:05:12 absurd kernel: [  274.263113] Intel pstate controlling: cpu 8
Aug  4 17:05:12 absurd kernel: [  274.263162] CPU8 is up
Aug  4 17:05:12 absurd kernel: [  274.263496] smpboot: Booting Node 1 Processor 9 APIC 0x24
Aug  4 17:05:12 absurd kernel: [  274.276846] kvm: enabling virtualization on CPU9
Aug  4 17:05:12 absurd kernel: [  274.279092] Intel pstate controlling: cpu 9
Aug  4 17:05:12 absurd kernel: [  274.279142] CPU9 is up
Aug  4 17:05:12 absurd kernel: [  274.279404] smpboot: Booting Node 1 Processor 10 APIC 0x26
Aug  4 17:05:12 absurd kernel: [  274.292766] kvm: enabling virtualization on CPU10
Aug  4 17:05:12 absurd kernel: [  274.295023] Intel pstate controlling: cpu 10
Aug  4 17:05:12 absurd kernel: [  274.295068] CPU10 is up
Aug  4 17:05:12 absurd kernel: [  274.295314] smpboot: Booting Node 1 Processor 11 APIC 0x28
Aug  4 17:05:12 absurd kernel: [  274.308691] kvm: enabling virtualization on CPU11
Aug  4 17:05:12 absurd kernel: [  274.310929] Intel pstate controlling: cpu 11
Aug  4 17:05:12 absurd kernel: [  274.310974] CPU11 is up
Aug  4 17:05:12 absurd kernel: [  274.311201] smpboot: Booting Node 1 Processor 12 APIC 0x30
Aug  4 17:05:12 absurd kernel: [  274.324569] kvm: enabling virtualization on CPU12
Aug  4 17:05:12 absurd kernel: [  274.326837] Intel pstate controlling: cpu 12
Aug  4 17:05:12 absurd kernel: [  274.326887] CPU12 is up
Aug  4 17:05:12 absurd kernel: [  274.327068] smpboot: Booting Node 1 Processor 13 APIC 0x32
Aug  4 17:05:12 absurd kernel: [  274.340387] kvm: enabling virtualization on CPU13
Aug  4 17:05:12 absurd kernel: [  274.342705] Intel pstate controlling: cpu 13
Aug  4 17:05:12 absurd kernel: [  274.342752] CPU13 is up
Aug  4 17:05:12 absurd kernel: [  274.342932] smpboot: Booting Node 1 Processor 14 APIC 0x34
Aug  4 17:05:12 absurd kernel: [  274.356246] kvm: enabling virtualization on CPU14
Aug  4 17:05:12 absurd kernel: [  274.358584] Intel pstate controlling: cpu 14
Aug  4 17:05:12 absurd kernel: [  274.358629] CPU14 is up
Aug  4 17:05:12 absurd kernel: [  274.358799] smpboot: Booting Node 1 Processor 15 APIC 0x36
Aug  4 17:05:12 absurd kernel: [  274.372127] kvm: enabling virtualization on CPU15
Aug  4 17:05:12 absurd kernel: [  274.374462] Intel pstate controlling: cpu 15
Aug  4 17:05:12 absurd kernel: [  274.374507] CPU15 is up
Aug  4 17:05:12 absurd kernel: [  274.374635] smpboot: Booting Node 0 Processor 16 APIC 0x3
Aug  4 17:05:12 absurd kernel: [  274.386323] kvm: enabling virtualization on CPU16
Aug  4 17:05:12 absurd kernel: [  274.388812] Intel pstate controlling: cpu 16
Aug  4 17:05:12 absurd kernel: [  274.388877] CPU16 is up
Aug  4 17:05:12 absurd kernel: [  274.389019] smpboot: Booting Node 0 Processor 17 APIC 0x5
Aug  4 17:05:12 absurd kernel: [  274.400733] kvm: enabling virtualization on CPU17
Aug  4 17:05:12 absurd kernel: [  274.403257] Intel pstate controlling: cpu 17
Aug  4 17:05:12 absurd kernel: [  274.403327] CPU17 is up
Aug  4 17:05:12 absurd kernel: [  274.403471] smpboot: Booting Node 0 Processor 18 APIC 0x7
Aug  4 17:05:12 absurd kernel: [  274.415170] kvm: enabling virtualization on CPU18
Aug  4 17:05:12 absurd kernel: [  274.417660] Intel pstate controlling: cpu 18
Aug  4 17:05:12 absurd kernel: [  274.417727] CPU18 is up
Aug  4 17:05:12 absurd kernel: [  274.417871] smpboot: Booting Node 0 Processor 19 APIC 0x9
Aug  4 17:05:12 absurd kernel: [  274.429578] kvm: enabling virtualization on CPU19
Aug  4 17:05:12 absurd kernel: [  274.432067] Intel pstate controlling: cpu 19
Aug  4 17:05:12 absurd kernel: [  274.432131] CPU19 is up
Aug  4 17:05:12 absurd kernel: [  274.432275] smpboot: Booting Node 0 Processor 20 APIC 0x11
Aug  4 17:05:12 absurd kernel: [  274.443965] kvm: enabling virtualization on CPU20
Aug  4 17:05:12 absurd kernel: [  274.446495] Intel pstate controlling: cpu 20
Aug  4 17:05:12 absurd kernel: [  274.446558] CPU20 is up
Aug  4 17:05:12 absurd kernel: [  274.446701] smpboot: Booting Node 0 Processor 21 APIC 0x13
Aug  4 17:05:12 absurd kernel: [  274.458384] kvm: enabling virtualization on CPU21
Aug  4 17:05:12 absurd kernel: [  274.460929] Intel pstate controlling: cpu 21
Aug  4 17:05:12 absurd kernel: [  274.460993] CPU21 is up
Aug  4 17:05:12 absurd kernel: [  274.461136] smpboot: Booting Node 0 Processor 22 APIC 0x15
Aug  4 17:05:12 absurd kernel: [  274.472816] kvm: enabling virtualization on CPU22
Aug  4 17:05:12 absurd kernel: [  274.475386] Intel pstate controlling: cpu 22
Aug  4 17:05:12 absurd kernel: [  274.475450] CPU22 is up
Aug  4 17:05:12 absurd kernel: [  274.475601] smpboot: Booting Node 0 Processor 23 APIC 0x17
Aug  4 17:05:12 absurd kernel: [  274.487274] kvm: enabling virtualization on CPU23
Aug  4 17:05:12 absurd kernel: [  274.489860] Intel pstate controlling: cpu 23
Aug  4 17:05:12 absurd kernel: [  274.489929] CPU23 is up
Aug  4 17:05:12 absurd kernel: [  274.490262] smpboot: Booting Node 1 Processor 24 APIC 0x23
Aug  4 17:05:12 absurd kernel: [  274.503563] kvm: enabling virtualization on CPU24
Aug  4 17:05:12 absurd kernel: [  274.505955] Intel pstate controlling: cpu 24
Aug  4 17:05:12 absurd kernel: [  274.506002] CPU24 is up
Aug  4 17:05:12 absurd kernel: [  274.506212] smpboot: Booting Node 1 Processor 25 APIC 0x25
Aug  4 17:05:12 absurd kernel: [  274.519544] kvm: enabling virtualization on CPU25
Aug  4 17:05:12 absurd kernel: [  274.521991] Intel pstate controlling: cpu 25
Aug  4 17:05:12 absurd kernel: [  274.522037] CPU25 is up
Aug  4 17:05:12 absurd kernel: [  274.522224] smpboot: Booting Node 1 Processor 26 APIC 0x27
Aug  4 17:05:12 absurd kernel: [  274.535593] kvm: enabling virtualization on CPU26
Aug  4 17:05:12 absurd kernel: [  274.538002] Intel pstate controlling: cpu 26
Aug  4 17:05:12 absurd kernel: [  274.538047] CPU26 is up
Aug  4 17:05:12 absurd kernel: [  274.538233] smpboot: Booting Node 1 Processor 27 APIC 0x29
Aug  4 17:05:12 absurd kernel: [  274.551593] kvm: enabling virtualization on CPU27
Aug  4 17:05:12 absurd kernel: [  274.554027] Intel pstate controlling: cpu 27
Aug  4 17:05:12 absurd kernel: [  274.554072] CPU27 is up
Aug  4 17:05:12 absurd kernel: [  274.554255] smpboot: Booting Node 1 Processor 28 APIC 0x31
Aug  4 17:05:12 absurd kernel: [  274.567608] kvm: enabling virtualization on CPU28
Aug  4 17:05:12 absurd kernel: [  274.570070] Intel pstate controlling: cpu 28
Aug  4 17:05:12 absurd kernel: [  274.570116] CPU28 is up
Aug  4 17:05:12 absurd kernel: [  274.570287] smpboot: Booting Node 1 Processor 29 APIC 0x33
Aug  4 17:05:12 absurd kernel: [  274.583581] kvm: enabling virtualization on CPU29
Aug  4 17:05:12 absurd kernel: [  274.585997] Intel pstate controlling: cpu 29
Aug  4 17:05:12 absurd kernel: [  274.586043] CPU29 is up
Aug  4 17:05:12 absurd kernel: [  274.586222] smpboot: Booting Node 1 Processor 30 APIC 0x35
Aug  4 17:05:12 absurd kernel: [  274.599518] kvm: enabling virtualization on CPU30
Aug  4 17:05:12 absurd kernel: [  274.601955] Intel pstate controlling: cpu 30
Aug  4 17:05:12 absurd kernel: [  274.602001] CPU30 is up
Aug  4 17:05:12 absurd kernel: [  274.602179] smpboot: Booting Node 1 Processor 31 APIC 0x37
Aug  4 17:05:12 absurd kernel: [  274.615457] kvm: enabling virtualization on CPU31
Aug  4 17:05:12 absurd kernel: [  274.617922] Intel pstate controlling: cpu 31
Aug  4 17:05:12 absurd kernel: [  274.617967] CPU31 is up
Aug  4 17:05:12 absurd kernel: [  274.723789] PM: noirq restore of devices complete after 16.674 msecs
Aug  4 17:05:12 absurd kernel: [  274.724300] PM: early restore of devices complete after 0.450 msecs
Aug  4 17:05:12 absurd kernel: [  274.896491] pcieport 0000:00:01.1: System wakeup disabled by ACPI
Aug  4 17:05:12 absurd kernel: [  274.896564] usb usb1: root hub lost power or was reset
Aug  4 17:05:12 absurd kernel: [  274.896565] usb usb2: root hub lost power or was reset
Aug  4 17:05:12 absurd kernel: [  274.896747] igb 0000:02:00.1: irq 99 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896750] igb 0000:02:00.0: irq 100 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896754] igb 0000:02:00.1: irq 101 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896760] igb 0000:02:00.0: irq 102 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896762] igb 0000:02:00.1: irq 103 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896767] igb 0000:02:00.0: irq 104 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896772] igb 0000:02:00.1: irq 105 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896776] igb 0000:02:00.0: irq 106 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896780] igb 0000:02:00.1: irq 107 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896786] igb 0000:02:00.0: irq 111 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896789] igb 0000:02:00.1: irq 112 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896797] igb 0000:02:00.0: irq 113 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896800] igb 0000:02:00.1: irq 114 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896805] igb 0000:02:00.0: irq 115 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896808] igb 0000:02:00.1: irq 116 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896813] igb 0000:02:00.0: irq 117 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896815] igb 0000:02:00.1: irq 118 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.896820] igb 0000:02:00.0: irq 119 for MSI/MSI-X
Aug  4 17:05:12 absurd kernel: [  274.897210] serial 00:03: activated
Aug  4 17:05:12 absurd kernel: [  274.897672] serial 00:04: activated
Aug  4 17:05:12 absurd kernel: [  274.898361] sd 1:0:0:0: [sda] Starting disk
Aug  4 17:05:12 absurd kernel: [  274.898397] sd 2:0:0:0: [sdb] Starting disk
Aug  4 17:05:12 absurd kernel: [  274.898438] sd 5:0:0:0: [sdc] Starting disk
Aug  4 17:05:12 absurd kernel: [  274.898464] sd 6:0:0:0: [sdd] Starting disk
Aug  4 17:05:12 absurd kernel: [  274.900456] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
Aug  4 17:05:12 absurd kernel: [  274.900457] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
Aug  4 17:05:12 absurd kernel: [  274.900463] ------------[ cut here ]------------
Aug  4 17:05:12 absurd kernel: [  274.900469] WARNING: CPU: 11 PID: 5849 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:05:12 absurd kernel: [  274.900501] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop raid1 hid_logitech_dj usb_storage snd_hda_codec_hdmi nvidia(PO) x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm joydev crct10dif_pclmul crc32_pclmul hid_generic iTCO_wdt ghash_clmulni_intel iTCO_vendor_support snd_hda_codec_ca0132 mxm_wmi aesni_intel evdev usbhid aes_x86_64 hid ablk_helper cryptd glue_helper lrw snd_hda_intel gf128mul snd_hda_controller snd_hda_codec pcspkr sb_edac snd_hwdep edac_core snd_pcm snd_seq snd_seq_device snd_timer i2c_i801 snd lpc_ich mfd_core mei_me soundcore ioatdma mei tpm_tis tpm ipmi_si ipmi_msghandler wmi processor thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci ehci_pci scsi_transport_sas ehci_hcd libata usbcore 
Aug  4 17:05:12 absurd kernel: igb i2c_algo_bit scsi_mod usb_common i2c_core dca ptp pps_core
Aug  4 17:05:12 absurd kernel: [  274.900515] CPU: 11 PID: 5849 Comm: kworker/u66:7 Tainted: P           O  3.16.0-vanilla.1 #1
Aug  4 17:05:12 absurd kernel: [  274.900516] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:05:12 absurd kernel: [  274.900520] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:05:12 absurd kernel: [  274.900522]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:05:12 absurd kernel: [  274.900523]  ffffffff810664f6 ffffffffa093909b ffff881056783d20 ffff881057af3040
Aug  4 17:05:12 absurd kernel: [  274.900524]  ffff88107f41fc90 ffff881057558000 ffffffff813a7d3b ffff881055cdce00
Aug  4 17:05:12 absurd kernel: [  274.900525] Call Trace:
Aug  4 17:05:12 absurd kernel: [  274.900531]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:05:12 absurd kernel: [  274.900534]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:05:12 absurd kernel: [  274.900537]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:05:12 absurd kernel: [  274.900539]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:05:12 absurd kernel: [  274.900542]  [<ffffffffa093803f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:05:12 absurd kernel: [  274.900546]  [<ffffffffa0290e21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:05:12 absurd kernel: [  274.900549]  [<ffffffffa0290f17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:05:12 absurd kernel: [  274.900553]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:05:12 absurd kernel: [  274.900555]  [<ffffffffa0290951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:05:12 absurd kernel: [  274.900558]  [<ffffffffa0292776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:05:12 absurd kernel: [  274.900560]  [<ffffffffa0304070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:05:12 absurd kernel: [  274.900563]  [<ffffffffa0383c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:05:12 absurd kernel: [  274.900566]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:05:12 absurd kernel: [  274.900570]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:05:12 absurd kernel: [  274.900572]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:05:12 absurd kernel: [  274.900573]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:05:12 absurd kernel: [  274.900574]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:05:12 absurd kernel: [  274.900577]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:05:12 absurd kernel: [  274.900579]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:05:12 absurd kernel: [  274.900582]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:05:12 absurd kernel: [  274.900583]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:05:12 absurd kernel: [  274.900585]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:05:12 absurd kernel: [  274.900586]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:05:12 absurd kernel: [  274.900587]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:05:12 absurd kernel: [  274.900589]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:05:12 absurd kernel: [  274.900590] ---[ end trace 6e31c737d4270bf9 ]---
Aug  4 17:05:12 absurd kernel: [  274.900591] snd_hda_intel 0000:83:00.0: firmware: ctefx.bin will not be loaded
Aug  4 17:05:12 absurd kernel: [  275.215262] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:05:12 absurd kernel: [  275.215797] ata1.00: configured for UDMA/133
Aug  4 17:05:12 absurd kernel: [  275.223220] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Aug  4 17:05:12 absurd kernel: [  275.231234] ata3: SATA link down (SStatus 0 SControl 300)
Aug  4 17:05:12 absurd kernel: [  275.231289] usb 1-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:05:12 absurd kernel: [  275.231293] usb 2-1: reset high-speed USB device number 2 using ehci-pci
Aug  4 17:05:12 absurd kernel: [  275.239208] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug  4 17:05:12 absurd kernel: [  275.240787] ata4.00: configured for UDMA/100
Aug  4 17:05:12 absurd kernel: [  275.245012] ata2.00: configured for UDMA/133
Aug  4 17:05:12 absurd kernel: [  275.247197] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:05:12 absurd kernel: [  275.250457] ata5.00: configured for UDMA/133
Aug  4 17:05:12 absurd kernel: [  275.367134] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Aug  4 17:05:12 absurd kernel: [  275.378756] ata6.00: configured for UDMA/133
Aug  4 17:05:12 absurd kernel: [  275.643314] usb 1-1.6: reset full-speed USB device number 3 using ehci-pci
Aug  4 17:05:12 absurd kernel: [  275.831057] usb 2-1.2: reset low-speed USB device number 4 using ehci-pci
Aug  4 17:05:12 absurd kernel: [  276.182835] usb 2-1.3: reset high-speed USB device number 5 using ehci-pci
Aug  4 17:05:12 absurd kernel: [  276.346742] usb 2-1.1: reset high-speed USB device number 3 using ehci-pci
Aug  4 17:05:12 absurd kernel: [  276.554795] usb 2-1.3.1: reset high-speed USB device number 6 using ehci-pci
Aug  4 17:05:12 absurd kernel: [  276.734513] usb 2-1.3.3: reset full-speed USB device number 7 using ehci-pci
Aug  4 17:05:12 absurd kernel: [  276.906490] PM: restore of devices complete after 2011.275 msecs
Aug  4 17:05:12 absurd kernel: [  276.910882] hid-generic 0003:0665:5161.0009: hiddev0,hidraw2: USB HID v1.00 Device [INNO TECH USB to Serial] on usb-0000:00:1d.0-1.2/input0
Aug  4 17:05:12 absurd kernel: [  276.911592] PM: Image restored successfully.
Aug  4 17:05:12 absurd kernel: [  276.911949] PM: Basic memory bitmaps freed
Aug  4 17:05:12 absurd kernel: [  276.911951] Restarting tasks ... 
Aug  4 17:05:12 absurd kernel: [  276.913556] usb 2-1.2: usbfs: process 4398 (blazer_usb) did not claim interface 0 before use
Aug  4 17:05:12 absurd kernel: [  276.913924] done.
Aug  4 17:05:12 absurd acpid: client connected from 4387[0:0]
Aug  4 17:05:12 absurd acpid: 1 client rule loaded
Aug  4 17:05:12 absurd acpid: client connected from 4387[0:0]
Aug  4 17:05:12 absurd acpid: 1 client rule loaded
Aug  4 17:05:13 absurd acpid: client connected from 4387[0:0]
Aug  4 17:05:13 absurd acpid: 1 client rule loaded
Aug  4 17:05:13 absurd acpid: client connected from 4387[0:0]
Aug  4 17:05:13 absurd acpid: 1 client rule loaded
Aug  4 17:05:14 absurd NetworkManager[4201]: <info> (eth0): carrier now ON (device state 100)
Aug  4 17:05:14 absurd kernel: [  278.229770] igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Aug  4 17:05:15 absurd upsmon[4429]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:05:15 absurd upsmon[4429]: Communications with UPS duo2pro@localhost lost
Aug  4 17:05:17 absurd kernel: imklog 5.8.11, log source = /proc/kmsg started.
Aug  4 17:05:17 absurd rsyslogd: [origin software="rsyslogd" swVersion="5.8.11" x-pid="5977" x-info="http://www.rsyslog.com"] start
Aug  4 17:05:17 absurd salomea: ========== resume complete ===========
Aug  4 17:05:32 router dhcpd: DHCPDISCOVER from 00:25:90:ce:a1:20 via eth0
Aug  4 17:05:32 router dhcpd: DHCPOFFER on 192.168.16.231 to 00:25:90:ce:a1:20 via eth0
Aug  4 17:05:18 absurd upsmon[4429]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:05:32 router dhcpd: DHCPREQUEST for 192.168.16.231 (192.168.16.1) from 00:25:90:ce:a1:20 via eth0
Aug  4 17:05:32 router dhcpd: DHCPACK on 192.168.16.231 to 00:25:90:ce:a1:20 via eth0
Aug  4 17:05:21 absurd upsmon[4429]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:05:24 absurd upsmon[4429]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:05:27 absurd upsmon[4429]: Poll UPS [duo2pro@localhost] failed - Driver not connected
Aug  4 17:05:30 absurd upsmon[4429]: Poll UPS [duo2pro@localhost] failed - Driver not connected

--MP_/cEJe+m.7nh.4DHL/+fQKd3_--
