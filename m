Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3JHIfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:35:03 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:42151 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3JHIe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:34:58 -0400
MIME-Version: 1.0
In-Reply-To: <5253BCD1.6080606@intel.com>
References: <1381128618-22721-1-git-send-email-adrian.hunter@intel.com>
 <1381128618-22721-9-git-send-email-adrian.hunter@intel.com>
 <87k3hoky4x.fsf@sejong.aot.lge.com> <5253BCD1.6080606@intel.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 8 Oct 2013 17:34:36 +0900
X-Google-Sender-Auth: DeTE2E7f1WLaoMZYmObYOG5ETFo
Message-ID: <CAM9d7chHTUvm9xZ191P-RbCgSNEBUanJ2hgYCgYvhA_10o-uhw@mail.gmail.com>
Subject: Re: [PATCH V4 8/9] perf buildid-cache: add ability to add kcore to
 the cache
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 5:05 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> On 08/10/13 10:41, Namhyung Kim wrote:
>> On Mon,  7 Oct 2013 09:50:17 +0300, Adrian Hunter wrote:
>>> kcore can be used to view the running kernel object code.
>>> However, kcore changes as modules are loaded and unloaded,
>>> and when the kernel decides to modify its own code.
>>> Consequently it is useful to create a copy of kcore at a
>>> particular time.  Unlike vmlinux, kcore is not unique
>>> for a given build-id.  And in addition, the kallsyms
>>> and modules files are also needed.  The tool therefore
>>> creates a directory:
>>>
>>>      ~/.debug/[kernel.kcore]/<build-id>/<YYYYmmddHHMMSShh>
>>>
>>> which contains: kcore, kallsyms and modules.
>>
>> Hmm..  I think the problem is that the kallsyms and kcore also have
>> module information and the build-id of kernel can identify the core
>> kernel part only.  So why not splitting modules from kcore and kallsyms?
>>
>> As the modules have their own build-id, we can extract module info from
>> kcore and kallsyms and put them under ~/.debug/[module]/<build-id>.
>> While at it, we can even synthesize symbol table and inject it into the
>> module kcore and get rid of the module kallsyms file.
>>
>> This way, we can identify all binaries using build-id only, no?
>
> No.
>
> kcore doesn't just give the module object code - it gives it
> linked in to the kernel.  Unless you have the modules at the same
> addresses the linking doesn't match what you traced.

Ah.. right.  I missed that.

Thanks,
Namhyung
