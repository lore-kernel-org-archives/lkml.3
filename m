Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbaCDWZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:25:28 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51125 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaCDWZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:25:27 -0500
Date: Tue, 4 Mar 2014 22:23:56 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
Message-ID: <20140304222356.41c55bbc@alan.etchedpixels.co.uk>
In-Reply-To: <53164824.3000704@oracle.com>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
	<531641A8.40306@zytor.com>
	<53164824.3000704@oracle.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obvious bug

| Usage model is a thread mmaps this file during initialization. It then
| writes a 1 to the mmap'd file after it grabs the lock in its critical
| section where it wants immunity from pre-emption.

You need to write it first or you can be pre-empted taking the lock
before asking for immunity.

Presumably you could equally use something to group tasks (say a control
group of some form) and implement voluntary pre-emption within the group
only when in user space. Ie they only pre-empt each other by yielding but
they can be pre-empted by other tasks outside the group ?

