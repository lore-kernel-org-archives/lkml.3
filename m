Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaDYXnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 19:43:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbaDYXm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 19:42:58 -0400
Message-ID: <535AF2E9.1000005@redhat.com>
Date: Sat, 26 Apr 2014 00:42:33 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, avagin@openvz.org,
        oleg@redhat.com, mikey@neuling.org, benh@kernel.crashing.org
Subject: Re: [PATCH 2/3] powerpc, ptrace: Add new ptrace request macros for
 transactional memory
References: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com> <1396422144-11032-3-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1396422144-11032-3-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 08:02 AM, Anshuman Khandual wrote:
> This patch adds following new sets of ptrace request macros for transactional
> memory expanding the existing ptrace ABI on PowerPC.
> 
> 	/* TM special purpose registers */
> 	PTRACE_GETTM_SPRREGS
> 	PTRACE_SETTM_SPRREGS
> 
> 	/* TM checkpointed GPR registers */
> 	PTRACE_GETTM_CGPRREGS
> 	PTRACE_SETTM_CGPRREGS
> 
> 	/* TM checkpointed FPR registers */
> 	PTRACE_GETTM_CFPRREGS
> 	PTRACE_SETTM_CFPRREGS
> 
> 	/* TM checkpointed VMX registers */
> 	PTRACE_GETTM_CVMXREGS
> 	PTRACE_SETTM_CVMXREGS

Urgh, we're _still_ adding specialized register specific calls?
Why aren't these exported as new register sets, accessible through
PTRACE_GETREGSET /  PTRACE_SETREGSET?  That's supposed to be the
Modern Way to do things.

-- 
Pedro Alves

