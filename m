Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3IRLI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:08:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab3IRLI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:08:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
References: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
To: danielfsantos@att.net
Cc: dhowells@redhat.com, linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 0/5] Preliminary: Add error names & descrptions to printks
Date: Wed, 18 Sep 2013 12:08:38 +0100
Message-ID: <22288.1379502518@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

danielfsantos@att.net wrote:

> Typically, we don't care about error messages or names in the kernel because
> userspace will manage that.  But sometimes we need to output an error number
> to printks and that creates a situation where a user, system admistrator or
> developer must find an error number reference to figure out what went wrong
> with a particular driver or whatever.  This patch adds two alternatives at
> increasing memory costs:
> 
> 1. print the number in addition to the name for 2k extra or
> 2. print the number, name and description for 6k extra.

I like the idea generally - and have occasionally entertained the idea of
implementing it myself.  However, I wouldn't bother with the "human readable"
description if we're going to do this.  Generally, the symbolic representation
is good enough - and that's what you're going to grep the code for anyway.

David
