Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbaDVOrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:47:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946AbaDVOrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:47:39 -0400
Date: Tue, 22 Apr 2014 16:47:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] uprobes/x86: completely untangle branch_xol_ops and
	default_xol_ops
Message-ID: <20140422144719.GA7456@redhat.com>
References: <20140417200228.GA31097@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417200228.GA31097@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17, Oleg Nesterov wrote:
>
> This series only fixes the problem. I'll send more changes to address
> some of TODO's mentioned in the changelogs later.

Another series which connects to the already merged changes.

All changes were planned, except 1/5 fixes the oversight in 8ad8e9d3fd64
"uprobes/x86: Introduce uprobe_xol_ops and arch_uprobe->ops". Fortunately
the wrong logic is harmless currently, but it should be fixed anyway.

Oleg.

 arch/x86/include/asm/uprobes.h |   12 +++--
 arch/x86/kernel/uprobes.c      |   94 +++++++++++++++++++++++----------------
 2 files changed, 62 insertions(+), 44 deletions(-)

