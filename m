Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab3J1I4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:56:09 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48426 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912Ab3J1I4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:56:07 -0400
X-Sasl-enc: RkWSx4Zb3DGMKiBxR1ke+CPiJtFc/z+Xb7CiFzr//dxC 1382950566
Message-ID: <526E26A4.8000802@iki.fi>
Date: Mon, 28 Oct 2013 10:56:04 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <20131025125921.GA29424@linux.vnet.ibm.com> <20131026095023.GF14237@gmail.com>
In-Reply-To: <20131026095023.GF14237@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2013 12:50 PM, Ingo Molnar wrote:
> I think in 99% of the usecases people will either use pre-built
> markers that come with their distro, or will be intimately aware of
> the markers because they are in the very app they are developing.
>
> So I wouldn't worry about 'user has a weird binary' case too much.
>
> I agree with Pekka that making them easily discoverable and visible
> as a coherent whole is really important.

I wouldn't worry about the weird binary case either.

Even a build-time whitelist would help. Just put libc and libjvm
there and you're already covering a lot of interesting cases.
And if you then add a printout:

   Use 'perf list --scan' to find more tracepoints on your
   system.

you're now effectively covering 100% of the cases.

The trick of making the UI not suck is not to force the user
to think about the different mechanisms like SDT markers,
uprobes, or ktap scripts but to make them as transparent
as possible, provide useful defaults, and actively guide the
user towards learning about more command line options
for the complex cases.

                 Pekka
