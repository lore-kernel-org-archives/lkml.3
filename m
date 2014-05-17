Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbaEQADg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 20:03:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbaEQADe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 20:03:34 -0400
Date: Fri, 16 May 2014 20:03:11 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/8] list: Out of line INIT_LIST_HEAD and list_del
Message-ID: <20140517000311.GA26496@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
 <1400276595-6965-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400276595-6965-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 02:43:10PM -0700, Andi Kleen wrote:

 > diff --git a/lib/Makefile b/lib/Makefile
 > index 0cd7b68..8b744f7 100644
 > --- a/lib/Makefile
 > +++ b/lib/Makefile
 > @@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 >  	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 >  	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 >  	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 > -	 earlycpio.o
 > +	 earlycpio.o list.o

Hey Andi,

Did you test this with CONFIG_DEBUG_LIST ?
Unless I'm missing something, this looks like we'll have duplicate
symbols for list_del if that is set.

	Dave

