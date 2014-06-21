Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbaFUC0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 22:26:55 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:36564 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778AbaFUC0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 22:26:54 -0400
MIME-Version: 1.0
In-Reply-To: <1403294880.4076.7.camel@joe-AO725>
References: <1403283410-7022-1-git-send-email-xerofoify@gmail.com>
	<20140620195926.GY5500@mwanda>
	<1403294880.4076.7.camel@joe-AO725>
Date: Fri, 20 Jun 2014 22:26:53 -0400
Message-ID: <CAPDOMVi2humH7sL8DDkY=WJ3gWnehdeX8QEnNf6d8oTWftHXKA@mail.gmail.com>
Subject: Re: [PATCH] staging:rtl8821ae: rewrite legacy wifi check in halbcoutsrc
From: Nick Krause <xerofoify@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        pebolle@tiscali.nl, Himangi Saraogi <himangi774@gmail.com>,
        Konrad Zapalowicz <bergo.torino@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the feedback I will resend the patch fixed.
Otherwise please use Larry's idea.
Cheers Nick

On Fri, Jun 20, 2014 at 4:08 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2014-06-20 at 22:59 +0300, Dan Carpenter wrote:
>> On Fri, Jun 20, 2014 at 12:56:50PM -0400, Nicholas Krause wrote:
>> > Rewrites the wireless check for legacy checking in function
>> > halbtc_legacy to check for both Mode A and B.
>>
>> You're just guessing that A and B were intended but it could have been
>> something B and G...
>>
>> Don't do this.  Just leave the static checker warning there so someone
>> can fix it properly instead of introducing a second new bug and hiding
>> the warning so it's impossible to find.
>>
>
> It's most likely G anyway:
>
> drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.c:     if ((mac->mode == WIRELESS_MODE_B) || (mac->mode == WIRELESS_MODE_G))
> drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c:     if ((mac->mode == WIRELESS_MODE_B) || (mac->mode == WIRELESS_MODE_B))
>
> Larry probably has a better idea.
>
