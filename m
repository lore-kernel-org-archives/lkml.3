Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbbAFRsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:48:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:30923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbbAFRso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:48:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="508249580"
Message-ID: <54AC1FFB.7030504@linux.intel.com>
Date: Tue, 06 Jan 2015 09:48:43 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API
 to arch_prctl
References: <cover.1419900414.git.luto@amacapital.net> <d5efe02b133f6d9fb4cb9d03e0f0b9e17211c06f.1419900414.git.luto@amacapital.net> <54A64E6D.1020304@linux.intel.com> <87mw5x0xjz.fsf@tassilo.jf.intel.com> <54AAFFA3.6000901@linux.intel.com> <CALCETrUeMS7zwjXfSMN-6A8-gpLc68n7U5Y6SPdzgw6hSbYGNg@mail.gmail.com> <20150106040428.GR2915@two.firstfloor.org> <CALCETrU3oHO5Rjqp_DmJaOkEBOtZpQ+f99xXiY5=84JfJphZCA@mail.gmail.com>
In-Reply-To: <CALCETrU3oHO5Rjqp_DmJaOkEBOtZpQ+f99xXiY5=84JfJphZCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 09:59 PM, Andy Lutomirski wrote:
> But I decided to check whether libmpx links against glibc, and I can't
> find sources for it at all.  Do they exist?  Is there any code with
> source available that invokes this prctl?
> 
> If not, I personally have very little sympathy for the argument that a
> binary buried in the depths of the Intel SDE would need to change if
> we switched to using arch_prctl.  And I think that it should issue the
> syscall itself without using glibc, in which case the syscall wrapper
> issue is moot.

Andy, as I mentioned previously, there is code in a GCC branch that uses
the existing prctl().  It's also been posted for review to one of the
GCC mailing lists.  I've been told that it will be in gcc 5.0.

The Intel SDE does not use the prctl() in any way that I know of.
