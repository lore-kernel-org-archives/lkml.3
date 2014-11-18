Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaKRA1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:27:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:50124 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752545AbaKRA1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:27:49 -0500
Date: Mon, 17 Nov 2014 19:27:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [PATCH 20/26 v5] seq_buf: Add seq_buf_can_fit() helper function
Message-ID: <20141117192733.0ab1ba2e@gandalf.local.home>
In-Reply-To: <1416269253.29010.4.camel@perches.com>
References: <20141115045847.712848224@goodmis.org>
	<20141115050604.073390701@goodmis.org>
	<20141117123642.1de9252e@gandalf.local.home>
	<1416269253.29010.4.camel@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014 16:07:33 -0800
Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-11-17 at 12:36 -0500, Steven Rostedt wrote:
> > On Fri, 14 Nov 2014 23:59:07 -0500
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > 
> > > Add a seq_buf_can_fit() helper function that removes the possible mistakes
> > > of comparing the seq_buf length plus added data compared to the size of
> > > the buffer.
> []
> > > +static bool seq_buf_can_fit(struct seq_buf *s, size_t len)
> > > +{
> > > +	return s->len + len < s->size;
> > > +}
> > > +
> 
> Why is this useful?

Places the logic in one place and makes the next patch much shorter.

As the change log states, makes mistakes much less likely to happen
(note, I made one doing the next change and this makes me more
confident not to do another one)

-- Steve
