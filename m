Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3JYAIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 20:08:36 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60044 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab3JYAIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 20:08:34 -0400
MIME-Version: 1.0
In-Reply-To: <14578957.OSuohDRLT9@cmlinux10.ih.lucent.com>
References: <14578957.OSuohDRLT9@cmlinux10.ih.lucent.com>
Date: Thu, 24 Oct 2013 20:08:33 -0400
X-Google-Sender-Auth: HGwDgOQ5j8P6F6xpr7rviqpUrFQ
Message-ID: <CA+5PVA4C_KN=aUPewU+xHa4PSogskYMPugi-wBAZ=Ft446vDbg@mail.gmail.com>
Subject: Re: [PATCH] Adding Documentation/module-signing.txt file
From: Josh Boyer <jwboyer@fedoraproject.org>
To: James Solner <solner@alcatel-lucent.com>
Cc: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 6:35 PM, James Solner <solner@alcatel-lucent.com> wrote:
> This patch adds the Documentation/module-signing.txt file that is
> missing. There is a link to Documentation/module-signing.txt file
> in init/Kconfig that references this file.
>
> Signed-off-by: James Solner <solner@alcatel-lucent.com>

Nak.  Please see below.

> ---
>  Documentation/module-signing.txt | 182 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 182 insertions(+)
>  create mode 100644 Documentation/module-signing.txt
>
> diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
> new file mode 100644
> index 0000000..b21e1f1
> --- /dev/null
> +++ b/Documentation/module-signing.txt
> @@ -0,0 +1,182 @@
> +                       ==============================
> +                       KERNEL MODULE SIGNING FACILITY
> +                       ==============================
> +
> +The module signing facility applies cryptographic signature checking to modules
> +on module load, checking the signature against a ring of public keys compiled
> +into the kernel.  GPG is used to do the cryptographic work and determines the
> +format of the signature and key data.  The facility uses GPG&#39;s MPI library to
> +handle the huge numbers involved.
> +
> +The signature checker in the kernel is capable of handling multiple keys of
> +either DSA or RSA type, and can support any of MD5, RIPE-MD-160, SHA-1,
> +SHA-224, SHA-256, SHA-384 and SHA-512 hashes - PROVIDED(!) the requisite
> +algorithms are compiled into the kernel.
> +
> +(!) NOTE: Modules may only be verified initially with algorithms compiled into
> +the kernel.  Further algorithm modules may be loaded and used - but these must
> +first pass a verification step using already loaded/compiled-in algorithms.
> +
> +
> +=====================
> +SUPPLYING PUBLIC KEYS
> +=====================
> +
> +A set of public keys must be supplied at kernel image build time.  This is done
> +by taking a GPG public key file and placing it in the base of the kernel
> +directory in a file called modsign.pub.
> +
> +For example, a throwaway key could be generated automatically by something like
> +the following:
> +
> +       cat &gt;genkey &lt;&lt;EOF
> +       %pubring modsign.pub
> +       %secring modsign.sec
> +       Key-Type: RSA
> +       Key-Length: 4096
> +       Name-Real: A. N. Other
> +       Name-Comment: Kernel Module GPG key
> +       %commit
> +       EOF
> +       gpg --homedir . --batch --gen-key genkey
> +
> +The above generates fresh keys using /dev/random.  If there&#39;s insufficient data
> +in /dev/random, more can be provided using the rngd program if there&#39;s a
> +hardware random number generator available.
> +
> +Note that no GPG password is used in the above scriptlet.

This is inaccurate and doesn't match how module signing is done today.
 The document you have here is a weird mix of the old RHEL style GPG
signing and the current appended-signature x509 certificate signing.

It needs to be updated to match the fact that x509 keys and signatures
are used now.

josh
