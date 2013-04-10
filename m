Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935671Ab3DJTmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:42:04 -0400
Received: from www.sr71.net ([198.145.64.142]:38546 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935722Ab3DJTmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:42:00 -0400
Message-ID: <5165C087.4060404@sr71.net>
Date: Wed, 10 Apr 2013 12:41:59 -0700
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
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos> <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <516439DF.3050901@sr71.net> <alpine.LFD.2.02.1304092036431.21884@ionos> <alpine.LFD.2.02.1304092126150.21884@ionos> <51647C30.3050109@sr71.net> <alpine.LFD.2.02.1304101024010.21884@ionos> <alpine.LFD.2.02.1304101250320.21884@ionos>
In-Reply-To: <alpine.LFD.2.02.1304101250320.21884@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I got a full trace this time:

	http://sr71.net/~dave/linux/bigbox-trace.1365621899.txt.gz

The last timestamp is pretty close to the timestamp on the console:

[ 2071.033434] smpboot_thread_fn():
[ 2071.033455] smpboot_thread_fn() cpu: 22 159
[ 2071.033470] td->cpu: 22
[ 2071.033475] smp_processor_id(): 21
[ 2071.033486] comm: migration/%u


