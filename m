Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaG1TSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:18:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48506 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaG1TSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:18:48 -0400
Message-ID: <53D6A1F2.5070404@zytor.com>
Date: Mon, 28 Jul 2014 12:18:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>,
        virtualization@lists.linux-foundation.org
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Chris Wright <chrisw@sous-sol.org>,
        Alok Kataria <akataria@vmware.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, paravirt: BUG_ON on {rd,wr}msr exceptions
References: <1406574278-23946-1-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1406574278-23946-1-git-send-email-ehabkost@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 12:04 PM, Eduardo Habkost wrote:
> When CONFIG_PARAVIRT is enabled, the kernel is ignoring exceptions on
> the {rd,wr}msr instructions. This makes serious issues (either on the
> guest kernel, or on the host) be silently ignored, and is different from
> the native MSR code (which does not ignore the exceptions).
> 
> As paravirt.h already includes linux/bug.h, I don't see what was the
> original issue preventing BUG_ON from being used.
> 
> Change rdmsr(), wrmsr(), and rdmsrl() to BUG_ON() on errors.

How much does this bloat the kernel?

#include <stdparavirtrant.h>

	-hpa


