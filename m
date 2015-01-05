Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbbAEXQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:16:20 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:50832 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753885AbbAEXQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:16:19 -0500
Message-ID: <1420499776.14308.50.camel@x220>
Subject: Re: [PATCH] checkpatch: add check for keyword 'boolean' in Kconfig
 definitions
From: Paul Bolle <pebolle@tiscali.nl>
To: Christoph Jaeger <cj@linux.com>
Cc: apw@canonical.com, joe@perches.com, linux-kernel@vger.kernel.org,
        dborkman@redhat.com
Date: Tue, 06 Jan 2015 00:16:16 +0100
In-Reply-To: <1419108036-11536-1-git-send-email-cj@linux.com>
References: <1419108036-11536-1-git-send-email-cj@linux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jan 2015 23:16:17.0057 (UTC) FILETIME=[9B64E910:01D0293D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-12-20 at 15:40 -0500, Christoph Jaeger wrote:
> Discourage the use of keyword 'boolean' for type definition attributes of
> config options as support for it will be dropped later on.
> 
> Reference: http://lkml.kernel.org/r/cover.1418003065.git.cj@linux.com
> Suggested-by: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Christoph Jaeger <cj@linux.com>

Works as advertised:
    $ scripts/checkpatch.pl -f kernel/livepatch/Kconfig 
    WARNING: Use of boolean is deprecated, please use bool instead.
    #2: FILE: kernel/livepatch/Kconfig:2:
    +        boolean

    WARNING: Use of boolean is deprecated, please use bool instead.
    #7: FILE: kernel/livepatch/Kconfig:7:
    +        boolean "Kernel Live Patching"

    total: 0 errors, 2 warnings, 18 lines checked

    kernel/livepatch/Kconfig has style problems, please review.

    If any of these errors are false positives, please report
    them to the maintainer, see CHECKPATCH in MAINTAINERS.

Acked-by: Paul Bolle <pebolle@tiscali.nl>

> ---
>  scripts/checkpatch.pl | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index f0bb6d6..cae974e 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2355,6 +2355,13 @@ sub process {
>  			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
>  		}
>  
> +# discourage the use of boolean for type definition attributes of Kconfig options
> +		if ($realfile =~ /Kconfig/ &&
> +		    $line =~ /^\+\s*\bboolean\b/) {
> +			WARN("CONFIG_TYPE_BOOLEAN",

This should become an error once "boolean" is removed (on some future
date).

> +			     "Use of boolean is deprecated, please use bool instead.\n" . $herecurr);
> +		}
> +
>  		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
>  		    ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
>  			my $flag = $1;


Paul Bolle

