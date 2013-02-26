Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab3BZGqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:46:46 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:49017 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab3BZGqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:46:45 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx7jq7ruTN+pnp-4hPHnkr1G-1WAiAJSQYTPr7GOJjExw@mail.gmail.com>
References: <20130223212120.GA4593@google.com>
	<CAE9FiQWDktthNN3aCq-+tqWJU+Cz+PjN57E=pHzBBErCsZ8B7Q@mail.gmail.com>
	<CA+55aFx7jq7ruTN+pnp-4hPHnkr1G-1WAiAJSQYTPr7GOJjExw@mail.gmail.com>
Date: Mon, 25 Feb 2013 22:46:44 -0800
X-Google-Sender-Auth: SZ4NqfynIDdHEWRrsodA7Y-N0HY
Message-ID: <CAE9FiQUT+iHHZwn-2OsoJX0zXJ6rt6n0zuT+mLP=M8yFMxmMdg@mail.gmail.com>
Subject: Re: [GIT PULL] PCI changes for v3.9
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d044788d95336c404d69b05ee
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d044788d95336c404d69b05ee
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Feb 25, 2013 at 9:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Feb 23, 2013 at 6:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> Please check if attached diff is right, and hope it could save Linus some time.
>
> Hmm. I did things a bit differently, moving things around more in
> drivers/acpi/internal.h.

Yes, it is better to put them together with acpi_pci_root_init().

>
> Also, my *gut* feel is that the new _handle_hotplug_event_root()
> function should do that whole dance with
> acpi_scan_lock_acquire()/acpi_scan_lock_release(), but I didn't really
> know if it's required or appropriate, so I left it alone. Could you
> take a look?

Yes, we need that for root bridge hot add path.

for hot remove path, we already have lock acquire/release in
acpi_bus_hot_remove_device().

Please check attached patch for hot add path.

Thanks

Yinghai

--f46d044788d95336c404d69b05ee
Content-Type: application/octet-stream; 
	name="fix_acpi_pci_root_acquire_lock.patch"
Content-Disposition: attachment; 
	filename="fix_acpi_pci_root_acquire_lock.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdmozj600

LS0tCiBkcml2ZXJzL2FjcGkvcGNpX3Jvb3QuYyB8ICAgIDIgKysKIDEgZmlsZSBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKykKCkluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9hY3BpL3BjaV9yb290LmMK
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9hY3BpL3BjaV9yb290LmMKKysr
IGxpbnV4LTIuNi9kcml2ZXJzL2FjcGkvcGNpX3Jvb3QuYwpAQCAtNjQwLDggKzY0MCwxMCBAQCBz
dGF0aWMgdm9pZCBoYW5kbGVfcm9vdF9icmlkZ2VfaW5zZXJ0aW9uCiAJCXJldHVybjsKIAl9CiAK
KwlhY3BpX3NjYW5fbG9ja19hY3F1aXJlKCk7CiAJaWYgKGFjcGlfYnVzX3NjYW4oaGFuZGxlKSkK
IAkJcHJpbnRrKEtFUk5fRVJSICJjYW5ub3QgYWRkIGJyaWRnZSB0byBhY3BpIGxpc3RcbiIpOwor
CWFjcGlfc2Nhbl9sb2NrX3JlbGVhc2UoKTsKIH0KIAogc3RhdGljIHZvaWQgaGFuZGxlX3Jvb3Rf
YnJpZGdlX3JlbW92YWwoc3RydWN0IGFjcGlfZGV2aWNlICpkZXZpY2UpCg==
--f46d044788d95336c404d69b05ee--
