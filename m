Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab3KLVk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:40:57 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:53038 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab3KLVks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:40:48 -0500
Date: Tue, 12 Nov 2013 22:40:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf trace: Simplify '--summary' output
Message-ID: <20131112214045.GA29680@gmail.com>
References: <1384267334-18953-1-git-send-email-penberg@kernel.org>
 <20131112213334.GF25913@gmail.com>
 <52829F4F.6070800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52829F4F.6070800@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 11/12/13, 2:33 PM, Ingo Molnar wrote:
> >>>  Summary of events:
> >>>
> >>>  dbus-daemon (555), 10 events, 0.0%, 0.000 msec
> >>>
> >>>                                                     msec/call
> >>>    syscall            calls      min      avg      max stddev
> >>>    --------------- -------- -------- -------- -------- ------
> >>>    sendmsg                2    0.002    0.005    0.008  55.00
> >>>    recvmsg                2    0.002    0.003    0.005  44.00
> >>>    epoll_wait             1    0.000    0.000    0.000   0.00
> >In what units is stddev? Percentage? If yes then it might be useful to
> >output it as %. [and probably to restrict precision to a single digit,
> >standard deviations are rarely more accurate than 0.1%.]
> >
> 
> %. That was dropped in the recent output change.

So if you prefer unit-less lines that's defensible, perhaps output the 
unit somewhere else:

    syscall            calls     min      avg      max  stddev
                               (msec)   (msec)   (msec)    (%)
    --------------- -------- -------- -------- -------- ------
    sendmsg                2    0.002    0.005    0.008  55.00
    recvmsg                2    0.002    0.003    0.005  44.00
    epoll_wait             1    0.000    0.000    0.000   0.00

or so?

Thanks,

	Ingo
