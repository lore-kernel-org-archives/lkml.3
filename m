Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaIDTON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:14:13 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58438 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaIDTOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:14:11 -0400
Message-ID: <5408B9FB.5000701@redhat.com>
Date: Thu, 04 Sep 2014 21:14:03 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>,
        Chris J Arges <chris.j.arges@canonical.com>
CC: lkml <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com>	<54088CB5.6050406@canonical.com> <CALAqxLV0-9q_HNMSWrmqX0esUBecUBGDc3EOe_7gtbb4ZCnLJQ@mail.gmail.com>
In-Reply-To: <CALAqxLV0-9q_HNMSWrmqX0esUBecUBGDc3EOe_7gtbb4ZCnLJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/09/2014 21:00, John Stultz ha scritto:
> 
> Hey, thanks for reporting the issue and sending an initial patch (even
> if its not quite all sorted yet).
> 
> Is the test you're using here available somewhere? Are there any
> special requirements to run it?

You need KVM on a machine with clocksource=tsc.  Grab the tests from
git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git

and run them with

    ./configure
    make
    ./x86-run x86/kvmclock_test.flat  --append "10000000 `date +%s`"

Thanks,

Paolo
