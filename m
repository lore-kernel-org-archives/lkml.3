Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbaHYPL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:11:59 -0400
Received: from kanga.kvack.org ([205.233.56.17]:45232 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaHYPL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:11:58 -0400
Date: Mon, 25 Aug 2014 11:11:56 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Dan Aloni <dan@kernelim.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Revert "aio: fix aio request leak when events are reaped by user space"
Message-ID: <20140825151156.GE20070@kvack.org>
References: <cover.1403632276.git.bcrl@kvack.org> <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org> <20140819163733.GA10132@gmail.com> <20140819165404.GD13858@kvack.org> <20140819171426.GA11811@gmail.com> <20140820004651.GJ13858@kvack.org> <20140822160111.GD20391@kvack.org> <20140822161502.GA30392@gmail.com> <20140822162630.GF20391@kvack.org> <94D0CD8314A33A4D9D801C0FE68B402958C22133@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C22133@G9W0745.americas.hpqcorp.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 03:06:12PM +0000, Elliott, Robert (Server Storage) wrote:
> Using this version of the patch, I ran into this crash after 36
> hours of scsi-mq testing over the weekend.
...
> 
>         local_irq_save(flags);
>         kcpu = this_cpu_ptr(ctx->cpu);
>         kcpu->reqs_available += nr;
> 
>         while (kcpu->reqs_available >= ctx->req_batch * 2) {

This crash is not particularly useful, as that version of the patch was 
buggy and could result in reqs_available getting corrupted (ie, it could 
overflow), which could lead to the system getting stuck for a significant 
amount of time in put_reqs_available().  In other words, the crash you 
reported matches the known problem with that patch.

		-ben
-- 
"Thought is the essence of where you are now."
