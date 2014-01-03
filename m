Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaACRjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:39:14 -0500
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:52115 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751856AbaACRjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:39:13 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2692:2693:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3870:3871:3874:4321:5007:6119:7652:7903:8526:10004:10400:10848:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: care59_6d1f8de4a0a38
X-Filterd-Recvd-Size: 1960
Message-ID: <1388770748.14334.19.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 03 Jan 2014 09:39:08 -0800
In-Reply-To: <CAGXu5jL7RunQuAw1MjnUMgWeYMX35+YcGeaZYCx6dhND3YUmsQ@mail.gmail.com>
References: <1388507067.2259.24.camel@joe-AO722>
	 <201401011434.GAF34360.FFQOVtFOHJSMLO@I-love.SAKURA.ne.jp>
	 <1388555362.2259.38.camel@joe-AO722>
	 <201401011902.JEF43770.FSOVFFOHOtQLJM@I-love.SAKURA.ne.jp>
	 <1388626389.2259.57.camel@joe-AO722>
	 <201401021349.JGJ78109.OOFtFFHJMLSOQV@I-love.SAKURA.ne.jp>
	 <CAGXu5jL7RunQuAw1MjnUMgWeYMX35+YcGeaZYCx6dhND3YUmsQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-03 at 09:08 -0800, Kees Cook wrote:
> I'm on board with the idea of embedding comm/pid/whatever,

I still think the space reduction isn't worth the
complication.

>  but I
> either missed or do not understand why a second format-start character
> is being added. I think this will complicate audits and maybe trigger
> weird info leaks (imagine printing a string that was %-escaped, but
> not 0x1A-escaped?)
> Why not use % followed by 0x1A to be the start code, instead of just 0x1A?

gcc would bleat an error for
	"unknown conversion type character 0x1a in format".


