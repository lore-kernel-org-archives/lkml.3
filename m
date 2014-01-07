Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaAGXNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:13:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32822 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbaAGXM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:12:56 -0500
Message-ID: <52CC89B4.4060300@zytor.com>
Date: Tue, 07 Jan 2014 15:11:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org
CC: linux-arch@vger.kernel.org, patches@linaro.org, linux-mm@kvack.org,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 1/5] mm: create generic early_ioremap() support
References: <1389062120-31896-1-git-send-email-msalter@redhat.com> <1389062120-31896-2-git-send-email-msalter@redhat.com>
In-Reply-To: <1389062120-31896-2-git-send-email-msalter@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 06:35 PM, Mark Salter wrote:
> 
> There is one difference from the existing x86 implementation which
> should be noted. The generic early_memremap() function does not return
> an __iomem pointer and a new early_memunmap() function has been added
> to act as a wrapper for early_iounmap() but with a non __iomem pointer
> passed in. This is in line with the first patch of this series:
> 

This makes a lot of sense.  However, I would suggest that we preface the
patch series with a single patch changing the signature for the existing
x86 function, that way this change becomes bisectable.

	-hpa


