Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaESTEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:04:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26189 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaESTEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:04:51 -0400
Date: Mon, 19 May 2014 22:04:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navin.patidar@gmail.com>
Cc: devel@driverdev.osuosl.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 05/28] staging: rtl8188eu: Remove unused function
 rtl8188eu_ps_func()
Message-ID: <20140519190434.GS16255@mwanda>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
 <1400426361-19596-6-git-send-email-navin.patidar@gmail.com>
 <20140519105208.GV15585@mwanda>
 <CAPV97ydMiagwQqS6cAS_ck1+XOZWKH82okPG0V1fLcpsLKL8zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPV97ydMiagwQqS6cAS_ck1+XOZWKH82okPG0V1fLcpsLKL8zg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 09:19:07PM +0530, navin patidar wrote:
> > You have changed it to return _FAIL instead of true.  Perhaps that is ok
> > but you need to explain it in the changelog.
> >
> oops, I'll resend this patch with proper changelog.
> I have one question, do i need to send v2 of whole patch series or
> just this patch.

Greg, none of the other patches rely on this one.  Could you apply them
and drop this one?  This one is also fine except for the changelog but
Navin can send a new version in a new thread.

[ General rules on redoing patches threads ]

When you are sending a patch series and someone asks you to update one
changelog, then you can resend just the patch but you must set the
In-Reply-To email header.  You didn't do that for [PATCH 13/28] so now
the v2 of that patch is in its own thread.  That's fine because it can
be applied in any order and it doesn't matter.

If you are sending a patch series and updating one in the middle means
that the other patches won't apply then you should redo the whole thing
or ask Greg to apply the first 7 patches and redo the last ones.

If you are sending a series and you have to update a lot of patches then
resend the whole thing because otherwise it becomes confusing.

[ This patch in particular ]

Ok.  So I looked at this and the function which calls
rtw_hal_intf_ps_func() is never called, so you're right that this
function isn't used.  Probably this is what you were going to put in
your changelog and I would check and that's fine.

But when I am reviewing these kinds of "delete unused code" patches then
I just "Ok.  If there are still users the compile will break."  So I
don't have to look outside the email client.  So I would prefer if you
did it in this order:

[patch 1/4] staging: rtl8188eu: Remove unused function rtw_interface_ps_func()
[patch 2/4] staging: rtl8188eu: Remove unused function rtw_hal_intf_ps_func()
[patch 3/4] staging: rtl8188eu: Remove unused function pointer ->interface_ps_func
[patch 4/4] staging: rtl8188eu: staging: rtl8188eu: Remove unused function rtl8188eu_ps_func()

You can fold them together if you want, that's not my point.  What I'm
saying is that when you remove the ->interface_ps_func pointer first,
it's obvious that rtl8188eu_ps_func() is unused because otherwise the
compiler will complain.

But on the other hand, I also don't really care about this patch.  I
know it is ok now because I have verified it.  Resend it however you
want and I will Ack it.  No worries.  I hope the long explanation is
helpfull and thanks for doing this cleanup work.

regards,
dan carpenter
