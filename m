Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3CSMfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:35:16 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54284
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855Ab3CSMfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:35:14 -0400
Message-ID: <1363696502.22553.38.camel@laptop>
Subject: Re: [PATCH v2] perf: fix ring_buffer perf_output_space() boundary
 calculation
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jolsa@redhat.com,
        fweisbec@gmail.com
Date: Tue, 19 Mar 2013 13:35:02 +0100
In-Reply-To: <20130318133327.GA3056@quad>
References: <20130318133327.GA3056@quad>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 14:33 +0100, Stephane Eranian wrote:
> This patch fixes a flaw in perf_output_space(). In case the size
> of the space needed is bigger than the actual buffer size, there
> may be situations where the function would return true (i.e., there
> is space) when it should not. head > offset due to rounding of the
> masking logic.
> 
> The problem can be tested by activating BTS on Intel processors.
> A BTS record can be as big as 16 pages. The following command
> fails:
> 
> $ perf record -m 4 -c 1 -e branches:u my_test_program
> 
> You will get a buffer corruption with this. Perf report won't be
> able to parse the perf.data.
> 
> The fix is to first check that the requested space is smaller than the
> buffer size. If so, then the masking logic will work fine. If not,
> then
> there is no chance the record can be saved and it will be gracefully
> handled
> by upper code layers.
> 
> In v2, we also make the logic for the writable more explicit by
> renaming it to rb->overwrite because it tells whether or not the
> buffer can overwrite its tail (suggested by PeterZ).
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks!

