Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3EJCJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 22:09:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:57055 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab3EJCJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 22:09:06 -0400
X-Spam-Score: -100.8
Message-ID: <518C568E.2040203@asianux.com>
Date: Fri, 10 May 2013 10:08:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel: audit_tree: resource management: need put_tree
 and goto Err when failure occures
References: <517110BA.5070806@asianux.com> <20130422160409.471f6208099a972d26c29fb9@linux-foundation.org> <518B9C32.7050408@asianux.com> <20130509131108.8a70aa5116ff0e3c250feb8b@linux-foundation.org>
In-Reply-To: <20130509131108.8a70aa5116ff0e3c250feb8b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 04:11 AM, Andrew Morton wrote:
>> > But we need let 'rule->tree = NULL;' firstly, so can protect rule itself freed in kill_rules().
> I'll believe you ;) I turned this into a proper patch and added your
> (missed) Signed-off-by:.
> 

Thanks.

At least, let 'rule->tree = NULL;' can:

  a. it matches 'rule->tree = tree;' which is before successful return.
       also can make 'if (list_empty(&rule->rlist))' reasonable.

  b. protect rule itself freed in kill_rules(), if it could happen.
       just like all 'rule->tree = NULL;' in audit_remove_tree_rule().

  c. it will no negative effect.


>> > For me, after 'rule->tree = NULL', all things seems fine !!
> Well, what was wrong before?  Is there some user-triggerable
> misbehaviour which you observed?  If so, please describe it.
> 
> 
> 

I think, it will cause issue (randomly): if when we are using auditctl
to add rule to monitor one file, and at the same time, the other user is
just deleting this file.

I guess, it is why original code need 'if (list_empty(&rule->rlist))'
after lock 'audit_filter_mutex' again.

Currently, I am just testing for it (and should give a test), and I will
send the test plan and test result within this week (2013-05-12).


Thanks.

-- 
Chen Gang

Asianux Corporation
