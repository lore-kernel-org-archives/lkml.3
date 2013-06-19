Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934276Ab3FSIwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:52:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:40074 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933755Ab3FSIwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:52:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,895,1363158000"; 
   d="scan'208";a="352225820"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: RE: INTEL_MEI_ME=y breaks suspend on 3.10-rc3
Thread-Topic: INTEL_MEI_ME=y breaks suspend on 3.10-rc3
Thread-Index: AQHObFGFS521D9lhe0OuLxJicUIio5k8u1SA
Date: Wed, 19 Jun 2013 08:52:21 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B028D67D0@HASMSX106.ger.corp.intel.com>
References: <51ACD4B2.7070107@message-id.googlemail.com>
 <51ACD600.2020805@message-id.googlemail.com>
 <CA+i0qc4eEDjygde4+frqd51JutTDeoJ8mTp-K==gwG_7ghJwcw@mail.gmail.com>
 <51C0A684.8030405@message-id.googlemail.com>
In-Reply-To: <51C0A684.8030405@message-id.googlemail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5J8qrq2007136

> 
> However, it still does not work, commit
> 42f132febff3b7b42c6c9dbfc151f29233be3132 does not seem to help enough
> on my hardware.
> 
> Still just unbinding and rebinding with
> echo 0000:00:03.0 > /sys/bus/pci/drivers/mei_me/unbind
> echo 0000:00:03.0 > /sys/bus/pci/drivers/mei_me/bind
> 
> triggers lots of
> [  318.330981] mei_me 0000:00:03.0: reset: wrong host start response [
> 318.330984] mei_me 0000:00:03.0: unexpected reset: dev_state = RESETTING
> [  318.330990] mei_me 0000:00:03.0: reset: unexpected enumeration
> response hbm.
> [  318.330993] mei_me 0000:00:03.0: unexpected reset: dev_state =
> RESETTING [  318.331016] mei_me 0000:00:03.0: reset: wrong host start
> response [  318.331019] mei_me 0000:00:03.0: unexpected reset: dev_state
> = RESETTING [  346.571031] mei_me 0000:00:03.0: reset: init clients timeout
> hbm_state = 1.
> [  346.571047] mei_me 0000:00:03.0: unexpected reset: dev_state =
> RESETTING [  376.631030] mei_me 0000:00:03.0: reset: init clients timeout
> hbm_state = 1.
> [  376.631044] mei_me 0000:00:03.0: unexpected reset: dev_state =
> RESETTING
> 
> It does, however, calm down after a few seconds, only to spew a few lines
> once every 30 seconds:
> 
> [  406.691032] mei_me 0000:00:03.0: reset: init clients timeout hbm_state = 1.
> [  406.691048] mei_me 0000:00:03.0: unexpected reset: dev_state =
> RESETTING [  436.751033] mei_me 0000:00:03.0: reset: init clients timeout
> hbm_state = 1.
> [  436.751047] mei_me 0000:00:03.0: unexpected reset: dev_state =
> RESETTING [  466.811030] mei_me 0000:00:03.0: reset: init clients timeout
> hbm_state = 1.
> [  466.811044] mei_me 0000:00:03.0: unexpected reset: dev_state =
> RESETTING
> 
> So it is not yet fixed, unfortunately.

Not sure I understand how to reproduce it.  it is still falling on suspend/resume or just unbind/bind?
Would you be so kind and send me the whole log.

Thanks
Tomas


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
