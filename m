Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaGTHci (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 03:32:38 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3315 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbaGTHch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 03:32:37 -0400
Message-ID: <53CB708B.7010508@parallels.com>
Date: Sun, 20 Jul 2014 11:32:27 +0400
From: Vasily Averin <vvs@parallels.com>
Organization: Parallels
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch v2] fs: umount on symlinlk leaks mnt count
Content-Type: multipart/mixed;
 boundary="------------040500000309090907090709"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040500000309090907090709
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

v2: mntget(path->mnt) should not be called if mountpoint_last() returns 1.

Currently umount on symlink blocks following umount:

/vz is separate mount

# ls /vz/ -al | grep test
drwxr-xr-x.  2 root root       4096 Jul 19 01:14 testdir
lrwxrwxrwx.  1 root root         11 Jul 19 01:16 testlink -> /vz/testdir

# umount -l /vz/testlink
umount: /vz/testlink: not mounted (expected)

# lsof /vz
# umount /vz
umount: /vz: device is busy. (unexpected)

In this case mountpoint_last() gets an extra refcount on path->mnt

Signed-off-by:	Vasily Averin <vvs@openvz.org>


--------------040500000309090907090709
Content-Type: text/plain; charset=us-ascii;
 name="diff-umount-symlink-ms-2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff-umount-symlink-ms-2"

ZGlmZiAtLWdpdCBhL2ZzL25hbWVpLmMgYi9mcy9uYW1laS5jCmluZGV4IDk4NWM2ZjMuLjll
Yjc4N2UgMTAwNjQ0Ci0tLSBhL2ZzL25hbWVpLmMKKysrIGIvZnMvbmFtZWkuYwpAQCAtMjI1
Niw5ICsyMjU2LDEwIEBAIGRvbmU6CiAJCWdvdG8gb3V0OwogCX0KIAlwYXRoLT5kZW50cnkg
PSBkZW50cnk7Ci0JcGF0aC0+bW50ID0gbW50Z2V0KG5kLT5wYXRoLm1udCk7CisJcGF0aC0+
bW50ID0gbmQtPnBhdGgubW50OwogCWlmIChzaG91bGRfZm9sbG93X2xpbmsoZGVudHJ5LCBu
ZC0+ZmxhZ3MgJiBMT09LVVBfRk9MTE9XKSkKIAkJcmV0dXJuIDE7CisJbW50Z2V0KHBhdGgt
Pm1udCk7CiAJZm9sbG93X21vdW50KHBhdGgpOwogCWVycm9yID0gMDsKIG91dDoK
--------------040500000309090907090709--
