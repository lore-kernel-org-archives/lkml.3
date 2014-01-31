Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaAaDHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 22:07:00 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:50221 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaAaDG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 22:06:59 -0500
MIME-Version: 1.0
Date: Thu, 30 Jan 2014 19:06:58 -0800
Message-ID: <CANN689FzOonHtEazR6KE+yZzohetwVQKaXHHnNYgC+615JszLw@mail.gmail.com>
Subject: Reverting warning for vmalloc and kmemcheck faults in NMI
From: Michel Lespinasse <walken@google.com>
To: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Salman Qazi <sqazi@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Way back in 2010, Frederic added commit
ebc8827f75954fe315492883eee5cb3f355d547d to warn us about cases where
faults were incorrectly firing during NMI handling on x86, as the IRET
from such faults would possibly trigger nested NMIs.

Later (2012), Salman added commit
28696f434fef0efa97534b59986ad33b9c4df7f8 to enable nested NMI
handling. See http://lwn.net/Articles/484932/

So, I believe such faults nesting under NMI are not an issue anymore,
and we could revert ebc8827f75954fe315492883eee5cb3f355d547d ?

Background: I'm asking this because at Google we like to dump memory
regions pointed by registers in our arch_trigger_all_cpu_backtrace
handler, and this occasionally causes the vmalloc_fault in_nmi()
warning to fire.

Patch is trivial, I can send it up for review if people don't object
to the idea.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
