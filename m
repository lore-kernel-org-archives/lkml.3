Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab3DWTDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:03:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:47673 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab3DWTC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:02:58 -0400
Message-ID: <5176DAC8.8040401@infradead.org>
Date: Tue, 23 Apr 2013 12:02:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v13 9/9] LSM: Documentation and cleanup
References: <5176ABB7.5080300@schaufler-ca.com> <5176B12C.4000506@schaufler-ca.com>
In-Reply-To: <5176B12C.4000506@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/13 09:05, Casey Schaufler wrote:
> Subject: [PATCH v13 9/9] LSM: Documentation and cleanup
> 
> Add a description of the ways secuirty modules work now.

                                security

> Remove security/capability.c as it is no longer used.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> ---
>  Documentation/security/LSM.txt |   39 +-
>  security/Makefile              |    3 +-
>  security/capability.c          | 1104 ----------------------------------------
>  3 files changed, 31 insertions(+), 1115 deletions(-)
> 
> diff --git a/Documentation/security/LSM.txt b/Documentation/security/LSM.txt
> index c335a76..f979e00 100644
> --- a/Documentation/security/LSM.txt
> +++ b/Documentation/security/LSM.txt
> @@ -9,18 +9,39 @@ CONFIG_DEFAULT_SECURITY and can be overridden at boot-time via the
>  "security=..." kernel command line argument, in the case where multiple
>  LSMs were built into a given kernel.
>  
> +Both CONFIG_DEFAULT_SECURITY and the "security=" option take a comma
> +separated list of LSM names. The LSM hooks are invoked in the order
> +specified. All hooks provided are invoked regardless of the outcome
> +of preceeding hooks. Hooks the return success or failure results

      preceding       .  ^^^confusing sentence structure^^^

> +return success if all of the LSM provided hooks succeed and the error
> +code of the last failing hook on error.
> +
> +The /proc filesystem attribute interface supports files from a time
> +when only one LSM could be used at a time. CONFIG_PRESENT_SECURITY
> +defines which LSM uses these interfaces. There are also LSM identified
> +interfaces which should be used in preference to the undifferentiated
> +interfaces.


-- 
~Randy
