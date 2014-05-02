Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaEBRWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:22:01 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:48670 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaEBRWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:22:00 -0400
MIME-Version: 1.0
In-Reply-To: <5363CA91.7070203@canonical.com>
References: <5363CA91.7070203@canonical.com>
Date: Fri, 2 May 2014 13:21:59 -0400
Message-ID: <CADnq5_OeiqpDZoPcAccKJn9Tvzz-euNJou4LhZqNKOH64F+7dw@mail.gmail.com>
Subject: Re: Lenovo x120e resume regression in 3.15-rc1 bisected to
 'drm/crtc-helpers: fix dpms on logic'
From: Alex Deucher <alexdeucher@gmail.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: multipart/mixed; boundary=047d7bf16274e9bfdb04f86e0485
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bf16274e9bfdb04f86e0485
Content-Type: text/plain; charset=UTF-8

On Fri, May 2, 2014 at 12:40 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> I've bisected a resume regression on a Lenovo x120e to
> 177cf92de4aa97ec1435987e91696ed8b5023130 (drm/crtc-helpers: fix dpms on
> logic). Everything works fine with this patch reverted on top of
> 3.15-rc3. I realize it is correcting a coding error that has been in
> place since 3.11, but it is also causing this laptop to resume to a
> black screen wherein the platform appears to be locked up (no console,
> no network). See attached bisect log and lspci. The BIOS version is 1.15.
>

Does the attached patch help?  I haven't had a chance to unwind all
the logic in the crtc helper code.

Alex

--047d7bf16274e9bfdb04f86e0485
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-drm-radeon-force-connector-dpm-state-to-ON-on-modese.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-force-connector-dpm-state-to-ON-on-modese.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hupqz28n2

RnJvbSBkYzMxOGIyYzg1ODNkMzcyNmM2NDE3NzAyNGQ3NzdjOTQwOGQzNTM4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IEZyaSwgMiBNYXkgMjAxNCAxMzoxODoyMyAtMDQwMApTdWJqZWN0OiBbUEFUQ0hd
IGRybS9yYWRlb246IGZvcmNlIGNvbm5lY3RvciBkcG0gc3RhdGUgdG8gT04gb24gbW9kZXNldAoK
V2UgdHVybiB0aGUgZGlzcGxheSBvbiBhcyBwYXJ0IG9mIHRoZSBtb2Rlc2V0LCBzbyBtYXJrIGl0
CmFzIHN1Y2guCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVy
QGFtZC5jb20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19lbmNvZGVycy5j
IHwgNCArKysrCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19lbmNvZGVycy5jIGIvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9hdG9tYmlvc19lbmNvZGVycy5jCmluZGV4IGU2ZWI1MDkuLjBiYTAyNWMgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZW5jb2RlcnMuYworKysg
Yi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2VuY29kZXJzLmMKQEAgLTIzOTcsOSAr
MjM5NywxMyBAQCBzdGF0aWMgdm9pZCByYWRlb25fYXRvbV9lbmNvZGVyX3ByZXBhcmUoc3RydWN0
IGRybV9lbmNvZGVyICplbmNvZGVyKQogCiBzdGF0aWMgdm9pZCByYWRlb25fYXRvbV9lbmNvZGVy
X2NvbW1pdChzdHJ1Y3QgZHJtX2VuY29kZXIgKmVuY29kZXIpCiB7CisJc3RydWN0IGRybV9jb25u
ZWN0b3IgKmNvbm5lY3RvciA9IHJhZGVvbl9nZXRfY29ubmVjdG9yX2Zvcl9lbmNvZGVyKGVuY29k
ZXIpOworCiAJLyogbmVlZCB0byBjYWxsIHRoaXMgaGVyZSBhcyB3ZSBuZWVkIHRoZSBjcnRjIHNl
dCB1cCAqLwogCXJhZGVvbl9hdG9tX2VuY29kZXJfZHBtcyhlbmNvZGVyLCBEUk1fTU9ERV9EUE1T
X09OKTsKIAlyYWRlb25fYXRvbV9vdXRwdXRfbG9jayhlbmNvZGVyLCBmYWxzZSk7CisJaWYgKGNv
bm5lY3RvcikKKwkJY29ubmVjdG9yLT5kcG1zID0gRFJNX01PREVfRFBNU19PTjsKIH0KIAogc3Rh
dGljIHZvaWQgcmFkZW9uX2F0b21fZW5jb2Rlcl9kaXNhYmxlKHN0cnVjdCBkcm1fZW5jb2RlciAq
ZW5jb2RlcikKLS0gCjEuOC4zLjEKCg==
--047d7bf16274e9bfdb04f86e0485--
