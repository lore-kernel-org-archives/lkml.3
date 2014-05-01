Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaEANle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:41:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150AbaEANlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:41:32 -0400
Message-ID: <53624EF7.8090603@redhat.com>
Date: Thu, 01 May 2014 14:41:11 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, avagin@openvz.org,
        oleg@redhat.com, mikey@neuling.org, benh@kernel.crashing.org
Subject: Re: [PATCH 2/3] powerpc, ptrace: Add new ptrace request macros for
 transactional memory
References: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com> <1396422144-11032-3-git-send-email-khandual@linux.vnet.ibm.com> <535AF2E9.1000005@redhat.com> <535E2DC9.7080602@linux.vnet.ibm.com>
In-Reply-To: <535E2DC9.7080602@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 11:30 AM, Anshuman Khandual wrote:
> On 04/26/2014 05:12 AM, Pedro Alves wrote:
>> On 04/02/2014 08:02 AM, Anshuman Khandual wrote:
>>> This patch adds following new sets of ptrace request macros for transactional
>>> memory expanding the existing ptrace ABI on PowerPC.
>>>
>>> 	/* TM special purpose registers */
>>> 	PTRACE_GETTM_SPRREGS
>>> 	PTRACE_SETTM_SPRREGS
>>>
>>> 	/* TM checkpointed GPR registers */
>>> 	PTRACE_GETTM_CGPRREGS
>>> 	PTRACE_SETTM_CGPRREGS
>>>
>>> 	/* TM checkpointed FPR registers */
>>> 	PTRACE_GETTM_CFPRREGS
>>> 	PTRACE_SETTM_CFPRREGS
>>>
>>> 	/* TM checkpointed VMX registers */
>>> 	PTRACE_GETTM_CVMXREGS
>>> 	PTRACE_SETTM_CVMXREGS
>>
>> Urgh, we're _still_ adding specialized register specific calls?
>> Why aren't these exported as new register sets, accessible through
>> PTRACE_GETREGSET /  PTRACE_SETREGSET?  That's supposed to be the
>> Modern Way to do things.
> 
> All these new register sets can be accessed through PTRACE_GETREGSET
> /SETREGSET requests with the new NT_PPC_* core note types added in the
> previous patch. PowerPC already has some register specific ptrace
> requests, so thought of adding some new requests for transactional
> memory purpose. But yes these are redundant and can be dropped.

Thank you.  I assume you guys will be working on gdb support for this,
and I'm really hoping that transaction support in the kernel is being
made uniform across archs.  E.g., on s390, PTRACE_GETREGSET returns
ENODATA if the ptracee was interrupted outside transactions.

  https://sourceware.org/ml/gdb-patches/2013-06/msg00273.html

-- 
Pedro Alves

