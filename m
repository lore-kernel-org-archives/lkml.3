Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaEWQ6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:58:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45266 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbaEWQ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:58:11 -0400
Message-ID: <537F7E1F.4020706@wwwdotorg.org>
Date: Fri, 23 May 2014 10:58:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "arm@kernel.org" <arm@kernel.org>
Subject: Re: [PATCH RESEND] ARM: trusted_foundations: fix compile error on
 non-SMP
References: <1400804612-11876-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1400804612-11876-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 06:23 PM, Alexandre Courbot wrote:
> The setup_max_cpus variable is only defined if CONFIG_SMP is set. Add
> a preprocessor condition to avoid the following compilation error if
> CONFIG_SMP is not set:
> 
>     arch/arm/include/asm/trusted_foundations.h: In function 'register_trusted_foundations':
>     arch/arm/include/asm/trusted_foundations.h:57:2: error: 'setup_max_cpus' undeclared (first use in this function)
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>

I spoke to Olof and IRC, and he said arm-soc would be OK taking this
patch, since they applied the original code this fixes. IIUC, they'll
pick this up directly.

Acked-by: Stephen Warren <swarren@nvidia.com>
