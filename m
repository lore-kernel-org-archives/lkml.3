Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaCGArm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:47:42 -0500
Received: from ozlabs.org ([203.10.76.45]:51465 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaCGArk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:47:40 -0500
Message-ID: <1394153258.21206.1.camel@concordia>
Subject: Re: [PATCH] kexec/powerpc: fix exporting memory limit
From: Michael Ellerman <mpe@ellerman.id.au>
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Cc: kexec@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Hari Bathini <hbathini@linux.vnet.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, yadviga@dev.rtsoft.ru,
        lugovskoy@dev.rtsoft.ru, linux-kernel@vger.kernel.org
Date: Fri, 07 Mar 2014 11:47:38 +1100
In-Reply-To: <1394115854-11709-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1394115854-11709-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 18:24 +0400, Nikita Yushchenko wrote:
> When preparing dump-capturing kernel, kexec userspace tool needs to know
> actual amount of memory used by the running kernel. This may differ from
> extire available DRAM for a couple of reasons. To address this issue,
> kdump kernel support code injects several attributes into device tree that
> are later captured by userspace kexec tool via /proc interface.
> 
> One such attrubute is 'chosen/linux,memory_limit' that is used to pass
> memory limit of the running kernel.
> 
> This was initialized using kernel's 'memory_limit' variable, that is set
> by early init code based on mem= kernel parameter and other reasons.
> 
> But there are cases when memory_limit variable does not contain proper
> information. One such case is when !CONFIG_HIGHMEM kernel runs on system
> with memory large enough not to fit into lowmem.

Why doesn't the !CONFIG_HIGHMEM code update memory_limit to reflect reality.

cheers


