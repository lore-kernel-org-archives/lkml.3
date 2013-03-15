Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3COL2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:28:33 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:41204 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3COL2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:28:32 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUUiGeUcbjphz6sY=1oA194a1MQN_FOpkm4=BVNXKmQmfA@mail.gmail.com>
References: <20130314172737.2856af8a9b368bc395d977be@canb.auug.org.au>
	<87li9ptgtq.fsf@rustcorp.com.au>
	<CA+icZUUiGeUcbjphz6sY=1oA194a1MQN_FOpkm4=BVNXKmQmfA@mail.gmail.com>
Date: Fri, 15 Mar 2013 12:28:30 +0100
Message-ID: <CA+icZUXvi49sAzihOJRcuNAzDtAGtj7FvZcmVG3yErEXBypL5w@mail.gmail.com>
Subject: Re: linux-next: manual merge of the signal tree with the modules tree
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>
Content-Type: multipart/mixed; boundary=047d7b5d44044cf0d804d7f4f040
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b5d44044cf0d804d7f4f040
Content-Type: text/plain; charset=UTF-8

On Fri, Mar 15, 2013 at 11:21 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Mar 15, 2013 at 5:41 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>>> Hi Al,
>>>
>>> Today's linux-next merge of the signal tree got a conflict in
>>> include/asm-generic/unistd.h between commit 837718bfd28b
>>> ("CONFIG_SYMBOL_PREFIX: cleanup") from the modules tree and commit
>>> e1b5bb6d1236 ("consolidate cond_syscall and SYSCALL_ALIAS declarations")
>>> from the signal tree.
>>>
>>> The latter moved the cond_syscall stuff to linkage.h, so I applied the
>>> following patch as a merge fixup and can carry the fix as necessary (no
>>> action is required).  I am not sure if this is completely correct or all
>>> that is needed.
>>
>> Your fix looks correct, thanks.
>>
>> I've been forced to update that patch after another round of
>> improvements, so you may need to re-do the merge.
>>
>
> Hi,
>
> I just looked into modules-next...
> The improved version is in [1]...
> ...and contains a file called "kernel/modsign_certificate.S" which is
> NOT in the latest Linux-Next tree [2].
> So, I thought about reverting the one in -next and apply the new one
> from modules-next.
> This is not possible!
>
> $ git log --oneline -2
> d98f244 Merge tag 'next-20130315' of
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next into
> Linux-Next-v20130315
> 1765898 Add linux-next specific files for 20130315
>
> $ LC_ALL=C ls -l kernel/mod*
> -rw-r--r-- 1 wearefam wearefam   458 Mar 15 11:13 kernel/module-internal.h
> -rw-r--r-- 1 wearefam wearefam 99000 Mar 15 11:13 kernel/module.c
> -rw-r--r-- 1 wearefam wearefam  6063 Mar 15 11:13 kernel/module_signing.c
>

OK, renamed: kernel/modsign_certificate.S -> kernel/system_certificates.S... see

commit ebe2e946f60e0012c02a27845bdab70e34cc4202
KEYS: Separate the kernel signature checking keyring from module signing

> Is this a generated file?
> I have attached both patches extracted from Linux-Next [3] and modules-next [4].
> Both patches list changes to "kernel/modsign_certificate.S".
> /me ---> confused!
>
> Can you please enlighten me?
>

Is this attached follow-up correct?

- Sedat -

>
> Regards,
> - Sedat -
>
> [1] http://git.kernel.org/cgit/linux/kernel/git/rusty/linux.git/commit/?h=modules-next&id=b92021b09df70c1609e3547f3d6128dd560be97f
> [2] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/kernel?id=next-20130315
> [3] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/patch/?id=837718bfd28ba5f474c1182ef2639b6949d854fc
> [4] http://git.kernel.org/cgit/linux/kernel/git/rusty/linux.git/patch/?id=b92021b09df70c1609e3547f3d6128dd560be97f
>
>> Cheers,
>> Rusty.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-next" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--047d7b5d44044cf0d804d7f4f040
Content-Type: application/octet-stream; 
	name="0001-CONFIG_SYMBOL_PREFIX-cleanup-improved-version.patch"
Content-Disposition: attachment; 
	filename="0001-CONFIG_SYMBOL_PREFIX-cleanup-improved-version.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_heb9h37v2

RnJvbSA3YzkyMTk1MTc4NGNiYzk3OGE1ZTAxOTNiOTFmMGMzZjhhNDY0ODEwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBGcmksIDE1IE1hciAyMDEzIDEyOjIyOjI2ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gQ09O
RklHX1NZTUJPTF9QUkVGSVg6IGNsZWFudXAgKGltcHJvdmVkIHZlcnNpb24pCgpJbXBvcnQgbWlz
c2luZyBiaXRzIGZyb20gaW1wcm92ZWQgdmVyc2lvbiBwZW5kaW5nIGluIG1vZHVsZXMtbmV4dC4K
ClRoaXMgaXMgYSBmb2xsb3cgdXAgdG8gY29tbWl0IDgzNzcxOGJmZDI4YiAoIkNPTkZJR19TWU1C
T0xfUFJFRklYOiBjbGVhbnVwLiIpCmluIExpbnV4LU5leHQgKG5leHQtMjAxMzAzMTUpLgoKU2ln
bmVkLW9mZi1ieTogU2VkYXQgRGlsZWsgPHNlZGF0LmRpbGVrQGdtYWlsLmNvbT4KLS0tCiBNYWtl
ZmlsZSAgICAgICAgICAgICAgICAgICAgICB8ICAyICstCiBkcml2ZXJzL210ZC9jaGlwcy9nZW5f
cHJvYmUuYyB8ICA4ICsrKysrLS0tCiBpbmNsdWRlL2xpbnV4L2V4cG9ydC5oICAgICAgICB8ICA5
ICsrLS0tLS0tLQogc2NyaXB0cy9tb2QvbW9kcG9zdC5jICAgICAgICAgfCAxNyArKysrKysrKyst
LS0tLS0tLQogNCBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAxOSBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxlCmluZGV4IDEwZmI2YzcuLjBiMDli
YTUgMTAwNjQ0Ci0tLSBhL01ha2VmaWxlCisrKyBiL01ha2VmaWxlCkBAIC0xMzk4LDcgKzEzOTgs
NyBAQCBxdWlldF9jbWRfcm1maWxlcyA9ICQoaWYgJCh3aWxkY2FyZCAkKHJtLWZpbGVzKSksQ0xF
QU4gICAkKHdpbGRjYXJkICQocm0tZmlsZXMpKQogIyBSdW4gZGVwbW9kIG9ubHkgaWYgd2UgaGF2
ZSBTeXN0ZW0ubWFwIGFuZCBkZXBtb2QgaXMgZXhlY3V0YWJsZQogcXVpZXRfY21kX2RlcG1vZCA9
IERFUE1PRCAgJChLRVJORUxSRUxFQVNFKQogICAgICAgY21kX2RlcG1vZCA9ICQoQ09ORklHX1NI
RUxMKSAkKHNyY3RyZWUpL3NjcmlwdHMvZGVwbW9kLnNoICQoREVQTU9EKSBcCi0gICAgICAgICAg
ICAgICAgICAgJChLRVJORUxSRUxFQVNFKSAiJChwYXRzdWJzdCB5LF8sJChDT05GSUdfSEFWRV9T
WU1CT0xfUFJFRklYX1VOREVSU0NPUkUpKSIKKyAgICAgICAgICAgICAgICAgICAkKEtFUk5FTFJF
TEVBU0UpICIkKHBhdHN1YnN0IHksXywkKENPTkZJR19IQVZFX1VOREVSU0NPUkVfU1lNQk9MX1BS
RUZJWCkpIgogCiAjIENyZWF0ZSB0ZW1wb3JhcnkgZGlyIGZvciBtb2R1bGUgc3VwcG9ydCBmaWxl
cwogIyBjbGVhbiBpdCB1cCBvbmx5IHdoZW4gYnVpbGRpbmcgYWxsIG1vZHVsZXMKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbXRkL2NoaXBzL2dlbl9wcm9iZS5jIGIvZHJpdmVycy9tdGQvY2hpcHMvZ2Vu
X3Byb2JlLmMKaW5kZXggMDBkMjBhZC4uNzRkYmI2YiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tdGQv
Y2hpcHMvZ2VuX3Byb2JlLmMKKysrIGIvZHJpdmVycy9tdGQvY2hpcHMvZ2VuX3Byb2JlLmMKQEAg
LTIwNCwxNCArMjA0LDE2IEBAIHN0YXRpYyBpbmxpbmUgc3RydWN0IG10ZF9pbmZvICpjZmlfY21k
c2V0X3Vua25vd24oc3RydWN0IG1hcF9pbmZvICptYXAsCiAJc3RydWN0IGNmaV9wcml2YXRlICpj
ZmkgPSBtYXAtPmZsZHJ2X3ByaXY7CiAJX191MTYgdHlwZSA9IHByaW1hcnk/Y2ZpLT5jZmlxLT5Q
X0lEOmNmaS0+Y2ZpcS0+QV9JRDsKICNpZmRlZiBDT05GSUdfTU9EVUxFUwotCWNoYXIgcHJvYmVu
YW1lWzE2K3NpemVvZihWTUxJTlVYX1NZTUJPTF9QUkVGSVhfU1RSKV07CisJY2hhciBwcm9iZW5h
bWVbc2l6ZW9mKFZNTElOVVhfU1lNQk9MX1NUUihjZmlfY21kc2V0XyU0LjRYKSldOwogCWNmaV9j
bWRzZXRfZm5fdCAqcHJvYmVfZnVuY3Rpb247CiAKLQlzcHJpbnRmKHByb2JlbmFtZSwgVk1MSU5V
WF9TWU1CT0xfUFJFRklYX1NUUiAiY2ZpX2NtZHNldF8lNC40WCIsIHR5cGUpOworCXNwcmludGYo
cHJvYmVuYW1lLCBWTUxJTlVYX1NZTUJPTF9TVFIoY2ZpX2NtZHNldF8lNC40WCksIHR5cGUpOwog
CiAJcHJvYmVfZnVuY3Rpb24gPSBfX3N5bWJvbF9nZXQocHJvYmVuYW1lKTsKIAlpZiAoIXByb2Jl
X2Z1bmN0aW9uKSB7Ci0JCXJlcXVlc3RfbW9kdWxlKHByb2JlbmFtZSArIHNpemVvZihWTUxJTlVY
X1NZTUJPTF9QUkVGSVhfU1RSKS0xKTsKKwkJY2hhciBtb2RuYW1lW3NpemVvZigiY2ZpX2NtZHNl
dF8lNC40WCIpXTsKKwkJc3ByaW50Zihtb2RuYW1lLCAiY2ZpX2NtZHNldF8lNC40WCIsIHR5cGUp
OworCQlyZXF1ZXN0X21vZHVsZShtb2RuYW1lKTsKIAkJcHJvYmVfZnVuY3Rpb24gPSBfX3N5bWJv
bF9nZXQocHJvYmVuYW1lKTsKIAl9CiAKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvZXhwb3J0
LmggYi9pbmNsdWRlL2xpbnV4L2V4cG9ydC5oCmluZGV4IGZjODNiMmEuLjQxMmNkNTAgMTAwNjQ0
Ci0tLSBhL2luY2x1ZGUvbGludXgvZXhwb3J0LmgKKysrIGIvaW5jbHVkZS9saW51eC9leHBvcnQu
aApAQCAtNSwyMiArNSwxNyBAQAogICogdG8gcmVkdWNlIHRoZSBhbW91bnQgb2YgcG9pbnRsZXNz
IGNydWZ0IHdlIGZlZWQgdG8gZ2NjIHdoZW4gb25seQogICogZXhwb3J0aW5nIGEgc2ltcGxlIHN5
bWJvbCBvciB0d28uCiAgKgotICogSWYgeW91IGZlZWwgdGhlIG5lZWQgdG8gYWRkICNpbmNsdWRl
IDxsaW51eC9mb28uaD4gdG8gdGhpcyBmaWxlCi0gKiB0aGVuIHlvdSBhcmUgZG9pbmcgc29tZXRo
aW5nIHdyb25nIGFuZCBzaG91bGQgZ28gYXdheSBzaWxlbnRseS4KLSAqCi0gKiBJZiB5b3UgdGhp
bmsgdGhlIGFib3ZlIGFycm9nYW5jZSBqdXN0IGVuY291cmFnZXMgbW9yZSBwZW9wbGUgdG8gYWRk
Ci0gKiByYW5kb20gY3JhcCB0byB0aGlzIGZpbGUsIHlvdSdyZSBub3QgYWxvbmUuCisgKiBUcnkg
bm90IHRvIGFkZCAjaW5jbHVkZXMgaGVyZS4gIEl0IHNsb3dzIGNvbXBpbGF0aW9uIGFuZCBtYWtl
cyBrZXJuZWwKKyAqIGhhY2tlcnMgcGxhY2UgZ3J1bXB5IGNvbW1lbnRzIGluIGhlYWRlciBmaWxl
cy4KICAqLwogCiAvKiBTb21lIHRvb2xjaGFpbnMgdXNlIGEgYF8nIHByZWZpeCBmb3IgYWxsIHVz
ZXIgc3ltYm9scy4gKi8KICNpZmRlZiBDT05GSUdfSEFWRV9VTkRFUlNDT1JFX1NZTUJPTF9QUkVG
SVgKICNkZWZpbmUgX19WTUxJTlVYX1NZTUJPTCh4KSBfIyN4CiAjZGVmaW5lIF9fVk1MSU5VWF9T
WU1CT0xfU1RSKHgpICJfIiAjeAotI2RlZmluZSBWTUxJTlVYX1NZTUJPTF9QUkVGSVhfU1RSICJf
IgogI2Vsc2UKICNkZWZpbmUgX19WTUxJTlVYX1NZTUJPTCh4KSB4CiAjZGVmaW5lIF9fVk1MSU5V
WF9TWU1CT0xfU1RSKHgpICN4Ci0jZGVmaW5lIFZNTElOVVhfU1lNQk9MX1BSRUZJWF9TVFIgIiIK
ICNlbmRpZgogCiAvKiBJbmRpcmVjdCwgc28gbWFjcm9zIGFyZSBleHBhbmRlZCBiZWZvcmUgcGFz
dGluZy4gKi8KZGlmZiAtLWdpdCBhL3NjcmlwdHMvbW9kL21vZHBvc3QuYyBiL3NjcmlwdHMvbW9k
L21vZHBvc3QuYwppbmRleCA2OTg1MDIxLi4yODJkZWNmIDEwMDY0NAotLS0gYS9zY3JpcHRzL21v
ZC9tb2Rwb3N0LmMKKysrIGIvc2NyaXB0cy9tb2QvbW9kcG9zdC5jCkBAIC02MzAsMTQgKzYzMCwx
NSBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfbW9kdmVyc2lvbnMoc3RydWN0IG1vZHVsZSAqbW9kLCBz
dHJ1Y3QgZWxmX2luZm8gKmluZm8sCiAJCX0KICNlbmRpZgogCi0JCWlmIChtZW1jbXAoc3ltbmFt
ZSwgVk1MSU5VWF9TWU1CT0xfUFJFRklYX1NUUiwKLQkJCSAgIHN0cmxlbihWTUxJTlVYX1NZTUJP
TF9QUkVGSVhfU1RSKSkgPT0gMCkgewotCQkJbW9kLT51bnJlcyA9Ci0JCQkgIGFsbG9jX3N5bWJv
bChzeW1uYW1lICsKLQkJCSAgICAgICAgICAgICAgIHN0cmxlbihWTUxJTlVYX1NZTUJPTF9QUkVG
SVhfU1RSKSwKLQkJCSAgICAgICAgICAgICAgIEVMRl9TVF9CSU5EKHN5bS0+c3RfaW5mbykgPT0g
U1RCX1dFQUssCi0JCQkgICAgICAgICAgICAgICBtb2QtPnVucmVzKTsKLQkJfQorI2lmZGVmIENP
TkZJR19IQVZFX1VOREVSU0NPUkVfU1lNQk9MX1BSRUZJWAorCQlpZiAoc3ltbmFtZVswXSAhPSAn
XycpCisJCQlicmVhazsKKwkJZWxzZQorCQkJc3ltbmFtZSsrOworI2VuZGlmCisJCW1vZC0+dW5y
ZXMgPSBhbGxvY19zeW1ib2woc3ltbmFtZSwKKwkJCQkJICBFTEZfU1RfQklORChzeW0tPnN0X2lu
Zm8pID09IFNUQl9XRUFLLAorCQkJCQkgIG1vZC0+dW5yZXMpOwogCQlicmVhazsKIAlkZWZhdWx0
OgogCQkvKiBBbGwgZXhwb3J0ZWQgc3ltYm9scyAqLwotLSAKMS44LjIKCg==
--047d7b5d44044cf0d804d7f4f040--
