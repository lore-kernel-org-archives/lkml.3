Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3GJSdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:33:00 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:43357 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754538Ab3GJSc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:32:58 -0400
Message-ID: <51DDA8D7.8010405@itdev.co.uk>
Date: Wed, 10 Jul 2013 19:32:55 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 22/51] Input: atmel_mxt_ts - Add shutdown function
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk> <1372337366-9286-23-git-send-email-nick.dyer@itdev.co.uk> <20130707052934.GB15453@core.coreip.homeip.net> <51DA8CB6.2010109@itdev.co.uk> <20130710165509.GC22992@core.coreip.homeip.net>
In-Reply-To: <20130710165509.GC22992@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
>> The patch disables the interrupt handler on shutdown.
>>
>> One of our customers reported a bug caused by input events being generated
>> during shutdown (for example if the user was touching the device whilst it
>> was turning off), which was solved by putting in this change.
> 
> What kind of bug? Could you please be more precise?

I did some more digging. Unfortunately the original problem report (some
time around March 2012) was in a customer ticket system that I no longer
have access to. It could well be trying to paper over a problem in their
app layer, to be honest.

>> However, now you've drawn my attention to it again, it seems to me that
>> probably a better thing for us to be doing would be to power off the
>> touchscreen controller here, and let the interrupt disable be handled by
>> core code - do you agree?
> 
> We'd be powering off everything in a moment anyway, no? Or is there a
> concern that the device will stay powered up even if the system is in off
> state?

I agree. I think it's best to not apply this patch for the moment, until we
can prove it's actually required.

Let me know if you want me to generate a new pull request.
