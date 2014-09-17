Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbaIQIMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:12:45 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:41417 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaIQIMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:12:41 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Darren Hart <dvhart@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 17/22] thinkpad_acpi: Replace strnicmp with strncasecmp
Organization: D03
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
	<1410900696-6481-18-git-send-email-linux@rasmusvillemoes.dk>
	<20140916220857.GA12780@vmdeb7>
X-Hashcash: 1:20:140917:ibm-acpi-devel@lists.sourceforge.net::vB0s4qqwRX4bQq2G:00000000000000000000000001Ngg
X-Hashcash: 1:20:140917:linux-kernel@vger.kernel.org::Ub+YOkOeQS6aI4Vj:0000000000000000000000000000000001fpZ
X-Hashcash: 1:20:140917:dvhart@infradead.org::3Fjyz+en619H41JL:000000000000000000000000000000000000000001fC3
X-Hashcash: 1:20:140917:platform-driver-x86@vger.kernel.org::p/m3L1HngBPV6Okr:000000000000000000000000001h4D
X-Hashcash: 1:20:140917:ibm-acpi@hmh.eng.br::dW3fOFn8wjgywmxX:000000000000000000000000000000000000000000217G
X-Hashcash: 1:20:140917:akpm@linux-foundation.org::60mOlLCYNG9ysIA2:000000000000000000000000000000000000CQRS
Date: Wed, 17 Sep 2014 10:12:38 +0200
In-Reply-To: <20140916220857.GA12780@vmdeb7> (Darren Hart's message of "Tue,
	16 Sep 2014 15:08:57 -0700")
Message-ID: <87d2auis21.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17 2014, Darren Hart <dvhart@infradead.org> wrote:

> On Tue, Sep 16, 2014 at 10:51:31PM +0200, Rasmus Villemoes wrote:
>> The kernel used to contain two functions for length-delimited,
>> case-insensitive string comparison, strnicmp with correct semantics
>> and a slightly buggy strncasecmp. The latter is the POSIX name, so
>> strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
>> for the new strncasecmp to avoid breaking existing users.
>
> When was this done? As of this morning I still see them as independent functions
> in lib/string.c.

It will be in 3.18. I thought it had made it to linux-next, but should
have double-checked (and included the 3.18 info in the email); sorry.

http://thread.gmane.org/gmane.linux.kernel/1775150/focus=1775152

Rasmus
