Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaHUUcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:32:00 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53189 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaHUUb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:31:58 -0400
Message-ID: <53F65738.10000@redhat.com>
Date: Thu, 21 Aug 2014 22:31:52 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        =?UTF-8?B?UmFkaW0=?= =?UTF-8?B?IEtyxI1tw6HFmQ==?= 
	<rkrcmar@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>, Vinod Chegu <chegu_vinod@hp.com>,
        Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 4/7] KVM: VMX: dynamise PLE window
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com> <1408637291-18533-5-git-send-email-rkrcmar@redhat.com> <53F6440B.8010709@linux.vnet.ibm.com>
In-Reply-To: <53F6440B.8010709@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/08/2014 21:10, Raghavendra K T ha scritto:
> 2. can we consider min_ple_window value of 2k. tracing showed that in
> overcommit there were several occations of 4k <- 4k situations.

Yes, that could be good now that we have adaptive exits.  Perhaps even 1k.

> 3. Do you think using ( << and >> ) instead of (*, /) saves some cycles
> considering we could have potentially have grow,shrink numbers != power
> of 2

* is very fast. / a bit less so but it never occurs with the defaults.
So I think it's okay.  I'm not sure why one would use a multiplier
bigger than 2.

Paolo
