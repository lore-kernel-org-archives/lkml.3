Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaHUU6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:58:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbaHUU63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:58:29 -0400
Date: Thu, 21 Aug 2014 16:57:27 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        peterz@infradead.org, mingo@redhat.com, ak@linux.intel.com,
        tim.c.chen@linux.intel.com, akpm@linux-foundation.org, cl@linux.com,
        penberg@kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        lauraa@codeaurora.org
Subject: Re: [PATCH] [v3] warn on performance-impacting configs aka.
 TAINT_PERFORMANCE
Message-ID: <20140821205727.GA7200@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
	dave.hansen@linux.intel.com, peterz@infradead.org, mingo@redhat.com,
	ak@linux.intel.com, tim.c.chen@linux.intel.com,
	akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
	linux-mm@kvack.org, kirill@shutemov.name, lauraa@codeaurora.org
References: <20140821202424.7ED66A50@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821202424.7ED66A50@viggo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 01:24:24PM -0700, Dave Hansen wrote:

 > Changes from v2:
 >  * remove tainting and stack track

...

 > diff -puN include/linux/kernel.h~taint-performance include/linux/kernel.h
 > --- a/include/linux/kernel.h~taint-performance	2014-08-19 11:38:07.424005355 -0700
 > +++ b/include/linux/kernel.h	2014-08-19 11:38:20.960615904 -0700
 > @@ -471,6 +471,7 @@ extern enum system_states {
 >  #define TAINT_OOT_MODULE		12
 >  #define TAINT_UNSIGNED_MODULE		13
 >  #define TAINT_SOFTLOCKUP		14
 > +#define TAINT_PERFORMANCE		15
 >  
 >  extern const char hex_asc[];
 >  #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
 > diff -puN kernel/panic.c~taint-performance kernel/panic.c
 > --- a/kernel/panic.c~taint-performance	2014-08-19 11:38:28.928975233 -0700
 > +++ b/kernel/panic.c	2014-08-20 09:56:29.528471033 -0700
 > @@ -225,6 +225,7 @@ static const struct tnt tnts[] = {
 >  	{ TAINT_OOT_MODULE,		'O', ' ' },
 >  	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
 >  	{ TAINT_SOFTLOCKUP,		'L', ' ' },
 > +	{ TAINT_PERFORMANCE,		'Q', ' ' },

You don't need these any more.

	Dave
