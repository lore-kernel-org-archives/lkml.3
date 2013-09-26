Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab3IZNPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:15:52 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:54701 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab3IZNPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:15:51 -0400
Date: Thu, 26 Sep 2013 09:15:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info' in
 all related extern functions
Message-ID: <20130926131544.GB31249@mtj.dyndns.org>
References: <524114B8.3070903@asianux.com>
 <20130924120429.GA2366@htj.dyndns.org>
 <5242331B.4010309@asianux.com>
 <20130925005802.GA25777@htj.dyndns.org>
 <5242372C.4010509@asianux.com>
 <20130925011404.GB25777@htj.dyndns.org>
 <52424094.3020504@asianux.com>
 <524267CD.4030007@asianux.com>
 <5243CD18.1060805@asianux.com>
 <5243D487.8000602@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5243D487.8000602@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Chen.

On Thu, Sep 26, 2013 at 02:30:31PM +0800, Chen Gang wrote:
> > Oh, not cause issue, the reason is "'groups' exports extern variable
> > 'init_groups', when start process, default 'cred' will set it to be
> > sure of groups always be initialized".
> > 
> > Hmm... but after all, I still think this file need be improved: "remove
> > the group_info checking in groups_search()", please help check, thanks.

Given the track record upto this point and how marginal the benefit of
the suggested change is, I'd rather not.  It's quite possible that we
had specific issue where that extra conditional is necessary and I
don't feel comfortable trusting your evaluation and analysis on the
subject at the moment, so the benefit / risk ratio seems way off from
my pov.

> >   If groups_alloc() fails, the caller must not call any related API again
> >   with the related invalid 'group_info'.
> > 
> > 
> > Signed-off-by: Chen Gang <gang.chen@asianux.com>

Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
