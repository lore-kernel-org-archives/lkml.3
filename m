Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaFEPCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:02:30 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51199 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaFEPC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:02:29 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH 9/9] KVM: x86: smsw emulation is incorrect in 64-bit mode
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <53908467.8030100@redhat.com>
Date: Thu, 5 Jun 2014 18:02:16 +0300
Cc: Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <CB894343-EC15-4A5D-B461-B012FC19FC3A@gmail.com>
References: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il> <1401723251-8034-10-git-send-email-namit@cs.technion.ac.il> <53908467.8030100@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 5, 2014, at 5:53 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 02/06/2014 17:34, Nadav Amit ha scritto:
>> In 64-bit mode, when the destination is a register, the assignment is done
>> according to the operand size. Otherwise (memory operand or no 64-bit mode), a
>> 16-bit assignment is performed.
> 
> I'm sorry, I'm missing the place where 64-bit mode is taken into account?
It is not, since on 32-bit mode the high-order 16 bits of a register destination are undefined. 
If I recall correctly, in this case the high-order 16-bits on native system actually reflect the high-order 16-bits of CR0.

Therefore, regardless to the mode of operation:
1. If the target is memory - the destination is 16-bit
2. If the target is a register - the register is written according to the operand size.

Nadav