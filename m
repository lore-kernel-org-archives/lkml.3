Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab3LaTkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:40:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51028 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab3LaTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:40:17 -0500
Message-ID: <52C31D9F.7090001@infradead.org>
Date: Tue, 31 Dec 2013 11:40:15 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
CC: x86@kernel.org
Subject: Re: [PATCH 00/12] Reorganize x86 Kconfig menu
References: <20131230184046.F5E42919@viggo.jf.intel.com>
In-Reply-To: <20131230184046.F5E42919@viggo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/13 10:40, Dave Hansen wrote:
> The x86 "Processor type and features" menu has really been
> letting itself go over the years.  It needs to be put on a
> diet as a new-year's resolution.


Applying all 12 patches in order provokes kconfig:

arch/x86/lguest/Kconfig:1:error: recursive dependency detected!
arch/x86/lguest/Kconfig:1:	symbol LGUEST_GUEST depends on VIRTUALIZATION
arch/x86/Kconfig.virt:2:	symbol VIRTUALIZATION is selected by LGUEST_GUEST
warning: (X86_VSMP) selects HYPERVISOR_GUEST which has unmet direct dependencies (VIRTUALIZATION)
warning: (X86_VSMP) selects PARAVIRT which has unmet direct dependencies (VIRTUALIZATION && HYPERVISOR_GUEST)


-- 
~Randy
