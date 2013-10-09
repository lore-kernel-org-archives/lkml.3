Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab3JIHeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:34:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:35942 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab3JIHec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:34:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1061,1371106800"; 
   d="scan'208";a="390412509"
Message-ID: <525506C5.3020101@intel.com>
Date: Wed, 09 Oct 2013 10:33:25 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V5 3/9] perf tools: workaround objdump difficulties with
 kcore
References: <1381221956-16699-1-git-send-email-adrian.hunter@intel.com> <1381221956-16699-4-git-send-email-adrian.hunter@intel.com> <20131008140236.GD1348@krava.redhat.com>
In-Reply-To: <20131008140236.GD1348@krava.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/13 17:02, Jiri Olsa wrote:
> On Tue, Oct 08, 2013 at 11:45:50AM +0300, Adrian Hunter wrote:
>> objdump fails to annotate module symbols when looking
>> at kcore.  Workaround this by extracting object code
>> from kcore and putting it in a temporary file for
>> objdump to use instead.  The temporary file is created
>> to look like kcore but contains only the function
>> being disassembled.
> 
> Excited to ses this one, but looks like I'm hitting some
> issue.  All annotation starts for me like this:
> 
>                                                                                                        ▒
>        │              Disassembly of section load0:                                                            ▒
>        │                                                                                                       ▒
>        │              ffffffff815eee80 <load0>:                                                                ◆
>   9.33 │ffffffff815eee80:   data32 data32 data32 xchg %ax,%ax                                                  
> 
> 
> which does not seem right

Can you tell me the commits of the kernel and perf tools you
were using, plus the commands and what symbol it was?

