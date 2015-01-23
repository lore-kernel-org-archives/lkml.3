Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbbAWJYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:24:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbbAWJYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:24:51 -0500
Message-ID: <54C21361.1080500@suse.cz>
Date: Fri, 23 Jan 2015 10:24:49 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org
CC: linux-kbuild@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] modsign: provide option to automatically delete the key
 after modules were installed
References: <1421976009-9819-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1421976009-9819-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-23 02:20, Alexander Holler wrote:
> I usually throw away (delete) the key used to sign modules after having
> called make -jN (b)zImage modules && make -jN modules_install. Because I've
> got bored to always have to type rm signing_key.* afterwards, I've build
> this patch some time ago.
> As I'm not eager anymore to publish kernel patches, it rested in my private
> chest of patches until I've seen the keynote of Linux.conf.au 2015. It made
> me aware that this patch might have a chance to become included. ;)
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>  Makefile     |  7 +++++++
>  init/Kconfig | 12 ++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index fb93350..95e07ca 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1129,6 +1129,13 @@ _modinst_:
>  	@cp -f $(objtree)/modules.order $(MODLIB)/
>  	@cp -f $(objtree)/modules.builtin $(MODLIB)/
>  	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
> +ifeq ($(CONFIG_MODULE_SIG_THROW_AWAY), y)
> +	@echo "###"
> +	@echo "### Deleting key used to sign modules."
> +	@echo "###"

Use @$(kecho) "..." to suppress output with make -s


> +	@rm ./signing_key.priv
> +	@rm ./signing_key.x509

Why do you need to delete the certificate?

Michal
