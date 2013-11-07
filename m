Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3KGTjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:39:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab3KGTis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:38:48 -0500
Date: Thu, 7 Nov 2013 20:40:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] uprobes: Fix the memory out of bound overwrite in
	copy_insn()
Message-ID: <20131107194010.GA29154@redhat.com>
References: <20131106191913.GA18661@redhat.com> <20131107075151.GB31560@gmail.com> <20131107143432.GA6240@redhat.com> <20131107151601.GA5163@gmail.com> <20131107162736.GA31834@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107162736.GA31834@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07, Oleg Nesterov wrote:
>
> But when I looked at it now I realized that it is very wrong, and it
> is very easy to crash the kernel (fortunately only root can enable
> uprobes).
>
> So we need to fix it (and cleanup), I'll try to make the patch asap.

Just truncate the binary after uprobe was enabled, then mmap() the
truncated area. This crashes the kernel if nobody else mmaped this
area in between.

Oleg.

