Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416AbaKMWgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:36:35 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:46183 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933604AbaKMWge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:36:34 -0500
Message-ID: <1415918185.19075.1.camel@sipsolutions.net>
Subject: Re: [PATCH] devcoredump: provide a one-way disable function
From: Johannes Berg <johannes@sipsolutions.net>
To: Kees Cook <keescook@google.com>
Cc: Greg Kroah-Hartmann <gregkh@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 13 Nov 2014 23:36:25 +0100
In-Reply-To: <CAGXu5jL8CBPXyiZM+AQpNUOvF=rQxay7ozmEaLuRL8WSiRQ2tA@mail.gmail.com> (sfid-20141113_225649_251686_3A86B085)
References: <1415913389-17734-1-git-send-email-johannes@sipsolutions.net>
	 <CAGXu5jL8CBPXyiZM+AQpNUOvF=rQxay7ozmEaLuRL8WSiRQ2tA@mail.gmail.com>
	 (sfid-20141113_225649_251686_3A86B085)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 13:56 -0800, Kees Cook wrote:

> > +       /*
> > +        * This essentially makes the attribute write-once, since you can't
> > +        * go back to not having it disabled. This is intentional, it serves
> > +        * as a system lockdown feature.
> > +        */
> > +       if (tmp != 1)
> > +               return -EINVAL;
> 
> Just a nit, but writing "0" is valid if devcd_disabled = false?

I thought about that too, but what would the point be? The only
operation you ever can/want to do is writing "1" to it to disable the
framework.

johannes

