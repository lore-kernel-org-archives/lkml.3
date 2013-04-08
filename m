Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935471Ab3DHRyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:54:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:38484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934750Ab3DHRye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:54:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="291869652"
From: "Luck, Tony" <tony.luck@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>, Joe Perches <joe@perches.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: RE: [PATCH] staging/adt7316 Fix some 'interesting' string operations
Thread-Topic: [PATCH] staging/adt7316 Fix some 'interesting' string
 operations
Thread-Index: AQHOMq6/C35FJgeBT0ab5H1U7F4x5ZjMnrdQ
Date: Mon, 8 Apr 2013 17:54:26 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1EA4089E@ORSMSX104.amr.corp.intel.com>
References: <515df29417437372eb@agluck-desk.sc.intel.com>
 <515FF438.6090305@metafoo.de>
In-Reply-To: <515FF438.6090305@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r38Hsc52029333

> I think it is a good idea to switch directly to strtobool. But anyway, if you
> don't want to respin the patch it is fine as it is.

I didn't know that strtobool() existed ... but now that I do I agree that it would
be better to use it here.  But ... I'm less comfortable updating the patch to use
it. User visible behavior would change (currently just "1" is considered "true",
but strtobool would also accept "y" and "Y").  I'd also have to think hard about
what to do if strtobool() said the input was not a valid boolean.

Thanks for the review.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
