Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab3H1Whs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 18:37:48 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:39928 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab3H1Whq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 18:37:46 -0400
Date: Wed, 28 Aug 2013 18:37:43 -0400 (EDT)
From: Lenny Szubowicz <lszubowi@redhat.com>
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org
Message-ID: <1241952070.8587861.1377729463830.JavaMail.root@redhat.com>
In-Reply-To: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
Subject: Re: [PATCH 0/10] Add additional security checks when module loading
 is restricted
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF17 (Linux)/8.0.3_GA_5664)
Thread-Topic: Add additional security checks when module loading is restricted
Thread-Index: Nz5hbGPlr11vDxoZBtCj48/bXxVZzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Matthew Garrett" <matthew.garrett@nebula.com>
> To: linux-kernel@vger.kernel.org
> Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org
> Sent: Monday, August 19, 2013 1:26:01 PM
> Subject: [PATCH 0/10] Add additional security checks when module loading is restricted
> 
> We have two in-kernel mechanisms for restricting module loading - disabling
> it entirely, or limiting it to the loading of modules signed with a trusted
> key. These can both be configured in such a way that even root is unable to
> relax the restrictions.
> 
> However, right now, there's several other straightforward ways for root to
> modify running kernel code. At the most basic level these allow root to
> reset the configuration such that modules can be loaded again, rendering
> the existing restrictions useless.
> 
> This patchset adds additional restrictions to various kernel entry points
> that would otherwise make it straightforward for root to disable enforcement
> of module loading restrictions. It also provides a patch that allows the
> kernel to be configured such that module signing will be automatically
> enabled when the system is booting via UEFI Secure Boot, allowing a stronger
> guarantee of kernel integrity.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Did you purposely exclude similar checks for hibernate that were covered
by earlier versions of your patch set?

I think you should include it and any patch set that attempts to add support
for doing hibernate securely would make appropriate changes.

                              -Lenny.
