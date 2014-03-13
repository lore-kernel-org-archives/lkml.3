Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaCMXMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:12:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbaCMXMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:12:40 -0400
Date: Thu, 13 Mar 2014 19:12:27 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        keescook@chromium.org
Subject: Re: [RFC] improve_stack: make stack dump output useful again
Message-ID: <20140313231227.GA32178@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sasha.levin@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	keescook@chromium.org
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
 <CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
 <5321CBDA.1060705@oracle.com>
 <CA+55aFwDKSKyxC4rTBiFMRVr6xYtL96ZYCQqNSVLJV0-=FLTUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwDKSKyxC4rTBiFMRVr6xYtL96ZYCQqNSVLJV0-=FLTUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 03:03:41PM -0700, Linus Torvalds wrote:

 > You need to look at the *symbol* number. In this output:
 > 
 >      [<ffffffff810020c2>] do_one_initcall+0xc2/0x1e0
 > 
 > that "ffffffff810020c2" is crap, and is going away. The address that
 > is meaningful and valid is the "do_one_initcall+0xc2" part.
 > 
 > *That* is the part you'd use to parse in user space.
 > 
 > Try it today with the CONFIG_RANDOMIZE_BASE option to see. Using the
 > hex number doesn't *work*.

That reminds me, perf top is still busted when this option is enabled.

	Dave
