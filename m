Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbaCDTZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:25:08 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:56548 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbaCDTZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:25:05 -0500
Message-ID: <1393961100.10148.69.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 6/8] evm: enable key retention service automatically
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        casey.schaufler@intel.com
Date: Tue, 04 Mar 2014 14:25:00 -0500
In-Reply-To: <CACE9dm_oQnOF1pp0k-GJcN9tOhr6Saod55srTJmsQEfhGphE=g@mail.gmail.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
	 <43c402f0d4fbcf222f8d669ccf5d237059bd34fe.1393599538.git.d.kasatkin@samsung.com>
	 <1393898536.10148.18.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CACE9dm_oQnOF1pp0k-GJcN9tOhr6Saod55srTJmsQEfhGphE=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030419-1542-0000-0000-0000001A5D9C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 16:10 +0200, Dmitry Kasatkin wrote: 
> On Tue, Mar 4, 2014 at 4:02 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Fri, 2014-02-28 at 16:59 +0200, Dmitry Kasatkin wrote:
> >> If keys are not enabled, EVM is not visible in the configuration menu.
> >> It may be difficult to figure out what to do unless  you really know.
> >>
> >> Other subsystems as NFS, CIFS select keys automatically.
> >> This patch does the same.
> >>
> >> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> >> ---
> >>  security/integrity/evm/Kconfig | 5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
> >> index 5aa9103..d35b491 100644
> >> --- a/security/integrity/evm/Kconfig
> >> +++ b/security/integrity/evm/Kconfig
> >> @@ -1,9 +1,10 @@
> >>  config EVM
> >>       boolean "EVM support"
> >> -     depends on SECURITY && KEYS && (TRUSTED_KEYS=y || TRUSTED_KEYS=n)
> >
> > Including KEYS is fine, but the trusted-keys dependency is still
> > required.  If trusted-keys is enabled, then the TPM and trusted-keys
> > must be builtin.
> >
> 
> Hello.
> 
> EVM does not depend on trusted keys, but on encrypted keys.
> There is no need for "&& (TRUSTED_KEYS=y || TRUSTED_KEYS=n)"
> 
> Header file already provides all necessary compile time dependencies...
> 
> -------------------------------------------------------------------------------------------------
> #if defined(CONFIG_TRUSTED_KEYS) || \
>   (defined(CONFIG_TRUSTED_KEYS_MODULE) && defined(CONFIG_ENCRYPTED_KEYS_MODULE))
> extern struct key *request_trusted_key(const char *trusted_desc,
>       u8 **master_key, size_t *master_keylen);
> #else
> static inline struct key *request_trusted_key(const char *trusted_desc,
>      u8 **master_key,
>      size_t *master_keylen)
> {
> return ERR_PTR(-EOPNOTSUPP);
> }
> #endif
> -------------------------------------------------------------------------------------------------

Either in the patch description or the changelog, please note the reason
for removing the builtin TRUSTED_KEY dependency.  

thanks,

Mimi

