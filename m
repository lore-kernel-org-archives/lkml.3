Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaIREnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 00:43:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:21726 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaIREnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 00:43:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,544,1406617200"; 
   d="scan'208";a="574863574"
Message-ID: <541A62DD.7080502@intel.com>
Date: Wed, 17 Sep 2014 21:43:09 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kevin Easton <kevin@guarana.org>, "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com> <20140916075007.GA22076@chicago.guarana.org> <9E0BE1322F2F2246BD820DA9FC397ADE017B32C6@shsmsx102.ccr.corp.intel.com> <20140918032334.GA26560@chicago.guarana.org>
In-Reply-To: <20140918032334.GA26560@chicago.guarana.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 08:23 PM, Kevin Easton wrote:
> I was actually thinking that the kernel would take care of the xsave / 
> xrstor (for current), updating tsk->thread.fpu.state (for non-running
> threads) and sending an IPI for threads running on other CPUs.
> 
> Of course userspace can always then manually change the bounds directory
> address itself, but then it's quite clear that they're doing something
> unsupported.  Just an idea, anyway.

What's the benefit of that?

As it stands now, MPX is likely to be enabled well before any threads
are created, and the MPX enabling state will be inherited by the new
thread at clone() time.  The current mechanism allows a thread to
individually enable or disable MPX independently of the other threads.

I think it makes it both more complicated and less flexible.

