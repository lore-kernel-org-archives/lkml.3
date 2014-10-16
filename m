Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbaJPEcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 00:32:39 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:62209 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaJPEci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 00:32:38 -0400
MIME-Version: 1.0
In-Reply-To: <543F049F.5090605@gaast.net>
References: <54347520.3050109@gaast.net>
	<543AA2FE.20105@gaast.net>
	<20141012204032.GA11171@amd>
	<9751497.0fL0kvsyX7@vostro.rjw.lan>
	<20141015111641.GC7792@gaast.net>
	<CAErSpo5A+nHTu2Y6KrXowBBCBsNw_hO0SRsnc6YRdJChCUmO6w@mail.gmail.com>
	<CAE9FiQV9t0bCfUy5Fichdk=04ruEVxGv-LUK1xxZjCrasAOACg@mail.gmail.com>
	<543F049F.5090605@gaast.net>
Date: Wed, 15 Oct 2014 21:32:37 -0700
X-Google-Sender-Auth: QfWETiQA6uncTWziBEW6bm8nvK8
Message-ID: <CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c326fef69934050582bc44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c326fef69934050582bc44
Content-Type: text/plain; charset=UTF-8

On Wed, Oct 15, 2014 at 4:34 PM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
>
> Is there anything I can do now to find out why your change is causing my
> machine to crash?

Can you please try attached patch? that should workaround the problem.

as some driver is using pci_enable_device in .resume instead of
pci_renable_device....

We should skip the pci_enable_bridge in those pci_enable_device to avoid
contention between async device_resume.

Thanks

Yinghai

--001a11c326fef69934050582bc44
Content-Type: text/x-patch; charset=US-ASCII; 
	name="skip_enable_bridge_on_resume_path.patch"
Content-Disposition: attachment; 
	filename="skip_enable_bridge_on_resume_path.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1bm3bxu0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3BjaS5jIGIvZHJpdmVycy9wY2kvcGNpLmMKaW5kZXgg
NjI1YTRhYy4uNjU2NzgzMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9wY2kvcGNpLmMKKysrIGIvZHJp
dmVycy9wY2kvcGNpLmMKQEAgLTEyNjYsNyArMTI2Niw2IEBAIHN0YXRpYyB2b2lkIHBjaV9lbmFi
bGVfYnJpZGdlKHN0cnVjdCBwY2lfZGV2ICpkZXYpCiAKIHN0YXRpYyBpbnQgcGNpX2VuYWJsZV9k
ZXZpY2VfZmxhZ3Moc3RydWN0IHBjaV9kZXYgKmRldiwgdW5zaWduZWQgbG9uZyBmbGFncykKIHsK
LQlzdHJ1Y3QgcGNpX2RldiAqYnJpZGdlOwogCWludCBlcnI7CiAJaW50IGksIGJhcnMgPSAwOwog
CkBAIC0xMjg1LDkgKzEyODQsMTkgQEAgc3RhdGljIGludCBwY2lfZW5hYmxlX2RldmljZV9mbGFn
cyhzdHJ1Y3QgcGNpX2RldiAqZGV2LCB1bnNpZ25lZCBsb25nIGZsYWdzKQogCWlmIChhdG9taWNf
aW5jX3JldHVybigmZGV2LT5lbmFibGVfY250KSA+IDEpCiAJCXJldHVybiAwOwkJLyogYWxyZWFk
eSBlbmFibGVkICovCiAKLQlicmlkZ2UgPSBwY2lfdXBzdHJlYW1fYnJpZGdlKGRldik7Ci0JaWYg
KGJyaWRnZSkKLQkJcGNpX2VuYWJsZV9icmlkZ2UoYnJpZGdlKTsKKwkvKgorCSAqIERvIG5vdCBl
bmFibGUgYnJpZGdlIGFnYWluIG9uIHJlc3VtZSBwYXRoLCBhcyBwYXJlbnQgc3RhdGUKKwkgKiBn
ZXQgcmVzdG9yZWQgYmVmb3JlLgorCSAqIEFsc28gY291bGQgYXZvaWQgZGVsYXkgYmV0d2VlbiBk
aWZmZXJlbnQgYXN5bmMgcmVzdW1lLgorCSAqLworCWlmICghKGRldi0+ZGV2LnBvd2VyLmlzX3N1
c3BlbmRlZCB8fAorCSAgICAgIGRldi0+ZGV2LnBvd2VyLmlzX25vaXJxX3N1c3BlbmRlZCB8fAor
CSAgICAgIGRldi0+ZGV2LnBvd2VyLmlzX2xhdGVfc3VzcGVuZGVkKSkgeworCQlzdHJ1Y3QgcGNp
X2RldiAqYnJpZGdlID0gcGNpX3Vwc3RyZWFtX2JyaWRnZShkZXYpOworCisJCWlmIChicmlkZ2Up
CisJCQlwY2lfZW5hYmxlX2JyaWRnZShicmlkZ2UpOworCX0KIAogCS8qIG9ubHkgc2tpcCBzcmlv
diByZWxhdGVkICovCiAJZm9yIChpID0gMDsgaSA8PSBQQ0lfUk9NX1JFU09VUkNFOyBpKyspCg==
--001a11c326fef69934050582bc44--
