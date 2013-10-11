Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3JKMYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:24:23 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:44273 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3JKMYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:24:22 -0400
Date: Fri, 11 Oct 2013 14:24:08 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] UPROBES: Remove useless __weak attribute
Message-ID: <20131011122407.GO1615@linux-mips.org>
References: <20131009120809.GN1615@linux-mips.org>
 <20131011005128.GA2199@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011005128.GA2199@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 06:21:28AM +0530, Srikar Dronamraju wrote:

> Will be nice to have another arch(mips) support for uprobes. 

It's basically ready to be merged - but it's triggering issues elsewhere
in the kernel which I have to resolve first.

The short version is that the memory special mapping created by uprobe
with VM_EXEC but not VM_READ permissions is not working but it's working
if I add VM_READ.  That should not be necessary so something deep down
in the guts of arch/mips is wrong.

  Ralf
