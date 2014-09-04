Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaIDTQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:16:07 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:64673 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbaIDTQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:16:04 -0400
Message-ID: <5408BA6D.1070602@redhat.com>
Date: Thu, 04 Sep 2014 21:15:57 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chris J Arges <chris.j.arges@canonical.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com> <54088CB5.6050406@canonical.com> <54089DDE.6010004@redhat.com> <5408AC76.6030404@canonical.com>
In-Reply-To: <5408AC76.6030404@canonical.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/09/2014 20:16, Chris J Arges ha scritto:
>> +	boot_ns = timespec_to_ns(&tk->total_sleep_time)
>> +		+ tk->wall_to_monotonic.tv_sec * (u64)NSEC_PER_SEC
>> +		+ tk->wall_to_monotonic.tv_nsec
>> +		+ tk->xtime_sec * (u64)NSEC_PER_SEC;

So this means that the above 3.16-based code is not the same as

        boot_ns = ktime_to_ns(ktime_add(tk->tkr.base_mono, tk->offs_boot));

in 3.17.  Everything else in the patch you tested is the same as the
code that is in 3.17, so that's a start.

Paolo
