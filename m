Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaILN7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:59:07 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:32894 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaILN7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:59:05 -0400
Message-ID: <1410530335.16936.60.camel@hornet>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
From: Pawel Moll <pawel.moll@arm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Christopher Covington <cov@codeaurora.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Fri, 12 Sep 2014 14:58:55 +0100
In-Reply-To: <20140912134910.GG1801@kernel.org>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>
	 <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
	 <5412EA7A.9020807@codeaurora.org> <1410526672.16936.52.camel@hornet>
	 <20140912134910.GG1801@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 14:49 +0100, Arnaldo Carvalho de Melo wrote:
> Perhaps both? I.e. an u64 followed from a string, if the u64 is zero,
> then there is a string right after it?

How would this look like in userspace? Something like this?

8<----
struct perf_event_marker {
	uint64_t value;
	char *string;
} arg;

arg.value = 0x1234;

/* or */

arg.value = 0;
arg.string = "abcd";

ioctl(fd, PERF_EVENT_IOC_MARKER, &arg)
8<----

If so, maybe it would simpler just to go for classic size/data
structure?

8<-----
struct perf_event_marker {
	uint32_t size;
	void *data;
}
8<-----

This would directly map into struct perf_raw_record...

Paweł

