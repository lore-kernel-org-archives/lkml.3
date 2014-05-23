Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaEWT27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 15:28:59 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49848 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaEWT26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 15:28:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] ARM: trusted_foundations: fix compile error on non-SMP
Date: Fri, 23 May 2014 21:28:51 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Olof Johansson <olof@lixom.net>, "arm@kernel.org" <arm@kernel.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
References: <1400804612-11876-1-git-send-email-acourbot@nvidia.com> <537F7E1F.4020706@wwwdotorg.org>
In-Reply-To: <537F7E1F.4020706@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201405232128.51247.arnd@arndb.de>
X-Provags-ID: V02:K0:0PaX//CInl/qRAqHOyQkdY9v8gdocaORu7GIBIXsYom
 QNzpdtXQPEWf6goufl61Ue6vMjp3q0kOec+/hCfsEX445mkLVc
 e2E1fyNKLYvd2dVRM0Q++iiknyPEfNVCZNTl6Y+/C0zZ80Znv1
 vMGgUbiuhrVVWKOEomt1AzyPfXlf1aIE2oZDcdquyoBS06g/Of
 d514wZKLoDfE1bfh2VSXvW1sb98Xmp/IUDHYxNRYddKELD54xz
 7W93GCqdyu/cNuKSwK3uKCjrnZpnPfh2jF/i9tduuMJnPMm8uT
 i4OlA6fVYzuvZCuri6rjvMas8+FQZbbpWQTkqXaf5PknrJ9HdL
 nOuocJ9YjwPsKE3ihNOU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2014, Stephen Warren wrote:
> On 05/22/2014 06:23 PM, Alexandre Courbot wrote:
> > The setup_max_cpus variable is only defined if CONFIG_SMP is set. Add
> > a preprocessor condition to avoid the following compilation error if
> > CONFIG_SMP is not set:
> > 
> >     arch/arm/include/asm/trusted_foundations.h: In function 'register_trusted_foundations':
> >     arch/arm/include/asm/trusted_foundations.h:57:2: error: 'setup_max_cpus' undeclared (first use in this function)
> > 
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> > Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> I spoke to Olof and IRC, and he said arm-soc would be OK taking this
> patch, since they applied the original code this fixes. IIUC, they'll
> pick this up directly.
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>
> 

Pulled into the fixes branch now, thanks!

	Arnd
