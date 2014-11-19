Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaKSCs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 21:48:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbaKSCsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 21:48:25 -0500
Message-ID: <546C04E0.4090209@redhat.com>
Date: Tue, 18 Nov 2014 21:48:00 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Tim Hartrick <tim@edgecast.com>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] Repeated fork() causes SLAB to grow without bound
References: <502D42E5.7090403@redhat.com>	<20120818000312.GA4262@evergreen.ssec.wisc.edu>	<502F100A.1080401@redhat.com>	<alpine.LSU.2.00.1208200032450.24855@eggly.anvils>	<CANN689Ej7XLh8VKuaPrTttDrtDGQbXuYJgS2uKnZL2EYVTM3Dg@mail.gmail.com>	<20120822032057.GA30871@google.com>	<50345232.4090002@redhat.com>	<20130603195003.GA31275@evergreen.ssec.wisc.edu>	<20141114163053.GA6547@cosmos.ssec.wisc.edu>	<20141117160212.b86d031e1870601240b0131d@linux-foundation.org>	<20141118014135.GA17252@cosmos.ssec.wisc.edu>	<546AB1F5.6030306@redhat.com> <20141118121936.07b02545a0684b2cc839a10c@linux-foundation.org>
In-Reply-To: <20141118121936.07b02545a0684b2cc839a10c@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/18/2014 03:19 PM, Andrew Morton wrote:
> On Mon, 17 Nov 2014 21:41:57 -0500 Rik van Riel <riel@redhat.com>
> wrote:
> 

>> That way people can understand what the code does simply by
>> looking at the changelog - no need to go find old linux-kernel
>> mailing list threads.
> 
> Yes please, there's a ton of stuff here which we should attempt to 
> capture.
> 
> https://lkml.org/lkml/2012/8/15/765 is useful.
> 
> I'm assuming that with the "foo < 5" hack, an application which
> forked 5 times then did a lot of work would still trigger the
> "catastrophic issue at page reclaim time" issue which Rik
> identified at https://lkml.org/lkml/2012/8/20/265?

It's not "forking 5 times", it is "forking >>5 generations deep".

There are a few programs that do that, but it does not appear
that they are forking servers like apache or sendmail (which
fork from the 2nd generation, and then sometimes again to exec
a helper from the 4th generation).

> There are real-world workloads which are triggering this slab
> growth problem, yes?  (Detail them in the changelog, please).

There are, but the overlap between "forks >>5 generations deep"
and "forks a bajillion child processes" appears to be zero.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUbATgAAoJEM553pKExN6Ds84H/ixCr4Q5C09sDISuw9y/PsVI
moXPbqgefpzbS316MgD1AMl7rj2OWAMiQcRGQ6yMelXOyuB89XTiBi19t5UxaSUn
tuFnxeknoIL0155yTfszETRGjN9mUKoyk9HAhND1T+x2VFLwaQYyk7CdZC/h7IQ7
m1jfwlR30r0Ie6x5lkN1XaculdWdXjr7wTwUWeOVsc6lWv3kR3dC52LKsB4fv340
gBeL5sTDNNp6r5Gfr5QL7fQR0eLVvhStSmsm4GbggpVSBSCpZ++h8eTjdtHxuJO3
jtgEGAvhnLDSqRi6NG6dKoxtXW8++hnFIKBw1Ec36NTuTkbKiHo9EQujINtXWro=
=/EU5
-----END PGP SIGNATURE-----
