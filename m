Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbaKCHkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 02:40:23 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:54351 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaKCHkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 02:40:20 -0500
MIME-Version: 1.0
In-Reply-To: <5457305B.9080404@intel.com>
References: <1414999678-31377-1-git-send-email-namhyung@kernel.org>
 <1414999678-31377-4-git-send-email-namhyung@kernel.org> <5457305B.9080404@intel.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 3 Nov 2014 16:39:59 +0900
X-Google-Sender-Auth: tMmfzrpNh0hcKyXe4dJJGiLXxYk
Message-ID: <CAM9d7cjfBXrd-8JxDAfG7OM7X_XxkojFnrxpbGVVUW_xwnwkbA@mail.gmail.com>
Subject: Re: [PATCH 3/8] perf tools: Get rid of unused dsos__hit_all()
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Mon, Nov 3, 2014 at 4:35 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> On 03/11/14 09:27, Namhyung Kim wrote:
>> The dsos__hit_all() and its friends are not used anywhere.  Let's get
>> rid of them.
>
> They were added for Intel PT preparation.  Intel PT is still on its way,
> so they are still needed.  Note the commit was:
>
> commit 1f625b0b3dd641b74ba21640a1fea19a3dd893a2
> Author: Adrian Hunter <adrian.hunter@intel.com>
> Date:   Tue Jul 22 16:17:23 2014 +0300
>
>     perf tools: Add dsos__hit_all()
>
>     Add ability to mark all dsos as hit.
>
>     This is needed in the case of Instruction Tracing.  It takes so long to
>     decode an Instruction Trace that it is not worth doing just to determine
>     which dsos are hit.  A later patch takes this into use.

Oops, didn't notice.  Sorry for not checking the commit log.  So how
about moving it into util/build-id.c then?

Thanks,
Namhyung
