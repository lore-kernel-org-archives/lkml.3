Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaAXFzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 00:55:16 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:53080 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaAXFzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 00:55:13 -0500
MIME-Version: 1.0
In-Reply-To: <52E19C7D.7050603@intel.com>
References: <52E19C7D.7050603@intel.com>
Date: Thu, 23 Jan 2014 21:55:13 -0800
X-Google-Sender-Auth: sZ9YvBg2z-zHXTsppnERXJbjngs
Message-ID: <CAE9FiQX9kTxnaqpWNgg3dUzr7+60YCrEx3q3xxO-G1n6z64xVQ@mail.gmail.com>
Subject: Re: Panic on 8-node system in memblock_virt_alloc_try_nid()
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=f46d0443fddc64c84c04f0b100ee
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0443fddc64c84c04f0b100ee
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jan 23, 2014 at 2:49 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> Linus's current tree doesn't boot on an 8-node/1TB NUMA system that I
> have.  Its reboots are *LONG*, so I haven't fully bisected it, but it's
> down to a just a few commits, most of which are changes to the memblock
> code.  Since the panic is in the memblock code, it looks like a
> no-brainer.  It's almost certainly the code from Santosh or Grygorii
> that's triggering this.
>
> Config and good/bad dmesg with memblock=debug are here:
>
>         http://sr71.net/~dave/intel/3.13/
>
> Please let me know if you need it bisected further than this.

Please check attached patch, and it should fix the problem.

Yinghai

--f46d0443fddc64c84c04f0b100ee
Content-Type: text/x-patch; charset=US-ASCII; name="fix_numa_x.patch"
Content-Disposition: attachment; filename="fix_numa_x.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqt1cp030

U3ViamVjdDogW1BBVENIXSB4ODY6IEZpeCBudW1hIHdpdGggcmV2ZXJ0aW5nIHdyb25nIG1lbWJs
b2NrIHNldHRpbmcuCgpEYXZlIHJlcG9ydGVkIE51bWEgb24geDg2IGlzIGJyb2tlbiBvbiBzeXN0
ZW0gd2l0aCAxVCBtZW1vcnkuCgpJdCB0dXJucyBvdXQKfCBjb21taXQgNWI2ZTUyOTUyMWQzNWUx
YmNhYTBmZTQzNDU2ZDFiYmIzMzVjYWU1ZAp8IEF1dGhvcjogU2FudG9zaCBTaGlsaW1rYXIgPHNh
bnRvc2guc2hpbGlta2FyQHRpLmNvbT4KfCBEYXRlOiAgIFR1ZSBKYW4gMjEgMTU6NTA6MDMgMjAx
NCAtMDgwMAp8CnwgICAgeDg2OiBtZW1ibG9jazogc2V0IGN1cnJlbnQgbGltaXQgdG8gbWF4IGxv
dyBtZW1vcnkgYWRkcmVzcwoKc2V0IGxpbWl0IHRvIGxvdyB3cm9uZ2x5LgoKbWF4X2xvd19wZm5f
bWFwcGVkIGlzIGRpZmZlcmVudCBmcm9tIG1heF9wZm5fbWFwcGVkLgptYXhfbG93X3Bmbl9tYXBw
ZWQgaXMgYWx3YXlzIHVuZGVyIDRHLgoKVGhhdCB3aWxsIG1lbWJsb2NrX2FsbG9jX25pZCBhbGwg
Z28gdW5kZXIgNEcuCgpSZXZlcnQgdGhhdCBvZmZlbmRpbmcgcGF0Y2guCgpSZXBvcnRlZC1ieTog
RGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTogWWluZ2hh
aSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKCi0tLQogYXJjaC94ODYvaW5jbHVkZS9hc20vcGFn
ZV90eXBlcy5oIHwgICAgNCArKy0tCiBhcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYyAgICAgICAgICAg
fCAgICAyICstCiAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMo
LSkKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvaW5jbHVkZS9hc20vcGFnZV90eXBlcy5oCj09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BhZ2VfdHlw
ZXMuaAorKysgbGludXgtMi42L2FyY2gveDg2L2luY2x1ZGUvYXNtL3BhZ2VfdHlwZXMuaApAQCAt
NTEsOSArNTEsOSBAQCBleHRlcm4gaW50IGRldm1lbV9pc19hbGxvd2VkKHVuc2lnbmVkIGxvCiBl
eHRlcm4gdW5zaWduZWQgbG9uZyBtYXhfbG93X3Bmbl9tYXBwZWQ7CiBleHRlcm4gdW5zaWduZWQg
bG9uZyBtYXhfcGZuX21hcHBlZDsKIAotc3RhdGljIGlubGluZSBwaHlzX2FkZHJfdCBnZXRfbWF4
X2xvd19tYXBwZWQodm9pZCkKK3N0YXRpYyBpbmxpbmUgcGh5c19hZGRyX3QgZ2V0X21heF9tYXBw
ZWQodm9pZCkKIHsKLQlyZXR1cm4gKHBoeXNfYWRkcl90KW1heF9sb3dfcGZuX21hcHBlZCA8PCBQ
QUdFX1NISUZUOworCXJldHVybiAocGh5c19hZGRyX3QpbWF4X3Bmbl9tYXBwZWQgPDwgUEFHRV9T
SElGVDsKIH0KIAogYm9vbCBwZm5fcmFuZ2VfaXNfbWFwcGVkKHVuc2lnbmVkIGxvbmcgc3RhcnRf
cGZuLCB1bnNpZ25lZCBsb25nIGVuZF9wZm4pOwpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tl
cm5lbC9zZXR1cC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5l
bC9zZXR1cC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL3NldHVwLmMKQEAgLTExNzMs
NyArMTE3Myw3IEBAIHZvaWQgX19pbml0IHNldHVwX2FyY2goY2hhciAqKmNtZGxpbmVfcCkKIAog
CXNldHVwX3JlYWxfbW9kZSgpOwogCi0JbWVtYmxvY2tfc2V0X2N1cnJlbnRfbGltaXQoZ2V0X21h
eF9sb3dfbWFwcGVkKCkpOworCW1lbWJsb2NrX3NldF9jdXJyZW50X2xpbWl0KGdldF9tYXhfbWFw
cGVkKCkpOwogCWRtYV9jb250aWd1b3VzX3Jlc2VydmUoMCk7CiAKIAkvKgo=
--f46d0443fddc64c84c04f0b100ee--
