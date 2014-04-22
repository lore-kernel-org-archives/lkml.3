Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaDVS2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:28:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaDVS2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:28:30 -0400
Date: Tue, 22 Apr 2014 11:28:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, mguzik@redhat.com
Subject: Re: [PATCH 0/4 V3] Print traces on softlockup
Message-Id: <20140422112828.ea511cefa17affb99d9aa97f@linux-foundation.org>
In-Reply-To: <1398179848-197479-1-git-send-email-dzickus@redhat.com>
References: <1398179848-197479-1-git-send-email-dzickus@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 11:17:24 -0400 Don Zickus <dzickus@redhat.com> wrote:

> Added more patches to handle the 'uniprocessor' panic case by sending NMIs
> to every cpu but self.  Only affects x86, sparc.
> 

Looks OK to me.  A couple of things:

- Patches 1-3 should be combined so we don't create bisection holes
  due to x86 and sparc build errors.

- Patch 4 adds stuff which is unusable on uniprocessor, especially
  the presence of /proc/sys/kernel/softlockup_all_cpu_backtrace.  We
  already have #ifdef CONFIG_SMP in kern_table, so do more of that?

