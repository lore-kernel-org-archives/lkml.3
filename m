Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaFWOAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:00:22 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:65512 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbaFWOAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:00:20 -0400
Message-ID: <53A832FF.1050002@gmail.com>
Date: Mon, 23 Jun 2014 08:00:31 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>
CC: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] perf trace pagefaults
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru> <20140620132105.GE31524@kernel.org> <20140620150318.GK15620@stfomichev-desktop.yandex.net> <20140620152449.GH31524@kernel.org>
In-Reply-To: <20140620152449.GH31524@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/14, 9:24 AM, Arnaldo Carvalho de Melo wrote:
> Right now it is too simple, but I was starting to work (when you jumped
> right in with your work making me stop and go on testing/reviewing :) )
> on making it more generic so that we could defer pretty printing the
> arguments from sys_enter to sys_exit, when, by then, we would already
> have an association of a user level pointer in some specific thread to
> its contents.
>
> This will allow us to to resolve the pathname pointer in things like
> open() (i.e. not just after that, in the fd syscalls (write, etc)) and
> as well any other pointer of interest.
>
> By librarizing 'builtin-probe.c', that now uses lots of global
> variables, etc, we would be able to insert probes where we want them to
> capture the contents of pointers, check if the probes are already in
> place, use just the ones that we managed to insert (i.e. that were not
> invalid because the places where we wanted them to be were changed
> across kernel releases, etc).
>
> I.e. no need for actual tracepoints from day one, just wannabe
> tracepoints using whatever probe inserting gizmo the kprobes_tracer used
> by 'perf probe' now thinks its best to use.
>
> Combine that with using DWARF descriptions (that could be pre cached
> into something like CTF (the DTrace kind of CTF) or similar) like pahole
> does and we would mostly automatically do all this work of prettyfing
> syscall parameters.
>
> </handwave>

That was so much handwaving you could keep cool at a World Cup game. :-)

David

