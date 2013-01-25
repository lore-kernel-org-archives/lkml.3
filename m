Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab3AYDBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:01:05 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48877 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3AYDAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:00:55 -0500
Message-ID: <5101F555.30403@linux.vnet.ibm.com>
Date: Fri, 25 Jan 2013 11:00:37 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 23/74] perf kvm: Initialize file_name var to fix segfault
References: <1359058103-31645-1-git-send-email-acme@infradead.org> <1359058103-31645-24-git-send-email-acme@infradead.org>
In-Reply-To: <1359058103-31645-24-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012502-1396-0000-0000-000002764539
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 04:07 AM, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> The 3786063 commit:
> 
>     perf kvm: Rename perf_kvm to perf_kvm_stat
> 
> Moved the file_name from inside a local struct var that initialized some
> of its members, thus zero initializing the not explicitely initialized
> variables, one of which was 'file_name', to a standalone local variable,
> but forgot to initialize it explicitely to NULL, so it then got some
> undefined value, causing a segfault in strdup when it wasn't, by luck,
> zero.
> 
> Fix it by explicitely initializing it to NULL.

Thank you for fixing my fault.

Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

