Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaCIIbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:31:16 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:52018 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaCIIbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:31:07 -0400
Message-ID: <531C26C4.2090205@redhat.com>
Date: Sun, 09 Mar 2014 09:31:00 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, alex.williamson@redhat.com, mtosatti@redhat.com,
        gleb@kernel.org
Subject: Re: [PATCH 0/7] KVM: x86: Let the guest write to multiple debug registers
 with one vmexit
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com> <531C2238.1060202@web.de> <531C232D.40200@web.de>
In-Reply-To: <531C232D.40200@web.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/03/2014 09:15, Jan Kiszka ha scritto:
>> > This looks good now to me from KVM perspective. I was just wondering how
>> > the case is handled that the host used debug registers on the thread the
>> > runs a VCPU? What if I set a hw breakpoint on its userspace path e.g.?
>> > What if I debug the kernel side with kgdb?
> Ah, this part didn't change, we still switch between host and guest
> state on vmentries/exits. All fine!

Yes, that's why sync_dirty_debug_regs is added so early.  Thanks for the 
review.

Paolo
