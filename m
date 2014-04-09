Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbaDIQxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:53:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62462 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbaDIQxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:53:34 -0400
MIME-Version: 1.0
In-Reply-To: <0286550@agluck-desk.sc.intel.com>
References: <20140408153412.0648fb96@gandalf.local.home>
	<0286550@agluck-desk.sc.intel.com>
Date: Wed, 9 Apr 2014 09:53:33 -0700
Message-ID: <CA+8MBbL6WWQzwMoL29yWR=9T3T-o0Ejb5xc-jwkEmAnaDTBeUw@mail.gmail.com>
Subject: Re: [PATCH] time: Provide full featured jiffies_to_nsecs() function
From: Tony Luck <tony.luck@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+       if (jl < 4*HZ) {

That was lazy ... should be something like:

+       if (jl < (u64)UINT_MAX * HZ / NSEC_PER_SEC)

-Tony
