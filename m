Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaK2QJD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:09:03 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:55380 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaK2QJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:09:01 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: fs-fat: Less function calls in fat_fill_super() after error detection
References: <5307CAA2.8060406@users.sourceforge.net>
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
	<87lhmu2jl8.fsf@devron.myhome.or.jp>
	<5479DD48.6030508@users.sourceforge.net>
Date: Sun, 30 Nov 2014 01:08:56 +0900
In-Reply-To: <5479DD48.6030508@users.sourceforge.net> (SF Markus Elfring's
	message of "Sat, 29 Nov 2014 15:50:48 +0100")
Message-ID: <87egsm2dlz.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SF Markus Elfring <elfring@users.sourceforge.net> writes:

>> More labels are more chances of bug (and we don't care micro optimize
>> on this error path), isn't it?
>
> I would prefer that a few jump targets can be redirected so that unnecessary
> function calls (and corresponding checks) can be avoided.

It is from real bugs in my experience, it saw several times those (mine
and other guys, in linux and others). And I think it doesn't have value
to maintain labels for micro optimization in *this error path* though.

So, if you or analyzer can check bugs by the patches affect to those
label usage in future,

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
