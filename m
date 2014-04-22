Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaDVXfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:35:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55990 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbaDVXfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:35:50 -0400
Message-ID: <5356FCC1.6060807@zytor.com>
Date: Tue, 22 Apr 2014 16:35:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Why do we set _PAGE_DIRTY for page tables?
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed this:

#define _PAGE_TABLE     (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |       \
                         _PAGE_ACCESSED | _PAGE_DIRTY)
#define _KERNPG_TABLE   (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |   \
                         _PAGE_DIRTY)

Is there a reason we set _PAGE_DIRTY for page tables?  It has no
function, but doesn't do any harm either (the dirty bit is ignored for
page tables)... it just looks funny to me.

	-hpa
