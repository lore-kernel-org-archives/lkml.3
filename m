Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbaCDLew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:34:52 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:50683 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbaCDLeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:34:50 -0500
Message-ID: <5315BA55.4070202@redhat.com>
Date: Tue, 04 Mar 2014 12:34:45 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, Andrew Jones <drjones@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 v2] x86: kvm: global clock updates
References: <1393588375-13664-1-git-send-email-drjones@redhat.com> <20140228145234.GA13771@amt.cnet>
In-Reply-To: <20140228145234.GA13771@amt.cnet>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/02/2014 15:52, Marcelo Tosatti ha scritto:
> On Fri, Feb 28, 2014 at 12:52:53PM +0100, Andrew Jones wrote:
>> This patch series addresses two issues with global clock updates.
>> The first fixes a bug found on hosts that have a tsc marked as
>> unstable. As global clock updates get triggered on every vcpu load
>> in these cases, guests with a large number of vcpus have their
>> progress nearly halted. The fix for that bug should also go to
>> stable. The second patch in this series ensures that NTP corrections
>> on the host, as well as on guests with all vcpus pinned, will be
>> propagated periodically. That patch improves things, but doesn't
>> fix a bug, thus it can be merged at a later time than the first.
>> I've posted them together as a series, as the second one builds
>> on the first.
>>
>> Andrew Jones (2):
>>   x86: kvm: rate-limit global clock updates
>>   x86: kvm: introduce periodic global clock updates
>>
>>  arch/x86/include/asm/kvm_host.h |  2 +
>>  arch/x86/kvm/x86.c              | 92 +++++++++++++++++++++++++++++++++++++++--
>>  2 files changed, 90 insertions(+), 4 deletions(-)
>>
>> --
>> 1.8.1.4
>
> Looks good.
>

Applied to kvm/queue, thanks to both.

Paolo
