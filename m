Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaFSElG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 00:41:06 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:49700 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaFSElD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 00:41:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAMxnaaWWuNeNbnUe++N=2bBfs5JyKiq7tHH+_kiQZyQ9aakEHg@mail.gmail.com>
References: <1402346730-2508-1-git-send-email-andreas.noever@gmail.com>
	<20140617221620.GC30559@google.com>
	<CAE9FiQXD7hvt0cUYMzvq0r6CbZn=iJZc7BHRaF2nACbG7qwuBQ@mail.gmail.com>
	<CAMxnaaWWuNeNbnUe++N=2bBfs5JyKiq7tHH+_kiQZyQ9aakEHg@mail.gmail.com>
Date: Wed, 18 Jun 2014 21:41:02 -0700
X-Google-Sender-Auth: 2xRb44xWVrYQLBrIlIKiNW94790
Message-ID: <CAE9FiQVQ657vDOhdhBq5VC044qt6TUF7FKP_-qy+35g71e56Yg@mail.gmail.com>
Subject: Re: [PATCH] PCI: Do not touch siblings in pci_assign_unassigned_bridge_resources
From: Yinghai Lu <yinghai@kernel.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: multipart/mixed; boundary=90e6ba6e8108ebb06e04fc28fbeb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba6e8108ebb06e04fc28fbeb
Content-Type: text/plain; charset=UTF-8

On Wed, Jun 18, 2014 at 3:40 PM, Andreas Noever
<andreas.noever@gmail.com> wrote:
> On Wed, Jun 18, 2014 at 1:39 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> It seems to fix the testcase (no unwanted resources are released). But
> why do you reassign bus and not just skip the top level bridge? If one
> of the allocations below bridge failed then a resource of that device
> will be in fail_res and bridge->subordinate will get released anyways?
> Also by not removing fail_res from the list you trigger the code in
> the next loop for the top level bridge (in particular the res->flags =
> 0 line looks dangerous).

Should not be dangerous, just second try.

>
> Could you explain why this function attempts to assign resources two
> times? In which scenario will a second attempt be successful?

For example, at first mmio is assigned (by firmware), but pref mmio fails,
then before second try,  mmio get cleared, then we could separate
mmio and mmio pref. So need to try again for pref mmio.

Also I missed one MEM_64 for hotplug path.

So we need two patches.

Thanks

Yinghai

--90e6ba6e8108ebb06e04fc28fbeb
Content-Type: text/x-patch; charset=US-ASCII; name="fix_release_sibling_bridge_res.patch"
Content-Disposition: attachment; 
	filename="fix_release_sibling_bridge_res.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hwlkz2960

U3ViamVjdDogW1BBVENIXSBwY2k6IERvbid0IHJlbGVhc2Ugc2liaWxpbmcgYnJpZGdlIHJlc291
cmNlcwoKT24gaG90cGx1ZyBjYXNlLCB3ZSBzaG91bGQgbm90IHRvdWNoIHNpYmxpbmcgYnJpZGdl
cyB0aGF0IGlzIG91dApzaWRlIG9mIHRoZSBzbG90cy4KClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkg
THUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCi0tLQogZHJpdmVycy9wY2kvc2V0dXAtYnVzLmMgfCAg
IDEyICsrKysrKysrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMyBkZWxl
dGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9wY2kvc2V0dXAtYnVzLmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9wY2kvc2V0dXAtYnVzLmMKKysrIGxpbnV4
LTIuNi9kcml2ZXJzL3BjaS9zZXR1cC1idXMuYwpAQCAtMTY3NiwxMCArMTY3NiwxNiBAQCBhZ2Fp
bjoKIAkgKiBUcnkgdG8gcmVsZWFzZSBsZWFmIGJyaWRnZSdzIHJlc291cmNlcyB0aGF0IGRvZXNu
J3QgZml0IHJlc291cmNlIG9mCiAJICogY2hpbGQgZGV2aWNlIHVuZGVyIHRoYXQgYnJpZGdlCiAJ
ICovCi0JbGlzdF9mb3JfZWFjaF9lbnRyeShmYWlsX3JlcywgJmZhaWxfaGVhZCwgbGlzdCkKLQkJ
cGNpX2J1c19yZWxlYXNlX2JyaWRnZV9yZXNvdXJjZXMoZmFpbF9yZXMtPmRldi0+YnVzLAorCWxp
c3RfZm9yX2VhY2hfZW50cnkoZmFpbF9yZXMsICZmYWlsX2hlYWQsIGxpc3QpIHsKKwkJc3RydWN0
IHBjaV9idXMgKmJ1cyA9IGZhaWxfcmVzLT5kZXYtPmJ1czsKKworCQlpZiAoZmFpbF9yZXMtPmRl
diA9PSBicmlkZ2UpCisJCQlidXMgPSBicmlkZ2UtPnN1Ym9yZGluYXRlOworCisJCXBjaV9idXNf
cmVsZWFzZV9icmlkZ2VfcmVzb3VyY2VzKGJ1cywKIAkJCQkJCSBmYWlsX3Jlcy0+ZmxhZ3MgJiB0
eXBlX21hc2ssCiAJCQkJCQkgd2hvbGVfc3VidHJlZSk7CisJfQogCiAJLyogcmVzdG9yZSBzaXpl
IGFuZCBmbGFncyAqLwogCWxpc3RfZm9yX2VhY2hfZW50cnkoZmFpbF9yZXMsICZmYWlsX2hlYWQs
IGxpc3QpIHsK
--90e6ba6e8108ebb06e04fc28fbeb
Content-Type: text/x-patch; charset=US-ASCII; name="assign_unassigned_bridge_MEM_64.patch"
Content-Disposition: attachment; 
	filename="assign_unassigned_bridge_MEM_64.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hwlkz9yh1

U3ViamVjdDogW1BBVENIXSBwY2k6IEFkZCBiYWNrIG1pc3NpbmcgTUVNXzY0IGNoZWNrIGZvciBo
b3RwbHVnIHBhdGgKCldlIG1pc3MgdGhhdCBpbgp8ICBjb21taXQgNWIyODU0MTU1MmVmNWVlZmZj
NDFkNjkzNjEwNWYzOGMyNTA4ZTU2Ngp8ICAgIFBDSTogUmVzdHJpY3QgNjQtYml0IHByZWZldGNo
YWJsZSBicmlkZ2Ugd2luZG93cyB0byA2NC1iaXQgcmVzb3VyY2VzCmZvciBwY2kgaG90cGx1ZyBw
YXRoLgoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0t
CiBkcml2ZXJzL3BjaS9zZXR1cC1idXMuYyB8ICAgIDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKSW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9z
ZXR1cC1idXMuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL3BjaS9zZXR1
cC1idXMuYworKysgbGludXgtMi42L2RyaXZlcnMvcGNpL3NldHVwLWJ1cy5jCkBAIC0xNjUyLDcg
KzE2NTIsNyBAQCB2b2lkIHBjaV9hc3NpZ25fdW5hc3NpZ25lZF9icmlkZ2VfcmVzb3VyCiAJc3Ry
dWN0IHBjaV9kZXZfcmVzb3VyY2UgKmZhaWxfcmVzOwogCWludCByZXR2YWw7CiAJdW5zaWduZWQg
bG9uZyB0eXBlX21hc2sgPSBJT1JFU09VUkNFX0lPIHwgSU9SRVNPVVJDRV9NRU0gfAotCQkJCSAg
SU9SRVNPVVJDRV9QUkVGRVRDSDsKKwkJCQkgIElPUkVTT1VSQ0VfUFJFRkVUQ0ggfCBJT1JFU09V
UkNFX01FTV82NDsKIAogYWdhaW46CiAJX19wY2lfYnVzX3NpemVfYnJpZGdlcyhwYXJlbnQsICZh
ZGRfbGlzdCk7Cg==
--90e6ba6e8108ebb06e04fc28fbeb--
