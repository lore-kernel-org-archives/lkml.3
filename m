Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbaGIXSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:18:20 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42158 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaGIXST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:18:19 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 9 Jul 2014 16:17:57 -0700
Message-ID: <CALCETrXrVNKNQtxncfOth5OqaSOC7KygerbB-+QQb4_VKESVsA@mail.gmail.com>
Subject: Is espfix64's double-fault thing OK on Xen?
To: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This part in __do_double_fault looks fishy:

    cmpl $__KERNEL_CS,CS(%rdi)
    jne do_double_fault

Shouldn't that be:

    test $3,CS(%rdi)
    jnz do_double_fault

--Andy
