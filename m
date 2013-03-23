Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3CWIis (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 04:38:48 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:53055 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3CWIio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 04:38:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVZ5VZDo1KCun6SDonTJ=TGWLxm5zJQN5U4f1_52cKKwg@mail.gmail.com>
References: <CAE9FiQVZ5VZDo1KCun6SDonTJ=TGWLxm5zJQN5U4f1_52cKKwg@mail.gmail.com>
Date: Sat, 23 Mar 2013 01:38:43 -0700
X-Google-Sender-Auth: LMCb9pOMNenvIFBs4yoih3O1CJk
Message-ID: <CAE9FiQUarQVqzB_VSMqUrMvSHryrSN3_4tLTEJqygDFzB7uDUw@mail.gmail.com>
Subject: Re: pm/linux-next cause network stop working with qemu-kvm/e1000
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Bob Moore <robert.moore@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=14dae9340b49e2117604d8937f03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9340b49e2117604d8937f03
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Mar 22, 2013 at 5:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> c13085e519e8984fede41fa3d6a5502523b10996 is the first bad commit
> commit c13085e519e8984fede41fa3d6a5502523b10996
> Author: Bob Moore <robert.moore@intel.com>
> Date:   Fri Mar 8 09:19:38 2013 +0000
>
>     ACPICA: Resource Mgr: Prevent infinite loops in resource walks
>
>     Add checks for zero-length resource descriptors in all code that
>     loops through a resource descriptor list. This prevents possible
>     infinite loops because the length is used to increment the traveral
>     pointer and detect the end-of-descriptor.
>
>     Signed-off-by: Bob Moore <robert.moore@intel.com>
>     Signed-off-by: Lv Zheng <lv.zheng@intel.com>
>     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> :040000 040000 84f29d6ee654ffe4c935ce9023208019b2ef09a5
> c8a6613be9a5a130f69e654c5b560a8adb2174db M      drivers
>
>
> long delay after
> calling  ip_auto_config+0x0/0xea4 @ 1
>
> also happen on one 8 sockets nehalem-ex.
>
> If I revert that commit, network works again.

Attached patch fix the problem. Please fold it into offending patch in
pm/linux-next.

Thanks

Yinghai

--14dae9340b49e2117604d8937f03
Content-Type: application/octet-stream; name="fix_x.patch"
Content-Disposition: attachment; filename="fix_x.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hemizep50

LS0tCiBkcml2ZXJzL2FjcGkvcGNpX2xpbmsuYyB8ICAgIDEgKwogMSBmaWxlIGNoYW5nZWQsIDEg
aW5zZXJ0aW9uKCspCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvYWNwaS9wY2lfbGluay5jCj09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvYWNwaS9wY2lfbGluay5jCisrKyBs
aW51eC0yLjYvZHJpdmVycy9hY3BpL3BjaV9saW5rLmMKQEAgLTM1NCw2ICszNTQsNyBAQCBzdGF0
aWMgaW50IGFjcGlfcGNpX2xpbmtfc2V0KHN0cnVjdCBhY3BpCiAKIAl9CiAJcmVzb3VyY2UtPmVu
ZC50eXBlID0gQUNQSV9SRVNPVVJDRV9UWVBFX0VORF9UQUc7CisJcmVzb3VyY2UtPmVuZC5sZW5n
dGggPSBzaXplb2Yoc3RydWN0IGFjcGlfcmVzb3VyY2UpOwogCiAJLyogQXR0ZW1wdCB0byBzZXQg
dGhlIHJlc291cmNlICovCiAJc3RhdHVzID0gYWNwaV9zZXRfY3VycmVudF9yZXNvdXJjZXMobGlu
ay0+ZGV2aWNlLT5oYW5kbGUsICZidWZmZXIpOwo=
--14dae9340b49e2117604d8937f03--
