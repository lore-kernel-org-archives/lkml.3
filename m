Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab3CQQYE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 12:24:04 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:56037 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab3CQQYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 12:24:01 -0400
MIME-Version: 1.0
In-Reply-To: <5145D236.70203@gmail.com>
References: <20130307052854.GA23745@redhat.com>
	<20130307060230.GA31738@kroah.com>
	<20130307062626.GA25095@redhat.com>
	<51429D7A.30906@gmail.com>
	<5142ABD3.4040106@gmail.com>
	<CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com>
	<CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com>
	<51448AC9.7080105@gmail.com>
	<CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com>
	<CACVXFVNCGBAYLbbpE1sBiXFNkJpRxVzY44y3Vok+GA9C0MKr3w@mail.gmail.com>
	<5144BB15.3020002@gmail.com>
	<CACVXFVOKi=wKsLP850XJ95P=e1B2z+CP=t0GATCZL0gNDOCwnA@mail.gmail.com>
	<5145D236.70203@gmail.com>
Date: Mon, 18 Mar 2013 00:23:59 +0800
Message-ID: <CACVXFVP7XHO8sT68ETam=R-+cbPjSGqz_xfnt30OiSPEuC4-Sg@mail.gmail.com>
Subject: Re: use after free in sysfs_find_dirent
From: Ming Lei <tom.leiming@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=14dae9cdcaadc3933b04d8214cc6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9cdcaadc3933b04d8214cc6
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Mar 17, 2013 at 10:24 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>
> I still see it going on with the patch applied:

Looks the previous patch still has the race problem, so could you just
apply the attachment patch and cancel all previous patches for the
test? If there is still the problem, please post out the log.

BTW, the attachment patch is only for verifying if the current problem
is caused by 'filp->private_data' race, and not for merge.

Thanks,
-- 
Ming Lei

--14dae9cdcaadc3933b04d8214cc6
Content-Type: application/octet-stream; name="sysfs-fix-readdir-v1.patch"
Content-Disposition: attachment; filename="sysfs-fix-readdir-v1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_heeez8i60

ZGlmZiAtLWdpdCBhL2ZzL3N5c2ZzL2Rpci5jIGIvZnMvc3lzZnMvZGlyLmMKaW5kZXggMmZiZGZm
Ni4uODdjY2VlZCAxMDA2NDQKLS0tIGEvZnMvc3lzZnMvZGlyLmMKKysrIGIvZnMvc3lzZnMvZGly
LmMKQEAgLTI4MCw2ICsyODAsMTEgQEAgdm9pZCByZWxlYXNlX3N5c2ZzX2RpcmVudChzdHJ1Y3Qg
c3lzZnNfZGlyZW50ICogc2QpCiAJICogc2QtPnNfcGFyZW50IHdvbid0IGNoYW5nZSBiZW5lYXRo
IHVzLgogCSAqLwogCXBhcmVudF9zZCA9IHNkLT5zX3BhcmVudDsKKwlpZighKHNkLT5zX2ZsYWdz
ICYgU1lTRlNfRkxBR19SRU1PVkVEKSkgeworCQlwcmludGsoIiVzLSVkIHN5c2ZzX2RpcmVudCB1
c2UgYWZ0ZXIgZnJlZTogJXMtJXNcbiIsCisJCQlfX2Z1bmNfXywgX19MSU5FX18sIHBhcmVudF9z
ZC0+c19uYW1lLCBzZC0+c19uYW1lKTsKKwkJZHVtcF9zdGFjaygpOworCX0KIAogCWlmIChzeXNm
c190eXBlKHNkKSA9PSBTWVNGU19LT0JKX0xJTkspCiAJCXN5c2ZzX3B1dChzZC0+c19zeW1saW5r
LnRhcmdldF9zZCk7CkBAIC05NjIsNiArOTY3LDEyIEBAIHN0YXRpYyBzdHJ1Y3Qgc3lzZnNfZGly
ZW50ICpzeXNmc19kaXJfcG9zKGNvbnN0IHZvaWQgKm5zLAogCQlpbnQgdmFsaWQgPSAhKHBvcy0+
c19mbGFncyAmIFNZU0ZTX0ZMQUdfUkVNT1ZFRCkgJiYKIAkJCXBvcy0+c19wYXJlbnQgPT0gcGFy
ZW50X3NkICYmCiAJCQloYXNoID09IHBvcy0+c19oYXNoOworCisJCWlmICgoYXRvbWljX3JlYWQo
JnBvcy0+c19jb3VudCkgPT0gMSkpIHsKKwkJCXByaW50aygiJXMtJWQgc3lzZnNfZGlyZW50IHVz
ZSBhZnRlciBmcmVlOiAlcyglcyktJXMsICVsbGQtJXVcbiIsCisJCQkJX19mdW5jX18sIF9fTElO
RV9fLCBwYXJlbnRfc2QtPnNfbmFtZSwgcG9zLT5zX3BhcmVudC0+c19uYW1lLAorCQkJCXBvcy0+
c19uYW1lLCBoYXNoLCBwb3MtPnNfaGFzaCk7CisJCX0KIAkJc3lzZnNfcHV0KHBvcyk7CiAJCWlm
ICghdmFsaWQpCiAJCQlwb3MgPSBOVUxMOwpAQCAtMTAwOCw3ICsxMDE5LDcgQEAgc3RhdGljIGlu
dCBzeXNmc19yZWFkZGlyKHN0cnVjdCBmaWxlICogZmlscCwgdm9pZCAqIGRpcmVudCwgZmlsbGRp
cl90IGZpbGxkaXIpCiB7CiAJc3RydWN0IGRlbnRyeSAqZGVudHJ5ID0gZmlscC0+Zl9wYXRoLmRl
bnRyeTsKIAlzdHJ1Y3Qgc3lzZnNfZGlyZW50ICogcGFyZW50X3NkID0gZGVudHJ5LT5kX2ZzZGF0
YTsKLQlzdHJ1Y3Qgc3lzZnNfZGlyZW50ICpwb3MgPSBmaWxwLT5wcml2YXRlX2RhdGE7CisJc3Ry
dWN0IHN5c2ZzX2RpcmVudCAqcG9zOwogCWVudW0ga29ial9uc190eXBlIHR5cGU7CiAJY29uc3Qg
dm9pZCAqbnM7CiAJaW5vX3QgaW5vOwpAQCAtMTAxNiw2ICsxMDI3LDcgQEAgc3RhdGljIGludCBz
eXNmc19yZWFkZGlyKHN0cnVjdCBmaWxlICogZmlscCwgdm9pZCAqIGRpcmVudCwgZmlsbGRpcl90
IGZpbGxkaXIpCiAJdHlwZSA9IHN5c2ZzX25zX3R5cGUocGFyZW50X3NkKTsKIAlucyA9IHN5c2Zz
X2luZm8oZGVudHJ5LT5kX3NiKS0+bnNbdHlwZV07CiAKKwltdXRleF9sb2NrKCZzeXNmc19tdXRl
eCk7CiAJaWYgKGZpbHAtPmZfcG9zID09IDApIHsKIAkJaW5vID0gcGFyZW50X3NkLT5zX2lubzsK
IAkJaWYgKGZpbGxkaXIoZGlyZW50LCAiLiIsIDEsIGZpbHAtPmZfcG9zLCBpbm8sIERUX0RJUikg
PT0gMCkKQEAgLTEwMjksNyArMTA0MSw3IEBAIHN0YXRpYyBpbnQgc3lzZnNfcmVhZGRpcihzdHJ1
Y3QgZmlsZSAqIGZpbHAsIHZvaWQgKiBkaXJlbnQsIGZpbGxkaXJfdCBmaWxsZGlyKQogCQlpZiAo
ZmlsbGRpcihkaXJlbnQsICIuLiIsIDIsIGZpbHAtPmZfcG9zLCBpbm8sIERUX0RJUikgPT0gMCkK
IAkJCWZpbHAtPmZfcG9zKys7CiAJfQotCW11dGV4X2xvY2soJnN5c2ZzX211dGV4KTsKKwlwb3Mg
PSBmaWxwLT5wcml2YXRlX2RhdGE7CiAJZm9yIChwb3MgPSBzeXNmc19kaXJfcG9zKG5zLCBwYXJl
bnRfc2QsIGZpbHAtPmZfcG9zLCBwb3MpOwogCSAgICAgcG9zOwogCSAgICAgcG9zID0gc3lzZnNf
ZGlyX25leHRfcG9zKG5zLCBwYXJlbnRfc2QsIGZpbHAtPmZfcG9zLCBwb3MpKSB7CkBAIC0xMDQ0
LDE3ICsxMDU2LDE1IEBAIHN0YXRpYyBpbnQgc3lzZnNfcmVhZGRpcihzdHJ1Y3QgZmlsZSAqIGZp
bHAsIHZvaWQgKiBkaXJlbnQsIGZpbGxkaXJfdCBmaWxsZGlyKQogCQlmaWxwLT5mX3BvcyA9IHBv
cy0+c19oYXNoOwogCQlmaWxwLT5wcml2YXRlX2RhdGEgPSBzeXNmc19nZXQocG9zKTsKIAotCQlt
dXRleF91bmxvY2soJnN5c2ZzX211dGV4KTsKIAkJcmV0ID0gZmlsbGRpcihkaXJlbnQsIG5hbWUs
IGxlbiwgZmlscC0+Zl9wb3MsIGlubywgdHlwZSk7Ci0JCW11dGV4X2xvY2soJnN5c2ZzX211dGV4
KTsKIAkJaWYgKHJldCA8IDApCiAJCQlicmVhazsKIAl9Ci0JbXV0ZXhfdW5sb2NrKCZzeXNmc19t
dXRleCk7CiAJaWYgKChmaWxwLT5mX3BvcyA+IDEpICYmICFwb3MpIHsgLyogRU9GICovCiAJCWZp
bHAtPmZfcG9zID0gSU5UX01BWDsKIAkJZmlscC0+cHJpdmF0ZV9kYXRhID0gTlVMTDsKIAl9CisJ
bXV0ZXhfdW5sb2NrKCZzeXNmc19tdXRleCk7CiAJcmV0dXJuIDA7CiB9CiAK
--14dae9cdcaadc3933b04d8214cc6--
