Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965248AbaCTTc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:32:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50384 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbaCTTcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:32:22 -0400
Date: Thu, 20 Mar 2014 16:32:12 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrien BAK <adrien.bak@metascale.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mathias Gaunard <mathias.gaunard@metascale.org>
Subject: Re: [PATCH] perf-script : improves option passing mechansim
Message-ID: <20140320193212.GB21431@kernel.org>
References: <53286FBD.4050901@metascale.org>
 <20140318181525.GE6482@ghostprotocols.net>
 <532AF29E.3040207@metascale.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532AF29E.3040207@metascale.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 20, 2014 at 02:52:30PM +0100, Adrien BAK escreveu:
> Indeed. I wasn't aware of the '--' behaviour and the documentation
> doesn't seem to mention it. My patch essentially implements the same
> behaviour, except that the script name itself is used to separate
> the options. I guess there is not much need the proposed patch then.
> 
> Sorry for the wasted time.

No need to be sorry, I appreciate _you_ taking the time to help improve
the tools, maybe you can send a patch to update the documentation
instead, with examples where -- is used so that people don't fall into
this trap again?

Thanks!

- Arnaldo

> Adrien
> 
> On 03/18/2014 07:15 PM, Arnaldo Carvalho de Melo wrote:
> >Em Tue, Mar 18, 2014 at 05:09:33PM +0100, Adrien BAK escreveu:
> >>This pull request fixes the following issues :
> >>* when passing custom arguments to a script, if those arguments are
> >>  not declared within perf, they prevent the execution of perf.
> >>e.g.
> >>
> >>perf script -i path/to/perf.data -s my_script -arg1 arg_value
> >>
> >>perf will issue an error message and no processing will occur
> >I haven't tested this, but what comes to mind is the use of -- to
> >separate what options should be processed by perf and which ones should
> >be left to the script, is that what you're fixing?
> >
> >- Arnaldo
> >>* when passing custom arguments to a script, if those arguments are
> >>  declared by perf, they are consumed and not passed to the script.
> >>e.g.
> >>perf script -i path/to/perf.data -s my_script -h
> >>
> >>perf will display its own help message, instead of the expected help
> >>message from my_script.
> >>
> >>These issues are addressed as follows :
> >>* The parse option flag is changed from PARSE_OPT_STOP_AT_NON_OPTION to
> >>PARSE_OPT_KEEP_UNKNOWN
> >>* A new option type is introduce OPT_CALLBACK_FINAL_OPTION, which
> >>effectively
> >>  prevents the parsing of all options located after the script.
> >>
> >>Signed-off-by: Adrien Bak <adrien.bak@metascale.org>
