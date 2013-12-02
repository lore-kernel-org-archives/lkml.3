Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab3LBTEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:04:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:65108 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab3LBTE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:04:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,812,1378882800"; 
   d="scan'208";a="418120504"
Message-ID: <529CD9B9.7060003@linux.intel.com>
Date: Mon, 02 Dec 2013 11:04:25 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [RFC] Packaging libtraceevent.so
References: <20131202140322.4ad6a151@gandalf.local.home>
In-Reply-To: <20131202140322.4ad6a151@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/2013 11:03 AM, Steven Rostedt wrote:
> Hi all!
>
> The question has recently come up in Fedora about packaging the
> libtraceevent.so library. Currently there's 4 users of it:
>
>   1) perf
>   2) trace-cmd
>   3) powertop
>   4) rasdaemon
>
> But each have their own copy of the code.
>
> Both perf and trace-cmd are the major developers of the package, and I
> would recommend that they continue using the *.a version, but for those
> tools that are simple users of the library, it would probably make
> sense to have them use libtraceevent.so and remove their copies from
> the code (powertop and rasdaemon).
>
> The question that I'm posing here is, what currently needs to be done
> to have this happen?
>
> Is the API stable enough for a release?
>
> We probably should have a dot versioning with the .so (ie.
> libtraceevent.so.1)
>
> So what are people's thoughts on this topic?
>

powertop would much rather use a system copy than our own...
but if it's not there in common distros we need to carry our own obviously

