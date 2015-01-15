Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbbAOQII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:08:08 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36256 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbbAOQIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:08:06 -0500
Message-ID: <54B7E5E0.50702@gmail.com>
Date: Thu, 15 Jan 2015 09:08:00 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Adrian Hunter <adrian.hunter@intel.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Florian Fainelli <florian@openwrt.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Mark Salter <msalter@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "S. Lockwood-Childs" <sjl@vctlabs.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCHv2 00/36] perf tools: New build framework
References: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/15/15 5:54 AM, Jiri Olsa wrote:
> Since it's actually small portion of kbuild that perf needs,
> I realized it's actually better to steal it than 'reconfigure'
> kbuild to be usable for perf.
>
> Also this patchset is kind of incremental version of the latest:
>    perf tools: Add kbuild support into Makefile.kbuild
> so it should be easier to review.
>
> NOTE I couldn't find any copyright/credit messages in the kbuild
> system, but would be happy to include it if someone suggests one.
>
> The stolen parts are in files:
>    Makefile.kbuild
>    Build.include
>
> The idea and more details are explained in the 'Documentation/Build'
> file. The basic idea is the same as in kbuild system, with some minor
> changes to allow for multiple binaries build definitions.
>
> User provides 'Build' files with objects definitions like:
>    perf-y += perf.o
>    perf-y += builtin-bench.o
>    ...
>
>    libperf-y += util/
>    ...
>

It is not obvious to me how this works. Users provide a .config file for 
building perf? Or do users provide Build files like you state above? If 
it is a .config file then what if a .config file is not present is it 
auto generated using the current autoprobing?

David


> and the build framework outputs files:
>    perf-in.o
>    libperf-in.o
>
> which are then linked into appropriate binaries/libraries.
> (perf libperf.a libperf-gtk.so)
>


