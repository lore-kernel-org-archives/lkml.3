Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3H1K3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:29:20 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:57969 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3H1K3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:29:18 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUW6JMa6VoRJ62AUZDpYm2_q_tzSM0Ryb56RNnCdEhwQyA@mail.gmail.com>
References: <CA+icZUUTBYMxLPBv2fq86h3dxyANhtpd6=Q4XGMscrntPNA9bQ@mail.gmail.com>
	<CA+icZUW6JMa6VoRJ62AUZDpYm2_q_tzSM0Ryb56RNnCdEhwQyA@mail.gmail.com>
Date: Wed, 28 Aug 2013 12:29:16 +0200
Message-ID: <CA+icZUVTzMxS4f3kZnauDkrpf4vwMbS3zd7ECOhE37S_FF83UA@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 28 [ xhci build breakage ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Content-Type: multipart/mixed; boundary=089e0117646325d39d04e4ff769f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0117646325d39d04e4ff769f
Content-Type: text/plain; charset=UTF-8

On Wed, Aug 28, 2013 at 11:56 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Wed, Aug 28, 2013 at 11:49 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> Hi all,
>>
>> Changes since 20130827:
>>
>> The f2fs tree lost its build failure.
>>
>> The md tree gained a conflict against the arm tree.
>>
>> The libata tree lost its build failure.
>>
>> The spi tree lost its build failure.
>>
>> The arm-soc tree gained conflicts against the usb tree.
>>
>> The dma-mapping tree gained a conflict against the driver-core tree.
>>
>> The akpm-current tree gained a conflict against the net tree.
>>
>> ----------------------------------------------------------------------------
>>
>> My build here breaks like this:
>>
>>   CC      drivers/usb/host/xhci-ring.o
>>   CC      drivers/video/console/softcursor.o
>> drivers/usb/host/xhci-ring.c: In function 'xhci_queue_intr_tx':
>> drivers/usb/host/xhci-ring.c:3090:3: error: implicit declaration of
>> function 'DEFINE_DYNAMIC_DEBUG_METADATA'
>> [-Werror=implicit-function-declaration]
>> drivers/usb/host/xhci-ring.c:3090:3: error: 'descriptor' undeclared
>> (first use in this function)
>> drivers/usb/host/xhci-ring.c:3090:3: note: each undeclared identifier
>> is reported only once for each function it appears in
>> drivers/usb/host/xhci-ring.c:3090:3: error: implicit declaration of
>> function '__dynamic_pr_debug' [-Werror=implicit-function-declaration]
>> drivers/usb/host/xhci-ring.c: In function 'xhci_queue_isoc_tx_prepare':
>> drivers/usb/host/xhci-ring.c:3875:3: error: 'descriptor' undeclared
>> (first use in this function)
>> cc1: some warnings being treated as errors
>> make[5]: *** [drivers/usb/host/xhci-ring.o] Error 1
>> make[4]: *** [drivers/usb/host] Error 2
>>
>> My kernel-config is attached.
>>
>
> Looks like <linux/device.h> or <linux/dynamic_debug.h> is missing.
>
> $ egrep -w '__dynamic_pr_debug|DEFINE_DYNAMIC_DEBUG_METADATA' -nr linux/include/
> linux/include/linux/device.h:1118:
> DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);                 \
> linux/include/linux/device.h:1121:
> __dynamic_pr_debug(&descriptor, pr_fmt(fmt),            \
> linux/include/linux/dynamic_debug.h:45:int __dynamic_pr_debug(struct
> _ddebug *descriptor, const char *fmt, ...);
> linux/include/linux/dynamic_debug.h:63:#define
> DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)         \
> linux/include/linux/dynamic_debug.h:76:
> DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         \
> linux/include/linux/dynamic_debug.h:78:
> __dynamic_pr_debug(&descriptor, pr_fmt(fmt),    \
> linux/include/linux/dynamic_debug.h:84:
> DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         \
> linux/include/linux/dynamic_debug.h:92:
> DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         \
> linux/include/linux/dynamic_debug.h:101:
> DEFINE_DYNAMIC_DEBUG_METADATA(descriptor,               \
>
> Can't say which one is preferred here.
>

looks like device.h is preferred or used in the sources, but this does
not fix the issue here.
sth. wrong with dev_dbg_ratelimited()?

- sedat -

--089e0117646325d39d04e4ff769f
Content-Type: application/octet-stream; name="xhci-ring.diff"
Content-Disposition: attachment; filename="xhci-ring.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkwei1wh0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1yaW5nLmMgYi9kcml2ZXJzL3VzYi9o
b3N0L3hoY2ktcmluZy5jCmluZGV4IDQxMWRhMWYuLmY5OWI3YWQgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvdXNiL2hvc3QveGhjaS1yaW5nLmMKKysrIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLXJpbmcu
YwpAQCAtNjYsNiArNjYsNyBAQAogCiAjaW5jbHVkZSA8bGludXgvc2NhdHRlcmxpc3QuaD4KICNp
bmNsdWRlIDxsaW51eC9zbGFiLmg+CisjaW5jbHVkZSA8bGludXgvZGV2aWNlLmg+CiAjaW5jbHVk
ZSAieGhjaS5oIgogI2luY2x1ZGUgInhoY2ktdHJhY2UuaCIKIApAQCAtMzA4NywxMCArMzA4OCwx
MiBAQCBpbnQgeGhjaV9xdWV1ZV9pbnRyX3R4KHN0cnVjdCB4aGNpX2hjZCAqeGhjaSwgZ2ZwX3Qg
bWVtX2ZsYWdzLAogCSAqIHRvIHNldCB0aGUgcG9sbGluZyBpbnRlcnZhbCAob25jZSB0aGUgQVBJ
IGlzIGFkZGVkKS4KIAkgKi8KIAlpZiAoeGhjaV9pbnRlcnZhbCAhPSBlcF9pbnRlcnZhbCkgewor
I2lmIDAKIAkJZGV2X2RiZ19yYXRlbGltaXRlZCgmdXJiLT5kZXYtPmRldiwKIAkJCQkiRHJpdmVy
IHVzZXMgZGlmZmVyZW50IGludGVydmFsICglZCBtaWNyb2ZyYW1lJXMpIHRoYW4geEhDSSAoJWQg
bWljcm9mcmFtZSVzKVxuIiwKIAkJCQllcF9pbnRlcnZhbCwgZXBfaW50ZXJ2YWwgPT0gMSA/ICIi
IDogInMiLAogCQkJCXhoY2lfaW50ZXJ2YWwsIHhoY2lfaW50ZXJ2YWwgPT0gMSA/ICIiIDogInMi
KTsKKyNlbmRpZgogCQl1cmItPmludGVydmFsID0geGhjaV9pbnRlcnZhbDsKIAkJLyogQ29udmVy
dCBiYWNrIHRvIGZyYW1lcyBmb3IgTFMvRlMgZGV2aWNlcyAqLwogCQlpZiAodXJiLT5kZXYtPnNw
ZWVkID09IFVTQl9TUEVFRF9MT1cgfHwKQEAgLTM4NzIsMTAgKzM4NzUsMTIgQEAgaW50IHhoY2lf
cXVldWVfaXNvY190eF9wcmVwYXJlKHN0cnVjdCB4aGNpX2hjZCAqeGhjaSwgZ2ZwX3QgbWVtX2Zs
YWdzLAogCSAqIHRvIHNldCB0aGUgcG9sbGluZyBpbnRlcnZhbCAob25jZSB0aGUgQVBJIGlzIGFk
ZGVkKS4KIAkgKi8KIAlpZiAoeGhjaV9pbnRlcnZhbCAhPSBlcF9pbnRlcnZhbCkgeworI2lmIDAK
IAkJZGV2X2RiZ19yYXRlbGltaXRlZCgmdXJiLT5kZXYtPmRldiwKIAkJCQkiRHJpdmVyIHVzZXMg
ZGlmZmVyZW50IGludGVydmFsICglZCBtaWNyb2ZyYW1lJXMpIHRoYW4geEhDSSAoJWQgbWljcm9m
cmFtZSVzKVxuIiwKIAkJCQllcF9pbnRlcnZhbCwgZXBfaW50ZXJ2YWwgPT0gMSA/ICIiIDogInMi
LAogCQkJCXhoY2lfaW50ZXJ2YWwsIHhoY2lfaW50ZXJ2YWwgPT0gMSA/ICIiIDogInMiKTsKKyNl
bmRpZgogCQl1cmItPmludGVydmFsID0geGhjaV9pbnRlcnZhbDsKIAkJLyogQ29udmVydCBiYWNr
IHRvIGZyYW1lcyBmb3IgTFMvRlMgZGV2aWNlcyAqLwogCQlpZiAodXJiLT5kZXYtPnNwZWVkID09
IFVTQl9TUEVFRF9MT1cgfHwK
--089e0117646325d39d04e4ff769f--
