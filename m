Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbbAWIoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:44:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbbAWIof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:44:35 -0500
Date: Fri, 23 Jan 2015 09:44:17 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Wang Nan <wangnan0@huawei.com>
Cc: jeremie.galarneau@efficios.com, rostedt@goodmis.org, bigeasy@linutronix.de,
        lizefan@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] perf: convert: fix duplicate field names and
 avoid reserved keywords.
Message-ID: <20150123084416.GA2709@krava.brq.redhat.com>
References: <1421904958-24106-1-git-send-email-wangnan0@huawei.com>
 <1421905003-24242-1-git-send-email-wangnan0@huawei.com>
 <20150122132734.GB2473@krava.brq.redhat.com>
 <54C1AAA1.4000300@huawei.com>
 <54C1B793.3020509@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C1B793.3020509@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 10:53:07AM +0800, Wang Nan wrote:

SNIP

> >> SNIP
> >>
> >>>  
> >>> +/* If dup < 0, add a prefix. Else, add _dupl_X suffix. */
> >>> +static char *change_name(char *name, char *orig_name, int dup)
> >>> +{
> >>> +	char *new_name = NULL;
> >>> +	size_t len;
> >>> +
> >>> +	if (!name)
> >>> +		name = orig_name;
> >>> +
> >>> +	if (dup >= 10)
> >>> +		goto out;
> >>> +
> >>> +	if (dup < 0)
> >>> +		len = strlen(name) + sizeof("_");
> >>> +	else
> >>> +		len = strlen(orig_name) + sizeof("_dupl_X");
> >>
> >> if we allow for _dupl_10, should we use 'sizeof("_dupl_x")' ^^^ in here?
> >>
> 
> We don't allow _dupl_10. If dup is 10 or larger (see above two if clause), this function will
> return NULL.

ouch right.. ok ;-)

thanks,
jirka
