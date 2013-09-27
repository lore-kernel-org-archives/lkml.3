Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3I0BbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 21:31:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:29781 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3I0BbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 21:31:17 -0400
X-Spam-Score: -100.8
Message-ID: <5244DFA5.5090200@asianux.com>
Date: Fri, 27 Sep 2013 09:30:13 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info'
 in all related extern functions
References: <524114B8.3070903@asianux.com> <20130924120429.GA2366@htj.dyndns.org> <5242331B.4010309@asianux.com> <20130925005802.GA25777@htj.dyndns.org> <5242372C.4010509@asianux.com> <20130925011404.GB25777@htj.dyndns.org> <52424094.3020504@asianux.com> <524267CD.4030007@asianux.com> <5243CD18.1060805@asianux.com> <5243D487.8000602@asianux.com> <20130926131544.GB31249@mtj.dyndns.org>
In-Reply-To: <20130926131544.GB31249@mtj.dyndns.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 09:15 PM, Tejun Heo wrote:
> Hello, Chen.
> 
> On Thu, Sep 26, 2013 at 02:30:31PM +0800, Chen Gang wrote:
>>> Oh, not cause issue, the reason is "'groups' exports extern variable
>>> 'init_groups', when start process, default 'cred' will set it to be
>>> sure of groups always be initialized".
>>>
>>> Hmm... but after all, I still think this file need be improved: "remove
>>> the group_info checking in groups_search()", please help check, thanks.
> 
> Given the track record upto this point and how marginal the benefit of
> the suggested change is, I'd rather not.  It's quite possible that we
> had specific issue where that extra conditional is necessary and I
> don't feel comfortable trusting your evaluation and analysis on the
> subject at the moment, so the benefit / risk ratio seems way off from
> my pov.
> 
>>>   If groups_alloc() fails, the caller must not call any related API again
>>>   with the related invalid 'group_info'.
>>>
>>>
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Nacked-by: Tejun Heo <tj@kernel.org>
> 

The caller should not 'generate' a new 'groups_info' by itself, so, if
invalid 'groups_info' should not pass to groups_free(), of cause it
should not pass groups_search(), either.

If permit passing an invalid 'groups_info' to groups_search(), caller
also can pass this invalid 'groups_info' to groups_free(), too.

The original author exported extern variable 'init_groups', that means
'groups' wants no duty to be sure 'group_info' whether valid, caller
should be sure of that (or it is caller's bug, not 'groups' bug).


In my opinion, it is enough to know 'groups' interface is inconsistent,
it needs improvement (in fact, I don't think it's a good idea to export
'init_groups', neither good to let caller sure of 'group_info' valid).


As an integrator or large source code maintainer, we cannot only depend
on testing, or tracing log, or some short directly causes; we also need
find and solve issues by checking sub-systems' interface or documents.

> Thanks.
> 

Thanks.
-- 
Chen Gang
