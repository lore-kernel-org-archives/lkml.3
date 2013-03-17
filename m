Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab3CQVur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 17:50:47 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:62007 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab3CQVup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 17:50:45 -0400
MIME-Version: 1.0
Date: Sun, 17 Mar 2013 14:50:44 -0700
X-Google-Sender-Auth: -jJ5E6YzabXBgAmriiM3oeciQ8s
Message-ID: <CANeU7QkMd_evQrJL1Otp3j3CR9FAXSXO9VOKSFmESkWPZNMkEA@mail.gmail.com>
Subject: [RFC PATCH] kbuild: avoid some unnecessary rebuild
From: Christopher Li <sparse@chrisli.org>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d041c5f724980ae04d825dd2e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d041c5f724980ae04d825dd2e
Content-Type: text/plain; charset=ISO-8859-1

In the current tip of git tree. If I do a allmodconfig full build, then follow
by a "make" again without changing any code in the tree.
There are some object will always get rebuild. e.g. eboot.o.
I use "make V=2", it shows that the rebuild is due to some object file
not in $(targets). I did not understand the $(targets) very well, the
Kbuild.include mention that It is likely a bug in the kbuild if that
happen.

I add them in the $(targets) and that seems avoid the unnecessary
rebuild of several objects. The second "make" has fewer output.
The clean rebuild seems works fine too.

Chris

--f46d041c5f724980ae04d825dd2e
Content-Type: application/octet-stream; 
	name="kbuild-avoid-rebuild-some-object.patch"
Content-Disposition: attachment; 
	filename="kbuild-avoid-rebuild-some-object.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_heep743q0

dXNhZ2U6IGdpdCBbLS12ZXJzaW9uXSBbLS1leGVjLXBhdGhbPTxwYXRoPl1dIFstLWh0bWwtcGF0
aF0gWy0tbWFuLXBhdGhdIFstLWluZm8tcGF0aF0KICAgICAgICAgICBbLXB8LS1wYWdpbmF0ZXwt
LW5vLXBhZ2VyXSBbLS1uby1yZXBsYWNlLW9iamVjdHNdIFstLWJhcmVdCiAgICAgICAgICAgWy0t
Z2l0LWRpcj08cGF0aD5dIFstLXdvcmstdHJlZT08cGF0aD5dIFstLW5hbWVzcGFjZT08bmFtZT5d
CiAgICAgICAgICAgWy1jIG5hbWU9dmFsdWVdIFstLWhlbHBdCiAgICAgICAgICAgPGNvbW1hbmQ+
IFs8YXJncz5dCgpUaGUgbW9zdCBjb21tb25seSB1c2VkIGdpdCBjb21tYW5kcyBhcmU6CiAgIGFk
ZCAgICAgICAgQWRkIGZpbGUgY29udGVudHMgdG8gdGhlIGluZGV4CiAgIGJpc2VjdCAgICAgRmlu
ZCBieSBiaW5hcnkgc2VhcmNoIHRoZSBjaGFuZ2UgdGhhdCBpbnRyb2R1Y2VkIGEgYnVnCiAgIGJy
YW5jaCAgICAgTGlzdCwgY3JlYXRlLCBvciBkZWxldGUgYnJhbmNoZXMKICAgY2hlY2tvdXQgICBD
aGVja291dCBhIGJyYW5jaCBvciBwYXRocyB0byB0aGUgd29ya2luZyB0cmVlCiAgIGNsb25lICAg
ICAgQ2xvbmUgYSByZXBvc2l0b3J5IGludG8gYSBuZXcgZGlyZWN0b3J5CiAgIGNvbW1pdCAgICAg
UmVjb3JkIGNoYW5nZXMgdG8gdGhlIHJlcG9zaXRvcnkKICAgZGlmZiAgICAgICBTaG93IGNoYW5n
ZXMgYmV0d2VlbiBjb21taXRzLCBjb21taXQgYW5kIHdvcmtpbmcgdHJlZSwgZXRjCiAgIGZldGNo
ICAgICAgRG93bmxvYWQgb2JqZWN0cyBhbmQgcmVmcyBmcm9tIGFub3RoZXIgcmVwb3NpdG9yeQog
ICBncmVwICAgICAgIFByaW50IGxpbmVzIG1hdGNoaW5nIGEgcGF0dGVybgogICBpbml0ICAgICAg
IENyZWF0ZSBhbiBlbXB0eSBnaXQgcmVwb3NpdG9yeSBvciByZWluaXRpYWxpemUgYW4gZXhpc3Rp
bmcgb25lCiAgIGxvZyAgICAgICAgU2hvdyBjb21taXQgbG9ncwogICBtZXJnZSAgICAgIEpvaW4g
dHdvIG9yIG1vcmUgZGV2ZWxvcG1lbnQgaGlzdG9yaWVzIHRvZ2V0aGVyCiAgIG12ICAgICAgICAg
TW92ZSBvciByZW5hbWUgYSBmaWxlLCBhIGRpcmVjdG9yeSwgb3IgYSBzeW1saW5rCiAgIHB1bGwg
ICAgICAgRmV0Y2ggZnJvbSBhbmQgbWVyZ2Ugd2l0aCBhbm90aGVyIHJlcG9zaXRvcnkgb3IgYSBs
b2NhbCBicmFuY2gKICAgcHVzaCAgICAgICBVcGRhdGUgcmVtb3RlIHJlZnMgYWxvbmcgd2l0aCBh
c3NvY2lhdGVkIG9iamVjdHMKICAgcmViYXNlICAgICBGb3J3YXJkLXBvcnQgbG9jYWwgY29tbWl0
cyB0byB0aGUgdXBkYXRlZCB1cHN0cmVhbSBoZWFkCiAgIHJlc2V0ICAgICAgUmVzZXQgY3VycmVu
dCBIRUFEIHRvIHRoZSBzcGVjaWZpZWQgc3RhdGUKICAgcm0gICAgICAgICBSZW1vdmUgZmlsZXMg
ZnJvbSB0aGUgd29ya2luZyB0cmVlIGFuZCBmcm9tIHRoZSBpbmRleAogICBzaG93ICAgICAgIFNo
b3cgdmFyaW91cyB0eXBlcyBvZiBvYmplY3RzCiAgIHN0YXR1cyAgICAgU2hvdyB0aGUgd29ya2lu
ZyB0cmVlIHN0YXR1cwogICB0YWcgICAgICAgIENyZWF0ZSwgbGlzdCwgZGVsZXRlIG9yIHZlcmlm
eSBhIHRhZyBvYmplY3Qgc2lnbmVkIHdpdGggR1BHCgpTZWUgJ2dpdCBoZWxwIDxjb21tYW5kPicg
Zm9yIG1vcmUgaW5mb3JtYXRpb24gb24gYSBzcGVjaWZpYyBjb21tYW5kLgo=
--f46d041c5f724980ae04d825dd2e--
