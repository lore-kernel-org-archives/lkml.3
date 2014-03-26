Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbaCZSzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 14:55:41 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:23738 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaCZSzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 14:55:39 -0400
X-Greylist: delayed 7498 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Mar 2014 14:55:39 EDT
Date: Wed, 26 Mar 2014 12:55:35 -0600
From: Linn Crosetto <linn@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86, irq: get correct available vectors for cpu
 disable
Message-ID: <20140326185535.GE24604@oranje.fc.hp.com>
References: <1390946045-2769-1-git-send-email-yinghai@kernel.org>
 <20140325200352.GU31785@oranje.fc.hp.com>
 <CAE9FiQUxBWFfUBjdsakPV0B=rsB4wD-sX6Q2tVbOjNy9RJffRg@mail.gmail.com>
 <20140326165038.GD24604@oranje.fc.hp.com>
 <CAE9FiQUidLDFunEKpVPfSppO1qOzpVPMXW5utd939RdLLei_Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUidLDFunEKpVPfSppO1qOzpVPMXW5utd939RdLLei_Fg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 10:04:52AM -0700, Yinghai Lu wrote:
> On Wed, Mar 26, 2014 at 9:50 AM, Linn Crosetto <linn@hp.com> wrote:
> > On Tue, Mar 25, 2014 at 05:18:53PM -0700, Yinghai Lu wrote:
> >
> > Just noting that not all bits above first_system_vector are set in the bitmap,
> > so the comment in asm/desc.h and the change log could be misleading:
> >
> > /* used_vectors is BITMAP for irq is not managed by percpu vector_irq */
> >
> 
> Do you mean some vector that is neither used by percpu_vector_irq nor
> system_vector
> after first_system_vector ?

Yes, that is the case. In my previous example, first_system_vector is 239, but
test_bit(240, used_vectors) would return unset, though it cannot be used by
percpu vector_irq. If it marked all vectors unusable by percpu vector_irq, then
all bits above first_system_vector would be set.

> Anyway if bit is set in used_vectors, that vector can not be used by
> percpu vector_irq.
> 
> so that statement looks still right.
> 
> Feel free to suggest right comment or changelog.

The following might be more accurate:

/* 
 * The used_vectors BITMAP marks IRQs not managed by percpu vector_irq, below
 * first_system_vector. Vectors above first_system_vector are not managed by
 * percpu vector_irq.
 */
