Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaFBSTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:19:12 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:3255 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbaFBSTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:19:11 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArAeAJy/jFNbtAfK/2dsb2JhbABZgweBJ4IeqBgBAQEBAQUBmBcCAgGBFBd0giUBAQQBJxMcIwULCAMOCi45HgYTiDoMAc8bF4VViH0HhEABA49FijoBixuIEoM6Oy8
Date: Mon, 2 Jun 2014 20:17:57 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] drivers/s390/cio/qdio_main.c: replace shift loop by
 ilog2
Message-Id: <20140602201757.66cf234bcba12078dc278eba@skynet.be>
In-Reply-To: <alpine.LFD.2.11.1406021637300.1587@denkbrett>
References: <20140520183728.c28374c3f1a655a2e33996a3@skynet.be>
	<alpine.LFD.2.11.1406021637300.1587@denkbrett>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014 16:41:48 +0200 (CEST)
Sebastian Ott <sebott@linux.vnet.ibm.com> wrote:

> Hello Fabian,
> 
> On Tue, 20 May 2014, Fabian Frederick wrote:
> > 
> > This is untested.
> > 
> > Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  drivers/s390/cio/qdio_main.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
> > index 77466c4..8bf9ec1 100644
> > --- a/drivers/s390/cio/qdio_main.c
> > +++ b/drivers/s390/cio/qdio_main.c
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
> >  	q->q_stats.nr_sbals[pos]++;
> >  }
> > 
> > -- 
> > 1.8.4.5
> > 
> > 
> 
> Could you please resend the patch with a better description plus
> the change Joe suggested.
> 
> Thanks,
> Sebastian

Hello Sebastian,
   Conclusion of that patch/thread was that callers guarantee count to be > 0

Joe suggested to have unsigned count. Is it what you're talking about ?

Regards,
Fabian
