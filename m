Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbaJNOT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:19:56 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48018 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbaJNOTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:19:55 -0400
Message-ID: <543D3108.5080401@gmail.com>
Date: Tue, 14 Oct 2014 08:19:52 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, Jean Pihet <jean.pihet@linaro.org>
CC: Borislav Petkov <bp@alien8.de>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com> <20141006212606.GF14113@kernel.org> <CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com> <20141007133236.GG14113@kernel.org> <20141007140433.GG30146@pd.tnic> <20141010200708.GB18775@kernel.org> <20141010202854.GC13017@pd.tnic> <20141010204158.GA13834@kernel.org> <20141010204432.GD13017@pd.tnic> <CAFrcx1nm4pqWPsUtj1h5qQqo6dghiafRM60-9asaYXx7NLqAEQ@mail.gmail.com> <20141014135631.GA32308@krava.fdxtended.com>
In-Reply-To: <20141014135631.GA32308@krava.fdxtended.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/14, 7:56 AM, Jiri Olsa wrote:
> I read the rasd sources and realized we could poke this
> from another angle..  AFAIU the work the rasd does is following:
>     - reads config file and opens configured tracepoints
>     - reads samples comming from those tracepoints and displays/writes
>       this data to the console/file
>     - is there more?
>
> If I'm not missing anything, this is quite usefull/common usage
> pattern which would deserve new perf command.
>
> I can see the analogy with ftrace debugfs interface
>    - choose/enable tracepoints
>    - cat .../tracing/trace-pipe
>
> and there could be '-d' for the command to act as daemon.

Yes, this parallels a new use case on my end. Right now I am running 
perf record ... | perf script. With the tracepoints and filters involved 
it is a LOT of typing - and still collects more than is needed (I don't 
need MMAP events for example, only COMM events). I am leaning towards a 
new perf sub-command but from my scheduling timehist and daemon commands 
I know there is a lot of overhead that goes with that. A perf library 
with a stable API would make this a lot easier. (AFAIK the python 
bindings do not currently support opening events, it is mainly an 
analysis option.)

David

