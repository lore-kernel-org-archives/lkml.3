Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3GAPf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:35:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab3GAPfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:35:25 -0400
Date: Mon, 1 Jul 2013 12:35:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zoran Turalija <zoran.turalija@gmail.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Nicolas THERY <nicolas.thery@st.com>,
        Divneil Rai WADHAWAN <divneil.wadhawan@st.com>,
        Vincent ABRIOU <vincent.abriou@st.com>,
        Alain VOLMAT <alain.volmat@st.com>
Subject: Re: [GIT PULL for v3.11] media patches for v3.11
Message-ID: <20130701123512.04e0ab62.mchehab@redhat.com>
In-Reply-To: <CAHFNz9J_FJP4YcCd3-_3x6d5iNDoqpYMMtX1Xd+OFJX4H7so0A@mail.gmail.com>
References: <20130701075856.6e8daa98.mchehab@redhat.com>
	<CAHFNz9J_FJP4YcCd3-_3x6d5iNDoqpYMMtX1Xd+OFJX4H7so0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 1 Jul 2013 16:37:58 +0530
Manu Abraham <abraham.manu@gmail.com> escreveu:

> Mauro,
> 
> On Mon, Jul 1, 2013 at 4:28 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Hi Linus,
> >
> > Please pull from:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
> >
> > For the media patches for Kernel v3.11.
> >
> 
> >
> > Zoran Turalija (2):
> >       [media] stb0899: allow minimum symbol rate of 1000000
> >       [media] stb0899: allow minimum symbol rate of 2000000
> 
> 
> Somehow, I missed these patches; These are incorrect. Please revert
> these changes.
> Simply changing the advertized minima values don't change the search algorithm
> behaviour, it simply leads to broken behaviour.
> 
> NACK for these changes.

While this patch came from a sub-maintainer's tree, looking at its
history, the patch was proposed here:
	https://linuxtv.org/patch/18341/

>From what it is said there, with this patch, 6 additional channels
were discovered when using with Eutelsat 16A, that uses a symbol
rate between 2MS/s to 5 MS/s. Without this patch, those channels won't
be discovered, as the core won't try to use a symbol rate outside
the range.

Of course, transponders with a symbol rate equal or upper than 5MS/s
won't be affected by this patch.

Even if this is not a perfect patch and some changes would be 
needed to improve tuning for those low symbol rate transponders, 
it seems better than before, as at least now some channels are tuned.

The only reason I can see to reverse this patch is that if setting
the frontend to low bit ranges could damage the frontend or could
hit some bug on the hardware (or internal firmware).

Yet, from the datasheet pointed by the patch author, it seems that
this frontend allows such low symbol rates:
	http://comtech.sg1002.myweb.hinet.net/pdf/dvbs2-6899.pdf

Let me copy some people at ST. Maybe they could help to check internally
there if there are any risks for the hardware to accept low symbol rate 
transponders.

Regards,
Mauro
