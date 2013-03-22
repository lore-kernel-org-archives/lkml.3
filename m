Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab3CVVlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:41:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468Ab3CVVlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:41:09 -0400
Message-ID: <514CCFDA.2080305@redhat.com>
Date: Fri, 22 Mar 2013 14:40:42 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 0/7] uretprobes: return probes implementation
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <20130322151034.GC17286@redhat.com>
In-Reply-To: <20130322151034.GC17286@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 08:10 AM, Oleg Nesterov wrote:
> This looks simple, but probably we need to add the additional "ulong bp_vaddr"
> argument for rp_handler().

FWIW, in SystemTap we don't currently do anything that would need
bp_vaddr.  The uprobe_consumer already gives the context, so I'm not
sure what else you would do with the *entry* address of the function
that just returned.  Perhaps you could emulate an additional top line on
a stacktrace, but it doesn't tell you where in the function you were.

Josh
