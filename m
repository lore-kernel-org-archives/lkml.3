Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaKRFyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 00:54:52 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:34707 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaKRFyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 00:54:50 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: kan.liang@intel.com
Cc: acme@kernel.org, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, ak@linux.intel.com
Subject: Re: [PATCH V3 1/3] perf tools: enable LBR call stack support
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
	<1415972652-17310-2-git-send-email-kan.liang@intel.com>
Date: Tue, 18 Nov 2014 14:54:48 +0900
In-Reply-To: <1415972652-17310-2-git-send-email-kan.liang@intel.com> (kan
	liang's message of "Fri, 14 Nov 2014 08:44:10 -0500")
Message-ID: <87ppclqcif.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 08:44:10 -0500, kan liang wrote:
> From: Kan Liang <kan.liang@intel.com>
>
> Currently, there are two call chain recording options, fp and dwarf.
> Haswell has a new feature that utilizes the existing LBR facility to
> record call chains. So it provides the third options to record call
> chain. This patch enables the lbr call stack support.
>
> LBR call stack has some limitations. It reuses current LBR facility, so
> LBR call stack and branch record can not be enabled at the same time. It
> is only available for user callchain.
> However, LBR call stack can work on the user app which doesn't have
> frame-pointer or dwarf debug info compiled. It is a good alternative
> when nothing else works.

So this is only for Haswell or later, right?  What if user gives it to
the other CPUs - is it fail or ignore silently?  I think we need to warn
user about it more kindly..

Thanks,
Namhyung
