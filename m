Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3LSQWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:22:41 -0500
Received: from mx0.aculab.com ([213.249.233.131]:34064 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754442Ab3LSQWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:22:40 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [PATCH 3/7] drivers: usb: Include appropriate header file in hcd.h
Date: Thu, 19 Dec 2013 16:21:06 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B74B6@saturn3.aculab.com>
In-Reply-To: <026c3f34e6c26d5456940c28a0f33da96064e023.1387439261.git.rashika.kheria@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/7] drivers: usb: Include appropriate header file in hcd.h
Thread-Index: Ac78oljvqwgMdlmsQLaWWxUGN3fSaQAM35Ag
References: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com> <026c3f34e6c26d5456940c28a0f33da96064e023.1387439261.git.rashika.kheria@gmail.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Rashika Kheria" <rashika.kheria@gmail.com>,
        <linux-kernel@vger.kernel.org>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJGMlW4005670

> From: Rashika Kheria
> Include header file include/linux/usb.h in include/linux/usb/hcd.h
> because structures usb_device, usb_host_config and usb_interface have
> their definitions in include/linux/usb.h.
> 
> This eliminates the following warning in include/linux/usb/hcd.h:
> include/linux/usb/hcd.h:311:44: warning: â€˜struct usb_deviceâ€™ declared inside parameter list [enabled
> by default]
> include/linux/usb/hcd.h:412:10: warning: â€˜struct usb_host_configâ€™ declared inside parameter list
> [enabled by default]
> include/linux/usb/hcd.h:614:9: warning: â€˜struct usb_interfaceâ€™ declared inside parameter list [enabled
> by default]

All it is necessary to do is add a declaration of the struct before the function definition.
There is no need to include the definition of the structure.
It is a shame that gcc doesn't defer this warning to any call site
(where an incorrect type would get passed).

	David
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
