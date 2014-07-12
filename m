Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaGLMJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 08:09:27 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:54780 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaGLMJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:09:22 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Add include guard to include/linux/pci_ids.h
Organization: D03
References: <1404993911-10544-1-git-send-email-linux@rasmusvillemoes.dk>
	<20140710220233.GA21053@google.com>
X-Hashcash: 1:20:140712:linux-kernel@vger.kernel.org::prq9eJHPnqSprMbX:00000000000000000000000000000000009OM
X-Hashcash: 1:20:140712:bhelgaas@google.com::qXcj5ajAUB9caXhX:0000000000000000000000000000000000000000001IDy
X-Hashcash: 1:20:140712:linux-pci@vger.kernel.org::AzX98HjZwFToWnGw:0000000000000000000000000000000000001lRW
Date: Sat, 12 Jul 2014 14:09:18 +0200
In-Reply-To: <20140710220233.GA21053@google.com> (Bjorn Helgaas's message of
	"Thu, 10 Jul 2014 16:02:33 -0600")
Message-ID: <87tx6mzslt.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bhelgaas@google.com> writes:

> On Thu, Jul 10, 2014 at 02:05:11PM +0200, Rasmus Villemoes wrote:
>> Adding an include guard frees the preprocessor from reparsing over
>> 2600 #defines in the cases where pci_ids.h is somehow included more
>> than once. This gives a tiny-but-measurable performance improvement
>> when compiling such files.
>> 
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>
> Applied to pci/misc for v3.17, thanks!
>

Great.

One thing I thought about, but which is likely undoable in practice:
There are only about 800 files which use any of the #defines in
pci_ids.h, but more than 3000 files include pci.h directly or
indirectly. Making those 800 include pci_ids.h directly and removing it
from pci.h could speed up compilation of the other 2200.

Rasmus
