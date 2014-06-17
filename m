Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbaFQXjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 19:39:15 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:39971 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbaFQXjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 19:39:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140617221620.GC30559@google.com>
References: <1402346730-2508-1-git-send-email-andreas.noever@gmail.com>
	<20140617221620.GC30559@google.com>
Date: Tue, 17 Jun 2014 16:39:12 -0700
X-Google-Sender-Auth: _63GxXCrAuBsl_naQtDI4boeQkU
Message-ID: <CAE9FiQXD7hvt0cUYMzvq0r6CbZn=iJZc7BHRaF2nACbG7qwuBQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Do not touch siblings in pci_assign_unassigned_bridge_resources
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b10ca01aae09504fc10a6a3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b10ca01aae09504fc10a6a3
Content-Type: text/plain; charset=UTF-8

On Tue, Jun 17, 2014 at 3:16 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Yinghai]
>
> On Mon, Jun 09, 2014 at 10:45:30PM +0200, Andreas Noever wrote:
>> The problem can be reproduced by having two sibling hotplug bridges A
>> and B. The problem will occour if the parent of A and B does not have
>> enough resources to satisfy window allocations for B during a hotplug
>> event.

> I don't understand how all this works either.  Yinghai?
>
> We definitely don't want to release resources that are already in use.  Can
> you review and ack or nack this?

Hi Andreas,

Can you check if attached patch fix the problem on your test case?

In some case, if we can not assign pref mmio properly for the bridge,
we may need to even clear non-pref mmio for the bridge.

Thanks

Yinghai

--047d7b10ca01aae09504fc10a6a3
Content-Type: text/x-patch; charset=US-ASCII; name="fix_release_sibling_bridge_res.patch"
Content-Disposition: attachment; 
	filename="fix_release_sibling_bridge_res.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hwjuot350

U3ViamVjdDogW1BBVENIXSBwY2k6IERvbid0IHJlbGVhc2Ugc2liaWxpbmcgYnJpZGdlIHJlc291
cmNlcwoKT24gaG90cGx1ZyBjYXNlLCB3ZSBzaG91bGQgbm90IHRvdWNoIHNpYmxpbmcgYnJpZGdl
cyB0aGF0IGlzIG91dApzaWRlIG9mIHRoZSBzbG90cy4KClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkg
THUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCi0tLQogZHJpdmVycy9wY2kvc2V0dXAtYnVzLmMgfCAg
IDEwICsrKysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvcGNpL3NldHVwLWJ1cy5jCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3NldHVwLWJ1cy5jCisrKyBsaW51eC0y
LjYvZHJpdmVycy9wY2kvc2V0dXAtYnVzLmMKQEAgLTE2NzYsMTAgKzE2NzYsMTYgQEAgYWdhaW46
CiAJICogVHJ5IHRvIHJlbGVhc2UgbGVhZiBicmlkZ2UncyByZXNvdXJjZXMgdGhhdCBkb2Vzbid0
IGZpdCByZXNvdXJjZSBvZgogCSAqIGNoaWxkIGRldmljZSB1bmRlciB0aGF0IGJyaWRnZQogCSAq
LwotCWxpc3RfZm9yX2VhY2hfZW50cnkoZmFpbF9yZXMsICZmYWlsX2hlYWQsIGxpc3QpCi0JCXBj
aV9idXNfcmVsZWFzZV9icmlkZ2VfcmVzb3VyY2VzKGZhaWxfcmVzLT5kZXYtPmJ1cywKKwlsaXN0
X2Zvcl9lYWNoX2VudHJ5KGZhaWxfcmVzLCAmZmFpbF9oZWFkLCBsaXN0KSB7CisJCXN0cnVjdCBw
Y2lfYnVzICpidXMgPSBmYWlsX3Jlcy0+ZGV2LT5idXM7CisKKwkJaWYgKGZhaWxfcmVzLT5kZXYg
PT0gYnJpZGdlKQorCQkJYnVzID0gYnJpZGdlLT5zdWJvcmRpbmF0ZTsKKworCQlwY2lfYnVzX3Jl
bGVhc2VfYnJpZGdlX3Jlc291cmNlcyhidXMsCiAJCQkJCQkgZmFpbF9yZXMtPmZsYWdzICYgdHlw
ZV9tYXNrLAogCQkJCQkJIHdob2xlX3N1YnRyZWUpOworCX0KIAogCS8qIHJlc3RvcmUgc2l6ZSBh
bmQgZmxhZ3MgKi8KIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGZhaWxfcmVzLCAmZmFpbF9oZWFkLCBs
aXN0KSB7Cg==
--047d7b10ca01aae09504fc10a6a3--
