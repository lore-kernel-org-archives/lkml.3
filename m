Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935183AbaGYUHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:07:03 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65027 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934548AbaGYUHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:07:00 -0400
Date: Fri, 25 Jul 2014 13:06:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: cheng wei Lin <dusonlin@emc.com.tw>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        bleung@chromium.org, agnescheng@chromium.org,
        =?utf-8?B?IlNSRDEgJiM2NTUzMzvonazouJAmIzY1NTMzOyYjNjU1MzM7P+mDvSYjNjU1?=
	 =?utf-8?Q?33=3B&#65533=3B&#65533=3B&#65533=3B=22?= 
	<phoenix@emc.com.tw>,
        jeff.chuang@emc.com.tw
Subject: Re: [PATCH v2] Input: add i2c/smbus driver for elan touchpad
Message-ID: <20140725200656.GA2827@core.coreip.homeip.net>
References: <1389064083-11018-1-git-send-email-dusonlin@emc.com.tw>
 <20140724180516.GA26752@core.coreip.homeip.net>
 <73E9FA09-55D6-409D-A902-29CC3F414CBF@emc.com.tw>
 <20140725182053.GA23356@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725182053.GA23356@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 11:20:53AM -0700, Dmitry Torokhov wrote:
> Hi Duson,
> 
> On Sat, Jul 26, 2014 at 02:05:02AM +0800, cheng wei Lin wrote:
> > Hi Dmitry,
> > 
> > Sorry for late to reply you and thanks for your command
> > 
> > Yes, I also agree, it looks great than my original code.
> 
> Thank you for confirming.
> 
> > So, should I modify this and upstream v3 patch for you?
> 
> No, that is fine, I'll fix it up on my end.

Hmm, I am also looking at elan_get_x_resolution() and in case of SMB
we'll never get negative result since we are doing
"elan_convert_res(val[1] & 0x0F)". Was it intended as such, or do we
need to extend sign here via

	(((char)(val[1] & 0x0F)) << 4) >> 4;

Thanks.

-- 
Dmitry
