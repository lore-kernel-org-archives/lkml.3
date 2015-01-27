Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbbA0RYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:24:19 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:38725 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754192AbbA0RYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:24:18 -0500
Date: Tue, 27 Jan 2015 12:24:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Borislav Petkov <bp@alien8.de>, Richard Weinberger <richard@nod.at>,
        linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
Message-ID: <20150127172415.GC25043@home.goodmis.org>
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de>
 <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com>
 <54C77E69.7050600@ahsoftware.de>
 <20150127120855.GA9254@pd.tnic>
 <54C7816A.8050800@ahsoftware.de>
 <54C78524.3070901@nod.at>
 <54C7881F.6020501@ahsoftware.de>
 <20150127142120.GA3351@pd.tnic>
 <54C7C2EC.7010605@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C7C2EC.7010605@ahsoftware.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 05:55:08PM +0100, Alexander Holler wrote:
> >
> >So, even if you don't always agree with them, you need to realize that
> >those are the people responsible for that code and if they request a
> >reasonable change in your submission, you have to do it. It is that
> >simple.
> 
> Totally wrong. I'm free to just stop discussion. That's the difference
> between the old type of os communites and corporates where people do what
> they've got instructed from above without discussion. I offered something
> and wasn't paid to do something.

Yes, you are free to stop this discussion and not do the changes that were
asked. That is your prerogative. If you don't want to do what the maintainer
asked you to do, you have every right to ignore it. The change will just
not go in.

The question is, does someone else want this change too? If not, then this
change will go away and be a footnote of lkml archives. If people would
like this change. The maintainer could easily add it the way he wants it
added. The reason maintainers usually do not do such things is because
it is more polite to have the original submitter do the change and get credit
in the change logs. If the maintainer does the work, the best the original
submitter could get is some mention in the change log. Some people care
about getting the commit credit, so maintainers try to respect that.

> 
> It was worth a try but I don't have to build a framework to achieve
> something simple just because a maintainer requests it.

You are again correct. But as Boris stated, it is the maintainer that must
maintain and defend the code. If someone asks why the code is done some way,
it is the maintainer that must respond. Saying, I just took someone's patch
is not acceptable. The maintainer is responsible for all code that they
maintain regardless if they wrote it or not.

> 
> >  [ Unless you have a good argument against it but that's a different
> >    story and this is what is called the "review" process. ]
> 
> I want to see the mentionend information and want that it is seen and do not
> want to hide it away deep in the sysfs where it actually must be searched.

For most people a message in dmesg is not very useful. What you are asking for
is to print a characteristic of a device. Something that someone might want to
check much later in boot, where, as Boris stated, the dmesg could have been
flushed (by systemd, which loves to write stuff to the kernel buffers), and
there's no way to find out this information. The print message is long gone.
Having a static location like sysfs is the proper place, because user space
tools can always access it.

Is this something a tool would like to find out? If so, parsing dmesg is not
the way to go. Looking it up in sysfs is.

You are free to end this discussion. We are not forcing you to. But it is
obvious that the maintainer does not agree with your approach, so you can
either write a patch that he agrees with or not. If you do not, then you
will not get the feature you want in the kernel. No big deal either way.

-- Steve

