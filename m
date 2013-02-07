Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab3BGE1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 23:27:15 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:36620 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3BGE1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 23:27:14 -0500
MIME-Version: 1.0
Date: Wed, 6 Feb 2013 23:27:10 -0500
Message-ID: <CAKON4Oxmvc3ShbFVoeGH5ftcDNPSi9TN0bLp0bL9GF6yyTwF1w@mail.gmail.com>
Subject: DMAEngine and channel pairs
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU I'm working on uses two sequential DMA channels to implement
scatter-gather.  How do you handle this in the channel allocator? If
scatter-gather is not requested the two channels work fine as normal
DMA channels.

So when a scatter-gather channel is requested my driver needs to fail
the dma_alloc_chan_resources() requests until a sequential pair is
located? Plus I need to track what channels are used in my driver so
that I know where sequential pairs are. Is there a better way to do
this?

Another solution might be to statically allocate some channels as
being scatter/gather capable and others as not being able to do it. I
would just report fewer available channels to dmaengine and hide those
secondary channels from it. I have 12 channels to work with.

--
Jon Smirl
jonsmirl@gmail.com
