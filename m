Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaHUHe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:34:57 -0400
Received: from ozlabs.org ([103.22.144.67]:44541 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbaHUHe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:34:56 -0400
Message-ID: <1408606493.9307.7.camel@concordia>
Subject: Re: [PATCH 1/1] powerpc/jump_label: use HAVE_JUMP_LABEL?
From: Michael Ellerman <mpe@ellerman.id.au>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: benh@kernel.crashing.org, paulus@samba.org, paulmck@linux.vnet.ibm.com,
        anton@samba.org, aneesh.kumar@linux.vnet.ibm.com, jk@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        jbaron@akamai.com, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Date: Thu, 21 Aug 2014 17:34:53 +1000
In-Reply-To: <1408588883-26783-1-git-send-email-yizhouzhou@ict.ac.cn>
References: <1408588883-26783-1-git-send-email-yizhouzhou@ict.ac.cn>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 10:41 +0800, Zhouyi Zhou wrote:
> CONFIG_JUMP_LABEL doesn't ensure HAVE_JUMP_LABEL, if it
> is not the case use maintainers's own mutex to guard
> the modification of global values.
 
OK, so CONFIG_JUMP_LABEL says the user wants to use jump labels. But we also
need the toolchain to support it.

That is reflected in CC_HAVE_ASM_GOTO=y, and if both are set then
HAVE_JUMP_LABEL is set to true.

So this looks right to me.

cheers


