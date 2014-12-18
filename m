Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaLRSA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 13:00:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36370 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbaLRSAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 13:00:24 -0500
Message-ID: <5493162E.7060305@zytor.com>
Date: Thu, 18 Dec 2014 10:00:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        "Williamson, Glenn P" <glenn.p.williamson@intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v2] X86-32: Allocate 256 bytes for pgd in PAE paging
References: <1418852859-18852-1-git-send-email-fenghua.yu@intel.com> <54930E14.30800@zytor.com> <3E5A0FA7E9CA944F9D5414FEC6C712205A6C1D8F@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712205A6C1D8F@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 4*8 = 32 bytes, where did 256 bytes come from?
> 
> You are right. It should be 32 bytes. I will change the wording in future patch. The real calculation in code is right though.

I don't know if it makes sense to round up to a cache line.  My
suspicion is that it won't matter, as these fields will be read-mostly,
on the other hand, wasting 32 bytes isn't exactly a problem, either.

	-hpa


