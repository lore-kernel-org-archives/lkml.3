Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab3J3K3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:29:50 -0400
Received: from mx0.aculab.com ([213.249.233.131]:47662 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751353Ab3J3K3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:29:48 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Date: Wed, 30 Oct 2013 10:27:30 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B73C2@saturn3.aculab.com>
In-Reply-To: <201310300525.r9U5Pdqo014902@ib.usersys.redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Thread-Index: Ac7VMEhEoPA1tpjMQzSXmI3yif0kwAAJbglg
References: 20131029202644.GB32389@localhost.localdomain <201310300525.r9U5Pdqo014902@ib.usersys.redhat.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Doug Ledford" <dledford@redhat.com>,
        "Neil Horman" <nhorman@tuxdriver.com>
Cc: "Ingo Molnar" <mingo@kernel.org>, "Eric Dumazet" <eric.dumazet@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The parallel ALU design of this patch seems OK at first glance, but it means
> that two parallel operations are both trying to set/clear both the overflow
> and carry flags of the EFLAGS register of the *CPU* (not the ALU).  So, either
> some CPU in the past had a set of overflow/carry flags per ALU and did some
> sort of magic to make sure that the last state of those flags across multiple
> ALUs that might have been used in parallelizing work were always in the CPU's
> logical EFLAGS register, or the CPU has a buggy microcode that allowed two
> ALUs to operate on data at the same time in situations where they would
> potentially stomp on the carry/overflow flags of the other ALUs operations.

IIRC x86 cpu treat the (arithmetic) flags register as a single entity.
So an instruction that only changes some of the flags is dependant
on any previous instruction that changes any flags.
OTOH it the instruction writes all of the flags then it doesn't
have to wait for the earlier instruction to complete.

This is problematic for the ADC chain in the IP checksum.
I did once try to use the SSE instructions to sum 16bit
fields into multiple 32bit registers.

	David



