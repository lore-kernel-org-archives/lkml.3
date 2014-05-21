Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaEUMcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 08:32:35 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:57433 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaEUMcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 08:32:33 -0400
Date: Wed, 21 May 2014 14:32:27 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Joe Perches <joe@perches.com>, Ursula Braun <ursula.braun@de.ibm.com>
cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] drivers/s390/cio/qdio_main.c: replace shift loop by
 ilog2
In-Reply-To: <1400604342.26709.2.camel@joe-AO725>
Message-ID: <alpine.LFD.2.11.1405211418270.1579@denkbrett>
References: <20140520183728.c28374c3f1a655a2e33996a3@skynet.be> <1400604342.26709.2.camel@joe-AO725>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052112-0342-0000-0000-000008D8FBC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Joe Perches wrote:
> On Tue, 2014-05-20 at 18:37 +0200, Fabian Frederick wrote:
> > This is untested.
> []
> > diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
> []
> > @@ -411,15 +411,14 @@ static inline void qdio_stop_polling(struct qdio_q *q)
> >  
> >  static inline void account_sbals(struct qdio_q *q, int count)
> >  {
> > -	int pos = 0;
> > +	int pos;
> >  
> >  	q->q_stats.nr_sbal_total += count;
> >  	if (count == QDIO_MAX_BUFFERS_MASK) {
> >  		q->q_stats.nr_sbals[7]++;
> >  		return;
> >  	}
> > -	while (count >>= 1)
> > -		pos++;
> > +	pos = ilog2(count);
> 
> What guarantees count > 0 here?

We would already be screwed when called with count < 0. Ursula, do the
callers assure that count is positive?

Regards,
Sebastian
> 
> count may be better unsigned.
> 
> 

