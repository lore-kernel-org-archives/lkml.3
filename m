Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbaIVPSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:18:47 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:62908 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:18:46 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1409220042400.2595@hermes-1.csi.cam.ac.uk>
References: <Pine.LNX.4.64.1409220042400.2595@hermes-1.csi.cam.ac.uk>
Date: Mon, 22 Sep 2014 08:18:44 -0700
X-Google-Sender-Auth: 86On0XqU4w3M4BWPJ6cUnWUy-7E
Message-ID: <CA+55aFyYpe=oyF9yVqF3E6t4ZCpHAdnLj1g36FWUDZydW9mdgQ@mail.gmail.com>
Subject: Re: [PATCH] Fix nasty 32-bit overflow bug in buffer i/o code.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11339e067cf78a0503a8f7e7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11339e067cf78a0503a8f7e7
Content-Type: text/plain; charset=UTF-8

On Sun, Sep 21, 2014 at 5:53 PM, Anton Altaparmakov <aia21@cam.ac.uk> wrote:
>
> This patch fixes this issue by type casting "index" to sector_t before
> doing the left shift.

Ugh. Does the simpler patch to just pass in "block" work as well?

                    Linus

--001a11339e067cf78a0503a8f7e7
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i0dylfzo0

IGZzL2J1ZmZlci5jIHwgNSArKy0tLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9idWZmZXIuYyBiL2ZzL2J1ZmZlci5jCmlu
ZGV4IDhmMDUxMTFiYmI4Yi4uZjMyZDZhM2NmZjM4IDEwMDY0NAotLS0gYS9mcy9idWZmZXIuYwor
KysgYi9mcy9idWZmZXIuYwpAQCAtMTAyMSw4ICsxMDIxLDcgQEAgZ3Jvd19kZXZfcGFnZShzdHJ1
Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBzZWN0b3JfdCBibG9jaywKIAlpZiAocGFnZV9oYXNfYnVm
ZmVycyhwYWdlKSkgewogCQliaCA9IHBhZ2VfYnVmZmVycyhwYWdlKTsKIAkJaWYgKGJoLT5iX3Np
emUgPT0gc2l6ZSkgewotCQkJZW5kX2Jsb2NrID0gaW5pdF9wYWdlX2J1ZmZlcnMocGFnZSwgYmRl
diwKLQkJCQkJCWluZGV4IDw8IHNpemViaXRzLCBzaXplKTsKKwkJCWVuZF9ibG9jayA9IGluaXRf
cGFnZV9idWZmZXJzKHBhZ2UsIGJkZXYsIGJsb2NrLCBzaXplKTsKIAkJCWdvdG8gZG9uZTsKIAkJ
fQogCQlpZiAoIXRyeV90b19mcmVlX2J1ZmZlcnMocGFnZSkpCkBAIC0xMDQzLDcgKzEwNDIsNyBA
QCBncm93X2Rldl9wYWdlKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIHNlY3Rvcl90IGJsb2Nr
LAogCSAqLwogCXNwaW5fbG9jaygmaW5vZGUtPmlfbWFwcGluZy0+cHJpdmF0ZV9sb2NrKTsKIAls
aW5rX2Rldl9idWZmZXJzKHBhZ2UsIGJoKTsKLQllbmRfYmxvY2sgPSBpbml0X3BhZ2VfYnVmZmVy
cyhwYWdlLCBiZGV2LCBpbmRleCA8PCBzaXplYml0cywgc2l6ZSk7CisJZW5kX2Jsb2NrID0gaW5p
dF9wYWdlX2J1ZmZlcnMocGFnZSwgYmRldiwgYmxvY2ssIHNpemUpOwogCXNwaW5fdW5sb2NrKCZp
bm9kZS0+aV9tYXBwaW5nLT5wcml2YXRlX2xvY2spOwogZG9uZToKIAlyZXQgPSAoYmxvY2sgPCBl
bmRfYmxvY2spID8gMSA6IC1FTlhJTzsK
--001a11339e067cf78a0503a8f7e7--
