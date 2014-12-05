Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaLEUZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 15:25:11 -0500
Received: from nm7.bullet.mail.bf1.yahoo.com ([98.139.212.166]:46009 "EHLO
	nm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbaLEUZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 15:25:09 -0500
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Dec 2014 15:25:08 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=yahoo.ca;
	b=s8CpR63jlDyHvQ9XaBUDGa3vxHSHthbrmsrcsho76FsFUb9ZkaszExyHOKL5QNQuqtPXT2zrReNQmiCr5n6tPE9QDYjykMyQnQs/k0IWpdCQUZfrVzq6724pnY3YcYxOWOZyhIXD5yegCMVhA+yIZUs1AXyNYX2tmpz7CDezHj4dpCZKmyC3uf5CIHfS4I9wdu60oxpJIERS6w5ZGRBGT205hlvJp2iRFYAqUp0fahA5AtKDXm1iXxAExnwdJQKsL9uEZc3LfFEGAe448JjiRN6VMQfaK2qP+rkFia6MFUnb7X/ZW46/2ciTGLyrRfcxzhWKTxr5hGdOHLjlVCVE7w==;
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 145526.9823.bm@omp1013.mail.bf1.yahoo.com
X-YMail-OSG: IPojfKoVM1kSIqwJqCtGzNjcOekn8PPKUk8wlxefZjvS_Hs_bXH6cqDiQvxkPN6
 Q4l86SWB85hN1S0Tr3OiIdZujn_AMqpfxepvtj2gfnysVwIEZ3Oq5HsXRlpQrs4t2smV4Q4wcuYR
 DRW_nIrfhBvDImqP3.2nxB5SpiQ1F29Vn2UWDpWvWF6BxZW5r9Uxc5rkjtWl_fwi41XlZqSGoqaU
 oMmOUV_Jk6uhkRUYehweQpga1WPdn1J_MIglAv1Wl0qd3DMHaWQRwKpAGnkTmFSlV5kV0Ur_6uuA
 m2Idg0fDo.sdOxlftrKXP2FDGEXLFWI7_aodb_CjOnJNvYpBh_mDcN0j6jZBJcccIzXmjHOc1TpJ
 LfujiQ5TAHU.n3NKW7wmPSQGTCq5DKjiyaXLEIcQno4ejbV23juXfqfe7GPBAg7JaZl2x2bE7kTb
 6ltWP8suU7qpglJ0h8gcpUGcu.pXOOe..s__WG8Cgbbxf
Date: Fri, 5 Dec 2014 20:16:47 +0000 (UTC)
From: Denis Du <dudenis2000@yahoo.ca>
Reply-To: Denis Du <dudenis2000@yahoo.ca>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <345838865.5722597.1417810607255.JavaMail.yahoo@jws10603.mail.bf1.yahoo.com>
In-Reply-To: <950568161.5257116.1417730252670.JavaMail.yahoo@jws10613.mail.bf1.yahoo.com>
References: <950568161.5257116.1417730252670.JavaMail.yahoo@jws10613.mail.bf1.yahoo.com>
Subject: TTY layer need a lock to copy data to user space
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_5722596_1074393473.1417810607254"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_5722596_1074393473.1417810607254
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



Hi, Guys:
It was found that the 3.12 kernel tty layer will lose or corrupt data when =
have a full-duplex communication, especcially in high baudrate, for example=
 230k for my OMAP5 uart. Eventually I found there is lock missing between c=
opy data to ldisc layer buffer and copy data from the same buffer to user=
=20
space. I believe this issue existed since 3.8 kernel(since this kernel , it=
 start to remove most of the spin-locks) and I didn't find any fix even thr=
ough 3.17 kernel. This patch was tested to be works great with no any data =
loss again.


I did try to use the existed lock atomic_read_lock, but it doesn=E2=80=99t =
work.=20



Denis Du
------=_Part_5722596_1074393473.1417810607254
Content-Type: text/x-patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; 
	filename=Fix-serial-lose-data-by-newlock.patch
Content-ID: <1a97e2dd-6bb1-0fe6-ad49-785d90685c04@yahoo.com>

LS0tIGRyaXZlcnMvdHR5L25fdHR5LmMtb2xkCTIwMTQtMTAtMTYgMTY6Mzk6MzUuOTA5MzUwMzM4
IC0wNDAwCisrKyBkcml2ZXJzL3R0eS9uX3R0eS5jCTIwMTQtMTAtMTYgMTY6NDk6MDAuMDA0OTMw
NDY5IC0wNDAwCkBAIC0xMjQsNiArMTI0LDcgQEAKIAogCXN0cnVjdCBtdXRleCBhdG9taWNfcmVh
ZF9sb2NrOwogCXN0cnVjdCBtdXRleCBvdXRwdXRfbG9jazsKKwlzdHJ1Y3QgbXV0ZXggcmVhZF9i
dWZfbG9jazsKIH07CiAKIHN0YXRpYyBpbmxpbmUgc2l6ZV90IHJlYWRfY250KHN0cnVjdCBuX3R0
eV9kYXRhICpsZGF0YSkKQEAgLTE2ODYsOSArMTY4NywxMSBAQAogCQkJICAgICAgY2hhciAqZnAs
IGludCBjb3VudCkKIHsKIAlpbnQgcm9vbSwgbjsKKwlzdHJ1Y3Qgbl90dHlfZGF0YSAqbGRhdGEg
PSB0dHktPmRpc2NfZGF0YTsKIAogCWRvd25fcmVhZCgmdHR5LT50ZXJtaW9zX3J3c2VtKTsKIAor
CW11dGV4X2xvY2soJmxkYXRhLT5yZWFkX2J1Zl9sb2NrKTsKIAl3aGlsZSAoMSkgewogCQlyb29t
ID0gcmVjZWl2ZV9yb29tKHR0eSk7CiAJCW4gPSBtaW4oY291bnQsIHJvb20pOwpAQCAtMTcwMyw2
ICsxNzA2LDcgQEAKIAogCXR0eS0+cmVjZWl2ZV9yb29tID0gcm9vbTsKIAluX3R0eV9jaGVja190
aHJvdHRsZSh0dHkpOworCW11dGV4X3VubG9jaygmbGRhdGEtPnJlYWRfYnVmX2xvY2spOwogCXVw
X3JlYWQoJnR0eS0+dGVybWlvc19yd3NlbSk7CiB9CiAKQEAgLTE3MTMsNyArMTcxNyw3IEBACiAJ
aW50IHJvb20sIG4sIHJjdmQgPSAwOwogCiAJZG93bl9yZWFkKCZ0dHktPnRlcm1pb3NfcndzZW0p
OwotCisJbXV0ZXhfbG9jaygmbGRhdGEtPnJlYWRfYnVmX2xvY2spOwogCXdoaWxlICgxKSB7CiAJ
CXJvb20gPSByZWNlaXZlX3Jvb20odHR5KTsKIAkJbiA9IG1pbihjb3VudCwgcm9vbSk7CkBAIC0x
NzMyLDYgKzE3MzYsNyBAQAogCiAJdHR5LT5yZWNlaXZlX3Jvb20gPSByb29tOwogCW5fdHR5X2No
ZWNrX3Rocm90dGxlKHR0eSk7CisJbXV0ZXhfdW5sb2NrKCZsZGF0YS0+cmVhZF9idWZfbG9jayk7
CiAJdXBfcmVhZCgmdHR5LT50ZXJtaW9zX3J3c2VtKTsKIAogCXJldHVybiByY3ZkOwpAQCAtMTg4
MCw2ICsxODg1LDcgQEAKIAlsZGF0YS0+b3ZlcnJ1bl90aW1lID0gamlmZmllczsKIAltdXRleF9p
bml0KCZsZGF0YS0+YXRvbWljX3JlYWRfbG9jayk7CiAJbXV0ZXhfaW5pdCgmbGRhdGEtPm91dHB1
dF9sb2NrKTsKKwltdXRleF9pbml0KCZsZGF0YS0+cmVhZF9idWZfbG9jayk7CiAKIAl0dHktPmRp
c2NfZGF0YSA9IGxkYXRhOwogCXJlc2V0X2J1ZmZlcl9mbGFncyh0dHktPmRpc2NfZGF0YSk7CkBA
IC0xOTQ1LDYgKzE5NTEsOCBAQAogCXNpemVfdCB0YWlsID0gbGRhdGEtPnJlYWRfdGFpbCAmIChO
X1RUWV9CVUZfU0laRSAtIDEpOwogCiAJcmV0dmFsID0gMDsKKworCW11dGV4X2xvY2soJmxkYXRh
LT5yZWFkX2J1Zl9sb2NrKTsKIAluID0gbWluKHJlYWRfY250KGxkYXRhKSwgTl9UVFlfQlVGX1NJ
WkUgLSB0YWlsKTsKIAluID0gbWluKCpuciwgbik7CiAJaWYgKG4pIHsKQEAgLTE5NjAsNiArMTk2
OCw3IEBACiAJCSpiICs9IG47CiAJCSpuciAtPSBuOwogCX0KKwltdXRleF91bmxvY2soJmxkYXRh
LT5yZWFkX2J1Zl9sb2NrKTsKIAlyZXR1cm4gcmV0dmFsOwogfQogCkBAIC0xOTkwLDYgKzE5OTks
OCBAQAogCXNpemVfdCB0YWlsOwogCWludCByZXQsIGZvdW5kID0gMDsKIAlib29sIGVvZl9wdXNo
ID0gMDsKKwkKKwltdXRleF9sb2NrKCZsZGF0YS0+cmVhZF9idWZfbG9jayk7CiAKIAkvKiBOLkIu
IGF2b2lkIG92ZXJydW4gaWYgbnIgPT0gMCAqLwogCW4gPSBtaW4oKm5yLCByZWFkX2NudChsZGF0
YSkpOwpAQCAtMjA0OSw2ICsyMDYwLDggQEAKIAkJbGRhdGEtPmxpbmVfc3RhcnQgPSBsZGF0YS0+
cmVhZF90YWlsOwogCQl0dHlfYXVkaXRfcHVzaCh0dHkpOwogCX0KKworCW11dGV4X3VubG9jaygm
bGRhdGEtPnJlYWRfYnVmX2xvY2spOwogCXJldHVybiBlb2ZfcHVzaCA/IC1FQUdBSU4gOiAwOwog
fQogCg==

------=_Part_5722596_1074393473.1417810607254--
