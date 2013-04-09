Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936370Ab3DIUiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:38:12 -0400
Received: from www.sr71.net ([198.145.64.142]:55999 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935899Ab3DIUiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:38:08 -0400
Message-ID: <51647C30.3050109@sr71.net>
Date: Tue, 09 Apr 2013 13:38:08 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Borislav Petkov <bp@alien8.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos> <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <516439DF.3050901@sr71.net> <alpine.LFD.2.02.1304092036431.21884@ionos> <alpine.LFD.2.02.1304092126150.21884@ionos>
In-Reply-To: <alpine.LFD.2.02.1304092126150.21884@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 12:30 PM, Thomas Gleixner wrote:
> On Tue, 9 Apr 2013, Thomas Gleixner wrote:
> Thought more about it and found, that the stupid binding only works
> when the task is really descheduled. So there is a small window left,
> which could lead to this. Revised patch below.
> 
> Anyway a trace for that issue would be appreciated nevertheless.

Here you go:

	http://sr71.net/~dave/linux/bigbox.1365539189.txt.gz

It oopsed in exit.c:

https://picasaweb.google.com/lh/photo/7v_Xua9I29Rar3bBdNlLu9MTjNZETYmyPJy0liipFm0?feat=directlink


