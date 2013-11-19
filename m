Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3KSEVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 23:21:39 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:62765 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3KSEVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 23:21:36 -0500
MIME-Version: 1.0
In-Reply-To: <20131118213820.22173142@gandalf.local.home>
References: <20131118213820.22173142@gandalf.local.home>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 19 Nov 2013 04:21:15 +0000
X-Google-Sender-Auth: VEn_EowU3y2snZ2-43wy6UQyDv0
Message-ID: <CAM9d7chk_H6AcphYV4OK2iQVvcPgpagXDJEjemwV5=bOw1spWQ@mail.gmail.com>
Subject: Re: [PATCH v2] tools lib traceevent: Report better error message on
 bad function args
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 2:38 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> When Jiri Olsa was writing a function callback for
> scsi_trace_parse_cdb(), he thought that the traceevent library had a
> bug in it because he was getting this error:
>
>   Error: expected ')' but read ','
>   Error: expected ')' but read ','
>   Error: expected ')' but read ','
>   Error: expected ')' but read ','
>
> But in truth, he didn't have the write number of arguments for the
> function callback, and the error was the library detecting the
> discrepancy. A better error message would have prevented the confusion:
>
>   Error: function 'scsi_trace_parse_cdb()' only expects 2 arguments but event scsi_dispatch_cmd_timeout has more
>   Error: function 'scsi_trace_parse_cdb()' only expects 2 arguments but event scsi_dispatch_cmd_start has more
>   Error: function 'scsi_trace_parse_cdb()' only expects 2 arguments but event scsi_dispatch_cmd_error has more
>   Error: function 'scsi_trace_parse_cdb()' only expects 2 arguments but event scsi_dispatch_cmd_done has more
>
> Or
>
>   Error: function 'scsi_trace_parse_cdb()' expects 4 arguments but event scsi_dispatch_cmd_timeout only uses 3
>   Error: function 'scsi_trace_parse_cdb()' expects 4 arguments but event scsi_dispatch_cmd_start only uses 3
>   Error: function 'scsi_trace_parse_cdb()' expects 4 arguments but event scsi_dispatch_cmd_error only uses 3
>   Error: function 'scsi_trace_parse_cdb()' expects 4 arguments but event scsi_dispatch_cmd_done only uses 3

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
