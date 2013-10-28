Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab3J1Mmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:42:35 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48262 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756101Ab3J1Mm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:42:26 -0400
X-Sasl-enc: 6FHEn2/SOPLYfzEJs7n8kfxXQRm2F2gv4rwd++/jBrnX 1382964136
Message-ID: <526E5BA5.7050103@iki.fi>
Date: Mon, 28 Oct 2013 14:42:13 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <526E4940.8000608@hitachi.com>
In-Reply-To: <526E4940.8000608@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 1:23 PM, Masami Hiramatsu wrote:
> By the way, what happens if multiple binaries has same SDT marker?
> Yeah, perf list shows just one and ignores others. However, if we
> probe one, and run binary which use the other one, user will never
> see the marker.
>
> So, it still needs a concrete binary path to list or, we should
> support a syntax which specify actual binary, as like as below.
>
>   perf probe 'my_event=%libc:setjmp@/lib64/libc.so.6'
>
> And perf list may show the marker as in same syntax (for copy&paste).
>
> # perf list --sdt
>   %libc:setjmp@/lib64/libc.so.6
>   ...
>
> Note that we need '%' to separate namespace :(, since user can define
> any marker(provider) name in their binary...

Sure, you need to support that sort of 'fully qualified name' for
duplicate symbols but the default 'libc:setjmp' should still point
to system libc.

This is an example where tracing libc that's relevant to most of
the users should take priority over the 'duplicate marker in
obscure executable' corner case case.

                         Pekka
