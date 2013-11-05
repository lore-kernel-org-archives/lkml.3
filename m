Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3KEBRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 20:17:45 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:62502 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab3KEBRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 20:17:44 -0500
X-AuditID: 9c93017d-b7c6fae00000364c-a3-52784736173f
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a ring buffer
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
	<1383029621-7384-11-git-send-email-namhyung@kernel.org>
	<20131101150910.GA18278@redhat.com> <20131101152232.GA2703@redhat.com>
	<20131103202037.GA2785@redhat.com> <87txfs37ta.fsf@sejong.aot.lge.com>
	<20131104143813.GB4440@redhat.com>
Date: Tue, 05 Nov 2013 10:17:42 +0900
In-Reply-To: <20131104143813.GB4440@redhat.com> (Oleg Nesterov's message of
	"Mon, 4 Nov 2013 15:38:13 +0100")
Message-ID: <874n7r3avd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Nov 2013 15:38:13 +0100, Oleg Nesterov wrote:
> On 11/04, Namhyung Kim wrote:
>>
>> On Sun, 3 Nov 2013 21:20:37 +0100, Oleg Nesterov wrote:
>> >
>> > But. Perhaps it makes sense to at least add a couple of trivial
>> > helpers in 10/13? Something like arg_buf_get/put/init, just to
>> > simplify the potential changes.
>>
>> Good idea.  How about something like below?
>
> Thanks, I agree with any implementation ;)
>
>> static DEFINE_MUTEX(uprobe_buffer_mutex);
>
> but see my previous email, afaics we don't need it.

I see.  Probably checking the event_mutex is locked in front of the
_enable/disable function would be enough.

Thanks,
Namhyung
