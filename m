Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaFXSUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:20:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbaFXSUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:20:10 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] aio: fix aio request leak when events are reaped by userspace
References: <cover.1403632276.git.bcrl@kvack.org>
	<f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 24 Jun 2014 14:20:02 -0400
In-Reply-To: <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org>
	(Benjamin LaHaise's message of "Tue, 24 Jun 2014 14:01:54 -0400")
Message-ID: <x49a992b25p.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise <bcrl@kvack.org> writes:

> The aio cleanups and optimizations by kmo that were merged into the 3.10
> tree added a regression for userspace event reaping.  Specifically, the
> reference counts are not decremented if the event is reaped in userspace,
> leading to the application being unable to submit further aio requests.
> This patch applies to 3.12+.  A separate backport is required for 3.10/3.11.
> This issue was uncovered as part of CVE-2014-0206.
>
> Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
