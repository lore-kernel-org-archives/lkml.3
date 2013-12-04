Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3LDIkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:40:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab3LDIk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:40:29 -0500
Date: Wed, 4 Dec 2013 00:41:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] mm readahead: Fix the readahead fail in case of
 empty numa node
Message-Id: <20131204004125.a06f7dfc.akpm@linux-foundation.org>
In-Reply-To: <529EE811.5050306@linux.vnet.ibm.com>
References: <1386066977-17368-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
	<20131203143841.11b71e387dc1db3a8ab0974c@linux-foundation.org>
	<529EE811.5050306@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Dec 2013 14:00:09 +0530 Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:

> > I don't recall the rationale for the current code and of course we
> > didn't document it.  It might be in the changelogs somewhere - could
> > you please do the git digging and see if you can find out?
> 
> Unfaortunately, from my search, I saw that the code belonged to pre git
> time, so could not get much information on that.

Here: https://lkml.org/lkml/2004/8/20/242

It seems it was done as a rather thoughtless performance optimisation. 
I'd say it's time to reimplement max_sane_readahead() from scratch.

