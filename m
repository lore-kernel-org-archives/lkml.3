Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3AVNRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:17:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab3AVNRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:17:07 -0500
Date: Tue, 22 Jan 2013 14:16:47 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tools lib traceevent: Handle dynamic array's element
 size properly
Message-ID: <20130122131646.GB1037@krava.brq.redhat.com>
References: <1358772251-4411-1-git-send-email-jolsa@redhat.com>
 <1358829942.21576.49.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358829942.21576.49.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 11:45:42PM -0500, Steven Rostedt wrote:
> On Mon, 2013-01-21 at 13:44 +0100, Jiri Olsa wrote:

SNIP

> > +	for (i = 0; table[i].type; i++) {
> > +		if (!strcmp(table[i].type, field->type_dyn))
> > +			return table[i].size;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static int event_read_fields(struct event_format *event, struct format_field **fields)
> >  {
> >  	struct format_field *field = NULL;
> > @@ -1390,7 +1418,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
> >  				field->type = new_type;
> >  				strcat(field->type, " ");
> >  				strcat(field->type, field->name);
> > -				free_token(field->name);
> > +				field->type_dyn = field->name;
> 
> This is only used in this function (the field_dynamic_elem_size() is
> only called here). Can we not add the field->type_dyn, and just use a
> local variable here. You just need to make sure you free it correctly.

ook, will send v2

thanks,
jirka
