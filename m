Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab3CBDfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:35:42 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:61862 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3CBDfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:35:41 -0500
MIME-Version: 1.0
Date: Sat, 2 Mar 2013 11:35:41 +0800
Message-ID: <CAJd=RBD53ZkXb9bBV9gcBVF2+3dOVVFu41FCE9Ey++nSmpL9yQ@mail.gmail.com>
Subject: Re: [PATCH -V1 15/24] mm/THP: HPAGE_SHIFT is not a #define on some arch
From: Hillf Danton <dhillf@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Aneesh

[with lkml cced]

>-#if HPAGE_PMD_ORDER > MAX_ORDER
>-#error "hugepages can't be allocated by the buddy allocator"
>-#endif
...
>-	if (!has_transparent_hugepage()) {
>+	if (!has_transparent_hugepage() || (HPAGE_PMD_ORDER > MAX_ORDER)) {
> 		transparent_hugepage_flags = 0;
> 		return -EINVAL;
> 	}

Fair for other archs that support THP, if you are changing
build error to runtime error?
