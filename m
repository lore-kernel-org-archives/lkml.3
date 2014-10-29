Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbaJ2FRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:17:55 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:57102 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaJ2FRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:17:53 -0400
MIME-Version: 1.0
In-Reply-To: <545027F9.1040703@gaast.net>
References: <543F049F.5090605@gaast.net>
	<CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
	<543F9182.9000004@gaast.net>
	<CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com>
	<544033CF.3080104@gaast.net>
	<CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com>
	<5442FE58.5020700@gaast.net>
	<CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com>
	<5446D2D8.2090203@gaast.net>
	<CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com>
	<20141022125354.GA3832@gaast.net>
	<CAE9FiQXF-6b4+y-BJmv7ekrCrXKYyhvZDBqVbLeXSPJa0_cToA@mail.gmail.com>
	<544E235C.5010908@gaast.net>
	<CAE9FiQVMaGs=2OMbk6M7x=EhhfaVn5xT_70Sr+rU2Z1HEfjXbw@mail.gmail.com>
	<544EC59D.9080303@gaast.net>
	<CAE9FiQXC7YfzPp43EX5r4KNPhF4jua_Jg_JLBnSTffzAmRaY=g@mail.gmail.com>
	<544EDD40.1040107@gaast.net>
	<CAE9FiQWfV+h5YGxKEg7kSdhD7_OVoEqNyZZqYr=vpDwz1Lnb_g@mail.gmail.com>
	<545027F9.1040703@gaast.net>
Date: Tue, 28 Oct 2014 22:17:52 -0700
X-Google-Sender-Auth: KJUcbpRYC7sH7xwNaKIHs30Z3ok
Message-ID: <CAE9FiQXM=uAWPD04o8ic2juEaWVQ=seq=+CBjnPnFdrueY-RjQ@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf303dd708bd158b050688e286
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf303dd708bd158b050688e286
Content-Type: text/plain; charset=UTF-8

On Tue, Oct 28, 2014 at 4:34 PM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
>
> I've run the commands twice, once before and once after a single
> suspend+resume cycle. Small difference and only before that cycle:
>
> ruby:~/crashit# diff -u lspcixx-*
> --- lspcixx-nopatch.txt 2014-10-28 23:26:08.679690828 +0000
> +++ lspcixx-patched.txt 2014-10-28 23:10:05.391896757 +0000
> @@ -92,10 +92,10 @@
>  2f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  310: 00 00 00 00 1b 36 3a 74 00 00 14 14 31 17 42 00
> -320: 5b 60 09 00 00 20 00 0a 08 10 b8 04 07 00 d5 0c
> +320: 5b 60 09 00 00 20 00 0a 90 10 b8 04 8f 00 5d 0d
>  330: 16 00 00 28 bc b5 bc 4a 00 00 00 00 74 4c 85 00
> -340: 33 03 33 00 64 03 3f 00 30 00 0c 00 f8 07 d5 00
> -350: fe 07 dd 00 01 00 08 00 00 00 00 00 00 00 00 00
> +340: 33 03 33 00 64 03 3f 00 30 00 0c 00 f8 07 5d 00
> +350: fe 07 65 00 01 00 08 00 00 00 00 00 00 00 00 00
>  360: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  370: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> (Diff is in the Intel device, not the ITE one.)
>

That is strange.

Anyway please try attached patched on top of 3.17.

Thanks

Yinghai

--20cf303dd708bd158b050688e286
Content-Type: text/x-patch; charset=US-ASCII; name="debug_suspend_resume_z_xx.patch"
Content-Disposition: attachment; filename="debug_suspend_resume_z_xx.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1u8g3os0

LS0tCiBkcml2ZXJzL3BjaS9wY2kuYyB8ICAgIDIgKysKIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKykKCkluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9wY2kvcGNpLmMKPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQot
LS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9wY2kvcGNpLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJz
L3BjaS9wY2kuYwpAQCAtMTI2NSw2ICsxMjY1LDggQEAgc3RhdGljIHZvaWQgcGNpX2VuYWJsZV9i
cmlkZ2Uoc3RydWN0IHBjaQogCXBjaV9zZXRfbWFzdGVyKGRldik7CiB9CiAKK0RFQ0xBUkVfUENJ
X0ZJWFVQX0ZJTkFMKFBDSV9WRU5ET1JfSURfSVRFLCAweDg4OTIsIHBjaV9lbmFibGVfYnJpZGdl
KTsKKwogc3RhdGljIGludCBwY2lfZW5hYmxlX2RldmljZV9mbGFncyhzdHJ1Y3QgcGNpX2RldiAq
ZGV2LCB1bnNpZ25lZCBsb25nIGZsYWdzKQogewogCXN0cnVjdCBwY2lfZGV2ICpicmlkZ2U7Cg==
--20cf303dd708bd158b050688e286--
