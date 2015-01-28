Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbbA1GwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:52:19 -0500
Received: from 1wt.eu ([62.212.114.60]:16875 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759875AbbA1GwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:52:17 -0500
Date: Wed, 28 Jan 2015 07:51:15 +0100
From: Willy Tarreau <w@1wt.eu>
To: lizf@kernel.org
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 3.4 177/177] x86/tls: Validate TLS entries to protect espfix
Message-ID: <20150128065115.GA9007@1wt.eu>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org> <1422418236-12852-268-git-send-email-lizf@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422418236-12852-268-git-send-email-lizf@kernel.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

On Wed, Jan 28, 2015 at 12:10:35PM +0800, lizf@kernel.org wrote:
> From: Andy Lutomirski <luto@amacapital.net>
> 
> 3.4.106-rc1 review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> 
> commit 41bdc78544b8a93a9c6814b8bbbfef966272abbe upstream.
> 
> Installing a 16-bit RW data segment into the GDT defeats espfix.
> AFAICT this will not affect glibc, Wine, or dosemu at all.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Acked-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: security@kernel.org <security@kernel.org>
> Cc: Willy Tarreau <w@1wt.eu>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Zefan Li <lizefan@huawei.com>

This patch has introduced a few minor regressions for which Andy has
provided fixes already pending in latest stable previews, so maybe it
could make sense to either pick them as well or delay all of them for
another round. Greg has queued them in his latest preview if you are
interested (eg: 19/32 and 20/32 for 3.10.67) :

- e30ab18 ("x86, tls, ldt: Stop checking lm in LDT_empty")
- 3669ef9 ("x86, tls: Interpret an all-zero struct user_desc as "no segment"")

Best regards,
Willy

