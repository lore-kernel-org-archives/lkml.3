Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaDQNuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:50:13 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51884 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaDQNuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:50:08 -0400
Subject: Re: [PATCH 1/3] perf hists: Add missing updates on
 nr_non_filtered_entries
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20140417131014.GD7422@krava.brq.redhat.com>
References: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
	 <1397721206-15393-2-git-send-email-namhyung@kernel.org>
	 <20140417131014.GD7422@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Apr 2014 22:50:01 +0900
Message-ID: <1397742601.1731.27.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-17 (목), 15:10 +0200, Jiri Olsa:
> I'm probably missing something, but what is hists->nr_non_filtered_entries
> used for? I can only see it being inc/dec-ed, but not used..

Well, that's true.  Firstly, I thought that it'd be used for
browser->nr_entries but it couldn't due to --percent-limit.  So I ended
up keeping browser->nr_filtered_entries (looks like to be renamed as
->nr_non_filtered_entries) for that and update it regularly.

Maybe we can just use hists->nr_non_filtered_entries as
browser->nr_entries if --percent-limit is not used.

Thanks,
Namhyung


