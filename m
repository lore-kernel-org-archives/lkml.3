Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab3LBS0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:26:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:33857 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752098Ab3LBS0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:26:06 -0500
Date: Mon, 2 Dec 2013 13:26:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktest: Make the signal to terminate the console
 configurable.
Message-ID: <20131202132603.7dd7c0a6@gandalf.local.home>
In-Reply-To: <87zjol8pl5.wl%satoru.takeuchi@gmail.com>
References: <87zjol8pl5.wl%satoru.takeuchi@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Dec 2013 07:57:58 +0900
Satoru Takeuchi <satoru.takeuchi@gmail.com> wrote:

>  Currently ktest send SIGINT to terminate the console.
>  However, there are consoles which doesn't exit by this signal, for example,
>  in my case, "virsh console <guest OS>". In such case, ktest is blocked in
>  close_console(). It prevents to automate tests.
> 
> This patch adds new option CLOSE_CONSOLE_SIGNAL which mean the
> signal to terminate the console. Since its default value is "INT",
> the original behavior isn't changed.

Thanks! I'll add this to my 3.14 queue

-- Steve

> 
> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> 
> ---
>  tools/testing/ktest/ktest.pl | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
> index 999eab1..4e5ee67 100755
> --- a/tools/testing/ktest/ktest.pl
> +++ b/tools/testing/ktest/ktest.pl
> @@ -25,6 +25,7 @@ my %default = (
>      "TEST_TYPE"			=> "build",
>      "BUILD_TYPE"		=> "randconfig",
>      "MAKE_CMD"			=> "make",
> +    "CLOSE_CONSOLE_SIGNAL"	=> "INT",
>      "TIMEOUT"			=> 120,
>      "TMP_DIR"			=> "/tmp/ktest/\${MACHINE}",
>      "SLEEP_TIME"		=> 60,	# sleep time between tests
> @@ -163,6 +164,7 @@ my $timeout;
>  my $booted_timeout;
>  my $detect_triplefault;
>  my $console;
> +my $close_console_signal;
>  my $reboot_success_line;
>  my $success_line;
>  my $stop_after_success;
> @@ -285,6 +287,7 @@ my %option_map = (
>      "TIMEOUT"			=> \$timeout,
>      "BOOTED_TIMEOUT"		=> \$booted_timeout,
>      "CONSOLE"			=> \$console,
> +    "CLOSE_CONSOLE_SIGNAL"	=> \$close_console_signal,
>      "DETECT_TRIPLE_FAULT"	=> \$detect_triplefault,
>      "SUCCESS_LINE"		=> \$success_line,
>      "REBOOT_SUCCESS_LINE"	=> \$reboot_success_line,
> @@ -1296,7 +1299,7 @@ sub close_console {
>      my ($fp, $pid) = @_;
>  
>      doprint "kill child process $pid\n";
> -    kill 2, $pid;
> +    kill $close_console_signal, $pid;
>  
>      print "closing!\n";
>      close($fp);

