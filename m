Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaA0SlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:41:16 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48898 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbaA0SlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:41:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140127162226.GA3229@twins.programming.kicks-ass.net>
References: <20140123173120.GA25474@www.outflux.net>
	<20140125074738.GB10565@gmail.com>
	<52E669F1.9080603@intel.com>
	<20140127152557.GA27792@gmail.com>
	<52E681B6.7020501@intel.com>
	<20140127161959.GD4941@twins.programming.kicks-ass.net>
	<20140127162226.GA3229@twins.programming.kicks-ass.net>
Date: Mon, 27 Jan 2014 10:41:14 -0800
Message-ID: <CAKB9nXucRwn78+pw1oRQ_jP_kQJuOaUzPyiH0JE5Sv9utkK1ww@mail.gmail.com>
Subject: Re: [PATCH v2] x86, kaslr: export offset in VMCOREINFO ELF notes
From: Andrew Honig <ahonig@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Dave Anderson <anderson@redhat.com>,
        Eugene Surovegin <surovegin@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch to make it easier for processing offline
kdump files for crash analysis.  For context on the see this thread
for a patch in progress
(http://www.mail-archive.com/crash-utility@redhat.com/msg04640.html)

_stext doesn't quite work for this purpose because in my testing it
doesn't exactly match the kaslr offset, for some reason _stext is a
few hundred bytes after the kaslr offset.  The number doesn't appear
consistent and I would prefer not to take a dependency on that.

On Mon, Jan 27, 2014 at 8:22 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
>
> Do _NOT_ cross post to moderated lists!!
