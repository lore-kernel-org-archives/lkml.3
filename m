Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaIYQeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:34:00 -0400
Received: from 14.mo1.mail-out.ovh.net ([178.32.97.215]:41073 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751989AbaIYQd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:33:59 -0400
X-Greylist: delayed 2170 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2014 12:33:59 EDT
Message-ID: <54243B6B.9000102@ventoso.org>
Date: Thu, 25 Sep 2014 17:57:31 +0200
From: Luca Olivetti <luca@ventoso.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
        Fengguang Wu <fengguang.wu@intel.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, crope@iki.fi
Subject: Re: [media/dvb_usb_af9005] BUG: unable to handle kernel paging request
 (WAS: [media/em28xx] BUG: unable to handle kernel)
References: <20140919014124.GA8326@localhost> <541C7D9D.30908@googlemail.com> <541C826D.7060702@googlemail.com> <541C8A26.6050207@ventoso.org> <5421C187.2070407@googlemail.com> <5421E00B.2050404@ventoso.org> <54241E7D.3050201@googlemail.com>
In-Reply-To: <54241E7D.3050201@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 4282078822767561119
X-Ovh-Remote: 85.58.156.83 (83.pool85-58-156.dynamic.orange.es)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrheelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrheelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 25/09/14 15:54, Frank Schäfer ha escrit:
> 
> Am 23.09.2014 um 23:03 schrieb Luca Olivetti:
>> El 23/09/14 20:52, Frank Schäfer ha escrit:
>>
>>>>> This seems to be an ancient bug, which is known at least since 5 1/2 years:
>>>>> https://lkml.org/lkml/2009/2/4/350
>> [...]
>>>> #if defined(CONFIG_MODULE) || defined(CONFIG_DVB_USB_AF9005_REMOTE)
>>> What happens, if CONFIG_MODULES is enabled, but neither module
>>> af9005-remote nor any other IR module is available ?
>>> Has this ever been tested ?
>> I think I tested at the time and symbol_request returned NULL in that
>> case, however I'm not sure and I cannot find any documentation on how
>> symbol_request is supposed to work in that case.
> 
> Ok, thanks.
> I assume noone wants to invest some time into this old driver and covert
> it to todays kernel IR infrastructure as suggested by Antti ? :-)

Not me ;-)

> Then I'm going to send a patch with the 
> 
> #if defined(CONFIG_MODULE) || defined(CONFIG_DVB_USB_AF9005_REMOTE)
> 
> approach.
> That's at least better than leaving the bug unfixed.

Yes, it's an acceptable workaround until the bug in symbol_request is
fixed (because the bug actually is in symbol_request, isn't it?)

Bye
-- 
Luca
