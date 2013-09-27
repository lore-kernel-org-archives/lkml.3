Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab3I0LxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 07:53:23 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:62683 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3I0LxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 07:53:21 -0400
Date: Fri, 27 Sep 2013 07:53:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info' in
 all related extern functions
Message-ID: <20130927115318.GA12206@mtj.dyndns.org>
References: <5242372C.4010509@asianux.com>
 <20130925011404.GB25777@htj.dyndns.org>
 <52424094.3020504@asianux.com>
 <524267CD.4030007@asianux.com>
 <5243CD18.1060805@asianux.com>
 <5243D487.8000602@asianux.com>
 <20130926131544.GB31249@mtj.dyndns.org>
 <5244DFA5.5090200@asianux.com>
 <20130927033651.GA9768@htj.dyndns.org>
 <524530EB.6080109@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524530EB.6080109@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 27, 2013 at 03:16:59PM +0800, Chen Gang wrote:
> Hmm... do you mean: "can not evaluate an interface before implement(or
> read details) them all"?

No, I'm saying there are a lot more steps necessary between
recognizing that an interface needs an improvement and actually
improving it than what you're doing now.

> If we are agree with each other that "this interface can be improved",
> I will go ahead:
> 
>   I will reference the information which Paul McKenney provided.
>   And also, I will use LTP's some features to give a test.
>   And also, I will reference some contents you said above.
> 
>   Hope I can finish within next month (2013-10-31).

If you want to, go ahead but please see below.

> > So, please take some time to mull over why your initial patch was
> > completely wrong and I didn't even have to read the code to predict
> > that your patch has high chance of being wrong.  Now, you're doing the
> > *exactly* same thing in the opposite direction.  You should be able to
> > recognize that there's something very wrong with that.
> 
> No, I don't think so, in my opinion, for evaluate an api interface,
> don't need see the details implementation, even don't need know all
> demands.
> 
> During discussing, anyone can make mistakes, in fact, that is the main
> reason why we need discussing.
> 
> Hmm... in my opinion, for evaluate one's way/method whether suitable or
> not, it is not based on 1-2 mistakes, it need based on mistake/correct ratio.

The thing is you are showing a classical and common failure pattern
which is known to lead to bad code.  The only safe thing you'd be able
to do with your current pattern is making changes which are completely
contained and don't affect its interaction with large body of code,
and by not doing the necessary steps, you're shifting what you should
have done to your reviewers.

Your patch is bascially just saying "this part looks a bit
inconsistent and may need to be improved" and that's all it is.  This
is bad in two ways.  Firstly, the workload on reviewer is higher as
they have to do the actual work.  Secondly, it's a lot more likely to
lead to bugs as the developer is supposed to be our first and best
line of defense against introducing silliness and reviewers operate on
the assumption that the developer did her role.

Please recognize that obvious local changes and changes which may
affect larger interaction are different.  You will need to either
stick to obvious local changes or put a lot of effort into learning
how to do larger scope work.

I hope you understand what I mean.  If not, I don't know what else I
can do.  I already spent too much time on this thread and probably
won't be as verbose in my future interactions, so if you can come up
with a good patch with convincing enough presentation, go for it.  If
not, I'm likely to nack it again.

Thanks.

-- 
tejun
