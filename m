Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3C0OU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:20:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44565 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab3C0OU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:20:27 -0400
Message-ID: <1364394014.5053.76.camel@laptop>
Subject: Re: [PATCH v7 11/18] perf tools: add mem access sampling core
 support
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        namhyung.kim@lge.com
Date: Wed, 27 Mar 2013 15:20:14 +0100
In-Reply-To: <20130327141425.GC1092@krava.brq.redhat.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
	 <1359040242-8269-12-git-send-email-eranian@google.com>
	 <20130327141425.GC1092@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 15:14 +0100, Jiri Olsa wrote:
> we have correct cpumode for sample->ip, but I think it's the
> PEBS->dla (sample->addr) where we need to guess.. right?

kernel mode very much fakes the cpumode/segment stuff for PEBS. PEBS
assumes you're running in a linear/flat mode.

