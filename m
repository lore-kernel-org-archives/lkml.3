Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaEMRN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:13:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbaEMRNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:13:48 -0400
Message-ID: <537252C0.6090005@redhat.com>
Date: Tue, 13 May 2014 18:13:36 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
CC: michael@ellerman.id.au, mikey@neuling.org, avagin@openvz.org,
        oleg@redhat.com
Subject: Re: [PATCH V2 2/3] powerpc, ptrace: Enable support for transactional
 memory register sets
References: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com> <1399276469-13541-3-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1399276469-13541-3-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/14 08:54, Anshuman Khandual wrote:
> This patch enables get and set of transactional memory related register
> sets through PTRACE_GETREGSET/PTRACE_SETREGSET interface by implementing
> four new powerpc specific register sets i.e REGSET_TM_SPR, REGSET_TM_CGPR,
> REGSET_TM_CFPR, REGSET_CVMX support corresponding to these following new
> ELF core note types added previously in this regard.
> 
> 	(1) NT_PPC_TM_SPR
> 	(2) NT_PPC_TM_CGPR
> 	(3) NT_PPC_TM_CFPR
> 	(4) NT_PPC_TM_CVMX

Sorry that I couldn't tell this from the code, but, what does the
kernel return when the ptracer requests these registers and the
program is not in a transaction?  Specifically I'm wondering whether
this follows the same semantics as the s390 port.

-- 
Pedro Alves

