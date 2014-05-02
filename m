Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaEBQnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:43:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43404 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaEBQnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:43:13 -0400
Date: Fri, 2 May 2014 09:43:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lei <tom.leiming@gmail.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shaohua Li <shli@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
Message-ID: <20140502164305.GA18747@infradead.org>
References: <CACVXFVN-roORYH8b-qZ10e2_wrL1W5-xO2P=A_ARPFL2GqDn2Q@mail.gmail.com>
 <535AD235.90604@kernel.dk>
 <CACVXFVPkiQT6yxse=sX1yuX8wLbr1sgbT4chQycbbPDR_A6hqA@mail.gmail.com>
 <535B13D7.4050202@kernel.dk>
 <CACVXFVORX_qgJNXcB3OFpscVx0eQAbLPv2Jr1N3_yBKrPsGXFA@mail.gmail.com>
 <53601602.5060306@kernel.dk>
 <20140501224744.GA2285@kmo-pixel>
 <536300BB.5060906@kernel.dk>
 <20140502050523.GA21708@infradead.org>
 <5363CAC4.4040306@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5363CAC4.4040306@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 10:41:40AM -0600, Jens Axboe wrote:
> > At least for SCSI devices _tag space_ is plenty, it's just the we
> > artifically limit our tag space to the queue depth to avoid having to
> > track that one separately.  In addition we also preallocaste a request
> > for each tag, so even if we would track the queue depth separately
> > we would waste a lot of memory.
> 
> In practice it comes out to the same, it's not feasible to run a much
> larger space and track on queue depth. So I don't think that changes the
> conclusion for SCSI.

Agreed.  Just had to check if my smart ass hat still fits this morning..

