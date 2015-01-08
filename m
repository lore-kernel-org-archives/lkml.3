Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbbAHWLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:11:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344AbbAHWLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:11:54 -0500
Date: Thu, 8 Jan 2015 14:11:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.64
Message-ID: <20150108221152.GA24335@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.64 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                                  |    2=20
 arch/s390/kernel/compat_linux.c                           |    2=20
 arch/x86/include/uapi/asm/ldt.h                           |    7=20
 arch/x86/kernel/kvm.c                                     |    9=20
 arch/x86/kernel/kvmclock.c                                |    1=20
 arch/x86/kernel/process_64.c                              |  101 +++++-
 arch/x86/kernel/tls.c                                     |   39 ++
 crypto/af_alg.c                                           |    3=20
 drivers/md/bitmap.c                                       |   16 -
 drivers/md/dm-bufio.c                                     |   20 +
 drivers/md/persistent-data/dm-space-map-metadata.c        |    4=20
 drivers/mfd/tc6393xb.c                                    |   13=20
 drivers/mmc/card/block.c                                  |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c                 |    2=20
 fs/btrfs/disk-io.c                                        |    6=20
 fs/btrfs/extent-tree.c                                    |   10=20
 fs/btrfs/extent_map.c                                     |    2=20
 fs/ecryptfs/crypto.c                                      |    1=20
 fs/ecryptfs/file.c                                        |   12=20
 fs/ecryptfs/main.c                                        |   16 -
 fs/isofs/rock.c                                           |    9=20
 fs/namespace.c                                            |   11=20
 fs/ncpfs/ioctl.c                                          |    1=20
 fs/nfs/nfs4proc.c                                         |    6=20
 fs/proc/base.c                                            |   53 +++
 fs/udf/symlink.c                                          |   17 -
 include/linux/cred.h                                      |    1=20
 include/linux/user_namespace.h                            |   12=20
 kernel/groups.c                                           |   11=20
 kernel/pid.c                                              |    2=20
 kernel/uid16.c                                            |    2=20
 kernel/user.c                                             |    1=20
 kernel/user_namespace.c                                   |  125 +++++++-
 net/mac80211/key.c                                        |    2=20
 net/mac80211/rx.c                                         |   11=20
 security/keys/encrypted-keys/encrypted.c                  |    5=20
 tools/testing/selftests/mount/unprivileged-remount-test.c |  204 +++++++++=
++---
 37 files changed, 598 insertions(+), 143 deletions(-)

Andreas M=FCller (1):
      mac80211: fix multicast LED blinking and counter

Andy Lutomirski (5):
      x86/tls: Validate TLS entries to protect espfix
      x86/tls: Disallow unusual TLS segments
      x86_64, switch_to(): Load TLS descriptors before switching DS and ES
      x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit
      x86/tls: Don't validate lm in set_thread_area() after all

Baruch Siach (1):
      mmc: block: add newline to sysfs display of force_ro

Dan Carpenter (1):
      dm space map metadata: fix sm_bootstrap_get_nr_blocks()

Darrick J. Wong (1):
      dm bufio: fix memleak when using a dm_buffer's inline bio

Dmitry Eremin-Solenikov (1):
      mfd: tc6393xb: Fail ohci suspend if full state restore is required

Eric W. Biederman (13):
      mnt: Implicitly add MNT_NODEV on remount when it was implicitly added=
 by mount
      mnt: Update unprivileged remount test
      umount: Disallow unprivileged mount force
      groups: Consolidate the setgroups permission checks
      userns: Document what the invariant required for safe unprivileged ma=
ppings.
      userns: Don't allow setgroups until a gid mapping has been setablished
      userns: Don't allow unprivileged creation of gid mappings
      userns: Check euid no fsuid when establishing an unprivileged uid map=
ping
      userns: Only allow the creator of the userns unprivileged mappings
      userns: Rename id_map_mutex to userns_state_mutex
      userns: Add a knob to disable setgroups on a per user namespace basis
      userns: Allow setting gid_maps without privilege when setgroups is di=
sabled
      userns: Unbreak the unprivileged remount tests

Filipe Manana (1):
      Btrfs: fix fs corruption on transaction abort if device supports disc=
ard

Greg Kroah-Hartman (1):
      Linux 3.10.64

Jan Kara (4):
      isofs: Fix infinite looping over CE entries
      isofs: Fix unchecked printing of ER records
      ncpfs: return proper error from NCP_IOC_SETROOT ioctl
      udf: Verify symlink size before loading it

Johannes Berg (1):
      mac80211: free management frame keys when removing station

Josef Bacik (1):
      Btrfs: do not move em to modified list when unpinning

Michael Halcrow (1):
      eCryptfs: Remove buggy and unnecessary write in file name decode rout=
ine

NeilBrown (1):
      md/bitmap: always wait for writes on unplug.

Oleg Nesterov (1):
      exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiti=
ng

Peng Tao (1):
      nfs41: fix nfs4_proc_layoutget error handling

Rabin Vincent (1):
      crypto: af_alg - fix backlog handling

Sumit.Saxena@avagotech.com (1):
      megaraid_sas: corrected return of wait_event from abort frame path

Takashi Iwai (1):
      KEYS: Fix stale key registration at error path

Tyler Hicks (1):
      eCryptfs: Force RO mount when encrypted view is enabled


--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUrwCkAAoJEDjbvchgkmk+b5AP/3cOn9zqxuhtsdJMpx6wkQPq
trUjy4LCyNU/oz52Et5nniaOojJXlL2h287N94CL6V8yC3dpFX5Z86dRvb0fwyDs
XxkxAl5aIyjuj5WYU7aYWYTnYy7XclgSSvqMOstwBTtpMugdbQu2duwtihTL+xR0
XqhfAE8sOEemZUXWyV0Dl5UL839PXToX240OpcdT9rCILYn75XHqaCGnK/F9/8nz
mJRIRS+RUCCplG+Xu7zbN0QmWxSbVqWNuwwl6yTzNv94xMVx7iA1EpWAMZfC5Gfr
4gU5nHbpVsrSwJDcr8TJR8KUn7huAAo18zTT7AjrEcl6v3r6/gMv3Lqi0S3OMF7m
JNhR1KVirDzsSFTWeQsuitT1AfTHDM6Y2GSC5YHyNFds/ikUGAnAFzZYasbdRYkA
nc/mGGmn4Dpm6hhizjbESfe1KAKIMVgL804PoCUZxAKzdYeNZj1gMU8874Qczg+p
YiQY1jYT6EXJxrQsFmKCwmFLdz+mAgXnHNEzBYcbk62z/mxSfIhaYqBjEgKu17GP
ksIyW21dQ5nZGwyZna52PEu/s6O1G2NxgFm/6DPMdnNwArEPejM4KXgCRPx8quvO
hv4Vnk3NgcsRvwJjvFyh9G5YbSjcMazVtQGp6FtLiPf7Ky/dMUeQqNsUim3gusmd
tH7tqb7seX5Ufq9+cVZm
=Ch8n
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
