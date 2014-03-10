Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaCJMYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:24:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbaCJMYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:24:22 -0400
Message-ID: <531DAEEA.8000909@redhat.com>
Date: Mon, 10 Mar 2014 13:24:10 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, mtosatti@redhat.com, gleb@kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 4/7] KVM: vmx: Allow the guest to run with dirty debug
 registers
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com> <1394192571-11056-5-git-send-email-pbonzini@redhat.com> <20140309182639.GA10479@potion.redhat.com> <531CCB15.6070402@redhat.com> <20140310121704.GB16023@potion.brq.redhat.com>
In-Reply-To: <20140310121704.GB16023@potion.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/03/2014 13:17, Radim Krčmář ha scritto:
>> > I considered this, but decided that it's unlikely for emulation to
>> > be faster than hardware---especially on those AMD CPUs that lack
>> > decode assists (and it's good for VMX and SVM code to look as
>> > similar as possible).
> I meant to move it before the block that exits if there is the
> 'exception on access' bit set in cr7, so we wouldn't exit again right
> away on the actual access, which is quite likely.
> (Exiting without emulation was a great move.)
>

Ah yes, for the GD bit.  I don't know, it's quite unlikely that anyone 
will use it...  It's a feeble attempt at allowing virtualization of the 
debug registers without VMX.

Paolo
