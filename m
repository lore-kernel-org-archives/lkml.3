Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934328Ab3JPMnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:43:21 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35777 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab3JPMnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:43:20 -0400
Date: Wed, 16 Oct 2013 18:13:12 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <aarapov@redhat.com>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] uprobes: Teach __create_xol_area() to accept the
 predefined vaddr
Message-ID: <20131016124312.GF19729@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131013191815.GA32466@redhat.com>
 <20131013191838.GA32490@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131013191838.GA32490@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101612-3532-0000-0000-000002354124
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-10-13 21:18:38]:

> Currently xol_add_vma() uses get_unmapped_area() for area->vaddr,
> but the next patches need to use the fixed address. So this patch
> adds the new "vaddr" argument to __create_xol_area() which should
> be used as area->vaddr if it is nonzero.
> 
> xol_add_vma() doesn't bother to verify that the predefined addr is
> not used, insert_vm_struct() should fail if find_vma_links() detects
> the overlap with the existing vma.
> 
> Also, __create_xol_area() doesn't need __GFP_ZERO to allocate area.
> 
> Cc: stable@vger.kernel.org # 3.9+
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

