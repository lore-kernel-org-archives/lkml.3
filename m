Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaI3Gpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:45:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:12182 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaI3Gpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:45:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393398333"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: "richard@nod.at" <richard@nod.at>
CC: "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 4/4] UBI: Fastmap: Ensure that only one fastmap work is
 scheduled
Thread-Topic: [PATCH 4/4] UBI: Fastmap: Ensure that only one fastmap work is
 scheduled
Thread-Index: AQHP3Hocei/9zHAohUmCXsE+0dP68Q==
Date: Tue, 30 Sep 2014 06:45:24 +0000
Message-ID: <1412059523.3904.11.camel@sauron.fi.intel.com>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
	 <1412029248-22454-5-git-send-email-richard@nod.at>
In-Reply-To: <1412029248-22454-5-git-send-email-richard@nod.at>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.54]
Content-Type: text/plain; charset="utf-8"
Content-ID: <15448B3936E38841B49BE9986495A167@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8U6jmYa019768

On Tue, 2014-09-30 at 00:20 +0200, Richard Weinberger wrote:
> +       spin_lock(&ubi->wl_lock);
> +       ubi->fm_work_scheduled = 0;
> +       spin_unlock(&ubi->wl_lock);

Andrew Morton once said me that if I am protecting an integer change
like this with a spinlock, I have a problem in my locking design. He was
right for my particular case.

Integer is changes atomic. The only other thing spinlock adds are the
barriers.

-- 
Best Regards,
Artem Bityutskiy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
