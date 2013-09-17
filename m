Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3IQXT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:19:26 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:61458 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3IQXTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:19:24 -0400
Message-ID: <5238E385.1050705@redhat.com>
Date: Wed, 18 Sep 2013 01:19:33 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>, stable@vger.kernel.org,
        kvm@vger.kernel.org, gleb@redhat.com
Subject: Re: [PATCH 1/3] KVM: cleanup (physical) CPU hotplug
References: <1379340373-5135-1-git-send-email-pbonzini@redhat.com> <1379340373-5135-2-git-send-email-pbonzini@redhat.com> <52380B55.5010408@siemens.com>
In-Reply-To: <52380B55.5010408@siemens.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/09/2013 09:57, Jan Kiszka ha scritto:
>> > Remove the useless argument, and do not do anything if there are no
>> > VMs running at the time of the hotplug.
> kvm_cpu_hotplug already filters !kvm_usage_count. If we need the check
> to be under kvm_lock, drop that line as well. If that is not required
> (machine still halted?), drop the related changes here.

CPU_DYING is called under stop_machine, CPU_STARTING is not.  So I
should drop the test in kvm_cpu_hotplug.  It's a bit clearer anyway to
not rely on stop_machine.

Paolo
