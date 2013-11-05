Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3KEXxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:53:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3KEXxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:53:20 -0500
Date: Tue, 5 Nov 2013 15:53:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, dave.hansen@intel.com
Subject: Re: [PATCH v4 2/2] mm: allow to set overcommit ratio more precisely
Message-Id: <20131105155319.732dcbefb162c2ee4716ef9d@linux-foundation.org>
In-Reply-To: <1382101019-23563-2-git-send-email-jmarchan@redhat.com>
References: <1382101019-23563-1-git-send-email-jmarchan@redhat.com>
	<1382101019-23563-2-git-send-email-jmarchan@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013 14:56:59 +0200 Jerome Marchand <jmarchan@redhat.com> wrote:

> Some applications that run on HPC clusters are designed around the
> availability of RAM and the overcommit ratio is fine tuned to get the
> maximum usage of memory without swapping. With growing memory, the 1%
> of all RAM grain provided by overcommit_ratio has become too coarse
> for these workload (on a 2TB machine it represents no less than
> 20GB).
> 
> This patch adds the new overcommit_ratio_ppm sysctl variable that
> allow to set overcommit ratio with a part per million precision.
> The old overcommit_ratio variable can still be used to set and read
> the ratio with a 1% precision. That way, overcommit_ratio interface
> isn't broken in any way that I can imagine.

The way we've permanently squished this mistake in the past is to
switch to "bytes".  See /proc/sys/vm/*bytes.

Would that approach work in this case?
