Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaIEUiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:38:05 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52026 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaIEUiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:38:02 -0400
Message-ID: <540A1F22.7020107@redhat.com>
Date: Fri, 05 Sep 2014 22:37:54 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, chris.j.arges@canonical.com,
        kvm@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com> <alpine.DEB.2.10.1409042230020.3333@nanos> <5408D815.9090105@redhat.com> <alpine.DEB.2.10.1409050000570.3333@nanos> <5409E755.4040905@redhat.com> <alpine.DEB.2.10.1409052031140.5472@nanos>
In-Reply-To: <alpine.DEB.2.10.1409052031140.5472@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/09/2014 20:33, Thomas Gleixner ha scritto:
>> >  	update_vsyscall(tk);
>> > -	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
>> > 
>> >  	tk_update_ktime_data(tk);
>> > +	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
> Why are you moving the update between vsycall and pvclock update as I
> did in my patch? We really need to update everything before calling
> somewhere.

Do you mean the call should be moved not just after tk_update_ktime_data
(which sets base_mono), but further down after

        update_fast_timekeeper(tk);

?

Paolo
