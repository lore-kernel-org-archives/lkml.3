Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3JaPOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:14:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44770 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab3JaPOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:14:39 -0400
Date: Thu, 31 Oct 2013 16:14:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v4 3/4] perf/x86: add Intel RAPL PMU support
Message-ID: <20131031151423.GX19466@laptop.lan>
References: <1383231582-15856-1-git-send-email-eranian@google.com>
 <1383231582-15856-4-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383231582-15856-4-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 03:59:41PM +0100, Stephane Eranian wrote:
> +/*
> + * we compute in 0.23 nJ increments regardless of MSR

We don't in fact use 0.23 nJ, we use 2^-32 J.

> + */
> +EVENT_ATTR_STR(energy-cores.scale, rapl_cores_scale, "2.3e-10");
> +EVENT_ATTR_STR(energy-pkg.scale, rapl_pkg_scale, "2.3e-10");
> +EVENT_ATTR_STR(energy-ram.scale, rapl_ram_scale, "2.3e-10");

Am I weird for proposing we use:

  "2.3283064365386962890625e-10"

instead? Its not like anybody needs to go type this by hand.
