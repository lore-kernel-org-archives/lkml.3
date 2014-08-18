Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaHRVZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 17:25:09 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:47237 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaHRVZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 17:25:02 -0400
Message-ID: <53F26F29.9060308@redhat.com>
Date: Mon, 18 Aug 2014 23:24:57 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@kernel.org
CC: avi.kivity@gmail.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] kvm: x86: fix stale mmio cache bug
References: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1407999713-3726-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <1407999713-3726-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/08/2014 09:01, Xiao Guangrong ha scritto:
>   * Clear the mmio cache info for the given gva,
> - * specially, if gva is ~0ul, we clear all mmio cache info.
> + * specially, if gva is ~MMIO_GVA_ANY, we clear all mmio cache info.

Extra ~.

>   */
> +#define MMIO_GVA_ANY	~((gva_t)0)
> +

Better: (~(gva_t)0).

Paolo
