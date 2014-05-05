Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbaEEWjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:39:12 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:54743 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbaEEWjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:39:10 -0400
MIME-Version: 1.0
Date: Mon, 5 May 2014 18:39:08 -0400
Message-ID: <CAHqbYQtPj9C_Vm0tuYnUvkbHToih2+rAHhpykpWdA2h82-5LrQ@mail.gmail.com>
Subject: Nested EPT page fault
From: Hu Yaohui <loki2441@gmail.com>
To: kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have one question related to nested EPT page fault.
At the very start, L0 hypervisor launches L2 with an empty EPT0->2
table, building the table on-the-fly.
when one L2 physical page is accessed, ept_page_fault(paging_tmpl.h)
will be called to handle this fault in L0. which will first call
ept_walk_addr to get guest ept entry from EPT1->2. If there is no such
entry, a guest page fault will be injected into L1 to handle this
fault.
When the next time, the same L2 physical page is accessed,
ept_page_fault will be triggered again in L0, which will also call
ept_walk_addr and get the previously filled ept entry in EPT1->2, then
try_async_pf will be called to translate the L1 physical page to L0
physical page. At the very last, an entry will be created in the
EPT0->2 to solve the page fault.
Please correct me if I am wrong.

My question is when the EPT0->1 will be accessed during the EPT0->2
entry created, since according to the turtle's paper, both EPT0->1 and
EPT->12 will be accessed to populate an entry in EPT0->2.

Thanks for your time!

Best Wishes,
Yaohui
