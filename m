Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750781AbbABHxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 02:53:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:45942 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbbABHxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 02:53:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,683,1413270000"; 
   d="scan'208";a="655941094"
Message-ID: <54A64E6D.1020304@linux.intel.com>
Date: Thu, 01 Jan 2015 23:53:17 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API
 to arch_prctl
References: <cover.1419900414.git.luto@amacapital.net> <d5efe02b133f6d9fb4cb9d03e0f0b9e17211c06f.1419900414.git.luto@amacapital.net>
In-Reply-To: <d5efe02b133f6d9fb4cb9d03e0f0b9e17211c06f.1419900414.git.luto@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2014 04:52 PM, Andy Lutomirski wrote:
> This has the benefit the it avoids cluttering prctl with more
> arch-specific functionality.  The down side is that arch_prctl will
> need to be wired up as a 32-bit syscall to add 32-bit support for
> MPX.

There is existing userspace out there which depends on the existing
prctl() setup.  There isn't a _lot_ and it might still be able to be
changed easily, but this isn't a given.

I'll check in with the folks doing the gcc (runtime) part of this next
week and see what they think.
