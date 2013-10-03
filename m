Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3JCNm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:42:58 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:42531 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab3JCNm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:42:56 -0400
Message-ID: <524D7463.8080305@gmail.com>
Date: Thu, 03 Oct 2013 09:42:59 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Torvalds <torvalds@osdl.org>, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH 1/1] x86_64: add config options to optimize for newer
 AMD processors
References: <52486938.4090009@gmail.com> <20130929180101.GB5490@pd.tnic> <5248905E.8000801@gmail.com> <20130929205051.GD5426@pd.tnic> <52489A59.7040108@gmail.com> <20130929213026.GF5426@pd.tnic>
In-Reply-To: <20130929213026.GF5426@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-09-29 17:30, Borislav Petkov wrote:
> On Sun, Sep 29, 2013 at 05:23:37PM -0400, Austin S Hemmelgarn wrote:
>> I'm not saying that should just be included without substantiation,
>> I simply mean that the reason to include it (as far as I am
>> concerned) is that it doesn't break anything and provides something
>> useful that isn't in the kernel already.
>
> If it doesn't bring any performance improvement - and I don't want
> to rain on your parade but I think it won't, at least not enough to
> warrant a serious look - there's absolutely no reason to add it.
>
> But hey, I'm always open to surprises! So surprise me!
>
> :-)
>

Sorry it took me so long to get back to you about this.

After doing some intensive testing, it appears that there is some
improvement, but it is mostly in the scheduling code and syscalls.  Most
sysbench benchmarks only show improvement when running with
more threads than processor cores; however, build jobs appear to be much
improved.  Building kernel 3.12-rc2 with allmodconfig using 8 jobs on a
FX-8320 takes 22 minutes and 57 seconds on a kernel with CONFIG_MK8, 21
minutes and 35 seconds on a kernel with CONFIG_GENERIC, and 19 minutes
and 11 seconds on a kernel with CONFIG_PILEDRIVER.  I see similar
results for a build of GCC 4.7 (45m1s, 41m39s, and 38m56s(.  I would
love to test it on my Athlon II system, but I can't afford to have any
appreciable load on that system because I'm using it as a
router/firewall, based on a look at the low level stuff though, I
believe that it would still be at least a bit better with
CONFIG_MAMDFAM10 than with CONFIG_GENERIC, and certainly better than
CONFIG_MK8 (there are some big differences in the execution pipeline
between K8 and family 10h).

I don't know about you, but that sure seems to be a worthwhile
performance increase to me.

