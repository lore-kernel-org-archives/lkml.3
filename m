Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab3CYLn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:43:26 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57299
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756415Ab3CYLnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:43:25 -0400
Message-ID: <1364211788.5053.3.camel@laptop>
Subject: Re: [PATCH v5 2/2] perf: add sysfs entry to adjust multiplexing
 interval per PMU
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Date: Mon, 25 Mar 2013 12:43:08 +0100
In-Reply-To: <1363949499-3728-3-git-send-email-eranian@google.com>
References: <1363949499-3728-1-git-send-email-eranian@google.com>
	 <1363949499-3728-3-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 11:51 +0100, Stephane Eranian wrote:
> In the 4th version, we renamed the sysfs file to be more
> consistent with the other /proc/sys/kernel entries for
> perf_events.

>  static struct device_attribute pmu_dev_attrs[] = {
> -       __ATTR_RO(type),
> -       __ATTR_NULL,
> +       __ATTR_RO(type),
> +       __ATTR_RW(perf_event_mux_interval_ms),
> +       __ATTR_NULL,
>  };

but but but, the file doesn't live in /proc/sys/kernel/, its in
/sys/bus/event_source/devices/*/$foo and none of the files there are
perf_event_* prefixed.

Other than that, the patches look fine.

