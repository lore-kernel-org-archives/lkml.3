Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab3IRL5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:57:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab3IRL5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:57:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <29168.1379504300@warthog.procyon.org.uk>
References: <29168.1379504300@warthog.procyon.org.uk> <1379459317-13046-2-git-send-email-daniel.santos@pobox.com> <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
Cc: dhowells@redhat.com, Daniel Santos <daniel.santos@pobox.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 1/5] scripts: Add mkstrerror.sh
Date: Wed, 18 Sep 2013 12:55:10 +0100
Message-ID: <1352.1379505310@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

>  (1) Why are you double-NUL'ing all your strings?  (see the \0 in the strings)

Ah...  I see what you're doing.  I missed the fact that you don't have a comma
after each string.

>  (3) You are storing a pointer to the symbolic name for each error.  On a
>      64-bit machine, that's 8 bytes.  If you drop the leading 'E' and the
>      trailing NUL, most symbols will fit into an 8 character slot saving you
>      the cost of a pointer.
>      ...

In which case, you can ignore this too.

David
