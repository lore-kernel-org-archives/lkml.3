Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaFRQou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:44:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbaFRQot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:44:49 -0400
Message-ID: <53A1C1F2.4010909@redhat.com>
Date: Wed, 18 Jun 2014 18:44:34 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joro@8bytes.org
Subject: Re: [PATCH 3/3] KVM: x86: correct mwait and monitor emulation
References: <1403101176-23664-1-git-send-email-namit@cs.technion.ac.il>	<1403101176-23664-4-git-send-email-namit@cs.technion.ac.il> <jpg7g4ew4m6.fsf@redhat.com>
In-Reply-To: <jpg7g4ew4m6.fsf@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/06/2014 18:43, Bandan Das ha scritto:
>> > mwait and monitor are currently handled as nop. Considering this behavior, they
>> > should still be handled correctly, i.e., check execution conditions and generate
>> > exceptions when required. mwait and monitor may also be executed in real-mode
> Is this necessary ? They are NOPs and kvm prints that out (correctly so) to dmesg.
> Implementing them correctly is a different thing, but adding extra checks for NOPs
> just seems like adding extra cycles.

Raising the correct exception is a good thing, though.  The guest is 
going to busy wait anyway, it doesn't matter how fast it does that. :)

Paolo
