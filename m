Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab3BYGyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 01:54:12 -0500
Received: from fallback2.mail.ru ([94.100.176.87]:46269 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3BYGyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 01:54:11 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RG1pdHJ5IFRvcm9raG92?= <dmitry.torokhov@gmail.com>
Cc: =?UTF-8?B?U3RlcGhlbiBXYXJyZW4=?= <swarren@wwwdotorg.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>,
        =?UTF-8?B?VGhpZXJyeSBSZWRpbmc=?= <thierry.reding@avionic-design.de>,
        =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCB2NSAxLzNdIG1mZDogc3lzY29uOiBSZW1vdmVkIHN1?=
 =?UTF-8?B?cHBvcnQgZm9yIHVubG9hZGluZw==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Mon, 25 Feb 2013 10:53:42 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1361775222.578079910@f398.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <20130224075533.GB18844@core.coreip.homeip.net>
References: <1361596520-19332-1-git-send-email-shc_work@mail.ru> <512955F7.1020309@wwwdotorg.org> <20130224075533.GB18844@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1P6sDHZ023948

> On Sat, Feb 23, 2013 at 04:51:19PM -0700, Stephen Warren wrote:
> > On 02/22/2013 10:28 PM, Alexander Shiyan wrote:
> > >> On 02/22/2013 10:15 PM, Alexander Shiyan wrote:
> > >>> The driver can be used in various subsystems and therefore should not
> > >>> be unloaded when it is defined in the kernel configuration, so remove
> > >>> support for unloading it.
> > >>
> > >> Why not fix the clients to module_get() at the appropriate times; then
> > >> you could still allow unloading, couldn't you?
> > > 
> > > I has explain this before.
> > 
> > If multiple people have asked this, perhaps it'd be a good idea to
> > include the answer in the commit description.
> > 
> > > Driver defined as "bool" and loaded via postcore_initcall.
> > 
> > Being defined as a "bool" sounds like a reasonable reason that no
> > remove() is required.
> 
> No, it is not - I can still unbind the device from driver via sysfs. Now
> what will happen is resources are leaked and won't be available when
> trying to bin (via sysfs) again.
> 
> This patch is broken.

I will try to resolve the dispute.
Initially, the first part of the patch (this) was an attempt to prevent the unloading
(unregister) of the driver (not the device), ie remove module_exit call.
The patch also removes the code to remove the device. Inclusion in this patch
of the code was a mistake. Because of this, people are confused about the terms,
including me.
Code, relating to the removal of the device should be moved to the third patch.
Since all moved to using the managed resources, it should not have any questions.

About uloading (unregister) driver: As far i understand "__exit" section is
completely discarded when kernel compiled without module support.
But where is this call (module_exit) is placing in case "bool" driver and
kernel is compiled with module support? Fixme please.

Thanks.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
