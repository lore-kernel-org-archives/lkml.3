Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbaIQHq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 03:46:27 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34692 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaIQHqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 03:46:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX1pfciTcuF3_eggQLCn=LvTSLTT0UZxTb+z_RaLHwgJQ@mail.gmail.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
	<1386546869-31900-3-git-send-email-yinghai@kernel.org>
	<CAErSpo6VvV21DyHuHLcsA+_KPQcYdAWXtaVbZGUA-M9+iji0fw@mail.gmail.com>
	<CAE9FiQUWFoyg_7TPaBVftpojCocNu0=1yWtqKTBvkQkRhNOnhg@mail.gmail.com>
	<CAErSpo5+jY-P-9iUj0RVqyZzXwQcq9m9PqWKzZDU0yjK=4gAeQ@mail.gmail.com>
	<CAE9FiQXf6w0u+JLu-JHd45ofSTShaB0MoMNbck9EE-y3u6B98w@mail.gmail.com>
	<52A8BAC5.70006@canonical.com>
	<CAE9FiQV8mfF6SMTbZN5H+DmyuM0663wQyoKYJDa7MiBR4i7XQg@mail.gmail.com>
	<52D01D82.5070202@canonical.com>
	<CAE9FiQUD0XvPJNFNMoqX6J67TKuGcj+pSbj+iPUf=fvC-4UXOQ@mail.gmail.com>
	<54189BCE.2010206@canonical.com>
	<CAE9FiQX1pfciTcuF3_eggQLCn=LvTSLTT0UZxTb+z_RaLHwgJQ@mail.gmail.com>
Date: Wed, 17 Sep 2014 00:46:24 -0700
X-Google-Sender-Auth: k36n6QQA48KL3eL0nld1Va-Hl_U
Message-ID: <CAE9FiQWphiORhaVNNVGZXY6eYxLH2QYNbHcLdjzrBD98tMKz0Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: Only enable realloc auto when root bus has 64bit mmio
From: Yinghai Lu <yinghai@kernel.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary=90e6ba614fec911ff305033e1010
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba614fec911ff305033e1010
Content-Type: text/plain; charset=UTF-8

On Tue, Sep 16, 2014 at 3:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Sep 16, 2014 at 1:21 PM, Joseph Salisbury
> <joseph.salisbury@canonical.com> wrote:
>>
>> A new bug[0] was opened due to enabling PCI_REALLOC_ENABLE_AUTO, which
>> is similar to the original bug[1] we discussed.
>>
>> Just wondering if there have been any additional ideas on realloc since
>> this was last discussed?
>>
>> [0] http://pad.lv/1363313
>
> So the resource realloc do work as expected. but LSI firmware has some
> problem again?
>
> We may need to add command after the reset the bridge resource.

Can you try attached patch?

Thanks

Yinghai

--90e6ba614fec911ff305033e1010
Content-Type: text/x-patch; charset=US-ASCII; name="reset_lsi_pci_devices.patch"
Content-Disposition: attachment; filename="reset_lsi_pci_devices.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i06d7jpq0

LS0tCiBkcml2ZXJzL3BjaS9zZXR1cC1idXMuYyB8ICAgMTYgKysrKysrKysrKysrKysrKwogMSBm
aWxlIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKykKCkluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9w
Y2kvc2V0dXAtYnVzLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9wY2kv
c2V0dXAtYnVzLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9zZXR1cC1idXMuYwpAQCAtMTYx
NSw2ICsxNjE1LDIyIEBAIGFnYWluOgogCQkJCQkJIGZhaWxfcmVzLT5mbGFncyAmIHR5cGVfbWFz
aywKIAkJCQkJCSByZWxfdHlwZSk7CiAKKwkvKiByZXNldCBMU0kgZGV2aWNlICovCisJbGlzdF9m
b3JfZWFjaF9lbnRyeShmYWlsX3JlcywgJmZhaWxfaGVhZCwgbGlzdCkgeworCQlzdHJ1Y3QgcGNp
X2RldiAqcGRldjsKKwkJc3RydWN0IHBjaV9idXMgKnBidXMgPSBmYWlsX3Jlcy0+ZGV2LT5idXM7
CisKKwkJaWYgKHBjaV9pc19yb290X2J1cyhwYnVzKSB8fCAhcGJ1cy0+c2VsZikKKwkJCWNvbnRp
bnVlOworCisJCS8qIExTSSBkZXZpY2UgZmlybXdhcmUgaXMgbm90IGhhcHB5IHdpdGggY2hhbmdp
bmcgQkFSIHZhbHVlICovCisJCWxpc3RfZm9yX2VhY2hfZW50cnkocGRldiwgJnBidXMtPmRldmlj
ZXMsIGJ1c19saXN0KQorCQkJaWYgKHBkZXYtPnZlbmRvciA9PSBQQ0lfVkVORE9SX0lEX0xTSV9M
T0dJQykgeworCQkJCXBjaV9yZXNldF9zZWNvbmRhcnlfYnVzKHBidXMtPnNlbGYpOworCQkJCWJy
ZWFrOworCQkJfQorCX0KKwogCS8qIHJlc3RvcmUgc2l6ZSBhbmQgZmxhZ3MgKi8KIAlsaXN0X2Zv
cl9lYWNoX2VudHJ5KGZhaWxfcmVzLCAmZmFpbF9oZWFkLCBsaXN0KSB7CiAJCXN0cnVjdCByZXNv
dXJjZSAqcmVzID0gZmFpbF9yZXMtPnJlczsK
--90e6ba614fec911ff305033e1010--
