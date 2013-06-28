Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3F1Uox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:44:53 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:49868 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab3F1Uow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:44:52 -0400
MIME-Version: 1.0
In-Reply-To: <1372450451-8790-3-git-send-email-lszubowi@redhat.com>
References: <1372450451-8790-1-git-send-email-lszubowi@redhat.com>
	<1372450451-8790-3-git-send-email-lszubowi@redhat.com>
Date: Fri, 28 Jun 2013 13:44:51 -0700
Message-ID: <CA+8MBbJrU51R5TMV6m4nhAiz2kZQBOcmkeAkEcg-erJhDwrChA@mail.gmail.com>
Subject: Re: [PATCH 2/3] acpi: Eliminate console msg if pstore.backend
 excludes ERST
From: Tony Luck <tony.luck@gmail.com>
To: Lenny Szubowicz <lszubowi@redhat.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        n.hamaguchi@jp.fujitsu.com, Don Zickus <dzickus@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 1:14 PM, Lenny Szubowicz <lszubowi@redhat.com> wrote:

> -               if (pstore_register(&erst_info)) {
> -                       pr_info(ERST_PFX "Could not register with persistent store\n");
> +               rc = pstore_register(&erst_info);
> +               if (rc) {
> +                       if (rc != -EPERM)
> +                               pr_info(ERST_PFX
> +                               "Could not register with persistent store\n");
> +                       erst_info.buf = NULL;
> +                       erst_info.bufsize = 0;

Mismatch between part 1 and part 2 here ... we return -EINVAL if
our name doesn't match the desired backend ... but you only suppress
the "Could not register" message for -EPERM

Or am I confused while just looking at patch fragments?

-Tony
