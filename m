Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaCRMLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:11:55 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:49873 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaCRMLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:11:53 -0400
Message-ID: <53283803.5010209@redhat.com>
Date: Tue, 18 Mar 2014 13:11:47 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86 emulator: emulate MOVAPS and MOVAPD SSE
 instructions
References: <1394913720-6466-1-git-send-email-imammedo@redhat.com> <8569d2b4-0593-4f7a-859c-3848670f718d@email.android.com> <5326C0C3.6000105@redhat.com> <fb38ff9d-8c00-4b02-b0da-2db989f7190e@email.android.com> <53272A53.8090605@redhat.com> <53273309.8060103@zytor.com>
In-Reply-To: <53273309.8060103@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/03/2014 18:38, H. Peter Anvin ha scritto:
> I'm not sure what you mean with "valid real mode selectors"; the normal
> case in big real mode is that either CS = SS = 0 or CS = SS = <some
> program base address>.

I mean "valid according to the VMX spec" for running in vm86 mode: base 
= selector << 4, limit = 0xffff, access rights = 0xf3.

If a segment does not follow the rules, but CS does, we could run the 
guest normally and trap memory accesses to KVM.

Paolo
