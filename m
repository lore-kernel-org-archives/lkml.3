Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaD1BQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:16:39 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55000 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaD1BQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:16:38 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PROBLEM] perf report --gtk doesn't work
References: <CAOJsxLG-S2qske+o+hXKHMRLJu6McNFRi=tDQ8iraq=w_4oonA@mail.gmail.com>
Date: Mon, 28 Apr 2014 10:16:35 +0900
In-Reply-To: <CAOJsxLG-S2qske+o+hXKHMRLJu6McNFRi=tDQ8iraq=w_4oonA@mail.gmail.com>
	(Pekka Enberg's message of "Fri, 25 Apr 2014 14:09:45 +0300")
Message-ID: <87ppk2p824.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Fri, 25 Apr 2014 14:09:45 +0300, Pekka Enberg wrote:
> Hello,
>
> I'm seeing the following with v3.15-rc2:
>
> $ ~/bin/perf report --gtk
> GTK browser requested but could not find libperf-gtk.so
>
> The library file is in $HOME/lib64 and perf attempts to look it up.
> However, printing out dlerror() output shows the following:
>
> [penberg@localhost hornet]$ ~/bin/perf report --gtk
> /home/penberg/lib64/libperf-gtk.so: undefined symbol: sort_sym
> GTK browser requested but could not find libperf-gtk.so

Hmm.. strange.  On my system, it works perfectly..

>
> I'm not sure how this is supposed to work. sort_sym() is defined in
> the 'perf' executable so how is libperf-gtk.so going to see it?

I'm also not sure.. maybe linker finds the symbol in the executable in
case of dlopen()?

Thanks,
Namhyung
