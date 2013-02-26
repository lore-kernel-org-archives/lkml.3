Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607Ab3BZSOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:14:31 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:62018 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3BZSO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:14:29 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFy7PvVqAN6tLFFuCUALsXsKsuf-yqWso3aZGe4-MkFvuw@mail.gmail.com>
References: <20130223212120.GA4593@google.com>
	<CAE9FiQWDktthNN3aCq-+tqWJU+Cz+PjN57E=pHzBBErCsZ8B7Q@mail.gmail.com>
	<CA+55aFx7jq7ruTN+pnp-4hPHnkr1G-1WAiAJSQYTPr7GOJjExw@mail.gmail.com>
	<CAE9FiQUT+iHHZwn-2OsoJX0zXJ6rt6n0zuT+mLP=M8yFMxmMdg@mail.gmail.com>
	<CA+55aFy7PvVqAN6tLFFuCUALsXsKsuf-yqWso3aZGe4-MkFvuw@mail.gmail.com>
Date: Tue, 26 Feb 2013 10:14:29 -0800
X-Google-Sender-Auth: mq0K6Y8N7xLFv0H_S6YV-m6EKvs
Message-ID: <CAE9FiQUkMqqSE9JJuxt7MxLheQA1j2nKC7QfOB7xLEJ9iUhs7g@mail.gmail.com>
Subject: Re: [GIT PULL] PCI changes for v3.9
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e89a8f234e59e5dfd904d6a4a0e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f234e59e5dfd904d6a4a0e5
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Feb 26, 2013 at 8:13 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Feb 25, 2013 at 10:46 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Mon, Feb 25, 2013 at 9:19 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>>
>>> Also, my *gut* feel is that the new _handle_hotplug_event_root()
>>> function should do that whole dance with
>>> acpi_scan_lock_acquire()/acpi_scan_lock_release(), but I didn't really
>>> know if it's required or appropriate, so I left it alone. Could you
>>> take a look?
>>
>> Yes, we need that for root bridge hot add path.
>>
>> for hot remove path, we already have lock acquire/release in
>> acpi_bus_hot_remove_device().
>>
>> Please check attached patch for hot add path.
>
> Quite frankly, doing this in handle_root_bridge_insertion() doesn't
> match the pattern elsewhere. Elsewhere you also protected the whole
> acpi_get_name() lookup etc. Which is why I felt that it would make
> more sense to add this to _handle_hotplug_event_root().
>
> But there may be good reasons why the root bridge case is different,
> and I don't have strong opinions, I just wanted people to look at his
> case. I'll let you and Bjorn sort it out...

ok,

Bjorn, Rafael,

Can you please check if you are ok with attached patch ?

Thanks

Yinghai

--e89a8f234e59e5dfd904d6a4a0e5
Content-Type: application/octet-stream; 
	name="fix_acpi_pci_root_acquire_lock.patch"
Content-Disposition: attachment; 
	filename="fix_acpi_pci_root_acquire_lock.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdndj07b0

U3ViamVjdDogW1BBVENIXSBQQ0ksIEFDUEk6IGhvbGQgYWNwaV9zY2FuX2xvY2sgZHVyaW5nIHJv
b3QgYnVzIGhvdHBsdWcKCkR1cmluZyBtZXJnaW5nIHBjaSB0cmVlIHdpdGggcG0vYWNwaSB0cmVl
LCBMaW51cyBub3RpY2VkIHRoYXQKd2UgZG9uJ3QgaGF2ZSBzYW1lIGxvY2sgdXNpbmcgcGF0dGVu
IGFib3V0IGFjcGkgcGNpIHJvb3QgYXMKYWNwaXBocC4KCkhlcmUgYXBwbHkgc2FtZSBsb2NrIHBh
dHRlbiwgYW5kIHdlIG5lZWQgdG8gY2hhbmdlCmFjcGlfYnVzX2hvdF9yZW1vdmVfZGV2aWNlIGV4
ZWN1dGluZyB2aWEgYWNwaV9vc19ob3RwbHVnX2V4ZWN1dGUoKQphcyBpdCBhbHNvIGhvbGQgdGhl
IGxvY2sgaW4gYWNwaV9idXNfaG90X3JlbW92ZV9kZXZpY2UuCgpUaGF0IHdpbGwgbWFrZSBhY3Bp
X2J1c19ob3RfcmVtb3ZlX2RldmljZSBjYWxsaW5nIHRoZSBzYW1lIGFzIG90aGVyCmNhbGxlcnMu
CgpSZXBvcnRlZC1ieTogTGludXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24u
b3JnPgpTaWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CgotLS0K
IGRyaXZlcnMvYWNwaS9wY2lfcm9vdC5jIHwgICAgOSArKysrKysrLS0KIDEgZmlsZSBjaGFuZ2Vk
LCA3IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpJbmRleDogbGludXgtMi42L2RyaXZl
cnMvYWNwaS9wY2lfcm9vdC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMv
YWNwaS9wY2lfcm9vdC5jCisrKyBsaW51eC0yLjYvZHJpdmVycy9hY3BpL3BjaV9yb290LmMKQEAg
LTY1Miw2ICs2NTIsNyBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfcm9vdF9icmlkZ2VfaW5zZXJ0aW9u
CiAKIHN0YXRpYyB2b2lkIGhhbmRsZV9yb290X2JyaWRnZV9yZW1vdmFsKHN0cnVjdCBhY3BpX2Rl
dmljZSAqZGV2aWNlKQogeworCWFjcGlfc3RhdHVzIHN0YXR1czsKIAlzdHJ1Y3QgYWNwaV9lamVj
dF9ldmVudCAqZWpfZXZlbnQ7CiAKIAllal9ldmVudCA9IGttYWxsb2Moc2l6ZW9mKCplal9ldmVu
dCksIEdGUF9LRVJORUwpOwpAQCAtNjY3LDcgKzY2OCw5IEBAIHN0YXRpYyB2b2lkIGhhbmRsZV9y
b290X2JyaWRnZV9yZW1vdmFsKHMKIAllal9ldmVudC0+ZGV2aWNlID0gZGV2aWNlOwogCWVqX2V2
ZW50LT5ldmVudCA9IEFDUElfTk9USUZZX0VKRUNUX1JFUVVFU1Q7CiAKLQlhY3BpX2J1c19ob3Rf
cmVtb3ZlX2RldmljZShlal9ldmVudCk7CisJc3RhdHVzID0gYWNwaV9vc19ob3RwbHVnX2V4ZWN1
dGUoYWNwaV9idXNfaG90X3JlbW92ZV9kZXZpY2UsIGVqX2V2ZW50KTsKKwlpZiAoQUNQSV9GQUlM
VVJFKHN0YXR1cykpCisJCWtmcmVlKGVqX2V2ZW50KTsKIH0KIAogc3RhdGljIHZvaWQgX2hhbmRs
ZV9ob3RwbHVnX2V2ZW50X3Jvb3Qoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQpAQCAtNjgyLDgg
KzY4NSw5IEBAIHN0YXRpYyB2b2lkIF9oYW5kbGVfaG90cGx1Z19ldmVudF9yb290KHMKIAloYW5k
bGUgPSBocF93b3JrLT5oYW5kbGU7CiAJdHlwZSA9IGhwX3dvcmstPnR5cGU7CiAKLQlyb290ID0g
YWNwaV9wY2lfZmluZF9yb290KGhhbmRsZSk7CisJYWNwaV9zY2FuX2xvY2tfYWNxdWlyZSgpOwog
CisJcm9vdCA9IGFjcGlfcGNpX2ZpbmRfcm9vdChoYW5kbGUpOwogCWFjcGlfZ2V0X25hbWUoaGFu
ZGxlLCBBQ1BJX0ZVTExfUEFUSE5BTUUsICZidWZmZXIpOwogCiAJc3dpdGNoICh0eXBlKSB7CkBA
IC03MTcsNiArNzIxLDcgQEAgc3RhdGljIHZvaWQgX2hhbmRsZV9ob3RwbHVnX2V2ZW50X3Jvb3Qo
cwogCQlicmVhazsKIAl9CiAKKwlhY3BpX3NjYW5fbG9ja19yZWxlYXNlKCk7CiAJa2ZyZWUoaHBf
d29yayk7IC8qIGFsbG9jYXRlZCBpbiBoYW5kbGVfaG90cGx1Z19ldmVudF9icmlkZ2UgKi8KIAlr
ZnJlZShidWZmZXIucG9pbnRlcik7CiB9Cg==
--e89a8f234e59e5dfd904d6a4a0e5--
