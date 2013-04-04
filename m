Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389Ab3DDICk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 04:02:40 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:61238 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933369Ab3DDICb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 04:02:31 -0400
Message-ID: <1365062549.1830.16.camel@x61.thuisdomein>
Subject: Re: [PATCH 09/23] perf: make cfi unwind support based on
 CONFIG_LIBUNWIND
From: Paul Bolle <pebolle@tiscali.nl>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Date: Thu, 04 Apr 2013 10:02:29 +0200
In-Reply-To: <515AF720.9010809@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
	  <1364874877-5618-10-git-send-email-dsahern@gmail.com>
	 <1364895122.21627.94.camel@x61.thuisdomein> <515AF720.9010809@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2013 08:02:29.0199 (UTC) FILETIME=[C0A7F5F0:01CE310A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 09:20 -0600, David Ahern wrote:
> traditionally, perf has not required a kernel config to build it. The 
> above grabs some symbols for a standalone perf config. I guess that's a 
> question to be answered - should the kernel's config files should be 
> used for perf (or a tools target in general).

If you decide to only use the kernel kconfig tools but not the current
tree of Kconfig files I suggest to separate things clearly. So in that
case using Pconfig as a filename (as we discussed for PATCH 01/23)
actually seems to be a good idea. Likewise, in that case you might want
to prefix your macros with, say, PCONFIG_ instead of CONFIG_. (I think
the kconfig tools support that, but I haven't checked.)

> Also, perf can be built outside of the kernel tree. Tying the build to 
> the kernel config files would have an affect on that option.
> 
> Something to look at for the next version.


Paul Bolle

