Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbbAGMXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:23:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbbAGMXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:23:45 -0500
Message-ID: <54AD2549.9040107@redhat.com>
Date: Wed, 07 Jan 2015 13:23:37 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>,
        ast@plumgrid.com
Subject: Re: Edited seccomp.2 man page for review [v2]
References: <54A29722.1010901@gmail.com>	<CAGXu5j+C0SWQ+CeOb2ADXdsLWorUHahX4UhUg+UGbT6UuWiQFQ@mail.gmail.com>	<54A300D0.7090802@gmail.com> <CAGXu5jKCR8ft=2XNX+SsCOokEqCt9sZizKj4wfAGrXVzf6adcg@mail.gmail.com> <54AD1E37.8020509@gmail.com>
In-Reply-To: <54AD1E37.8020509@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 12:53 PM, Michael Kerrisk (man-pages) wrote:
...
> Still hoping to hear from Will Drewy regarding this FIXME in the
> page source:
>
> .\" FIXME What is the significance of the line
> .\"           ftest->code = BPF_LDX | BPF_W | BPF_ABS;
> .\"       in kernel/seccomp.c::seccomp_check_filter()?

This came in from our rework via commit bd4cf0ed331a ("net: filter:
rework/optimize internal BPF interpreter's instruction set"), and
is kernel-internal only, and unused in classic BPF. It translates
into A = *(u32 *) (ctx + K) and will basically load an offset from
the populated seccomp_data (= ctx) to A. For the man-page itself
it has therefore no relevance, hope that clarifies it.

Cheers,
Daniel
