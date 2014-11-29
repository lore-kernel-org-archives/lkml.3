Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaK2N7w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 08:59:52 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:55358 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaK2N7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 08:59:51 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2] fs-fat: Less function calls in fat_fill_super() after error detection
References: <5307CAA2.8060406@users.sourceforge.net>
	<530A086E.8010901@users.sourceforge.net>
	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<5467B12C.4010602@users.sourceforge.net>
	<alpine.DEB.2.02.1411152117540.2225@localhost6.localdomain6>
	<54796B5E.5040707@users.sourceforge.net>
	<87sih22sn8.fsf@devron.myhome.or.jp>
	<alpine.DEB.2.10.1411291338530.2378@hadrien>
Date: Sat, 29 Nov 2014 22:59:47 +0900
In-Reply-To: <alpine.DEB.2.10.1411291338530.2378@hadrien> (Julia Lawall's
	message of "Sat, 29 Nov 2014 13:40:34 +0100 (CET)")
Message-ID: <87lhmu2jl8.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia.lawall@lip6.fr> writes:

>> iput() checks NULL of inode. What is wrong just remove NULL check,
>> instead of adding new jump labels?
>
> Personally, I prefer that code that can be statically determined not to
> need to be executed not to be executed.  It can make the code easier to
> understand, because each function is only called when doing so is useful,
> and it can be helpful to static analysis.

Hm, first of all, we want to prevent the bugs. More labels are more
chances of bug (and we don't care micro optimize on this error path),
isn't it?  Increasing the chance of bugs and bothers developers for
analyzer sounds like strange.

(And we are initializing those for avoiding to be bothered by choosing
correct label. If we really care micro optimize, initialization of those
should not be required and should not be touched on other paths, and gcc
can warn its usage.)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
