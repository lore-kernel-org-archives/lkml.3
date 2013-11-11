Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3KKScd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:32:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab3KKSc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:32:26 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: =?utf-8?B?6Z+p56OK?= <bonben1989@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: About read/write requests in IO scheduler
References: <CAK2Ky6wEUDS0bQbbYSKv+hX=f6sCjJM7Fu4zOzAR_ftVX1obUg@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 11 Nov 2013 13:32:24 -0500
In-Reply-To: <CAK2Ky6wEUDS0bQbbYSKv+hX=f6sCjJM7Fu4zOzAR_ftVX1obUg@mail.gmail.com>
	(=?utf-8?B?IumfqeejiiIncw==?= message of "Sun, 10 Nov 2013 20:36:10 +0800")
Message-ID: <x498uwuhjrb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

韩磊 <bonben1989@gmail.com> writes:

> In IO scheduler level, whether all the read requests are synchronous?

Generically, yes, I/O schedulers (and the whole block layer, in fact)
consider READs synchronous:

/*
 * We regard a request as sync, if either a read or a sync write
 */
static inline bool rw_is_sync(unsigned int rw_flags)
{
        return !(rw_flags & REQ_WRITE) || (rw_flags & REQ_SYNC);
}
