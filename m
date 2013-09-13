Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3IMTHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:07:38 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38033 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3IMTHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:07:36 -0400
MIME-Version: 1.0
Date: Fri, 13 Sep 2013 15:07:34 -0400
X-Google-Sender-Auth: ulV9XvCgCdavVloqBfFt3dX3AR0
Message-ID: <CA+5PVA7Y-r67u7K5R5XJOEcyCmyTe9Q8fJNQr=6-i1n6QitrPA@mail.gmail.com>
Subject: Fedora Kernel Patch Report
From: Josh Boyer <jwboyer@fedoraproject.org>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Below is a patch report of the various patches Fedora is carrying on
top of the listed upstream kernel, and why we're carrying it.  Greg
said he'd like to see such a report, so I plan on sending one a month
or so.  Feel free to ping me with any questions you have.  Also, if
there's additional info you'd like to see, just let me know.


3.11 based (F19/F20 (this also basically applied to rawhide as well,
which is 3.12 merge window):

net-sctp-fix-ipv6-ipsec-encryption-bug-in-sctp_v6_xmit.patch (rhbz 1007903)
 - Backport of upstream commit
95ee62083cb6453e056562d91f597552021e6ae7 for security reasons.

tuntap-correctly-handle-error-in-tun_set_iff.patch (rhbz 1007741)
  - Backport of upstream commit
662ca437e714caaab855b12415d6ffd815985bc0 for security reasons.

crypto-fix-race-in-larval-lookup.patch (rhbz 1002351)
  - Backport of upstream commit 77dbd7a95e4a4f15264c333a9e9ab97ee27dc2aa

acpi-pcie-hotplug-conflict.patch (rhbz 963991)
  - Backport of upstream commit 3dc48af310709b85d07c8b0d3aa8f1ead02829d3

rt2800-rearrange-bbp-rfcsr-initialization.patch (rhbz 1000679)
  - http://marc.info/?l=linux-wireless&m=137872301718879&w=2

HID-CVE-fixes-3.11.patch
  - This is a backport of all of the HID CVE fixes Kees and Benjamin
did.  I believe all of them are now in Jiri's tree and on their way to
Linus and stable.

mei-me-fix-hardware-reset-flow.patch
  - Fixes MEI reset issues for a number of machines.  Queued for stable.

media-cx23885-Fix-TeVii-S471-regression-since-introduction-of-ts2020.patch
(rhbz 963715)
  - Backport of upstream b43ea8068d2090cb1e44632c8a938ab40d2c7419

iwl3945-better-skb-management-in-rx-path.patch
iwl4965-better-skb-management-in-rx-path.patch (rhbz 977040)
  - Backport of commits 45fe142cefa864b685615bcb930159f6749c3667 and
c1de4a9557d9e25e41fc4ba034b9659152205539

drm-radeon-Disable-writeback-by-default-on-ppc.patch
  - This is something the Fedora ppc secondary team wanted I think.
Posted here:
http://lists.freedesktop.org/archives/dri-devel/2013-June/040059.html

cve-2013-2147-ciss-info-leak.patch (rhbz 971249)
  - Patch from security people.

fix-child-thread-introspection.patch (rhbz 927469)
  - Fixed upstream with commit 73af963f9f3036dffed55c3a2898598186db1045

ath9k_rx_dma_stop_check.patch (rhbz 892811)
  - Fixes some DMA issue on specific hardware.  Taken from
https://dev.openwrt.org/browser/trunk/package/mac80211/patches/552-ath9k_rx_dma_stop_check.patch?rev=34910

vt-Drop-K_OFF-for-VC_MUTE.patch (rhbz 859485)
  - Fixes to vt K_OFF.  This was posted upstream but needs poking.

selinux-apply-different-permission-to-ptrace-child.patch
  - Allow e.g. gdb to only ptrace it's children and not random things.
 Upstream asked Fedora to carry this for a while.  Needs poking.

nowatchdog-on-virt.patch
  - We keep seeing soft lockup detector reports on virt guests where
the host was busy and didn't schedule the guest in time.  We disable
the detector on guests now.

efi-dont-map-boot-services-on-32bit.patch
  - I believe this is queued up in Matt Flemming's tree now.

disable-i8042-check-on-apple-mac.patch
  - Bastien added this to fix intermittent hangs on a Macbook Air 1,1.
 Should probably poke at it.

secure-modules.patch
modsign-uefi.patch
sb-hibernate.patch
sysrq-secure-boot.patch
  - Fedora secure boot support.

keys-expand-keyring.patch
 - Patches from David Howells to expand keyrings.  Can be found in his git tree.

keys-krb-support.patch
  - Patches from David Howells to support KRB usecases with keyrings.
Can be found in his git tree.

keys-x509-improv.patch
  - Patches from David Howells to improve x509 cert support, including
introducing a system_trusted_keyring.  Can be found in his git tree.

crash-driver.patch
  - The patch to add /dev/crash.  Dave Anderson keeps making this work (mostly).

taint-vbox.patch
  - We rebase the kernel often.  Virtual Box breaks when we do it.  We
don't support Virtual Box, so we taint it with the C flag.  We could
likely drop this as it is automatically tainted with O now.

There are a crapton of ARM patches.  I'm not going to go over those
because I honestly have no idea what they're for, where a lot of them
come from, or what their upstream status is.

We have a small number of debug or "silence stupid messages" patches
that have been there for years.  They're minor.

josh
