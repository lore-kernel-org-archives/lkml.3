Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3HFF42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:56:28 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:57842 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3HFF40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:56:26 -0400
MIME-Version: 1.0
In-Reply-To: <1375766056-19377-2-git-send-email-namhyung@kernel.org>
References: <1375766056-19377-1-git-send-email-namhyung@kernel.org>
	<1375766056-19377-2-git-send-email-namhyung@kernel.org>
Date: Tue, 6 Aug 2013 08:56:24 +0300
X-Google-Sender-Auth: qRaUwA6J8cFO92LL58O98Tc0lMA
Message-ID: <CAOJsxLGOguW4yGtXu+GhryRJpzzM3v4Mdewbv+vNiG2NbHQF7A@mail.gmail.com>
Subject: Re: [PATCH 1/4] perf ui/gtk: Fix segmentation fault on
 perf_hpp__for_each_format loop
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 8:14 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> The commit 2b8bfa6bb8a7 ("perf tools: Centralize default columns init
> in perf_hpp__init") moves initialization of common overhead column to
> perf_hpp__init() but forgot about the gtk code.
>
> So the gtk code added the same column to the list twice causing
> infinite loop when iterating it by perf_hpp__for_each_format loop.
> When I run perf report --gtk, I can see following messages
> indefinitely.
>
>   (perf:11687): Gtk-CRITICAL **: IA__gtk_main_quit: assertion 'main_loops != NULL' failed
>   perf: Segmentation fault
>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
