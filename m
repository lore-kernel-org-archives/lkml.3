Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab3DPE3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 00:29:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab3DPE3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 00:29:10 -0400
Date: Mon, 15 Apr 2013 21:29:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pan, Zhenjie" <zhenjie.pan@intel.com>
Cc: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NMI: fix NMI period is not correct when cpu frequency
 changes issue.
Message-Id: <20130415212914.936f903a.akpm@linux-foundation.org>
In-Reply-To: <F98D4B5C3D86834DB612ABF854C98B7FB5D662@SHSMSX101.ccr.corp.intel.com>
References: <F98D4B5C3D86834DB612ABF854C98B7FB54822@SHSMSX101.ccr.corp.intel.com>
	<20130415163049.08498e3a8726f0bd6f4d6ebe@linux-foundation.org>
	<F98D4B5C3D86834DB612ABF854C98B7FB5D662@SHSMSX101.ccr.corp.intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013 03:45:15 +0000 "Pan, Zhenjie" <zhenjie.pan@intel.com> wrote:

> > Overall the patch looks desirable, but it increases the kernel size by several
> > hundred bytes when CONFIG_CPU_FREQ=n.  It should produce no code in
> > this case!  Take a look at the magic in register_hotcpu_notifier(), the way in
> > which it causes all the code to be removed by the compiler in the
> > CONFIG_HOTPLUG_CPU=n case.  That trick can be used here.
> 
> I have checked if CONFIG_CPU_FREQ=n, cpufreq_register_notifier() will be a blank function.
> So I think it will not increases the kernel size.

I tested it.  The patch adds ~350 bytes of dead code.

This is partly an infrastructural problem: unlike
register_hotcpu_notifier(), the cpufreq notifier code lacks the
infrastructure with which we can prevent this problem.

