Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbbAGLJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:09:04 -0500
Received: from plane.gmane.org ([80.91.229.3]:45478 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbbAGLJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:09:03 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Subject: Re: Dirty pages underflow on 3.14.23
Date: Wed, 7 Jan 2015 10:57:46 +0000 (UTC)
Message-ID: <pan.2015.01.07.10.57.46@googlemail.com>
References: <alpine.LRH.2.02.1501051744020.5119@file01.intranet.prod.int.rdu2.redhat.com>
	<20150106150250.GA26895@phnom.home.cmpxchg.org>
	<alpine.LRH.2.02.1501061246400.16437@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p4ff58476.dip0.t-ipconnect.de
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
 git://git.gnome.org/pan2)
Cc: linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2015 12:54:43 -0500, Mikulas Patocka wrote:

> On Tue, 6 Jan 2015, Johannes Weiner wrote:
> 
>> > The bug probably happened during git pull or apt-get update, though
>> > one can't be sure that these commands caused it.
>> > 
>> > I see that 3.14.24 containes some fix for underflow (commit
>> > 6619741f17f541113a02c30f22a9ca22e32c9546, upstream commit
>> > abe5f972912d086c080be4bde67750630b6fb38b), but it doesn't seem that
>> > that commit fixes this condition. If you have a commit that could fix
>> > this, say it.
>> 
>> That's an unrelated counter, but there is a known dirty underflow
>> problem that was addressed in 87a7e00b206a ("mm: protect
>> set_page_dirty() from ongoing truncation").  It should make it into the
>> stable kernels in the near future.  Can you reproduce this issue?
>> 
>> Thanks,
>> Johannes
> 
> I can't reprodce it. It happened just once.
> 
> That patch is supposed to fix an occasional underflow by a single page -
> while my meminfo showed underflow by 22952KiB (5738 pages).

You are probably looking for:
commit 835f252c6debd204fcd607c79975089b1ecd3472
"aio: fix uncorrent dirty pages accouting when truncating AIO ring buffer"

It definitely went into 3.14.26, don't know about 3.16.x.

-h

