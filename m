Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109Ab3HSRei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:34:38 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:41892 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3HSReg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:34:36 -0400
MIME-Version: 1.0
In-Reply-To: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
Date: Mon, 19 Aug 2013 10:34:35 -0700
X-Google-Sender-Auth: EDspcch_kbDk7imlI9O2R89lXEQ
Message-ID: <CAGXu5jKX0vFSaVT+nqUjR7K-p0dCo3Uw=6y17ShuEDkRoOJA8g@mail.gmail.com>
Subject: Re: [PATCH 0/10] Add additional security checks when module loading
 is restricted
From: Kees Cook <keescook@chromium.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 10:26 AM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
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

I like this approach of attaching it to the module loading logic.
Given the LSM hook for loading modules, I think I'd like to add a hook
for the secure_modules() check so that an LSM can respond "secure" as
well, if it doing module loading mediation (for example, in the case
of Chrome OS's modules-only-from-rootfs). I'll work up a patch...

-Kees

-- 
Kees Cook
Chrome OS Security
