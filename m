Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaAESJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:09:57 -0500
Received: from smtprelay0170.hostedemail.com ([216.40.44.170]:34152 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751281AbaAESJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:09:56 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3874:4321:5007:7652:7903:7904:10004:10400:10848:11232:11658:11914:12296:12517:12519:12533:12740:13069:13311:13357:13618,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bear14_3947a843c3305
X-Filterd-Recvd-Size: 1960
Message-ID: <1388945392.5808.19.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: keescook@chromium.org, pavel@ucw.cz, akpm@linux-foundation.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Date: Sun, 05 Jan 2014 10:09:52 -0800
In-Reply-To: <201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
References: <201401021349.JGJ78109.OOFtFFHJMLSOQV@I-love.SAKURA.ne.jp>
	 <CAGXu5jL7RunQuAw1MjnUMgWeYMX35+YcGeaZYCx6dhND3YUmsQ@mail.gmail.com>
	 <1388770748.14334.19.camel@joe-AO722>
	 <CAGXu5j+gHtgx9MVCaJ2ogJ0WGCeTDkphsH3gm7S=+mTssicABg@mail.gmail.com>
	 <201401041126.BHJ81291.VOHLOtMFOJFQFS@I-love.SAKURA.ne.jp>
	 <201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-01-05 at 12:15 +0900, Tetsuo Handa wrote:
> Tetsuo Handa wrote:
> > Since my purpose is to make reading of task_struct->comm consistent, %pT-like
> > extension is what I want for centralizing pointer dereferences.
> 
> If we have no objections for %pT[C012] patch,

I still believe emitting different output styles using
%pT[012] is not ideal.

Is this really necessary?

I'd prefer that each element be described separately
using %pT<type> where T is a struct task_struct and
type is a member.

type 'c' -> tsk.comm
type 'p' -> tsk.pid
type 't' -> task.tgid

though if the real concern is simply comm consistency,
maybe these other member types aren't at all useful.


