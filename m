Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965399AbaH0VJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:09:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933809AbaH0VJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:09:43 -0400
Date: Wed, 27 Aug 2014 16:09:28 -0500
From: Clark Williams <williams@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Subject: [PATCH RT]  rt: add rwsem_is_contended() definition to rwsem_rt.h
Message-ID: <20140827160928.6f323642@sluggy>
Organization: Red Hat, Inc
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Chg.jXDUw.DpAsyvoMAecDr"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Chg.jXDUw.DpAsyvoMAecDr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Thomas,

The latest btrfs code uses rwsem_is_contended() in the function
caching_thread(). On RT systems, include/linux/rwsem.h is replaced with
include/linux/rwsem_rt.h which does not provide a definition for
rwsem_is_contended().  This commit provides a definition that should
work on RT (where the lock is actually an rt_mutex).

Signed-off-by: Clark Williams <williams@redhat.com>
---
 include/linux/rwsem_rt.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/rwsem_rt.h b/include/linux/rwsem_rt.h
index e94d945c5844..77035d7abc04 100644
--- a/include/linux/rwsem_rt.h
+++ b/include/linux/rwsem_rt.h
@@ -125,4 +125,9 @@ static inline void down_write_nest_lock(struct rw_semap=
hore *sem,
        rt_down_write_nested_lock(sem, NULL);
 }
 #endif
+
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+       return !plist_head_empty(&sem->lock.wait_list);
+}
 #endif

--Sig_/Chg.jXDUw.DpAsyvoMAecDr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/kkOAAoJEEersVlSw9NzDfkP/jJcV92Q9WGZysW6639FRuae
C0jx7hf5cmXbjfFdpIfPwF/Av6k09gfxIBnZi4Bgrjc9AyI3OYTwx7pMYXg0g9dg
s7aPHQhONb0qpzhdbN5Y58nYi7qXGPPhCvY5pH8OZsB8gVXcEu2rHAqWl8nsrMJC
zIfB5eUzXOsJEYZ0FoFvpCYgDwqNBZN28HFBMT7ceqKlkzYvMGzwYT+SkeV9RpoG
lKFD2dhnoTbTF4fYzgTp/kocF/kxdv671ZR028MYzCewnMG1G8qC37/3SPSbbqnb
u7S/lTcP447xiwlW0Ldw8QELO3OhzvWkQrP7E9RID/I2lqoSSjUESe4VT2D4uRxN
H+NWzY5025kioSuoGqinqZAbfeWulQ9a6yWnFyOGrlFH7YxtcI+o2SchPnXlR0RR
Ax76MrmX0PBb4mpOauwwdEjT6aI9njtguWXm1ce2oNMXfZmlW63GeYFj7hwYUf3w
AOdHOTxweauWFavoiLdYef2kGqxHCs2SE5LxR7grgkGUIwo/SA2QxvzOdyaeMVkI
6VrjmzIyNrY8i6FIPJkptqbdQWhMFGTTvXfuAvQMJMReoVLevnoyVXI1zFMDdk0f
M4ziZeKFPrQVSelwDor/cdYEsLtln7wVO1oY+ZtVClUxWQlq0EuN74lUj/gxEDvD
jvsyNIWO6H9p460pIvae
=SDKB
-----END PGP SIGNATURE-----

--Sig_/Chg.jXDUw.DpAsyvoMAecDr--
