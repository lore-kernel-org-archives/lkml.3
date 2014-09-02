Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaIBVru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:47:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbaIBVrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:47:49 -0400
Message-ID: <54063AF1.4020907@redhat.com>
Date: Tue, 02 Sep 2014 23:47:29 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH net-next v2] net: bpf: make eBPF interpreter images read-only
References: <aa5126f747594d768e0c518189a13e8674ad8ee5.1409690486.git.hannes@stressinduktion.org> <2bf2e54282097642db88e2b596b06a9ac3742883.1409690849.git.hannes@stressinduktion.org> <CAMEtUuyoWELJ0Yf+=5sDKxFEfgsiQ3kMCK+Wn_bdJgS8qaH2og@mail.gmail.com>
In-Reply-To: <CAMEtUuyoWELJ0Yf+=5sDKxFEfgsiQ3kMCK+Wn_bdJgS8qaH2og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 11:31 PM, Alexei Starovoitov wrote:
...
>> +#ifdef CONFIG_DEBUG_SET_MODULE_RONX
>> +static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
>> +{
>> +       set_memory_ro((unsigned long)fp, fp->pages);
>
> since ronx are ifdef checked together,
> would probably make sense to set nx too?

In case of JITs, for example, we request pages that are
PAGE_KERNEL_EXEC via module_alloc(), but here we only need
PAGE_KERNEL. At least on x86_64, PAGE_NX is then set already.
