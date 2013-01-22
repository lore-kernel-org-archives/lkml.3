Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab3AVUGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:06:51 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:32786 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab3AVUGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:06:49 -0500
MIME-Version: 1.0
In-Reply-To: <50FEBF35.6010502@zytor.com>
References: <1358868049-19884-1-git-send-email-trenn@suse.de>
	<1358868049-19884-3-git-send-email-trenn@suse.de>
	<50FEB620.3020805@zytor.com>
	<201301221723.03863.trenn@suse.de>
	<50FEBF35.6010502@zytor.com>
Date: Tue, 22 Jan 2013 12:06:47 -0800
X-Google-Sender-Auth: F0z-ftXOiEJ66JNxgQWYDmebBtU
Message-ID: <CAE9FiQWJqWQJhoJb2dBn=iAsKjxuf3MJro-jz+6k+WNZor8-xQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86 e820: Introduce memmap=resetusablemap for kdump usage
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, horms@verge.net.au
Content-Type: multipart/mixed; boundary=14dae9340faf175e1c04d3e61e2f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9340faf175e1c04d3e61e2f
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jan 22, 2013 at 8:32 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Again: Please explain what is bad with this solution.
>> I cannot see a better and more robust way for kdump other than
>> reserving the original reserved memory areas as declared by the BIOS.
>
> It is bad because it creates more complexity than is needed.
>
> The whole point is that what we want is simply to switch type 1 to type
> X, with the sole exceptions being the areas explicitly reserved for the
> kdump kernel.

Do you prefer to  "reserveram" way in attached patch?

Thanks

Yinghai

--14dae9340faf175e1c04d3e61e2f
Content-Type: application/octet-stream; name="e820_reserveram.patch"
Content-Disposition: attachment; filename="e820_reserveram.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hc9h2svn0

LS0tCiBhcmNoL3g4Ni9rZXJuZWwvZTgyMC5jIHwgICAxOCArKysrKysrKysrKysrKysrLS0KIDEg
ZmlsZSBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKSW5kZXg6IGxp
bnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvZTgyMC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5v
cmlnL2FyY2gveDg2L2tlcm5lbC9lODIwLmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwv
ZTgyMC5jCkBAIC04MzYsNiArODM2LDcgQEAgc3RhdGljIGludCBfX2luaXQgcGFyc2VfbWVtb3B0
KGNoYXIgKnApCiBlYXJseV9wYXJhbSgibWVtIiwgcGFyc2VfbWVtb3B0KTsKIAogc3RhdGljIGJv
b2wgX19pbml0ZGF0YSBleGFjdG1hcF9wYXJzZWQ7CitzdGF0aWMgYm9vbCBfX2luaXRkYXRhIHJl
c2VydmVyYW1fcGFyc2VkOwogCiBzdGF0aWMgaW50IF9faW5pdCBwYXJzZV9tZW1tYXBfb25lKGNo
YXIgKnApCiB7CkBAIC04NDUsNyArODQ2LDcgQEAgc3RhdGljIGludCBfX2luaXQgcGFyc2VfbWVt
bWFwX29uZShjaGFyCiAJaWYgKCFwKQogCQlyZXR1cm4gLUVJTlZBTDsKIAotCWlmICghc3RybmNt
cChwLCAiZXhhY3RtYXAiLCA4KSkgeworCWlmICghc3RybmNtcChwLCAiZXhhY3RtYXAiLCA4KSB8
fCAhc3RybmNtcChwLCAicmVzZXJ2ZXJhbSIsIDEwKSkgewogCQlpZiAoZXhhY3RtYXBfcGFyc2Vk
KQogCQkJcmV0dXJuIDA7CiAKQEAgLTg1OCw3ICs4NTksMTEgQEAgc3RhdGljIGludCBfX2luaXQg
cGFyc2VfbWVtbWFwX29uZShjaGFyCiAJCSAqLwogCQlzYXZlZF9tYXhfcGZuID0gZTgyMF9lbmRf
b2ZfcmFtX3BmbigpOwogI2VuZGlmCi0JCWU4MjAubnJfbWFwID0gMDsKKwkJaWYgKCFzdHJuY21w
KHAsICJyZXNlcnZlcmFtIiwgMTApKSB7CisJCQllODIwX3VwZGF0ZV9yYW5nZSgwLCBVTExPTkdf
TUFYLCBFODIwX1JBTSwgRTgyMF9SRVNFUlZFRCk7CisJCQlyZXNlcnZlcmFtX3BhcnNlZCA9IHRy
dWU7CisJCX0gZWxzZQorCQkJZTgyMC5ucl9tYXAgPSAwOwogCQl1c2VyZGVmID0gMTsKIAkJcmV0
dXJuIDA7CiAJfQpAQCAtODcxLDYgKzg3NiwxMCBAQCBzdGF0aWMgaW50IF9faW5pdCBwYXJzZV9t
ZW1tYXBfb25lKGNoYXIKIAl1c2VyZGVmID0gMTsKIAlpZiAoKnAgPT0gJ0AnKSB7CiAJCXN0YXJ0
X2F0ID0gbWVtcGFyc2UocCsxLCAmcCk7CisJCWlmIChyZXNlcnZlcmFtX3BhcnNlZCkgeworCQkJ
LyogcmVtb3ZlIG9sZCByZXNlcnZlZCBzbyBuZXcgcmFtIGNvdWxkIHRha2Ugb3ZlciAqLworCQkJ
ZTgyMF9yZW1vdmVfcmFuZ2Uoc3RhcnRfYXQsIG1lbV9zaXplLCBFODIwX1JFU0VSVkVELCAwKTsK
KwkJfQogCQllODIwX2FkZF9yZWdpb24oc3RhcnRfYXQsIG1lbV9zaXplLCBFODIwX1JBTSk7CiAJ
fSBlbHNlIGlmICgqcCA9PSAnIycpIHsKIAkJc3RhcnRfYXQgPSBtZW1wYXJzZShwKzEsICZwKTsK
QEAgLTg5MCw2ICs4OTksMTEgQEAgc3RhdGljIGludCBfX2luaXQgcGFyc2VfbWVtbWFwX29wdChj
aGFyCiAJcCA9IHN0cnN0cihwLCAiZXhhY3RtYXAiKTsKIAlpZiAocCkKIAkJcGFyc2VfbWVtbWFw
X29uZSgiZXhhY3RtYXAiKTsKKwllbHNlIHsKKwkJcCA9IHN0cnN0cihib290X2NvbW1hbmRfbGlu
ZSwgInJlc2VydmVyYW0iKTsKKwkJaWYgKHApCisJCQlwYXJzZV9tZW1tYXBfb25lKCJyZXNlcnZl
cmFtIik7CisJfQogCiAJd2hpbGUgKHN0cikgewogCQljaGFyICprID0gc3RyY2hyKHN0ciwgJywn
KTsK
--14dae9340faf175e1c04d3e61e2f--
