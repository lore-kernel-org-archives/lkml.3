Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab3IRB5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 21:57:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab3IRB5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 21:57:41 -0400
Date: Tue, 17 Sep 2013 21:57:31 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Luiz Capitulino <lcapitulino@redhat.com>, linux-kernel@vger.kernel.org,
        oleg@redhat.com
Subject: Re: [RFC] audit: avoid soft lockup in audit_log_start()
Message-ID: <20130918015731.GA13962@madcap2.tricolour.ca>
References: <20130828182114.6b67ea90@redhat.com>
 <522DDBED.2020505@openvz.org>
 <1378829005.12992.30.camel@flatline.rdu.redhat.com>
 <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 03:28:42PM -0700, Andrew Morton wrote:
> On Tue, 10 Sep 2013 12:03:25 -0400 Eric Paris <eparis@redhat.com> wrote:
> 
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -1215,9 +1215,10 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
> > > 
> > >                          sleep_time = timeout_start + audit_backlog_wait_time -
> > >                                          jiffies;
> > > -                       if ((long)sleep_time > 0)
> > > +                       if ((long)sleep_time > 0) {
> > >                                  wait_for_auditd(sleep_time);
> > > -                       continue;
> > > +                               continue;
> > > +                       }
> > >                  }
> > >                  if (audit_rate_check() && printk_ratelimit())
> > >                          printk(KERN_WARNING
> > 
> > I think this is the right(ish) fix, at least it gets at the real bug.
> > 829199197a430dade2519d54f5545c4a094393b8 definitely is the problem.
> 
> um, which idiot wrote that?

Heh...

> Thngs are somewhat foggy at present.  I have two patches from
> Dan/Chuck:
> 
> Subject: audit: fix soft lockups due to loop in audit_log_start() wh,en audit_backlog_limit exceeded
> Subject: audit: two efficiency fixes for audit mechanism

I have a patchset very similar to the first and breaking up the second,
with some added bits to address other related issues I'll post RSN...

> and two from Luiz:
> 
> Subject: audit: flush_hold_queue(): don't drop queued SKBs
> Subject: audit: kaudit_send_skb(): make non-blocking call to netlink_unicast()
> 
> and now a protopatch from Konstantin which eparis likes.
> 
> So, umm, guys, can you please devote a bit of time to working out what
> we should do here?

It is coming...  I'm hearing reports from others of the same bug, so it
is getting around...


- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545
