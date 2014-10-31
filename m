Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422810AbaJaCNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:13:15 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:63843 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422665AbaJaCNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:13:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWd7wC9ijzgObCcGd9QE+U3_wzjQwafXhV=U61hLxGszg@mail.gmail.com>
References: <543F049F.5090605@gaast.net>
	<CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com>
	<5446D2D8.2090203@gaast.net>
	<CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com>
	<20141022125354.GA3832@gaast.net>
	<CAE9FiQXF-6b4+y-BJmv7ekrCrXKYyhvZDBqVbLeXSPJa0_cToA@mail.gmail.com>
	<544E235C.5010908@gaast.net>
	<CAE9FiQVMaGs=2OMbk6M7x=EhhfaVn5xT_70Sr+rU2Z1HEfjXbw@mail.gmail.com>
	<544EC59D.9080303@gaast.net>
	<CAE9FiQXC7YfzPp43EX5r4KNPhF4jua_Jg_JLBnSTffzAmRaY=g@mail.gmail.com>
	<544EDD40.1040107@gaast.net>
	<CAE9FiQWfV+h5YGxKEg7kSdhD7_OVoEqNyZZqYr=vpDwz1Lnb_g@mail.gmail.com>
	<545027F9.1040703@gaast.net>
	<CAE9FiQXM=uAWPD04o8ic2juEaWVQ=seq=+CBjnPnFdrueY-RjQ@mail.gmail.com>
	<5450B55E.6010103@gaast.net>
	<CAE9FiQUH_Ce4ejnn_GG=QnG=R3jt7jHzYScPy-hqPzBMbFU=EQ@mail.gmail.com>
	<545214C5.6070004@gaast.net>
	<CAE9FiQVZV8xk0haCPo=nikBCNQfawPiw20kdEUGfJ_NdtSi5JQ@mail.gmail.com>
	<5452B3A6.7060100@gaast.net>
	<CAE9FiQUGm-gvqpzPymxqa6vdfV7xhv8-fb433irZE1AT-eNg9A@mail.gmail.com>
	<5452C8BE.3060206@gaast.net>
	<CAE9FiQWd7wC9ijzgObCcGd9QE+U3_wzjQwafXhV=U61hLxGszg@mail.gmail.com>
Date: Thu, 30 Oct 2014 19:13:11 -0700
X-Google-Sender-Auth: g5ksMnCqPSLd2rk5b88wYpigwuo
Message-ID: <CAE9FiQXPZdYndp6rTKxLUkkwX=AQtRVH3JJC=xzQfsehtBgOqA@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7bdc9daee7a08e0506ae8927
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bdc9daee7a08e0506ae8927
Content-Type: text/plain; charset=UTF-8

On Thu, Oct 30, 2014 at 5:43 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Oct 30, 2014 at 4:24 PM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
>>
>>
>> Same problem like this morning: Failure after the second resume already. :-(
>>
> can not find out any magic line in pci_enable_bridge that could cause
> the difference.
>
> so either use attached pcie_enable_bridge_ite.patch or just revert the
> commit 928bea9?

Last try:

Please check attached patch that will keep state consistent.

Thanks

Yinghai

--047d7bdc9daee7a08e0506ae8927
Content-Type: text/x-patch; charset=US-ASCII; name="pci_enable_bridge_ite_x.patch"
Content-Disposition: attachment; filename="pci_enable_bridge_ite_x.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1wwqltf2

LS0tCiBkcml2ZXJzL3BjaS9wY2kuYyB8ICAgMjAgKysrKysrKysrKysrKysrKysrKysKIDEgZmls
ZSBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvcGNp
L3BjaS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3BjaS5jCisr
KyBsaW51eC0yLjYvZHJpdmVycy9wY2kvcGNpLmMKQEAgLTEyNjQsNiArMTI2NCwyNiBAQCBzdGF0
aWMgdm9pZCBwY2lfZW5hYmxlX2JyaWRnZShzdHJ1Y3QgcGNpCiAJcGNpX3NldF9tYXN0ZXIoZGV2
KTsKIH0KIAorc3RhdGljIHZvaWQgcGNpX2VuYWJsZV9pdGUoc3RydWN0IHBjaV9kZXYgKmRldikK
K3sKKyAgICAgICAgdTE2IGNtZDsKKworCS8qCisJICogRlcgZW5hYmxlIHRoZSBicmlkZ2UgYWxy
ZWFkeSwgc28ga2VlcCBlbmFibGVfY250IGNvbnNpc3RlbnQsCisJICogdGhlbiBsYXRlciB3ZSBj
YW4gZ28gdGhyb3VnaCBwY2lfcG1fcmVzdW1lL3BjaV9wbV9yZWVuYWJsZV9kZXZpY2UKKwkgKiB0
byBlbmFibGUgaXQgYWdhaW4uCisJICogLS0tIGZvciBwY2kgYnJpZGdlIHdpdGhvdXQgZHJpdmVy
IGNhc2UuCisJICovCisJaWYgKGNtZCAmIFBDSV9DT01NQU5EX01BU1RFUikKKwkJZGV2LT5pc19i
dXNtYXN0ZXIgPSB0cnVlOworCisJcGNpX3JlYWRfY29uZmlnX3dvcmQoZGV2LCBQQ0lfQ09NTUFO
RCwgJmNtZCk7CisJaWYgKGNtZCAmIChQQ0lfQ09NTUFORF9JTyB8fCBQQ0lfQ09NTUFORF9NRU1P
UlkpKQorCQlhdG9taWNfaW5jKCZkZXYtPmVuYWJsZV9jbnQpOworfQorREVDTEFSRV9QQ0lfRklY
VVBfRklOQUwoUENJX1ZFTkRPUl9JRF9JTlRFTCwgMHgyNDRlLCBwY2lfZW5hYmxlX2l0ZSk7CitE
RUNMQVJFX1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lEX0lURSwgMHg4ODkyLCBwY2lfZW5h
YmxlX2l0ZSk7CisKIHN0YXRpYyBpbnQgcGNpX2VuYWJsZV9kZXZpY2VfZmxhZ3Moc3RydWN0IHBj
aV9kZXYgKmRldiwgdW5zaWduZWQgbG9uZyBmbGFncykKIHsKIAlzdHJ1Y3QgcGNpX2RldiAqYnJp
ZGdlOwo=
--047d7bdc9daee7a08e0506ae8927--
