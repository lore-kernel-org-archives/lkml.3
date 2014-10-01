Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaJANBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:01:41 -0400
Received: from mout.web.de ([212.227.15.4]:64407 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbaJANBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:01:40 -0400
Message-ID: <542BFB2C.5070609@users.sourceforge.net>
Date: Wed, 01 Oct 2014 15:01:32 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: Coccinelle <cocci@systeme.lip6.fr>, kernel-janitors@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Chi Pham <chidaph@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH with Coccinelle?] Deletion of unnecessary checks before
 specific function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:KevSVkWmkZQ/DBuwXqv4HU0+sWwY8SuqXzq43k4f11R8BVEe6cz
 uWns3jhSnirqDpP85OWMzvs8SyofsbPfC3b4A2bJrnBSVwW7I3x96ErNoB0XyyIklGvRQ6x
 SD4dr1exv7JGhteUqJ9o06ZmZt5PZYtQNgfltYLGjZRr2S/5JtlBdSr28H2x8dqGC+qpcEE
 C3B7DZDwFLbZvZIV/fCgQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If you are convinced that dropping the null tests is a good idea, then you 
>> can submit the patch that makes the change to the relevant maintainers and 
>> mailing lists.

Hello,

A couple of functions perform input parameter validation before their
implementations will try further actions with side effects. Some calling
functions perform similar safety checks.

Functions which release a system resource are occasionally documented in the way
that they tolerate the passing of a null pointer for example.
I do not see a need because of this fact that a function caller repeats a
corresponding check.

Now I would like to propose such a change again.

1. Extension of the infrastructure for the analysis tool "coccicheck"
   Semantic patch patterns can help to identify update candidates also in the
Linux source file hierarchy.

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/scripts/coccinelle?id=79f0345fefaafb7cde301a830471edd21a37989b

   Would you like to reconsider an approach which was discussed with a subject
like "scripts/coccinelle/free: Delete NULL test before freeing functions?" a
while ago?
   https://lkml.org/lkml/2014/8/9/36
   https://groups.google.com/d/msg/linux.kernel/rIWfYsRRW6I/cTs6y0STf2cJ


2. Clarification for some automated update suggestions
   My source code search approach found 227 functions with the help of the
software "Coccinelle 1.0.0-rc22" at least which might need another review and
corresponding corrections for Linux 3.16.3. Further software development will
point out even more potentially open issues.

Regards,
Markus

