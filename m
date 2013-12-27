Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab3L0OUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 09:20:34 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:49748 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab3L0OUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 09:20:32 -0500
Message-ID: <52BD8C9B.8030206@gmail.com>
Date: Fri, 27 Dec 2013 09:20:11 -0500
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip v2 1/2] [CLEANUP] perf-probe: Expand given path to
 absolute path
References: <20131226054148.22364.25224.stgit@kbuild-fedora.novalocal> <20131226054150.22364.12187.stgit@kbuild-fedora.novalocal> <52BC39D6.3090908@gmail.com> <20131226142248.GE30980@ghostprotocols.net> <52BD1ACA.7030506@hitachi.com>
In-Reply-To: <52BD1ACA.7030506@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/13, 1:14 AM, Masami Hiramatsu wrote:
> Nowhere, since there is no terminal code for user
> command interface.
>
> Those memories are released when the program terminated.
> I think it is just a waste of the time to free the memory
> pieces which are not used(and allocated) repeatedly.
> Or, is there any chance to call this part directly from
> other command?

Most of the functionality has a destructor to clean up memory 
allocations. probe code needs to follow suit.

e.g, from builtin-record.c:

     err = __cmd_record(&record, argc, argv);

     perf_evlist__munmap(evsel_list);
     perf_evlist__close(evsel_list);
out_free_fd:
     perf_evlist__delete_maps(evsel_list);
out_symbol_exit:
     symbol__exit();

and __cmd_record ends by cleaning up the session struct.

David
