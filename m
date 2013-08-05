Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab3HEWfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:35:11 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:56560 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab3HEWfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:35:09 -0400
Message-ID: <52002899.6060209@gmail.com>
Date: Mon, 05 Aug 2013 15:35:05 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>
CC: gleb@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: Make kvm_rebooting visible
References: <1375740747-7769-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1375740747-7769-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 03:12 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> kvm_rebooting is referenced from assembler code, thus
> needs to be visible.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>   virt/kvm/kvm_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1580dd4..eff6abd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -95,7 +95,7 @@ static void hardware_disable_all(void);
>
>   static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
>
> -bool kvm_rebooting;
> +__visible bool kvm_rebooting;
>   EXPORT_SYMBOL_GPL(kvm_rebooting);

How many of these are there kernel wide?

Could you do something like this instead:

DEFINE_AND_EXPORT_GPL(bool, kvm_rebooting);

The definition of DEFINE_AND_EXPORT_GPL(_type, _name) is left as an 
exercise for the reader.

David Daney


