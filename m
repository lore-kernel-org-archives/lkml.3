Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3EMS0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 14:26:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab3EMS0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 14:26:05 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: axboe@kernel.dk, linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH/RESEND v6 3/3] block: Adding ROW scheduling algorithm
References: <1368354917-28687-1-git-send-email-tlinder@codeaurora.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 13 May 2013 14:25:57 -0400
In-Reply-To: <1368354917-28687-1-git-send-email-tlinder@codeaurora.org> (Tanya
	Brokhman's message of "Sun, 12 May 2013 13:34:48 +0300")
Message-ID: <x49d2suohxm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tanya Brokhman <tlinder@codeaurora.org> writes:

> This patch adds the implementation of a new scheduling algorithm - ROW.
> The policy of this algorithm is to prioritize READ requests over WRITE
> as much as possible without starving the WRITE requests.
> The requests are kept in queues according to their priority. The dispatch
> is done in a Round Robin manner with a different slice for each queue.
> READ request queues get bigger dispatch quantum than the write requests.

You have just described CFQ.

Last time I asked for performance numbers[1], you mentioned that you had
published some, but provided no pointers to a paper or mailing list
posting, and I wasn't able to find anything via google, either.

It sounds as though you haven't even tried to adapt CFQ to your needs
(you mentioned trying to tune it, but not what tunings you tried or what
the results were).  Continuing to position your new scheduler as the
only way forward without providing the data that led you to that
conclusion isn't very helpful.  Note that I'm not suggesting that your
conclusion is wrong.  Perhaps if you can provide a link to a research
paper, we can start there.  For now, I can't see why we should take on
the maintenance of another I/O scheduler.

Cheers,
Jeff

[1] https://lkml.org/lkml/2012/8/7/164
