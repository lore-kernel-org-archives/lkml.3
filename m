Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3LaUZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 15:25:04 -0500
Received: from www.sr71.net ([198.145.64.142]:42080 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224Ab3LaUZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 15:25:03 -0500
Message-ID: <52C32818.2080205@sr71.net>
Date: Tue, 31 Dec 2013 12:24:56 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
CC: x86@kernel.org
Subject: Re: [PATCH 00/12] Reorganize x86 Kconfig menu
References: <20131230184046.F5E42919@viggo.jf.intel.com> <52C31D9F.7090001@infradead.org>
In-Reply-To: <52C31D9F.7090001@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2013 11:40 AM, Randy Dunlap wrote:
> arch/x86/lguest/Kconfig:1:error: recursive dependency detected!
> arch/x86/lguest/Kconfig:1:	symbol LGUEST_GUEST depends on VIRTUALIZATION
> arch/x86/Kconfig.virt:2:	symbol VIRTUALIZATION is selected by LGUEST_GUEST
> warning: (X86_VSMP) selects HYPERVISOR_GUEST which has unmet direct dependencies (VIRTUALIZATION)
> warning: (X86_VSMP) selects PARAVIRT which has unmet direct dependencies (VIRTUALIZATION && HYPERVISOR_GUEST)

I think this was caused because I moved lguest support to be underneath
"if VIRTUALIZATION".  I just removed the "select VIRTUALIZATION" which I
think fixes it properly.

Thanks for the review, Randy!  I'll repost these again later this week.

