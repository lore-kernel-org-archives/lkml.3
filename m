Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab3DWRYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:24:07 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:34622 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab3DWRYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:24:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAJsYZ5nQg9g73r5yLicq6gAGbKEXVAFqtF2av=heeNtrNSPSWg@mail.gmail.com>
References: <CAJsYZ5kk=J_Sc7w5dbMbkWWv8dXEU0ojKjEKNqH=Q6Tf2f7mQg@mail.gmail.com>
	<20130422142218.GA26760@mwanda>
	<CAG6tG3xc3RHD7sZXaEbg1vLRhFj+6d1wY=us4BfxBfi5y0o4zg@mail.gmail.com>
	<CAJsYZ5nQg9g73r5yLicq6gAGbKEXVAFqtF2av=heeNtrNSPSWg@mail.gmail.com>
Date: Tue, 23 Apr 2013 13:24:04 -0400
Message-ID: <CAG6tG3zcOdkA5QOBhaDzmMvcFSCwbfRAyKuRwXdn6ipOJhTVZQ@mail.gmail.com>
Subject: Re: [BUG] staging: android: ashmem: Deadlock during ashmem_shrink
From: Robert Love <rlove@google.com>
To: Shankar Brahadeeswaran <shankoo77@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, devel@driverdev.osuosl.org,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anjana V Kumar <anjanavk12@gmail.com>
Content-Type: multipart/mixed; boundary=20cf3074b44ab84dd004db0a73b3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3074b44ab84dd004db0a73b3
Content-Type: text/plain; charset=UTF-8

On Tue, Apr 23, 2013 at 12:20 PM, Shankar Brahadeeswaran
<shankoo77@gmail.com> wrote:

> I'm unable to think of a straight forward way to fix this. If you have
> any suggestions please provide the same.
> If we are unable to solve this too with minor mods, as suggested by
> Dan we have to re-look at the locking in this driver.

This doesn't look insurmountable. It isn't necessary AFAICT to hold
ashmem_mutex across shmem_file_setup.

Patch attached (untested).

           Robert

--20cf3074b44ab84dd004db0a73b3
Content-Type: application/octet-stream; name="ashmem-lock-fix.patch"
Content-Disposition: attachment; filename="ashmem-lock-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfvcegkq0

SXQgaXNuJ3QgbmVjZXNzYXJ5IHRvIGhvbGQgYXNobWVtX211dGV4IGFjcm9zcyBzaG1lbV9maWxl
X3NldHVwLgoKIGFzaG1lbS5jIHwgICAgNSArKysrLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQoKU2lnbmVkLW9mZi1ieTogUm9iZXJ0IExvdmUgPHJsb3Zl
QHJsb3ZlLm9yZz4KCi0tLSBsaW51eC1iYXNlL2RyaXZlcnMvc3RhZ2luZy9hbmRyb2lkL2FzaG1l
bS5jCTIwMTMtMDQtMjMgMTM6MTg6MDUuODAzNzEzNjc4IC0wNDAwCisrKyBsaW51eC9kcml2ZXJz
L3N0YWdpbmcvYW5kcm9pZC9hc2htZW0uYwkyMDEzLTA0LTIzIDEzOjIwOjI2Ljg4MzIzODExMCAt
MDQwMApAQCAtMzAwLDEyICszMDAsMTUgQEAKIAlpZiAoIWFzbWEtPmZpbGUpIHsKIAkJY2hhciAq
bmFtZSA9IEFTSE1FTV9OQU1FX0RFRjsKIAkJc3RydWN0IGZpbGUgKnZtZmlsZTsKKwkJbG9mZl90
IHNpemUgPSBhc21hLT5zaXplOwogCiAJCWlmIChhc21hLT5uYW1lW0FTSE1FTV9OQU1FX1BSRUZJ
WF9MRU5dICE9ICdcMCcpCiAJCQluYW1lID0gYXNtYS0+bmFtZTsKIAogCQkvKiAuLi4gYW5kIGFs
bG9jYXRlIHRoZSBiYWNraW5nIHNobWVtIGZpbGUgKi8KLQkJdm1maWxlID0gc2htZW1fZmlsZV9z
ZXR1cChuYW1lLCBhc21hLT5zaXplLCB2bWEtPnZtX2ZsYWdzKTsKKwkJbXV0ZXhfdW5sb2NrKCZh
c2htZW1fbXV0ZXgpOworCQl2bWZpbGUgPSBzaG1lbV9maWxlX3NldHVwKG5hbWUsIHNpemUsIHZt
YS0+dm1fZmxhZ3MpOworCQltdXRleF9sb2NrKCZhc2htZW1fbXV0ZXgpOwogCQlpZiAodW5saWtl
bHkoSVNfRVJSKHZtZmlsZSkpKSB7CiAJCQlyZXQgPSBQVFJfRVJSKHZtZmlsZSk7CiAJCQlnb3Rv
IG91dDsK
--20cf3074b44ab84dd004db0a73b3--
