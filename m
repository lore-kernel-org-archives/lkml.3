Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaJPSF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 14:05:26 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:53110 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaJPSFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 14:05:24 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Steve Capper <steve.capper@linaro.org>
Cc: akpm@linux-foundation.org, Andrea Arcangeli <aarcange@redhat.com>,
        benh@kernel.crashing.org, mpe@ellerman.id.au, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arch@vger.kernel.org, will.deacon@arm.com,
        catalin.marinas@arm.com, linux@arm.linux.org.uk
Subject: Re: [PATCH 1/2] mm: Update generic gup implementation to handle hugepage directory
In-Reply-To: <20141016154228.GA12995@linaro.org>
References: <1413390888-4934-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20141016092529.GA1524@linaro.org> <871tq8kpqb.fsf@linux.vnet.ibm.com> <20141016154228.GA12995@linaro.org>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Thu, 16 Oct 2014 23:35:10 +0530
Message-ID: <87ppdrki09.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101618-0013-0000-0000-0000005C19C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Capper <steve.capper@linaro.org> writes:

> Can we not just add a:
> #define pgd_huge(pgd)		(0)
> above the "#endif /* CONFIG_HUGETLB_PAGE */" line in the second patch?
> (or, more precisely, prevent the second patch from removing this line).
>
> That way we get a clearer code overall?

it is strange to have both pmd_huge and pud_huge in hugetlb.h and
pgd_huge in page.h. But if that is what we want then we may need.


diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index aa430ec14895..aeca81947dc6 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -383,6 +383,7 @@ static inline int hugepd_ok(hugepd_t hpd)
 int pgd_huge(pgd_t pgd);
 #else /* CONFIG_HUGETLB_PAGE */
 #define is_hugepd(pdep)			0
+#define pgd_huge(pgd)			0
 #endif /* CONFIG_HUGETLB_PAGE */
 #define __hugepd(x) ((hugepd_t) { (x) })
 

