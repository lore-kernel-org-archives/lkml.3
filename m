Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaHOB3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 21:29:42 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52711 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaHOB3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 21:29:41 -0400
Message-ID: <53ED627E.2090804@hitachi.com>
Date: Fri, 15 Aug 2014 10:29:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: Re: [PATCH] perf probe: Warn user to rebuild target with debuginfo
References: <53ECF7E9.3050200@hitachi.com> <20140814182938.13429.90615.stgit@kbuild-fedora.novalocal> <CAE40pdd_Fy-x5VuhAt46YWSAWmd3z6C5A3DeB6AjBQF4YDZKXw@mail.gmail.com> <20140815010716.GA3148@kernel.org>
In-Reply-To: <20140815010716.GA3148@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/15 10:07), Arnaldo Carvalho de Melo wrote:
> Em Thu, Aug 14, 2014 at 01:07:28PM -0700, Brendan Gregg escreveu:
>> On Thu, Aug 14, 2014 at 11:29 AM, Masami Hiramatsu
>> <masami.hiramatsu.pt@hitachi.com> wrote:
>> [...]
>>> The "rebuild with ..." part changes to "rebuild with CONFIG_DEBUG_INFO"
>>> if the target is the kernel or a kernel module.
>  
>> Thanks, definitely an improvement! Should the kernel message also
>> mention kernel debuginfo packages? Depends on the distribution and
>> environment, but I think for some users the solution is to add the
>> package.

I see, and at least fedora/rhel has debuginfo for all packages.
So, not only for the kernel, but also for user applications,
we'll need to do that.

> Yeah, something like what is suggested by gdb and documented here:
> 
> https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Developer_Guide/intro.debuginfo.html
> 
> --------------------------------------------------------------------
> In some cases (such as loading a core file), GDB does not know the
> name, version, or release of a name-debuginfo-version-release.rpm
> package; it only knows the build-id. In such cases, GDB suggests a
> different command:
> 
> gdb -c ./core
> [...]
> Missing separate debuginfo for the main executable filename
> Try: yum --disablerepo='*' --enablerepo='*debug*' install /usr/lib/debug/.build-id/ef/dd0b5e69b0742fa5e5bad0771df4d1df2459d1
> ---------------------------------------------------------------------

ah, that's nice :)

> 
> This is something I want to have eventually, i.e. to have per distro
> plugins to automatically download packages required for some features,
> like probing and annotation, for instance.

Yeah, however, it depends on the distro. AFAIK, ubuntu provides
debuginfo package only for the kernel. So, at this point, I think
what we can do is just say "please install debuginfo package"
as below.

  $ ./perf probe -x perf -L argv_split
  The /home/fedora/ksrc/linux-3/tools/perf/perf file has no debug information, rebuild with -g.
  Or install appropriate debuginfo package.
    Error: Failed to show lines.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


