Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaK2OvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 09:51:04 -0500
Received: from mout.web.de ([212.227.15.14]:62409 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaK2OvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 09:51:02 -0500
Message-ID: <5479DD48.6030508@users.sourceforge.net>
Date: Sat, 29 Nov 2014 15:50:48 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: fs-fat: Less function calls in fat_fill_super() after error detection
References: <5307CAA2.8060406@users.sourceforge.net>	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>	<530A72AA.3000601@users.sourceforge.net>	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>	<530B5FB6.6010207@users.sourceforge.net>	<alpine.DEB.2.10.1402241710370.2074@hadrien>	<530C5E18.1020800@users.sourceforge.net>	<alpine.DEB.2.10.1402251014170.2080@hadrien>	<530CD2C4.4050903@users.sourceforge.net>	<alpine.DEB.2.10.1402251840450.7035@hadrien>	<530CF8FF.8080600@users.sourceforge.net>	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>	<530DD06F.4090703@users.sourceforge.net>	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>	<5317A59D.4@users.sourceforge.net>	<5467B12C.4010602@users.sourceforge.net>	<alpine.DEB.2.02.1411152117540.2225@localhost6.localdomain6>	<54796B5E.5040707@users.sourceforge.net>	<87sih22sn8.fsf@devron.myhome.or.jp>	<alpine.DEB.2.10.1411291338530.2378@hadrien> <87lhmu2jl8.fsf@devron.myhome.or.jp>
In-Reply-To: <87lhmu2jl8.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:31sEuQds3mibU7PG/JDdE8rsFlWqE0CzBUTF0N/vX6JOj6P4JQ8
 gD72ZmKBUOcu/YxytaNa/fLtKmfW8ZhXwSrJhsZHXViia7qrfq3sEys+xxzia99Oe9a8Dzi
 sPvEorH1WiAXeGLM36tskCRuSuyViGe6/hGnKKqmYvAzruKIl7lJ5Jx9PfzNXFYAZ9bYvcF
 0z0gMx9IyD3pAU4JjspFQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> More labels are more chances of bug (and we don't care micro optimize
> on this error path), isn't it?

I would prefer that a few jump targets can be redirected so that unnecessary
function calls (and corresponding checks) can be avoided.


> Increasing the chance of bugs and bothers developers for analyzer sounds
> like strange.

There are different opinions around source code clarity.


> (And we are initializing those for avoiding to be bothered by choosing
> correct label.

Pointer initialisation is convenient and safe in some use cases, isn't it?


> If we really care micro optimize, initialization of those should not
> be required and should not be touched on other paths, and gcc can warn
> its usage.)

I imagine that a software optimiser can eventually perform better job
if unneeded statements could be omitted, couldn't it?

Regards,
Markus
