Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaE2Tzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:55:42 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:41228 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755455AbaE2Tzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:55:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEgAOmPh1NbslZz/2dsb2JhbABZgweDRKd4AQEBAQEBBQGYEgICAQEBgQ0XdIIlAQEFOhwjEAgDGC45HgYTGYgtAddkF4VViH0HhEABA49AijQBkymDOjuBMAc
Date: Thu, 29 May 2014 21:55:43 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 3/3] init/calibrate.c: no prefix in logging
Message-Id: <20140529215543.eae390965cb7948ecf57812e@skynet.be>
In-Reply-To: <20140529144321.GB32669@windriver.com>
References: <20140529101458.047becb88f3ba83196045465@skynet.be>
	<20140529144321.GB32669@windriver.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014 10:43:21 -0400
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> [[PATCH V2 3/3] init/calibrate.c: no prefix in logging] On 29/05/2014 (Thu 10:14) Fabian Frederick wrote:
> 
> > define pr_fmt without prefix to avoid any default prefix update
> 
> Again, it isn't clear to me what you are trying to achieve here.
> The printk.h header already has the define which you add here.
> 
> A general rule for commits is to cover off three points.
> 
> 1) Describe what the user visible symptom is, i.e. "printk from
> calibrate.c are appearing with verbose prefix blah blah..."
> 
> 2) Describe the underlying reason for the bug/issue, i.e. "This happens
> because macro blah comes from foo.h but only when bar is defined."
> 
> 3) Describe how your fix works and why it is the right/best fix for the
> issue, i.e. "Here we introduce blah blah which will ensure ...."
> 
> Also, to make life easier for maintainers, you probably want to add a
> 0/N lead-in (see --cover-letter) which describes what you are trying to
> achieve with the whole series, and when you create a v2 of the series,
> you need to list in there for the maintainer how v2 differs from v1.
> 
> Finally try not to send a v2 within hours of sending a v1 -- give a
> chance for the v1 to get looked at 1st; typically at least one day.
> 
> Thanks,
> Paul.

Thanks for your help, I'll send more details.

Regards,
Fabian

> --
> 
> > 
> > Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  init/calibrate.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/init/calibrate.c b/init/calibrate.c
> > index fb9be44..169e98d 100644
> > --- a/init/calibrate.c
> > +++ b/init/calibrate.c
> > @@ -4,6 +4,8 @@
> >   *  Copyright (C) 1991, 1992  Linus Torvalds
> >   */
> >  
> > +#define pr_fmt(fmt) fmt
> > +
> >  #include <linux/jiffies.h>
> >  #include <linux/delay.h>
> >  #include <linux/init.h>
> > -- 
> > 1.9.1
> > 
