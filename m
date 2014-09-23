Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaIWIAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:00:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64207 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbaIWIAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:00:21 -0400
Message-ID: <5421288C.9090805@redhat.com>
Date: Tue, 23 Sep 2014 10:00:12 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chris@arachsys.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86: kvm: use alternatives for VMCALL vs. VMMCALL if
 kernel text is read-only
References: <1411384668-11135-1-git-send-email-pbonzini@redhat.com> <20140922194335.GB5119@pd.tnic>
In-Reply-To: <20140922194335.GB5119@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/09/2014 21:43, Borislav Petkov ha scritto:
>> > On x86_64, kernel text mappings are mapped read-only with CONFIG_DEBUG_RODATA.
> Hmm, that depends on DEBUG_KERNEL.
> 
> I think you're actually talking about distro kernels which enable
> CONFIG_DEBUG_RODATA, right?

This is for guest kernels, so it's not necessarily distro kernels.
Anyone who compiles their kernel with CONFIG_DEBUG_RODATA + PV spinlocks
would not be able to run it on AMD.

Paolo
