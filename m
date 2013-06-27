Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3F0DW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 23:22:29 -0400
Received: from mx2.parallels.com ([199.115.105.18]:45461 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3F0DW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 23:22:27 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3/5] Drivers: scsi: storvsc: Implement multi-channel
 support
Thread-Topic: [PATCH 3/5] Drivers: scsi: storvsc: Implement multi-channel
 support
Thread-Index: AQHOcuWLp2Kg5yHSpkeh+3gHvDVLmg==
Date: Thu, 27 Jun 2013 03:22:25 +0000
Message-ID: <1372303344.557.6.camel@dabdike>
References: <1370372674-10046-1-git-send-email-kys@microsoft.com>
	 <1370372709-10098-1-git-send-email-kys@microsoft.com>
	 <1370372709-10098-3-git-send-email-kys@microsoft.com>
In-Reply-To: <1370372709-10098-3-git-send-email-kys@microsoft.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.18.112.117]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDDDE8B0D64E6F43980E82A027B77EE3@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5R3MXOU010992

On Tue, 2013-06-04 at 12:05 -0700, K. Y. Srinivasan wrote:
> Implement multi-channel support for the storage devices.

This doesn't compile:

  CC [M]  drivers/scsi/storvsc_drv.o
drivers/scsi/storvsc_drv.c: In function â€˜handle_sc_creationâ€™:
drivers/scsi/storvsc_drv.c:763:35: error: â€˜struct vmbus_channelâ€™ has no
member named â€˜primary_channelâ€™
drivers/scsi/storvsc_drv.c: In function â€˜handle_multichannel_storageâ€™:
drivers/scsi/storvsc_drv.c:805:2: error: implicit declaration of
function
â€˜vmbus_set_sc_create_callbackâ€™ [-Werror=implicit-function-declaration]
drivers/scsi/storvsc_drv.c:812:2: error: implicit declaration of
function
â€˜vmbus_are_subchannels_presentâ€™ [-Werror=implicit-function-declaration]
drivers/scsi/storvsc_drv.c: In function â€˜storvsc_on_channel_callbackâ€™:
drivers/scsi/storvsc_drv.c:1223:13: error: â€˜struct vmbus_channelâ€™ has no
member named â€˜primary_channelâ€™
drivers/scsi/storvsc_drv.c:1224:19: error: â€˜struct vmbus_channelâ€™ has no
member named â€˜primary_channelâ€™
drivers/scsi/storvsc_drv.c: In function â€˜storvsc_do_ioâ€™:
drivers/scsi/storvsc_drv.c:1341:2: error: implicit declaration of
function
â€˜vmbus_get_outgoing_channelâ€™ [-Werror=implicit-function-declaration]
drivers/scsi/storvsc_drv.c:1341:19: warning: assignment makes pointer
from integer without a cast [enabled by default]
cc1: some warnings being treated as errors
make[2]: *** [drivers/scsi/storvsc_drv.o] Error 1

I assume this is a cross tree dependency?  What's the relevant branch I
need?

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
