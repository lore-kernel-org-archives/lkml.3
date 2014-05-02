Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbaEBFFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 01:05:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39606 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaEBFFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 01:05:31 -0400
Date: Thu, 1 May 2014 22:05:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kmo@daterainc.com>, Ming Lei <tom.leiming@gmail.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shaohua Li <shli@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
Message-ID: <20140502050523.GA21708@infradead.org>
References: <CACVXFVMXh5ZP+ZsO2fV2mdKJrJF9AHg58v5KWmt_ZbEWvszsLw@mail.gmail.com>
 <535716A5.6050108@kernel.dk>
 <CACVXFVN-roORYH8b-qZ10e2_wrL1W5-xO2P=A_ARPFL2GqDn2Q@mail.gmail.com>
 <535AD235.90604@kernel.dk>
 <CACVXFVPkiQT6yxse=sX1yuX8wLbr1sgbT4chQycbbPDR_A6hqA@mail.gmail.com>
 <535B13D7.4050202@kernel.dk>
 <CACVXFVORX_qgJNXcB3OFpscVx0eQAbLPv2Jr1N3_yBKrPsGXFA@mail.gmail.com>
 <53601602.5060306@kernel.dk>
 <20140501224744.GA2285@kmo-pixel>
 <536300BB.5060906@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536300BB.5060906@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 08:19:39PM -0600, Jens Axboe wrote:
> I've taken the consequence of this and implemented another tagging
> scheme that blk-mq will use if it deems that percpu_ida isn't going
> to be effective for the device being initialized. But I really hate
> to have both of them in there. Unfortunately I have no devices
> available that have a tag space that will justify using percu_ida,
> so comparisons are a bit hard at the moment. NVMe should change
> that, though, so decision will have to be deferred until that is
> tested.

At least for SCSI devices _tag space_ is plenty, it's just the we
artifically limit our tag space to the queue depth to avoid having to
track that one separately.  In addition we also preallocaste a request
for each tag, so even if we would track the queue depth separately
we would waste a lot of memory.

