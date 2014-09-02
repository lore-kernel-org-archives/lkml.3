Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbaIBVnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:43:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33018 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbaIBVnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:43:03 -0400
Message-Id: <1409694182.1034977.162882841.29AA6A80@webmail.messagingengine.com>
X-Sasl-Enc: 1FYyL6VbKpknxv7zVBAMdS3ww11pu8Fs4DzKyfBpK+So 1409694182
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>
Cc: Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Kees Cook <keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-73bced9a
In-Reply-To: <1409694059.26422.18.camel@edumazet-glaptop2.roam.corp.google.com>
References: <aa5126f747594d768e0c518189a13e8674ad8ee5.1409690486.git.hannes@stressinduktion.org>
 <2bf2e54282097642db88e2b596b06a9ac3742883.1409690849.git.hannes@stressinduktion.org>
 <CAMEtUuyoWELJ0Yf+=5sDKxFEfgsiQ3kMCK+Wn_bdJgS8qaH2og@mail.gmail.com>
 <1409694059.26422.18.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next v2] net: bpf: make eBPF interpreter images read-only
Date: Tue, 02 Sep 2014 23:43:02 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014, at 23:40, Eric Dumazet wrote:
> On Tue, 2014-09-02 at 14:31 -0700, Alexei Starovoitov wrote:
> 
> > > +static inline void bpf_prog_unlock_ro(struct bpf_prog *fp)
> > > +{
> > > +       set_memory_rw((unsigned long)fp, fp->pages);
> > 
> > why rw is needed?
> > since fp is allocated with vmalloc, vfree doesn't need
> > to touch the pages to free them, no?
> 
> That assumes that vmalloc() do not have any debugging features, like
> poisoning content before freeing, to catch some use after free.
> 
> Lets be clean and safe, and give back same memory permission we had
> after vmalloc()

Yes, I agree. I just went down the kmemleak codepaths and we certainly
don't want to cause issues in there if the implementation changes one
day.

Bye,
Hannes
