Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab3DTWbI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 18:31:08 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:34830 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab3DTWbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 18:31:06 -0400
Date: Sat, 20 Apr 2013 15:31:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kref: minor cleanup
Message-ID: <20130420223103.GA15927@kroah.com>
References: <1366421634-20773-1-git-send-email-anatol.pomozov@gmail.com>
 <20130420022415.GA24713@kroah.com>
 <CAOMFOmU2ig8JXb_+YtQGHkU5+c19S7Y=qWXjb+0HE1TwmLO3kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMFOmU2ig8JXb_+YtQGHkU5+c19S7Y=qWXjb+0HE1TwmLO3kw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 09:27:20PM -0700, Anatol Pomozov wrote:
> >> -static struct kobject *kobject_get_unless_zero(struct kobject *kobj)
> >> +static struct kobject *__must_check kobject_get_unless_zero(
> >> +             struct kobject *kobj)
> >
> > __must_check needs to be in the .h file, not the .c file.
> 
> This function is static and defined in *.c. But I think the function
> should be declared in *.h as it might be useful for others. I'll
> resend patch tomorrow.

No, I was trying to give you a hint in that it is not needed because
this function is not exported, sorry for being vague.

greg k-h
