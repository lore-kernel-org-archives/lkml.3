Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaBER15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:27:57 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:57190 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbaBER1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:27:55 -0500
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6B9214@AcuExch.aculab.com>
References: <1391091027-31783-1-git-send-email-mathias.nyman@linux.intel.com>
	<063D6719AE5E284EB5DD2968C1650D6D0F6B532A@AcuExch.aculab.com>
	<CAPcyv4gWnaK+s5zSu58Kue2ZiTTr4YC6pJG0n_Tu2Cm4RXOR=A@mail.gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D0F6B8B7E@AcuExch.aculab.com>
	<CAPcyv4gerLT1uuUre9L4minu6u4HYRFSYD2s-bo_7H9UH64QYQ@mail.gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D0F6B9214@AcuExch.aculab.com>
Date: Wed, 5 Feb 2014 09:27:55 -0800
Message-ID: <CAPcyv4ipHdM7HnB=P+eWrPc9kBRzPoxOw+Of6eS+QkcYzk2vfA@mail.gmail.com>
Subject: Re: [RFCv2 00/10] xhci: re-work command queue management
From: Dan Williams <dan.j.williams@intel.com>
To: David Laight <David.Laight@aculab.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 9:05 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Dan Williams
>> Yes, but I think we need to centralize the context under which
>> commands are submitted.  The complicating factor is the mix of
>> synchronous command submission and interrupt driven asynchronous
>> command queuing.  I think we can simplify it by making it all
>> submitted from a single event queue context.  I'm investigating if
>> that is a workable solution...
>
> Given that the entire network stack runs from (I believe) 'process level'
> contexts (NAPI functions),

Not really.  Much of the network stack runs under softirq context.
