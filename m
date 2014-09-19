Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbaISUbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:31:08 -0400
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:55113 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700AbaISUbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:31:07 -0400
X-Greylist: delayed 2133 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Sep 2014 16:31:07 EDT
Message-ID: <541C8A26.6050207@ventoso.org>
Date: Fri, 19 Sep 2014 21:55:18 +0200
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
References: <20140919014124.GA8326@localhost> <541C7D9D.30908@googlemail.com> <541C826D.7060702@googlemail.com>
In-Reply-To: <541C826D.7060702@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 9955206977484589471
X-Ovh-Remote: 85.58.156.79 (79.pool85-58-156.dynamic.orange.es)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrgeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrgeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 19/09/14 21:22, Frank Schäfer ha escrit:

>>
>> So symbol_request() returns pointers.!= NULL
>>
>> A closer look at the definition of symbol_request() shows, that it does
>> nothing if CONFIG_MODULES is disabled (it just returns its argument).
>>
>>
>> One possibility to fix this bug would be to embrace these three lines with
>>
>> #ifdef CONFIG_DVB_USB_AF9005_REMOTE
>> ...
>> #endif
> Luca, what do you think ?
> 
> This seems to be an ancient bug, which is known at least since 5 1/2 years:
> https://lkml.org/lkml/2009/2/4/350

Well, it's been a while so I don't remember the details, but I think the
same now as then ;-)
The idea behind CONFIG_DVB_USB_AF9005_REMOTE was to provide an
alternative implementation (based on lirc, at the time it wasn't in the
kernel), since this adapter doesn't decode the IR pulses by itself.
In theory you could leave it undefined but still provide an
implementation in a different module. Just adding

#ifdef CONFIG_DVB_USB_AF9005_REMOTE

would nuke the (futile?) effort.

Now, since the problem seems to be with CONFIG_MODULES disabled, maybe
you could combine both conditions

#if defined(CONFIG_MODULE) || defined(CONFIG_DVB_USB_AF9005_REMOTE)

Bye
-- 
Luca

