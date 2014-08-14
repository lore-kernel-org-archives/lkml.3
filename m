Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaHNSh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 14:37:59 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:61694 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbaHNSh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:37:57 -0400
Date: Thu, 14 Aug 2014 13:37:54 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ebiederm@xmission.com, hpa@zytor.com, kexec@lists.infradead.org
Subject: Re: [PATCH 1/2] kexec: Create a new config option CONFIG_KEXEC_FILE
 for new syscall
Message-ID: <20140814183753.GA25199@digium.com>
References: <1407940980-7100-1-git-send-email-vgoyal@redhat.com>
 <1407940980-7100-2-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407940980-7100-2-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 10:42:59AM -0400, Vivek Goyal wrote:
> Currently new system call kexec_file_load() and all the associated code
> compiles if CONFIG_KEXEC=y. But new syscall also compiles purgatory code
> which currently uses gcc option -mcmodel=large. This option seems to be
> available only gcc 4.4 onwards.
> 
> Hiding new functionality behind a new config option will not break
> existing users of old gcc. Those who wish to enable new functionality
> will require new gcc. Having said that, I am trying to figure out how
> can I move away from using -mcmodel=large but that can take a while.
> 
> I think there are other advantages of introducing this new config
> option. As this option will be enabled only on x86_64, other arches
> don't have to compile generic kexec code which will never be used.
> This new code selects CRYPTO=y and CRYPTO_SHA256=y. And all other
> arches had to do this for CONFIG_KEXEC. Now with introduction
> of new config option, we can remove crypto dependency from other
> arches.
> 
> Now CONFIG_KEXEC_FILE is available only on x86_64. So whereever I
> had CONFIG_X86_64 defined, I got rid of that.
> 
> For CONFIG_KEXEC_FILE, instead of doing select CRYPTO=y, I changed
> it to "depends on CRYPTO=y". This should be safer as "select" is
> not recursive.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/Kbuild                    |  4 +---
>  arch/x86/Kconfig                   | 18 ++++++++++++++----
>  arch/x86/Makefile                  |  5 +----
>  arch/x86/kernel/Makefile           |  2 +-
>  arch/x86/kernel/crash.c            |  6 ++----
>  arch/x86/kernel/machine_kexec_64.c | 11 +++++++++++
>  arch/x86/purgatory/Makefile        |  5 +----
>  kernel/kexec.c                     | 11 +++++++++++
>  8 files changed, 42 insertions(+), 20 deletions(-)


Thanks Vivek. It is no surprise but applying this patch resolved my
issue.

Shaun
