Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaEVKWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:22:46 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:58845 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaEVKWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:22:45 -0400
Message-ID: <1400754158.8873.3.camel@BR9GV9YG.de.ibm.com>
Subject: Re: [PATCH 1/1] drivers/s390/cio/qdio_main.c: replace shift loop by
 ilog2
From: Ursula Braun <ubraun@linux.vnet.ibm.com>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Joe Perches <joe@perches.com>, ursula.braun@de.ibm.com,
        Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
Date: Thu, 22 May 2014 12:22:38 +0200
In-Reply-To: <OF57E68FFD.38663B1A-ONC1257CE0.00383C6B-C1257CE0.0038457A@de.ibm.com>
References: <OF57E68FFD.38663B1A-ONC1257CE0.00383C6B-C1257CE0.0038457A@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052210-1948-0000-0000-000008E2A7A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yes, the callers guarantee that count > 0 here.

Regards, Ursula Braun

On Thu, 2014-05-22 at 12:14 +0200, Ursula Braun1 wrote:
> From:        Sebastian Ott <sebott@linux.vnet.ibm.com> 
> To:        Joe Perches <joe@perches.com>, Ursula
> Braun1/Germany/IBM@IBMDE, 
> Cc:        Fabian Frederick <fabf@skynet.be>, linux-kernel
> <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org> 
> Date:        21/05/2014 14:32 
> Subject:        Re: [PATCH 1/1] drivers/s390/cio/qdio_main.c: replace
> shift loop by ilog2 
> 
> ______________________________________________________________________
> 
> 
> 
> On Tue, 20 May 2014, Joe Perches wrote:
> > On Tue, 2014-05-20 at 18:37 +0200, Fabian Frederick wrote:
> > > This is untested.
> > []
> > > diff --git a/drivers/s390/cio/qdio_main.c
> b/drivers/s390/cio/qdio_main.c
> > []
> > > @@ -411,15 +411,14 @@ static inline void qdio_stop_polling(struct
> qdio_q *q)
> > >  
> > >  static inline void account_sbals(struct qdio_q *q, int count)
> > >  {
> > > -                 int pos = 0;
> > > +                 int pos;
> > >  
> > >                   q->q_stats.nr_sbal_total += count;
> > >                   if (count == QDIO_MAX_BUFFERS_MASK) {
> > >                                    q->q_stats.nr_sbals[7]++;
> > >                                    return;
> > >                   }
> > > -                 while (count >>= 1)
> > > -                                  pos++;
> > > +                 pos = ilog2(count);
> > 
> > What guarantees count > 0 here?
> 
> We would already be screwed when called with count < 0. Ursula, do the
> callers assure that count is positive?
> 
> Regards,
> Sebastian
> > 
> > count may be better unsigned.
> > 
> > 


