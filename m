Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbbAUOUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:20:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbbAUOUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:20:00 -0500
Date: Wed, 21 Jan 2015 15:19:38 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Wang Nan <wangnan0@huawei.com>
Cc: jeremie.galarneau@efficios.com, bigeasy@linutronix.de, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] perf: convert: fix duplicate field names and avoid
 reserved keywords.
Message-ID: <20150121141938.GB6835@krava.brq.redhat.com>
References: <20150120130609.GC15315@krava.brq.redhat.com>
 <1421810634-1373-1-git-send-email-wangnan0@huawei.com>
 <54BF8A97.6050402@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BF8A97.6050402@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 07:16:39PM +0800, Wang Nan wrote:
> Hi Jiri,
> 
> I found that only this patch is not enough. When converting such tracepoints,
> it uses add_tracepoint_fields_values(..., struct format_field *fields ...),
> and fields->name is still the original one.
> 
> If 'struct format_field' has a field like 'dup_name' we can make things simpler.
> However, struct format_field is part of traceevent, not only used by perf.
> 
> I have no enough time to think on it. Jiri, could you please give me some hints
> so I can implement another patch tomorrow?

yea, looks like we either need to add 'void *priv' into 'struct format_field'
or if Steven doesn't like it, we'd need to save 'our' field name in some way
so it's reachable via format_field::name string.

Steven,
we need to use changed format_field::name to interface babeltrace
library, because it has restriction that fields within tracepoint
should have unique names.

Any chance we could introduce 'void *priv' member to format_field::name ?
Maybe with 'destroy_priv' callback to be called when the field is destroyed.

I can provide patch, just wanted to know first if you're not strictly against ;-)

thanks,
jirka
