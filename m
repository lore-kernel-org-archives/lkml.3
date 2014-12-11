Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbaLKOzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:55:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaLKOy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:54:58 -0500
Date: Thu, 11 Dec 2014 09:54:08 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141211145408.GB16800@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20141201230339.GA20487@ret.masoncoding.com>
 <1417529606.3924.26.camel@maggy.simpson.net>
 <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com>
 <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 11:29:05AM -0800, Linus Torvalds wrote:

 > So it must be some very particular corruption. I still vote for "let's
 > see if Dave can narrow it down with bisection".

I vote for "plane ticket to drinking island".

So I've been continuing the bisect, leaving the 'good' cases running for
as long as a day and a half, and it's taking me down a path of staging
commits again (which is crap, as I don't even have that enabled).

git bisect start
git bisect bad 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9
git bisect good 19583ca584d6f574384e17fe7613dfaeadcdc4a6
git bisect bad ae045e2455429c418a418a3376301a9e5753a0a8
git bisect bad 53ee983378ff23e8f3ff95ecf99dea7c6c221900
git bisect good 2042088cd67d0064d18c52c13c69af2499907bb1
git bisect good 98959948a7ba33cf8c708626e0d2a1456397e1c6
git bisect bad 6f929b4e5a022c3ca806c1675ccb833c42086853


So either one of those 'good's actually wasn't, or I'm just cursed.

I'm going to lose access to this machine next week, so unless I see
this on different hardware in the new year, I'm running out of options.

(on the bright side, having people stare at various suspect code
 throughout this thread does some to have yielded some good from all of
 this).

	Dave
