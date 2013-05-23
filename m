Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab3EWBav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 21:30:51 -0400
Received: from intranet.asianux.com ([58.214.24.6]:59380 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab3EWBau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 21:30:50 -0400
X-Spam-Score: -100.8
Message-ID: <519D7116.7090107@asianux.com>
Date: Thu, 23 May 2013 09:29:58 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/auditfilter.c: need process 'tree' when audit_add_watch()
 failed in audit_add_rule().
References: <518CC80A.3070608@asianux.com> <20130522141818.25520521fe5ebcd5acf61bf5@linux-foundation.org>
In-Reply-To: <20130522141818.25520521fe5ebcd5acf61bf5@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 05:18 AM, Andrew Morton wrote:
> On Fri, 10 May 2013 18:12:26 +0800 Chen Gang <gang.chen@asianux.com> wrote:
> 
>> > 
>> > If both 'tree' and 'watch' are valid, need call audit_put_tree(), just
>> > like the upper area has done within function audit_add_rule().
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  kernel/auditfilter.c |    6 ++++++
>> >  1 files changed, 6 insertions(+), 0 deletions(-)
>> > 
>> > diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
>> > index f9fc54b..81f63f9 100644
>> > --- a/kernel/auditfilter.c
>> > +++ b/kernel/auditfilter.c
>> > @@ -952,6 +952,12 @@ static inline int audit_add_rule(struct audit_entry *entry)
>> >  		err = audit_add_watch(&entry->rule, &list);
>> >  		if (err) {
>> >  			mutex_unlock(&audit_filter_mutex);
>> > +			/*
>> > +			 * normally audit_add_tree_rule() will free it
>> > +			 * on failure
>> > +			 */
>> > +			if (tree)
>> > +				audit_put_tree(tree);
>> >  			goto error;
>> >  		}
>> >  	}
> Are you sure?  Or is the earlier audit_put_tree(tree) wrong?
> 

Yes I am sure.

Since audit_add_tree_rule() will really free it on failure, we have to
be sure to free it in another area within audit_add_rule().


> Where is the "get" which this "put" is undoing?
> 
> 

"Allocating tree" is the "get", this "put" will really free the tree.



Thanks.
-- 
Chen Gang

Asianux Corporation
