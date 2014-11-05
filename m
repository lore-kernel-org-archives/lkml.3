Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaKEVAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:00:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaKEVAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:00:19 -0500
Date: Wed, 5 Nov 2014 13:00:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-aio@kvack.org,
        m.koenigshaus@wut.de, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] aio: fix uncorrent dirty pages accouting when
 truncating AIO ring buffer
Message-Id: <20141105130018.7750139c497f842bdf6070e4@linux-foundation.org>
In-Reply-To: <20141105145620.GA23695@kvack.org>
References: <1414750042-20832-1-git-send-email-guz.fnst@cn.fujitsu.com>
	<5459F387.909@cn.fujitsu.com>
	<20141105145620.GA23695@kvack.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 09:56:20 -0500 Benjamin LaHaise <bcrl@kvack.org> wrote:

> On Wed, Nov 05, 2014 at 05:53:11PM +0800, Gu Zheng wrote:
> > ping...
> 
> I need someone a bit more familiar with this area of code to chime in on 
> reviewing this.  Andrew, can you provide any feedback on this fix?

That looks like a sensible solution and the changelog is good.  A
couple of suggested modifications:

- Don't use the term "pinned" in the changelog without explaining it
  - it's a terribly ambiguous term.  I assume here you mean "pinned by
  elevating the page's refcount"?

- Could we have just one wee little code comment, explaining why
  aio_fs_backing_dev_info exists, what function it is serving?  Put
  yourself in the position of a reader wondering "why is this here".
