Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3IPPoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:44:44 -0400
Received: from smtprelay0119.hostedemail.com ([216.40.44.119]:47612 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751025Ab3IPPom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:44:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2693:2736:2828:2901:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4385:5007:7652:7903:8531:8603:10004:10400:10848:11232:11658:11914:12296:12517:12519:12663:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSB
X-HE-Tag: offer36_289175851004c
X-Filterd-Recvd-Size: 2752
Message-ID: <1379346277.1934.9.camel@joe-AO722>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        LKML <linux-kernel@vger.kernel.org>,
        George Spelvin <linux@horizon.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Beulich <JBeulich@suse.com>,
        Motohiro KOSAKI <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 16 Sep 2013 08:44:37 -0700
In-Reply-To: <CAGXu5jK7ALtFq74duH_ymoLnmoHKYmty+60HCG3YFyhghi2Scg@mail.gmail.com>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
	 <1379317437-28329-2-git-send-email-keescook@chromium.org>
	 <201309162041.HHG69783.FLFMJFtSOQOHVO@I-love.SAKURA.ne.jp>
	 <CAGXu5jJErvcfdq0=QDd2pwCeK7kKnJ-GY2ybv9ssdkF6NjNvDw@mail.gmail.com>
	 <1379344187.1934.1.camel@joe-AO722>
	 <CAGXu5jK7ALtFq74duH_ymoLnmoHKYmty+60HCG3YFyhghi2Scg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 08:25 -0700, Kees Cook wrote:
> On Mon, Sep 16, 2013 at 8:09 AM, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2013-09-16 at 07:59 -0700, Kees Cook wrote:
> >> Perhaps instead of seq->count, there should be an access function?
> >> seq_get_count(seq) or something?
> >
> > My thought was to add a seq_last_len()
> 
> That would mean growing the size of the seq_file structure and adding
> instructions for all users. While I personally have no problem with
> that, I worry others might.

I don't think adding an int and a size_t is a big deal.

I'm still hoping to hear from Al if expanding the struct
is OK and race-free.

> If we just use seq->count (or equivalent
> function), then only those that want length will use it. I actually
> think this uses fewer instructions than %n. Especially in the case
> where seq_printf got replaced by seq_puts. :)

Shrug.  None of these are inline uses so the overall
code size doesn't change much.

I have patches that make seq_overflow public and replace
the current uses of the seq_printf/seq_puts/seq_putc
returns where appropriate.

Given that I was already touching a lot of the
seq_<foo> calls, I also have patches that convert all
the seq_printf(fmt) (no additional args) to seq_puts()
and all the seq_puts("[single char]") to seq_putc() as
separate patches.


