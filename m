Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbbABPpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:45:35 -0500
Received: from smtprelay0122.hostedemail.com ([216.40.44.122]:32918 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752616AbbABPpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:45:31 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3874:4321:5007:6261:6609:6742:6743:7875:10004:10400:10848:10967:11026:11232:11473:11657:11658:11914:12043:12517:12519:12555:12740:13069:13161:13229:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: son47_4ce67396ac53d
X-Filterd-Recvd-Size: 2825
Date: Fri, 2 Jan 2015 10:45:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mmarek@suse.cz, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        mingo@redhat.com, davem@davemloft.net, keescook@chromium.org,
        tranmanphong@gmail.com, mpe@ellerman.id.au, cov@codeaurora.org,
        dh.herrmann@gmail.com, hughd@google.com, bobby.prani@gmail.com,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 05/20] selftests/ftrace: add install target to enable
 test install
Message-ID: <20150102104526.29df5641@gandalf.local.home>
In-Reply-To: <e84eeeecde70ecb3ab82c5f825fec359f9e967ff.1419387513.git.shuahkh@osg.samsung.com>
References: <cover.1419387513.git.shuahkh@osg.samsung.com>
	<e84eeeecde70ecb3ab82c5f825fec359f9e967ff.1419387513.git.shuahkh@osg.samsung.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Dec 2014 09:27:41 -0700
Shuah Khan <shuahkh@osg.samsung.com> wrote:

> Add a new make target to enable installing test. This target
> installs test in the kselftest install location and add to the
> kselftest script to run the test. Install target can be run
> only from top level kernel source directory.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  tools/testing/selftests/ftrace/Makefile | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/ftrace/Makefile b/tools/testing/selftests/ftrace/Makefile
> index 76cc9f1..7c7cf42 100644
> --- a/tools/testing/selftests/ftrace/Makefile
> +++ b/tools/testing/selftests/ftrace/Makefile
> @@ -1,7 +1,16 @@
> +TEST_STR = /bin/sh ./ftracetest || echo ftrace selftests: [FAIL]

Is it ok that this removes the quotes around the echo string? I don't
see anything wrong about it, but I don't know if there's a shell out
there that will fail due to it.

Other than than,

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


> +
>  all:
>  
> +install:
> +ifdef INSTALL_KSFT_PATH
> +	install ./ftracetest $(INSTALL_KSFT_PATH)
> +	@cp -r test.d $(INSTALL_KSFT_PATH)
> +	echo "$(TEST_STR)" >> $(KSELFTEST)
> +endif
> +
>  run_tests:
> -	@/bin/sh ./ftracetest || echo "ftrace selftests: [FAIL]"
> +	@$(TEST_STR)
>  
>  clean:
>  	rm -rf logs/*

