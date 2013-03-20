Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3CTX6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:58:49 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:59483
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676Ab3CTX6r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:58:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Wed, 20 Mar 2013 18:58:41 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] KVM: allow host header to be included even for
 !CONFIG_KVM
To: Kevin Hilman <khilman@linaro.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, <linaro-kernel@lists.linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1363306426-27209-1-git-send-email-khilman@linaro.org>
In-Reply-To: <1363306426-27209-1-git-send-email-khilman@linaro.org> (from
	khilman@linaro.org on Thu Mar 14 19:13:46 2013)
X-Mailer: Balsa 2.4.11
Message-ID: <1363823921.25034.35@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 07:13:46 PM, Kevin Hilman wrote:
> The new context tracking subsystem unconditionally includes kvm_host.h
> headers for the guest enter/exit macros.  This causes a compile
> failure when KVM is not enabled.
> 
> Fix by adding an IS_ENABLED(CONFIG_KVM) check to kvm_host so it can
> be included/compiled even when KVM is not enabled.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
> Applies on v3.9-rc2
> 
>  include/linux/kvm_host.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

This broke the PPC non-KVM build, which was relying on stub functions  
in kvm_ppc.h, which relies on "struct vcpu" in kvm_host.h.

Why can't the entirety kvm_host.h be included regardless of CONFIG_KVM,  
just like most other feature-specific headers?  Why can't the if/else  
just go around the functions that you want to stub out for non-KVM  
builds?

-Scott
