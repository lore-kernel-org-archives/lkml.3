Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbaFDGt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 02:49:58 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:62380 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932723AbaFDGty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 02:49:54 -0400
Message-ID: <1401864591.14072.2.camel@x220>
Subject: Re: [PATCH 03/32] perf tools: Kbuild source related fixies
From: Paul Bolle <pebolle@tiscali.nl>
To: David Ahern <dsahern@gmail.com>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kbuild@vger.kernel.org, Stephane Eranian <eranian@google.com>
Date: Wed, 04 Jun 2014 08:49:51 +0200
In-Reply-To: <538E7B2F.2000100@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
	 <1401833185-10347-4-git-send-email-alexis.berlemont@gmail.com>
	 <538E7B2F.2000100@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2014 06:49:51.0729 (UTC) FILETIME=[2F604E10:01CF7FC1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-03 at 19:49 -0600, David Ahern wrote:
> On 6/3/14, 4:05 PM, Alexis Berlemont wrote:
> > From: Jiri Olsa <jolsa@redhat.com>
> > diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> > index c852c7a..b255c20 100644
> > --- a/tools/perf/builtin-lock.c
> > +++ b/tools/perf/builtin-lock.c
> > @@ -992,9 +992,11 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
> >   				usage_with_options(report_usage, report_options);
> >   		}
> >   		rc = __cmd_report(false);
> > +#ifdef CONFIG_BULTIN_SCRIPT
> >   	} else if (!strcmp(argv[0], "script")) {
> >   		/* Aliased to 'perf script' */
> > -		return cmd_script(argc, argv, prefix);
> > +		rc = cmd_script(argc, argv, prefix);
> > +#endif
> >   	} else if (!strcmp(argv[0], "info")) {
> >   		if (argc) {
> >   			argc = parse_options(argc, argv,
> 
> Since you are not adding builtin-cmds.h as an included file this change 
> takes away functionality.

And I guess that, because of the typo in CONFIG_BULTIN_SCRIPT, that
would also be true if builtin-cmds.h were actually included.

>  Each patch should ensure that existing options 
> continue to work after the change.
> 
> ditto for all of the other changes to other files.


Paul Bolle

