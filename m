Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935147AbaFTRuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:50:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47532 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbaFTRuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:50:44 -0400
Message-ID: <53A47461.4050409@zytor.com>
Date: Fri, 20 Jun 2014 10:50:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
References: <20140620161736.D6AC16FD@viggo.jf.intel.com> <20140620161740.BFB00798@viggo.jf.intel.com> <53A46008.5060509@zytor.com> <53A4619C.8020100@sr71.net> <53A46365.6090101@zytor.com> <20140620174345.GD11391@pd.tnic>
In-Reply-To: <20140620174345.GD11391@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at the AMD init code, there is a whole bunch of other 32/64-bit
differences that are clearly bogus.  I also see that amd_k7_smp_check()
doesn't even *exist* on 64 bits, and that init_amd_k7() which calls
amd_k7_smp_check() only is ever called for family == 6, despite having
tests for family 7 and above in it.

Urgh.

Borislav, any way that you would be willing to take this on, or get
someone from AMD to clean up this mess?

	-hpa

