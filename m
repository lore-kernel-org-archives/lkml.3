Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaGLRb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 13:31:59 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:59371 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaGLRb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 13:31:57 -0400
MIME-Version: 1.0
In-Reply-To: <87tx6mzslt.fsf@rasmusvillemoes.dk>
References: <1404993911-10544-1-git-send-email-linux@rasmusvillemoes.dk>
 <20140710220233.GA21053@google.com> <87tx6mzslt.fsf@rasmusvillemoes.dk>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 12 Jul 2014 11:31:36 -0600
Message-ID: <CAErSpo6KyT=cnESwHL9cGaeGyC-XpHk7wi55Tp_Dw92WquEotg@mail.gmail.com>
Subject: Re: [PATCH] pci: Add include guard to include/linux/pci_ids.h
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 6:09 AM, Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> Bjorn Helgaas <bhelgaas@google.com> writes:
>
>> On Thu, Jul 10, 2014 at 02:05:11PM +0200, Rasmus Villemoes wrote:
>>> Adding an include guard frees the preprocessor from reparsing over
>>> 2600 #defines in the cases where pci_ids.h is somehow included more
>>> than once. This gives a tiny-but-measurable performance improvement
>>> when compiling such files.
>>>
>>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>>
>> Applied to pci/misc for v3.17, thanks!
>>
>
> Great.
>
> One thing I thought about, but which is likely undoable in practice:
> There are only about 800 files which use any of the #defines in
> pci_ids.h, but more than 3000 files include pci.h directly or
> indirectly. Making those 800 include pci_ids.h directly and removing it
> from pci.h could speed up compilation of the other 2200.

Yeah, changing 800 files for a minor build performance improvement
doesn't sound like it'd be worth the churn.

Bjorn
