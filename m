Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423601Ab3CVXGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 19:06:17 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:12114 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423421Ab3CVXGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 19:06:16 -0400
Message-ID: <1363993574.1946.8.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/3] rbtree_test: use pr_info for module prefix in
 messages
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Michel Lespinasse <walken@google.com>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 22 Mar 2013 16:06:14 -0700
In-Reply-To: <CANN689H3J+Ep8KAaQczbrAC_KAsqkJu_t3xJ3UNp5pkOKDOr+Q@mail.gmail.com>
References: <1363648854.1774.16.camel@buesod1.americas.hpqcorp.net>
	 <CAKocOOOj80R2nP+B_k=jTS-UgA27VvMa-kAFiJbORZg4pKRS1Q@mail.gmail.com>
	 <1363713282.2781.2.camel@buesod1.americas.hpqcorp.net>
	 <CAKocOOM8WeEgDdk6gkKCxLZFgdX8=+-e2zK0qOGmxxfS2qc4bw@mail.gmail.com>
	 <1363920689.31240.70.camel@buesod1.americas.hpqcorp.net>
	 <CANN689H3J+Ep8KAaQczbrAC_KAsqkJu_t3xJ3UNp5pkOKDOr+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 20:29 -0700, Michel Lespinasse wrote:
> On Thu, Mar 21, 2013 at 7:51 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> > On Tue, 2013-03-19 at 11:54 -0600, Shuah Khan wrote:
> >> On Tue, Mar 19, 2013 at 11:14 AM, Davidlohr Bueso
> >> <davidlohr.bueso@hp.com> wrote:
> >> > On Tue, 2013-03-19 at 10:29 -0600, Shuah Khan wrote:
> >> >> On Mon, Mar 18, 2013 at 5:20 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> >> >> > This provides nicer message output. Since it seems more appropriate
> >> >> > for the nature of this module, also use KERN_INFO instead of other
> >> >> > levels.
> >> >>
> >> >> Why are you changing the ALERTs to INFO?
> >> >
> >> > Because of the nature of the messages. They don't justify having a
> >> > KERN_ALERT level (requiring immediate attention), and it seems a lot
> >> > more suitable to use INFO instead.
> >> >
> >>
> >> Hmm. I see interval_tree_test using the same alerts. It almost looks
> >> like the start and end of a test are meant to be alerts. I am not
> >> saying it shouldn't be changed, however looking for a stronger reason
> >> than "it seems a lot more suitable to use INFO instead". Are there any
> >> use-cases in which KERN_ALERTs cause problems?
> >>
> >
> > No 'issue' particularly, just common sense. In any case I have no
> > problem reverting the changes back to KERN_ALERT, no big deal.
> >
> > Andrew, Michel, do you have any preferences? I'm mostly interested in
> > patch 3/3, do you have any objections?
> 
> Sorry for the late reply - I have a lot of upstream email to catch up to.
> 
> No objection to the change but I also have to say I'm not quite sure
> what's the motivation - it'd be easier if you had a 0/3 mail to
> explain the issue. In particular, I'm not sure if you've been trying
> to use the test compiled in rather than as a module (which is all I've
> ever built it as myself :)
> 

Yeah, since it was a small and straightforward patchset I chose not to
send a 0/3 explaining the motivation. I was basically going through your
augmented rbtree work and noticed some property checks missing. FWIW I
only used it as a module as well.

Thanks,
Davidlohr


