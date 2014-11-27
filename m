Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaK0CFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 21:05:36 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44593 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaK0CFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 21:05:35 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Kan Liang <kan.liang@intel.com>
Cc: acme@kernel.org, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V5 3/3] perf tool: check buildid for symoff
References: <1416844829-26945-1-git-send-email-kan.liang@intel.com>
	<1416844829-26945-3-git-send-email-kan.liang@intel.com>
Date: Thu, 27 Nov 2014 11:05:32 +0900
In-Reply-To: <1416844829-26945-3-git-send-email-kan.liang@intel.com> (Kan
	Liang's message of "Mon, 24 Nov 2014 11:00:29 -0500")
Message-ID: <87d289o0sz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kan,

On Mon, 24 Nov 2014 11:00:29 -0500, Kan Liang wrote:
> From: Kan Liang <kan.liang@intel.com>
>
> symoff can support both same binaries and different binaries. However,
> the offset may be changed for different binaries. This patch checks the
> buildid of perf.data. If they are from different binaries, print a
> warning to notify the user.

Hmm.. I think that perf diff is supposed to compare performance between
different (i.e. modified) binaries.  So there's a little point to print
the warning IMHO - but I'm not insist it strongly..

Anyway, I think what we really need for the warning is different version
of same binary.  For example, if data file 1 has DSO A and B, and data
file 2 has DSO B and C, we should not consider they're different (unless
build-ids of B in data file 1 and 2 are different) since A and C won't
affect symoff comparision.

Thanks,
Namhyung
