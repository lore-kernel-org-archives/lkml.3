Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbaIBRB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:01:28 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:47381 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbaIBRB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:01:26 -0400
Message-ID: <5405F7E1.1090505@redhat.com>
Date: Tue, 02 Sep 2014 19:01:21 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Joerg Roedel <jroedel@suse.de>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, agraf@suse.de,
        valentine.sinitsyn@gmail.com, jan.kiszka@siemens.com,
        gleb@cloudius-systems.com, avi@cloudius-systems.com
Subject: Re: [PATCH 2/4] KVM: nSVM: propagate the NPF EXITINFO to the guest
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com> <1409670830-14544-3-git-send-email-pbonzini@redhat.com> <20140902163344.GB16722@suse.de> <5405F44E.7090803@redhat.com>
In-Reply-To: <5405F44E.7090803@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/09/2014 18:46, Paolo Bonzini ha scritto:
>> > How about an io-port emulated on
>> > L1 but passed through to L2 by the nested hypervisor. On emulation of
>> > INS or OUTS, KVM would need to read/write to an L2 address space,
> It would need to read/write to *L1* (that's where the VMCB's IOIO map
> lies), which could result into a regular page fault injected into L1.

Nevermind, the VMCB's IO bitmap is a guest physical address.  I see what
you mean now.  nested_svm_intercept_ioio would return NESTED_EXIT_HOST
and proceed to emulate the read/write.  This could indeed cause a NPF.
For now I'll remove the WARN_ON.

Paolo
