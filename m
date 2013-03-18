Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3CRUXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:23:13 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:41286 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3CRUXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:23:12 -0400
MIME-Version: 1.0
In-Reply-To: <1363379758-10071-5-git-send-email-vgoyal@redhat.com>
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
	<1363379758-10071-5-git-send-email-vgoyal@redhat.com>
Date: Mon, 18 Mar 2013 16:23:11 -0400
Message-ID: <CA+5PVA4fxN4EhKQJ5C4dLG__ZRzrYPKFqNnZuDgssXCYAjX2yQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] binfmt_elf: Elf executable signature verification
From: Josh Boyer <jwboyer@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@intel.com,
        akpm@linux-foundation.org, ebiederm@xmission.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 4:35 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Do elf executable signature verification (if one is present). If signature
> is present, it should be valid. Validly signed files are given a capability
> CAP_SIGNED.
>
> If file is unsigned, it can execute but it does not get the capability
> CAP_SIGNED.
>
> This is work in progress. This patch is just an RFC to show how one
> can go about making use of IMA APIs for executable signature
> verification.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/Kconfig.binfmt |   12 ++++++++++++
>  fs/binfmt_elf.c   |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+), 0 deletions(-)
>
> diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
> index 0efd152..cbb1d4a 100644
> --- a/fs/Kconfig.binfmt
> +++ b/fs/Kconfig.binfmt
> @@ -23,6 +23,18 @@ config BINFMT_ELF
>           ld.so (check the file <file:Documentation/Changes> for location and
>           latest version).
>
> +config BINFMT_ELF_SIG
> +       bool "ELF binary signature verification"
> +       depends on BINFMT_ELF
> +       select INTEGRITY
> +       select INTEGRITY_SIGNATURE
> +       select INTEGRITY_ASYMMETRIC_KEYS
> +       select IMA
> +       select IMA_APPRAISE
> +       default n
> +       ---help---
> +         Check ELF binary signature verfication.
> +

I haven't reviewed the whole patch set, but this caught my eye.  There
are a couple things wrong with it.

1) The help text isn't helpful.  It could definitely be more verbose and
should probably point to something in Documentation/ that describes what
this whole thing is.

2) The select mechanism is horrible.  I would really like to see this
option use "depends on" instead of select given that you're selecting in
a whole subsystem that people probably aren't going to have already
enabled.

josh
