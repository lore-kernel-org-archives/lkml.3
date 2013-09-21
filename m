Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab3IUJcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 05:32:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18865 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab3IUJch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 05:32:37 -0400
Date: Sat, 21 Sep 2013 12:32:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: devel@driverdev.osuosl.org, Greg KH <gregkh@linuxfoundation.org>,
        harsh1kumar@gmail.com, linux-kernel@vger.kernel.org,
        Adil Mujeeb <mujeeb.adil@gmail.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 15/24] Staging: winbond: reg: seventh of the patches
 that fixes lines over 80 characters
Message-ID: <20130921093217.GC6247@mwanda>
References: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
 <1379339024-12157-16-git-send-email-ikerpedrosam@gmail.com>
 <CANBXnMm7QCab3cU4NMzmA3OjXckcUx5dakyD_TRwfj3j2_02MA@mail.gmail.com>
 <20130917094326.GO19256@mwanda>
 <20130920164508.ec1ab4101bcc3c77396c943d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920164508.ec1ab4101bcc3c77396c943d@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 04:45:08PM +0200, Iker Pedrosa wrote:
> On Tue, 17 Sep 2013 12:43:26 +0300
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > On Tue, Sep 17, 2013 at 02:29:22PM +0530, Adil Mujeeb wrote:
> > > Hi,
> > > 
> > > 
> > > >-       PowerData = (1 << 31) | (0 << 30) | (24 << 24) |
> > > BitReverse(w89rf242_txvga_data[i][0], 24);
> > > >+       PowerData = (1 << 31) | (0 << 30) | (24 << 24)
> > > >+                           | BitReverse(w89rf242_txvga_data[i][0], 24);
> > > .....
> > > .....
> > > 
> > > >-       reg->M38_MacControl = (DEFAULT_RATE_RETRY_LIMIT << 8) |
> > > (DEFAULT_LONG_RETRY_LIMIT << 4) | DEFAULT_SHORT_RETRY_LIMIT;
> > > >+       reg->M38_MacControl = (DEFAULT_RATE_RETRY_LIMIT << 8) |
> > > >+                                      (DEFAULT_LONG_RETRY_LIMIT << 4) |
> > > >+                                      DEFAULT_SHORT_RETRY_LIMIT;
> > > 
> > > I think consistency is needed. Either break the lines putting the OR
> > > operator ( | ) at the start of new line or at the end of each line. People
> > > has its own preference but here you have used both style in single file.
> > > Just a suggestion.
> > > 
> > 
> > Put the '|' character at the end of the line.  That's the New Unwritten
> > Style Guidelines.  Most of the kernel does it this way and it's easier
> > to read.
> > 
> > But this could be fixed in a later patch instead of redoing the whole
> > series.
> > 
> > regards,
> > dan carpenter
> > 
> 
> I will change it for the new version of this patch but I want to wait
> some days until everybody looks the patches that I've sent.

If they haven't looked after three days then they won't look.  Greg will
look over the patches but everyone else is done.

If you can redo this patch without changing any of the others then just
redo it.  But otherwise I would prefer if you do it in a follow on
patch.  It gets tiresome to review patchsets over and over.

Joe's comment on [PATCH v2 21/24] is correct.  Technically the original
code was buggy as well, but using dev_err() means it will generate a
popup notification in Gnome so the new code is worse.  Redo that one.
Hopefully, you can just redo the one patch without redoing the following
3 patches.

So either send a single patch to Joe's comment, or send an email in
reply to Joe's comment, "Ok.  I will redo the last 4 patches".  Use the
--in-reply-to option of git to send email in reply to a thread.  Pratice
in an email to yourself before sending it to the list.

regards,
dan carpenter
