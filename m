Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3AaOVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 09:21:10 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:49543 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3AaOVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 09:21:08 -0500
Date: Thu, 31 Jan 2013 15:21:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH 0/2] perf: add new uncore command
Message-ID: <20130131142102.GA7339@gmail.com>
References: <1359640479-5289-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359640479-5289-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> This patchset adds a new command to perf: perf uncore.
> It is used to measure processor socket-level metrics
> on a system-wide basis and at all priv levels.
> 
> The command comes with a set of predefined key metrics
> which are useful to measure multi-socket system imbalance
> and various bandwidths.
> 
> The following metrics are currently defined:
>   - memory bandwidth (Nehalem, Westmere, SandyBridge-EP)
>   - PCIe bandwidth (SandyBridge-EP)
>   - QPI bandwidth (SandyBridge-EP)
>   - C-state residency (SandyBridge-EP)
> 
> Others can be added in the future.
> 
> The command provides options to modify the unit of the metrics
> (default: MB/s for bandwidth).
> 
> Example on Nehalem:
> 
>  # perf uncore
>  #------------------------------
>  #           Socket0           |
>  #------------------------------
>  #        RAM Bandwidth        |
>  #            Wr             Rd|
>  #          MB/s           MB/s|
>  #------------------------------
>          4954.99       14897.29
>          4953.97       14894.56
>          4947.52       14874.97
> 
> To make plotting easier, the output can be augmented with a timestamp:
> 
>  # perf uncore -T
>  #----------------------------------------
>  #         |           Socket0           |
>  #         |------------------------------
>  #   Time  |        RAM Bandwidth        |
>  #    in   |            Wr             Rd|
>  #   secs  |          MB/s           MB/s|
>  #----------------------------------------
>           1        4952.50       14890.49
>           2        4955.55       14900.19
>           3        4949.13       14879.60
>           4        4954.66       14896.26

Looks really useful - how about naming it in a bit more generic 
way, because I'm quite sure this command will become popular and 
'perf uncore' is a bit un-intutive.

A couple of possibilities:

  perf system
  perf hw
  perf hw-stat

and also adding subcommands instead of options for the various 
views/metrics, such as:

  perf hw ram
  perf hw pci
  perf hw qpi
  perf hw cstate
  etc.

A plain 'perf hw' command would then list the available 
sub-commands and inform the user about the (current) set of 
hw subsystems that provide metrics.

Hm?

Thanks,

	Ingo
