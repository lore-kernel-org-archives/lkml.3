Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab3FCNuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:50:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757773Ab3FCNuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:50:14 -0400
Date: Mon, 3 Jun 2013 15:49:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 16/16] perf, persistent: Allow multiple users for an event
Message-ID: <20130603134925.GA13548@krava.brq.redhat.com>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <1369990056-10310-17-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369990056-10310-17-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:47:36AM +0200, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>

SNIP

>  out:
>  	mutex_unlock(&per_cpu(pers_events_lock, cpu));
>  }
> @@ -182,18 +195,31 @@ fail:
>  int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
>  {
>  	struct pers_event_desc *desc;
> +	struct perf_event *event;
>  	int event_fd = -ENODEV;
>  
>  	mutex_lock(&per_cpu(pers_events_lock, cpu));

maybe check for valid cpu, since perf_get_persistent_event_fd is
called directly from syscall allowing anything in cpu

(unrelated to this patch, but I couldn't find the original
patch that adds perf_get_persistent_event_fd)

jirka
