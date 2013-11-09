Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab3KISUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 13:20:47 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:58729 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab3KISUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 13:20:42 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Matt Sealey <neko@bakuhatsu.net>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Christopher Covington <cov@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?M=E5n?= =?iso-8859-1?Q?s_Rullg=E5rd?= 
	<mans@mansr.com>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v2] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
References: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org>
	<CAHCPf3tCTUEX6oDLUndZwt=Hk+YxsKjPO96N=Zhx82+_LM66sQ@mail.gmail.com>
Date: Sat, 09 Nov 2013 18:20:38 +0000
In-Reply-To: <CAHCPf3tCTUEX6oDLUndZwt=Hk+YxsKjPO96N=Zhx82+_LM66sQ@mail.gmail.com>
	(Matt Sealey's message of "Sat, 9 Nov 2013 00:46:11 -0600")
Message-ID: <yw1x38n5wi6h.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Sealey <neko@bakuhatsu.net> writes:

> BTW has there been any evaluation of the penalty for the extra
> branching, or the performance hit for the ARMv7-without-division
> cases?

The branches themselves probably have minimal overhead.  There will
however be code to preserve call-clobbered registers (and move the
values to/from r0/r1) that would not be needed if the div instructions
were done inline (obviously such a kernel could only run on hardware
with division support).

-- 
Måns Rullgård
mans@mansr.com
