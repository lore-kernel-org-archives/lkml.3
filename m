Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3HOVSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:18:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3HOVSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:18:49 -0400
Date: Thu, 15 Aug 2013 14:18:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergei Trofimovich <slyfox@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2] Makefile: enable -Werror=implicit-int and
 -Werror=strict-prototypes by default
Message-Id: <20130815141848.0af8cc27fa852905a35b02f8@linux-foundation.org>
In-Reply-To: <1376591851-31854-1-git-send-email-slyfox@gentoo.org>
References: <1376591851-31854-1-git-send-email-slyfox@gentoo.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug 2013 21:37:31 +0300 Sergei Trofimovich <slyfox@gentoo.org> wrote:

> The common error type found in forward-ported/backported patches is missing headers.
> One recent example (files and function names are mangled):
> 
>     void foo(){}
>     EXPORT_SYMBOL(foo);
> 
> gave only warning
> 
>     foo.c:12345678:5: warning: function declaration isn't a prototype [-Wstrict-prototypes]
>     void foo(){}
>          ^
> 
>     foo.c:12345679:5: warning: data definition has no type or storage class [enabled by default]
>     EXPORT_SYMBOL(foo);
>     foo.c:12345679:5: warning: type defaults to 'int' in declaration of 'EXORT_SYMBOL' [-Werror=implicit-int]
> 
> Now it's a fata error. Tested on x86_64 allyesconfig.

Yes, let's try that.

Partly because the build still generates far too many warnings..
