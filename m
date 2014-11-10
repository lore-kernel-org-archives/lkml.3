Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaKJOOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:14:15 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44461 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaKJOON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:14:13 -0500
Message-ID: <5460C83B.5050905@gmail.com>
Date: Mon, 10 Nov 2014 07:14:19 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Vince Weaver <vince@deater.net>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] perf syscall error handling
References: <20141031072109.GD12706@worktop.programming.kicks-ass.net> <20141031092713.GA23124@gmail.com> <20141031122824.GZ12020@console-pimps.org> <CABPqkBS0gKWyTc=TFpGxRwOQkAe1o5zXtWaUyHezpO53LhCqrQ@mail.gmail.com> <alpine.DEB.2.10.1411010130170.6256@pianoman.cluster.toy> <20141103162548.GB18464@kernel.org> <20141103165019.GY10501@worktop.programming.kicks-ass.net> <20141103170059.GC18464@kernel.org> <20141110102725.GA19309@gmail.com> <20141110121527.GQ18464@kernel.org> <20141110122446.GA21503@gmail.com>
In-Reply-To: <20141110122446.GA21503@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/14, 5:24 AM, Ingo Molnar wrote:
> Programmatic use in user-spaec is very simple - go with my
> initial example, tooling can either just display the error string
> and bail out, or do:
>
>    if (unlikely(error)) {
> 	if (!strcmp(attr->error_str, "x86/bts: BTS not supported by this CPU architecture")) {
> 		fprintf(stderr, "x86/BTS: No hardware support falling back to branch sampling\n");
> 		activate_x86_bts_fallback_code();
> 		goto out;
> 	}

That makes the exact string content part of the ABI. As I recall ftrace 
had a problem with format strings changing and tooling then limiting the 
ability to change it.

David
