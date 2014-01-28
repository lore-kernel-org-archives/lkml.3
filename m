Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaA1URh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:17:37 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36294 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaA1URg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:17:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXc5GYK2EnZ3j3STYLy_t8FeUkqeJb+3=bJ7hT9vtORMQ@mail.gmail.com>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
	<1390590670-25901-4-git-send-email-yinghai@kernel.org>
	<CAOesGMh7+SzLTfyPomnB_Q_wft+RC+F3tx-Ow1TdSmHiSwrKcw@mail.gmail.com>
	<CAGa+x87jJep_TSG70wAr5M-Ce7soPyr4SBdPqyo2ENZ2DYcqkA@mail.gmail.com>
	<CAE9FiQU_vZo40cje_XJXSxuKW-JL6H-8rAazwOw1O-ewcV+C5g@mail.gmail.com>
	<20140128171823.GN15937@n2100.arm.linux.org.uk>
	<CAE9FiQUa3uKZNc=5fiuvcR4bjEeQ3=RuhFVxUyKyMsJwe2YurA@mail.gmail.com>
	<20140128194739.GP15937@n2100.arm.linux.org.uk>
	<CAE9FiQXc5GYK2EnZ3j3STYLy_t8FeUkqeJb+3=bJ7hT9vtORMQ@mail.gmail.com>
Date: Tue, 28 Jan 2014 12:17:35 -0800
X-Google-Sender-Auth: KHQtaP2KI0P6gdFQylo71bSs3yA
Message-ID: <CAE9FiQV7op_5tvS0Xovw1YC4dp4Mon_iN7ane_WKjfag0Q+8VA@mail.gmail.com>
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
From: Yinghai Lu <yinghai@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: multipart/mixed; boundary=089e013a10e4d4ff1104f10d834f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e013a10e4d4ff1104f10d834f
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jan 28, 2014 at 11:55 AM, Yinghai Lu <yinghai@kernel.org> wrote:

> but looks like memblock_virt_alloc_low is not the same as alloc_bootmem_low yet.
>

The memblock_virt_alloc missed limit checking.

Please check attached patch.

Thanks

Yinghai

--089e013a10e4d4ff1104f10d834f
Content-Type: text/x-patch; charset=US-ASCII; name="fix_memblock_virt_alloc_low.patch"
Content-Disposition: attachment; 
	filename="fix_memblock_virt_alloc_low.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqzlxhvo0

U3ViamVjdDogW1BBVENIXSBtZW1ibG9jazogQWRkIGxpbWl0IGNoZWNraW5nIHRvIG1lbWJsb2Nr
X3ZpcnRfYWxsb2MKCkluIG9yaWdpbmFsIGJvb3RtZW0gd3JhcHBlciBmb3IgbWVtYmxvY2ssIHdl
IGhhdmUgbGltaXQgY2hlY2tpbmcuCgpBZGQgaXQgdG8gbWVtYmxvY2tfdmlydF9hbGxvYywgdG8g
YWRkcmVzcyBhcm0gYW5kIHg4NiBib290aW5nIGNyYXNoLgoKU2lnbmVkLW9mZi1ieTogWWluZ2hh
aSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBtbS9tZW1ibG9jay5jIHwgICAgMyArKysK
IDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCkluZGV4OiBsaW51eC0yLjYvbW0vbWVt
YmxvY2suYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9tbS9tZW1ibG9jay5jCisrKyBs
aW51eC0yLjYvbW0vbWVtYmxvY2suYwpAQCAtMTA3Nyw2ICsxMDc3LDkgQEAgc3RhdGljIHZvaWQg
KiBfX2luaXQgbWVtYmxvY2tfdmlydF9hbGxvYwogCWlmICghYWxpZ24pCiAJCWFsaWduID0gU01Q
X0NBQ0hFX0JZVEVTOwogCisJaWYgKG1heF9hZGRyID4gbWVtYmxvY2suY3VycmVudF9saW1pdCkK
KwkJbWF4X2FkZHIgPSBtZW1ibG9jay5jdXJyZW50X2xpbWl0OworCiBhZ2FpbjoKIAlhbGxvYyA9
IG1lbWJsb2NrX2ZpbmRfaW5fcmFuZ2Vfbm9kZShzaXplLCBhbGlnbiwgbWluX2FkZHIsIG1heF9h
ZGRyLAogCQkJCQkgICAgbmlkKTsK
--089e013a10e4d4ff1104f10d834f--
