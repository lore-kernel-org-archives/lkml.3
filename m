Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaIBVlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:41:05 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56315 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaIBVlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:41:00 -0400
Message-ID: <1409694059.26422.18.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next v2] net: bpf: make eBPF interpreter images
 read-only
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Kees Cook <keescook@chromium.org>
Date: Tue, 02 Sep 2014 14:40:59 -0700
In-Reply-To: <CAMEtUuyoWELJ0Yf+=5sDKxFEfgsiQ3kMCK+Wn_bdJgS8qaH2og@mail.gmail.com>
References: <aa5126f747594d768e0c518189a13e8674ad8ee5.1409690486.git.hannes@stressinduktion.org>
	 <2bf2e54282097642db88e2b596b06a9ac3742883.1409690849.git.hannes@stressinduktion.org>
	 <CAMEtUuyoWELJ0Yf+=5sDKxFEfgsiQ3kMCK+Wn_bdJgS8qaH2og@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-02 at 14:31 -0700, Alexei Starovoitov wrote:

> > +static inline void bpf_prog_unlock_ro(struct bpf_prog *fp)
> > +{
> > +       set_memory_rw((unsigned long)fp, fp->pages);
> 
> why rw is needed?
> since fp is allocated with vmalloc, vfree doesn't need
> to touch the pages to free them, no?

That assumes that vmalloc() do not have any debugging features, like
poisoning content before freeing, to catch some use after free.

Lets be clean and safe, and give back same memory permission we had
after vmalloc()



