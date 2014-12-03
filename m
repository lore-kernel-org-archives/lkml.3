Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaLCSqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:46:00 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34274 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaLCSp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:45:58 -0500
MIME-Version: 1.0
In-Reply-To: <20141203184111.GA32005@redhat.com>
References: <547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
Date: Wed, 3 Dec 2014 10:45:57 -0800
X-Google-Sender-Auth: xwy9lbT0PYoos8NUxHW90HOXrRA
Message-ID: <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 10:41 AM, Dave Jones <davej@redhat.com> wrote:
>
> I've been stuck on this kernel for a few days now trying to prove it
> good/bad one way or the other, and I'm leaning towards good, given
> that it recovers, even though the traces look similar.

Ugh. But this does *not* happen with 3.16, right? Even the non-fatal case?

If so, I'd be inclined to call it "bad". But there might well be two
bugs: one that makes that NMI watchdog trigger, and another one that
then makes it be a hard lockup. I'd think it would be good to figure
out the "NMI watchdog starts triggering" one first, though.

                 Linus
