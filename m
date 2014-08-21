Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaHUBmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 21:42:00 -0400
Received: from relay-s04-hub006.domainlocalhost.com ([74.115.207.217]:5034
	"EHLO relay-S04-HUB006.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbaHUBl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 21:41:58 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Aug 2014 21:41:58 EDT
From: Dudley Du <dudl@cypress.com>
To: Dudley Du <dudley.dulixin@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Benson Leung <bleung@google.com>, Patrik Fimml <patrikf@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 0/14] input: cyapa: re-architecture driver to support
 multi-trackpads in one driver
Thread-Topic: [PATCH v4 0/14] input: cyapa: re-architecture driver to
 support multi-trackpads in one driver
Thread-Index: Ac+hiqcggqGLJSASR1uLi5h07B+kvgbVUMzA
Date: Thu, 21 Aug 2014 01:36:24 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4C940AAC@S04-MBX01-01.s04.local>
References: <53c77101.0374440a.664d.46e2@mx.google.com>
In-Reply-To: <53c77101.0374440a.664d.46e2@mx.google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.30.12.149]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7L1g5UR002539

Hi Dmitry, Patrik,

Is there any update or feedback on the re-submitted v4 cyapa driver patches?

Thanks,
Dudley

> -----Original Message-----
> From: linux-input-owner@vger.kernel.org [mailto:linux-input-
> owner@vger.kernel.org] On Behalf Of Dudley Du
> Sent: Thursday, July 17, 2014 2:45 PM
> To: Dmitry Torokhov; Rafael J. Wysocki
> Cc: Benson Leung; Patrik Fimml; linux-input@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH v4 0/14] input: cyapa: re-architecture driver to support
> multi-trackpads in one driver
>
> This patch set is made based on kernel 3.16.0-rc5.
> It's aimed to re-architecture the cyapa driver to support
> old gen3 trackpad device and new gen5 trackpad device in one
> cyapa driver for easily productions support based on
> customers' requirements, and add sysfs functions and interfaces
> supported that required by users and customers.
> Because the earlier gen3 and the latest gen5 trackpad devies using
> two different chipsets, and have different protocol and interfaces.
> If supported these two trackpad devices in two different drivers, then
> it will be difficult to manage productions and later firmware updates.
> it will cause customer don't know which one to use and update
> because these two trackpad devices have been used and integrated
> in same one productions at a time, so must to support these two trackpad
> devices in same on driver.
>
> Compare to v3, it has below changes:
> 1) Eliminate irq-state-remembering logic, remove irq help functions;
> 2) Remove state sync help functions instead of mutex_lock/mutex_unlock;
> 3) Fix comments and charaters errors and not consistent issues.
> 4) Fix other issues that pointed out in the review.
>
>
> The new architecture is made of:
> cyapa.c - the core of the architecture, supply interfaces and
> functions to system and read trackpad devices.
> cyapa_gen3.c - functions support for gen3 trackpad devices,
> cyapa_gen5.c - functions support for gen5 trackpad devices.
>
> Beside this introduction patch, it has 14 patches listed as below.
> For these patches each one is patched based on previous one.
>
> patch 1/14: re-architecture cyapa driver with core functions,
> and applying the device detecting function in async thread to speed
> up system boot time.
>
> patch 2/14: add cyapa driver power management interfaces support.
>
> patch 3/14: add cyapa driver runtime power management interfaces support.
>
> patch 4/14: add cyapa key function interfaces in sysfs system.
> Including read firmware version, get production ID, read baseline,
> re-calibrate trackpad baselines and do trackpad firmware update.
>
> patch 5/14: add read firmware image and read raw trackpad device'
> sensors' raw data interface in debugfs system.
>
> patch 6/14: add gen3 trackpad device basic functions support.
>
> patch 7/14: add gen3 trackpad device firmware update function support.
>
> patch 8/14: add gen3 trackpad device report baseline and do force
> re-calibrate functions support.
>
> patch 9/14: add gen3 trackpad device read firmware image function support.
>
> patch 10/14: add gen5 trackpad device basic functions support.
>
> patch 11/14: add gen5 trackpad device firmware update function support.
>
> patch 12/14: add gen5 trackpad device report baseline and do force
> re-calibrate functions support.
>
> patch 13/14: add gen5 trackpad device read firmware image and report
> sensors' raw data values functions support.
>
> patch 14/14: add function to monitor LID close event to off trackpad device.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
