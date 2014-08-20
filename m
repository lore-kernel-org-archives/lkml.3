Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaHTNP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:15:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbaHTNP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:15:56 -0400
Message-ID: <53F49F80.1090408@redhat.com>
Date: Wed, 20 Aug 2014 15:15:44 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: Re: [PATCH 9/9] KVM: VMX: automatic PLE window maximum
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com> <1408480536-8240-10-git-send-email-rkrcmar@redhat.com> <53F44B40.6060806@redhat.com> <20140820124112.GC28873@potion.brq.redhat.com>
In-Reply-To: <20140820124112.GC28873@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/08/2014 14:41, Radim Krčmář ha scritto:
>> > 	if (ple_window_grow < 1 || ple_window_actual_max < ple_window)
>> > 		new = ple_window;
>> > 	else if (ple_window_grow < ple_window)
>> > 		new = max(ple_window_actual_max, old) * ple_window_grow;
>> > 	else
>> > 		new = max(ple_window_actual_max, old) + ple_window_grow;
> Oh, I like that this can get rid of all overflows, ple_window_actual_max
> (PW_effective_max?) is going to be set to
> "ple_window_max [/-] ple_window_grow" in v2.
> 
>> > (I think the || in the first "if" can be eliminated with some creativity
>> > in clamp_ple_window_max).
> To do it, we'll want to intercept changes to ple_window as well.
> (I disliked this patch a lot even before :)

What about setting ple_window_actual_max to 0 if ple_window_grow is 0
(instead of just returning)?

Then the "if (ple_window_actual_max < ple_window)" will always fail and
you'll go through "new = ple_window".  But perhaps it's more gross and
worthless than creative. :)

Paolo
