Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407AbaGRM4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:56:49 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:35047 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbaGRM4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:56:47 -0400
Message-ID: <53C9198B.1020808@imgtec.com>
Date: Fri, 18 Jul 2014 13:56:43 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <lftan.linux@gmail.com>, <cltang@codesourcery.com>, Arnd <arnd@arndb.de>
Subject: Re: [PATCH v2 15/29] nios2: System calls handling
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <1405413956-2772-16-git-send-email-lftan@altera.com>
In-Reply-To: <1405413956-2772-16-git-send-email-lftan@altera.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 15/07/14 09:45, Ley Foon Tan wrote:
> This patch adds support for system calls from userspaces. It uses the
> asm-generic/unistd.h definitions with architecture spcific syscall. The sys_call_table
> is just an array defined in a C file and it contains pointers to the syscall functions.

I don't think you need the renameat syscall now that renameat2 exists.

Can I suggest preceding your patchset with this patch:
https://lkml.org/lkml/2014/4/23/197
([RFC 3/3] asm-generic: Drop renameat syscall from default list)

which drops renameat from the generic list unless __ARCH_WANT_RENAMEAT
is defined in the arch's uapi/asm/unistd.h.

Cheers
James
