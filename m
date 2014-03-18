Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbaCRNLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:11:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbaCRNLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:11:13 -0400
Date: Tue, 18 Mar 2014 10:10:48 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 3/5] tools lib traceevent: use else-if cascade, not
 separate ifs
Message-ID: <20140318131048.GA3585@infradead.org>
References: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
 <1395095198-20034-4-git-send-email-artagnon@gmail.com>
 <87d2hkrl32.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2hkrl32.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 18, 2014 at 05:02:09PM +0900, Namhyung Kim escreveu:
> On Mon, 17 Mar 2014 18:26:36 -0400, Ramkumar Ramachandra wrote:
> > When token cannot be more than one value, it seems wasteful to go
> > through all the strcmp() calls. Use an else-if cascade instead.
> 
> I think the end result will be same since it returns from inside the
> block, right?

Exactly :-)

We could have it changed to something like:

	if (strcmp()) {
		ret = bla();
		goto out_free_token;
	}
.
.
.
out_free_token:
	free_token(token);
	return ret;

 
> Thanks,
> Namhyung
> 
> >
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> > ---
> >  tools/lib/traceevent/event-parse.c | 12 ++++--------
> >  1 file changed, 4 insertions(+), 8 deletions(-)
> >
> > diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> > index 42bc571..7a8d9ae 100644
> > --- a/tools/lib/traceevent/event-parse.c
> > +++ b/tools/lib/traceevent/event-parse.c
> > @@ -2770,21 +2770,17 @@ process_function(struct event_format *event, struct print_arg *arg,
> >  		free_token(token);
> >  		is_flag_field = 1;
> >  		return process_flags(event, arg, tok);
> > -	}
> > -	if (strcmp(token, "__print_symbolic") == 0) {
> > +	} else if (strcmp(token, "__print_symbolic") == 0) {
> >  		free_token(token);
> >  		is_symbolic_field = 1;
> >  		return process_symbols(event, arg, tok);
> > -	}
> > -	if (strcmp(token, "__print_hex") == 0) {
> > +	} else if (strcmp(token, "__print_hex") == 0) {
> >  		free_token(token);
> >  		return process_hex(event, arg, tok);
> > -	}
> > -	if (strcmp(token, "__get_str") == 0) {
> > +	} else if (strcmp(token, "__get_str") == 0) {
> >  		free_token(token);
> >  		return process_str(event, arg, tok);
> > -	}
> > -	if (strcmp(token, "__get_dynamic_array") == 0) {
> > +	} else if (strcmp(token, "__get_dynamic_array") == 0) {
> >  		free_token(token);
> >  		return process_dynamic_array(event, arg, tok);
> >  	}
