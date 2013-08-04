Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab3HDUTD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 16:19:03 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:43589 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3HDUTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 16:19:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130803231447.GF5051@mwanda>
References: <1375562675-7816-1-git-send-email-jfrederich@gmail.com>
	<20130803231447.GF5051@mwanda>
Date: Sun, 4 Aug 2013 22:18:59 +0200
Message-ID: <CAF92uro8CGxjTkdwtxa-U1WwFE16F95YaQKOtSxsXXvPy7Le7g@mail.gmail.com>
Subject: Re: [PATCH] Staging: olpc_dcon: replace some magic numbers
From: Jens Frederich <jfrederich@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 4, 2013 at 1:14 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sat, Aug 03, 2013 at 10:44:35PM +0200, Jens Frederich wrote:
>> @@ -126,7 +127,7 @@ static int dcon_bus_stabilize(struct dcon_priv *dcon, int is_powered_down)
>>  power_up:
>>       if (is_powered_down) {
>>               x = 1;
>> -             x = olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
>> +             x = olpc_ec_cmd(EC_DCON_POWER_MODE, (u8 *)&x, 1, NULL, 0);
>                                                     ^^^^^^^^
> You didn't introduce this but using "x" as the inbuf here messy.
> It should be char instead of an int.  The code won't work on big
> endian systems.  I know this hardware is only available on little
> endian systems and that's why it's not a bug.  It's just an ugly
> thing to do.
>

Hello Dan, you're right. It doesn't matter whether the current
hardware is little or big endian. The driver should be able to
support both. I will fix it soon.

thanks,
Jens
