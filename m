Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3HVQhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:37:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22676 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3HVQhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:37:15 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=gPhQW-MqCHAA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=g0UHv3CdosEA:10 a=9AzMRrQhAAAA:8 a=gkbvocDIl5Lr0wzoPMQA:9 a=CjuIK1q_8ugA:10 a=SxxB86fLhQ4A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 22 Aug 2013 12:37:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tony Lu <zlu@tilera.com>
Cc: <linux-kernel@vger.kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tile: support ftrace on tilegx
Message-ID: <20130822123714.2611671a@gandalf.local.home>
In-Reply-To: <2c9c68a646dd67eb51d89d878966c08941efa055.1376076465.git.cmetcalf@tilera.com>
References: <2c9c68a646dd67eb51d89d878966c08941efa055.1376076465.git.cmetcalf@tilera.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Aug 2013 13:26:09 -0400
Tony Lu <zlu@tilera.com> wrote:


> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 858966a..a674fd5 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -364,6 +364,10 @@ if ($arch eq "x86_64") {
>  } elsif ($arch eq "blackfin") {
>      $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s__mcount\$";
>      $mcount_adjust = -4;
> +} elsif ($arch eq "tilegx") {
> +    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s__mcount\$";
> +    $type = ".quad";
> +    $alignment = 8;
>  } else {
>      die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
>  }


If you want faster build times, you may want to update recordmcount.c,
and then add HAVE_C_RECORDMCOUNT

-- Steve
