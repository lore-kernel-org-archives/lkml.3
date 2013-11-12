Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3KLPUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:20:16 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:44573 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3KLPUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:20:12 -0500
Date: Tue, 12 Nov 2013 10:20:10 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: Use udiv/sdiv for __aeabi_{u}idiv library
 functions
In-Reply-To: <alpine.LFD.2.10.1311120948000.9667@knanqh.ubzr>
Message-ID: <alpine.LFD.2.10.1311121014530.9667@knanqh.ubzr>
References: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.10.1311092357090.2314@knanqh.ubzr> <528193A0.7050505@codeaurora.org> <alpine.LFD.2.10.1311120839310.9667@knanqh.ubzr> <20131112140436.GK16735@n2100.arm.linux.org.uk>
 <52823877.60806@codethink.co.uk> <alpine.LFD.2.10.1311120924330.9667@knanqh.ubzr> <yw1x8uwtvg3i.fsf@unicorn.mansr.com> <alpine.LFD.2.10.1311120948000.9667@knanqh.ubzr>
User-Agent: Alpine 2.10 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1089545557-1384269611=:9667"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1089545557-1384269611=:9667
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 12 Nov 2013, Nicolas Pitre wrote:

> On Tue, 12 Nov 2013, Måns Rullgård wrote:
> 
> > It might be possible to extract this information from relocation tables.
> 
> True, but only for individual .o files.  Once the linker puts them 
> together the information is lost, and trying to infer what the linker 
> has done is insane.
> 
> Filtering the compiler output to annotate idiv calls before it is 
> assembled would probably be a better solution.

Another solution is to patch the call site from within __aeabi_idiv at 
run time using lr.  That wouldn't work in the presence of tail call 
optimization though.

Again this might not be worth it and patching __aeabi_idiv instead might 
be a good enough compromize.


Nicolas
--8323328-1089545557-1384269611=:9667--
