Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaCZQvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:51:00 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:54891 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbaCZQu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:50:59 -0400
Date: Wed, 26 Mar 2014 10:50:38 -0600
From: Linn Crosetto <linn@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86, irq: get correct available vectors for cpu
 disable
Message-ID: <20140326165038.GD24604@oranje.fc.hp.com>
References: <1390946045-2769-1-git-send-email-yinghai@kernel.org>
 <20140325200352.GU31785@oranje.fc.hp.com>
 <CAE9FiQUxBWFfUBjdsakPV0B=rsB4wD-sX6Q2tVbOjNy9RJffRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUxBWFfUBjdsakPV0B=rsB4wD-sX6Q2tVbOjNy9RJffRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 05:18:53PM -0700, Yinghai Lu wrote:
> On Tue, Mar 25, 2014 at 1:03 PM, Linn Crosetto <linn@hp.com> wrote:
> > Thanks for the patch.
> >
> > On Tue, Jan 28, 2014 at 01:54:05PM -0800, Yinghai Lu wrote:
> >> used_vectors is a bitmap for vectors that are not tracked in per_cpu
> >> vector_irq.
> >
> > I feel like this comment (also in the code) could be misleading because vectors
> > above first_system_vector are effectively not tracked in per_cpu vector_irq, but
> > also may not have the bit set in used_vectors. For example, used_vectors from a
> > system that I am looking at now:
> >
> > first_system_vector
> >                 239                  255
> >                   |                  |
> >                   10 01000 11111 11111
> >
> > test_bit(240, used_vectors) does not return the correct answer to the question
> > about whether the vector is tracked in per_cpu vector_irq. This leads to two
> > meanings for the bitmap; for vectors less than first_system_vector whether or
> > not they are tracked in per_cpu vector_irq, and for vectors above
> > first_system_vector, whether or not they are in use:
> >
> > static inline int is_per_cpu_vector(int vector) {
> >         return !test_bit(vector, used_vectors) &&
> >                         vector < first_system_vector;
> > }
> 
> sorry, I can not catch what you want to say.
> 
> Do you mean the change log or comment in the patch is not right?

Just noting that not all bits above first_system_vector are set in the bitmap,
so the comment in asm/desc.h and the change log could be misleading:

/* used_vectors is BITMAP for irq is not managed by percpu vector_irq */

I have tested and the patch itself is good.

Thanks,
Linn
