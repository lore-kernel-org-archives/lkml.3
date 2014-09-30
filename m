Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaI3VWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:22:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57612 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaI3VWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:22:00 -0400
Message-ID: <542B1EC1.8090502@zytor.com>
Date: Tue, 30 Sep 2014 14:21:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Baoquan He <bhe@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, vgoyal@redhat.com, keescook@chromium.org,
        ak@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        whissi@whissi.de, kumagai-atsushi@mxc.nes.nec.co.jp,
        stable@vger.kernel.org
Subject: Re: [resend Patch v3 1/2] kaslr: check if kernel location is changed
References: <1412060896-1902-1-git-send-email-bhe@redhat.com>
In-Reply-To: <1412060896-1902-1-git-send-email-bhe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 12:08 AM, Baoquan He wrote:
> Function handle_relocations() is used to do the relocations handling
> for i686 and kaslr of x86_64. For 32 bit the relocation handling is
> mandotary to perform. For x86_64 only when kaslr is enabled and a
> random kernel location is chosen successfully the relocation handling
> shound be done. However previous implementation only compared the
> kernel loading address and LOAD_PHYSICAL_ADDR where kernel were
> compiled to run at. This would casue system to be exceptional in
> few conditions like when delta between load address and compiled
> address is bigger than what 32bit signed relocations can handle.
> Also there will be limitations that delta can't be too big otherwise
> kernel text virtual addresses will overflow in module address space.
> 
> So in this patch check if kernel location is changed after
> choose_kernel_location() when x86_64. If and only if in x86_64
> and kernel location is changed, we say a kaslr random kernel
> location is chosen, then the relocation handling is needed.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> Tested-by: Thomas D. <whissi@whissi.de>
> Cc: stable@vger.kernel.org

Could you clarify under what conditions we may end up with 32-bit signed
overflow, and yet have a functional kernel?

	-hpa


