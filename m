Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaIYNwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:52:37 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:62453 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaIYNwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:52:36 -0400
Message-ID: <54241E7D.3050201@googlemail.com>
Date: Thu, 25 Sep 2014 15:54:05 +0200
From: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Luca Olivetti <luca@ventoso.org>, Fengguang Wu <fengguang.wu@intel.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, crope@iki.fi
Subject: Re: [media/dvb_usb_af9005] BUG: unable to handle kernel paging request
 (WAS: [media/em28xx] BUG: unable to handle kernel)
References: <20140919014124.GA8326@localhost> <541C7D9D.30908@googlemail.com> <541C826D.7060702@googlemail.com> <541C8A26.6050207@ventoso.org> <5421C187.2070407@googlemail.com> <5421E00B.2050404@ventoso.org>
In-Reply-To: <5421E00B.2050404@ventoso.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 23.09.2014 um 23:03 schrieb Luca Olivetti:
> El 23/09/14 20:52, Frank Schäfer ha escrit:
>
>>>> This seems to be an ancient bug, which is known at least since 5 1/2 years:
>>>> https://lkml.org/lkml/2009/2/4/350
> [...]
>>> #if defined(CONFIG_MODULE) || defined(CONFIG_DVB_USB_AF9005_REMOTE)
>> What happens, if CONFIG_MODULES is enabled, but neither module
>> af9005-remote nor any other IR module is available ?
>> Has this ever been tested ?
> I think I tested at the time and symbol_request returned NULL in that
> case, however I'm not sure and I cannot find any documentation on how
> symbol_request is supposed to work in that case.

Ok, thanks.
I assume noone wants to invest some time into this old driver and covert
it to todays kernel IR infrastructure as suggested by Antti ? :-)
Then I'm going to send a patch with the 

#if defined(CONFIG_MODULE) || defined(CONFIG_DVB_USB_AF9005_REMOTE)

approach.
That's at least better than leaving the bug unfixed.

Regards,
Frank

