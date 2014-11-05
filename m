Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaKERJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:09:40 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:44857 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbaKERJi convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 5 Nov 2014 12:09:38 -0500
Message-Id: <545A59D002000078000C1057@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Wed, 05 Nov 2014 17:09:36 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <luto@amacapital.net>, <mingo@elte.hu>, <tglx@linutronix.de>,
        <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86-64: allow using RIP-relative addressing
 for per-CPU data
References: <5458A12C0200007800044A97@mail.emea.novell.com>
 <545929F9.7010301@amacapital.net>
In-Reply-To: <545929F9.7010301@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andy Lutomirski <luto@amacapital.net> 11/04/14 8:33 PM >>>
>On 11/04/2014 12:49 AM, Jan Beulich wrote:
>> Observing that per-CPU data (in the SMP case) is reachable by
>> exploiting 64-bit address wraparound, these two patches
>> arrange for using the one byte shorter RIP-relative addressing
>> forms for the majority of per-CPU accesses.
>> 
>> 1: handle PC-relative relocations on per-CPU data
>> 2: use RIP-relative addressing for most per-CPU accesses
>> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> 
>
>I'm lost here.  Can you give an example of a physical and virtual
>address of an instruction, the address within the gs segment, and why
>the relocations are backwards?

When an instruction using RIP relative addressing gets moved up in
address space, the distance to the target address decreases. I.e. it's the
opposite of a normal, non-PC-relative base relocation (where the target
address increases together with the instruction getting moved up).

Jan

