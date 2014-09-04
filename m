Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaIDNwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:52:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:52261 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbaIDNwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:52:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,466,1406617200"; 
   d="scan'208";a="597909308"
From: "Usyskin, Alexander" <alexander.usyskin@intel.com>
To: Shuah Khan <shuahkh@osg.samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "satoru.takeuchi@gmail.com" <satoru.takeuchi@gmail.com>,
        "shuah.kh@samsung.com" <shuah.kh@samsung.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH 3.10 00/55] 3.10.54-stable review
Thread-Topic: [PATCH 3.10 00/55] 3.10.54-stable review
Thread-Index: AQHPyEVCFjzW8S0Mpk64//1lp3NuFpvw/FzQ
Date: Thu, 4 Sep 2014 13:52:18 +0000
Message-ID: <C980C034A53E0646B96866D6CE3D187A34776F55@HASMSX106.ger.corp.intel.com>
References: <20140903220453.653576908@linuxfoundation.org>
 <54086ADF.3090901@osg.samsung.com>
In-Reply-To: <54086ADF.3090901@osg.samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s84Dqx1h010136

Hi

Strange...
None of these patches touches init flow where error occurred.
Actually error print is called before patched code came into play.
It is possible that the FW was not ready at the beginning, so some retries are performed.

Thanks
--
Sasha



-----Original Message-----
From: Shuah Khan [mailto:shuahkh@osg.samsung.com] 
Sent: Thursday, September 04, 2014 16:37
To: Greg Kroah-Hartman; linux-kernel@vger.kernel.org; Usyskin, Alexander
Cc: torvalds@linux-foundation.org; akpm@linux-foundation.org; linux@roeck-us.net; satoru.takeuchi@gmail.com; shuah.kh@samsung.com; stable@vger.kernel.org; Shuah Khan
Subject: Re: [PATCH 3.10 00/55] 3.10.54-stable review

On 09/03/2014 04:04 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.54 release.
> There are 55 patches in this series, all will be posted as a response 
> to this one.  If anyone has any issues with these being applied, 
> please let me know.
> 
> Responses should be made by Fri Sep  5 22:04:21 UTC 2014.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.54-rc1.gz
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

rc-2 compiled and booted on my test system. There is one regression in dmesg with mei:

mei_me 0000:00:16.0: version message writet failed mei_me 0000:00:16.0: version message writet failed

Could this be related to:

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: nfc: fix memory leak in error path

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: reset client state on queued connect request

These two patches are in 3.14 and 3.16 as well and I didn't see this regression on those.

-- Shuah

--
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley) shuahkh@osg.samsung.com | (970) 217-8978
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
