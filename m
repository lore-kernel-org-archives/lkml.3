Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab3KMLOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:14:40 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:53796 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3KMLOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:14:36 -0500
Date: Wed, 13 Nov 2013 12:14:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Pekka Enberg <penberg@iki.fi>
Cc: David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf trace: Simplify '--summary' output
Message-ID: <20131113111430.GA9654@gmail.com>
References: <1384267334-18953-1-git-send-email-penberg@kernel.org>
 <20131112213334.GF25913@gmail.com>
 <52829F4F.6070800@gmail.com>
 <20131112214045.GA29680@gmail.com>
 <528322F3.5050008@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528322F3.5050008@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@iki.fi> wrote:

> On 11/12/13 11:40 PM, Ingo Molnar wrote:
> >So if you prefer unit-less lines that's defensible, perhaps output the
> >unit somewhere else:
> >
> >     syscall            calls     min      avg      max  stddev
> >                                (msec)   (msec)   (msec)    (%)
> >     --------------- -------- -------- -------- -------- ------
> >     sendmsg                2    0.002    0.005    0.008  55.00
> >     recvmsg                2    0.002    0.003    0.005  44.00
> >     epoll_wait             1    0.000    0.000    0.000   0.00
> >
> >or so?
> 
> Looks good.  I'll make a patch later today unless someone else beats
> me to it.

Maybe this variant is even better:

     syscall            calls     min      avg      max      stddev
                                (msec)   (msec)   (msec)        (%)
     --------------- -------- -------- -------- --------     ------
     sendmsg                2    0.002    0.005    0.008      55.0%
     recvmsg                2    0.002    0.003    0.005      44.0%
     epoll_wait             1    0.000    0.000    0.000       0.0%

Note how we can squeeze the % into that column by using only single digit 
precision percentage - double digit is pretty pointless IMO.

Also note that the different nature of the stddev column stands out better 
if there's four more horizontal spaces separating it from the other 
colums.

But maybe it's just me.

Btw., the msec colums seem a bit narrow, they allow up to 9999.999msec 
values which is 10 seconds. If any delay is larger than that then what 
happens, do the values get unaligned in an ugly fashion like they so often 
do in 'vmstat'? Maybe space for one or two digits more would give it more 
breathing space:

     syscall            calls      min       avg       max      stddev
                                 (msec)    (msec)    (msec)        (%)
     --------------- -------- --------- --------- ---------     ------
     sendmsg                2     0.002     0.005     0.008      55.0%
     recvmsg                2     0.002     0.003     0.005      44.0%
     epoll_wait             1     0.000     0.000     0.000       0.0%

This still looks directly pasteable into email and commit logs and looks 
nicely compact on my terminals as well.

Thanks,

	Ingo
