Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaFCC5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 22:57:45 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54030 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaFCC5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 22:57:43 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Jean Delvare <jdelvare@suse.de>,
        zhangdianfang <zhangdianfang@huawei.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        David Binderman <dcb314@hotmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] toosl/perf: convert "==" into "="
References: <5387D6A6.20703@huawei.com>
	<20140530144446.1b4586f5@endymion.delvare>
	<20140530152011.GA1202@kernel.org>
	<20140530153729.GE7427@krava.brq.redhat.com>
	<20140530154709.GC1202@kernel.org>
Date: Tue, 03 Jun 2014 11:57:41 +0900
In-Reply-To: <20140530154709.GC1202@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Fri, 30 May 2014 12:47:09 -0300")
Message-ID: <87a99uem3e.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Fri, 30 May 2014 12:47:09 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, May 30, 2014 at 05:37:29PM +0200, Jiri Olsa escreveu:
>> On Fri, May 30, 2014 at 12:20:11PM -0300, Arnaldo Carvalho de Melo wrote:
>> > Em Fri, May 30, 2014 at 02:44:46PM +0200, Jean Delvare escreveu:
>> > > I don't have anything to do with this, I'm not the author of the code
>> > > nor the maintainer and I don't know anything about it. Arnaldo Carvalho
>> > > de Melo is the right person to handle this bug.
>> > 
>> > Jiri,
>
>> > 	Please take this patch, you can stick my:
>
>> > Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
>> sure, but I dont see the patch on the lkml.. any chance of resend?
>  
>> I guess I could dig the patch from above.. if you confirm it's
>> the only change ;-)
>
> Hey, no need to go to such great lenghts, submitters must try and make
> it easier to maintainers! :-)
>
> Find it attached, zhangdianfang, please send it as an attachment next
> time, also please CC lkml as well.


[SNIP]
>
> convert "==" into "="
>
> Bug description: https://bugzilla.kernel.org/show_bug.cgi?id=76751
>
> Cc: Jean Delvare <jdelvare@suse.de>
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Dianfang Zhang <zhangdianfang@huawei.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/ui/browser.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
> index d11541d..3ccf6e1 100644
> --- a/tools/perf/ui/browser.c
> +++ b/tools/perf/ui/browser.c
> @@ -194,7 +194,7 @@ int ui_browser__warning(struct ui_browser *browser, int timeout,
>  		ui_helpline__vpush(format, args);
>  		va_end(args);
>  	} else {
> -		while ((key == ui__question_window("Warning!", text,
> +		while ((key = ui__question_window("Warning!", text,
>  						   "Press any key...",
>  						   timeout)) == K_RESIZE)
>  			ui_browser__handle_resize(browser);
