Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaFDJXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:23:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbaFDJXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:23:04 -0400
Date: Wed, 4 Jun 2014 17:22:14 +0800
From: WANG Chao <chaowang@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, jkosina@suse.cz, dyoung@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC PATCH 00/13][V3] kexec: A new system call to allow in
 kernel loading
Message-ID: <20140604092214.GA17528@dhcp-17-89.nay.redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <20140603131203.GA23395@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603131203.GA23395@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/14 at 09:12am, Vivek Goyal wrote:
> On Tue, Jun 03, 2014 at 09:06:49AM -0400, Vivek Goyal wrote:
> > Hi,
> > 
> > This is V3 of the patchset. Previous versions were posted here.
> > 
> > V1: https://lkml.org/lkml/2013/11/20/540
> > V2: https://lkml.org/lkml/2014/1/27/331
> > 
> > Changes since v2:
> > 
> > - Took care of most of the review comments from V2.
> > - Added support for kexec/kdump on EFI systems.
> > - Dropped support for loading ELF vmlinux.
> > 
> > This patch series is generated on top of 3.15.0-rc8. It also requires a
> > two patch cleanup series which is sitting in -tip tree here.
> 
> I used following kexec-tools patches to test kernel changes.
> 
> Thanks
> Vivek
> 
> 
> kexec-tools: Provide an option to make use of new system call
> 
> This patch provides and option --use-kexec2-syscall, to force use of
> new system call for kexec. Default is to continue to use old syscall.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Hi, Vivek

In your kexec-tools patch, you mentioned '-s' as a short option for
--use-kexec2-syscall in usage(). But it doesn't work.

[..]
> Index: kexec-tools/kexec/kexec.h
> ===================================================================
> --- kexec-tools.orig/kexec/kexec.h	2014-06-02 14:34:16.719774316 -0400
> +++ kexec-tools/kexec/kexec.h	2014-06-02 14:34:42.010036325 -0400
> @@ -156,6 +156,13 @@ struct kexec_info {
>  	unsigned long kexec_flags;
>  	unsigned long backup_src_start;
>  	unsigned long backup_src_size;
> +	/* Set to 1 if we are using kexec2 syscall */
> +	unsigned long file_mode :1;
> +
> +	/* Filled by kernel image processing code */
> +	int initrd_fd;
> +	char *command_line;
> +	int command_line_len;
>  };
>  
>  struct arch_map_entry {
> @@ -207,6 +214,7 @@ extern int file_types;
>  #define OPT_UNLOAD		'u'
>  #define OPT_TYPE		't'
>  #define OPT_PANIC		'p'
> +#define OPT_USE_KEXEC2_SYSCALL	's'
>  #define OPT_MEM_MIN             256
>  #define OPT_MEM_MAX             257
>  #define OPT_REUSE_INITRD	258
> @@ -230,6 +238,7 @@ extern int file_types;
>  	{ "mem-min",		1, 0, OPT_MEM_MIN }, \
>  	{ "mem-max",		1, 0, OPT_MEM_MAX }, \
>  	{ "reuseinitrd",	0, 0, OPT_REUSE_INITRD }, \
> +	{ "use-kexec2-syscall",	0, 0, OPT_USE_KEXEC2_SYSCALL }, \
>  	{ "debug",		0, 0, OPT_DEBUG }, \
>  
>  #define KEXEC_OPT_STR "h?vdfxluet:p"

This line,
#define KEXEC_OPT_STR "h?vdfxluet:p"

should be something like,
#define KEXEC_OPT_STR "h?vdfxluet:ps"

Thanks
WANG Chao
