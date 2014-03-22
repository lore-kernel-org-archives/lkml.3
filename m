Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaCVQ0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:26:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaCVQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:26:39 -0400
Date: Sat, 22 Mar 2014 09:28:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: behanw@converseincode.com
Cc: dh.herrmann@gmail.com, sameo@linux.intel.com, jani.nikula@intel.com,
        alexandre.bounine@idt.com, akpm@linux-foundation.org,
        dmitry.torokhov@gmail.com, tomas.winkler@intel.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu,
        Jan-Simon =?iso-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
Subject: Re: [PATCH] x86: LLVMLinux: Fix "incomplete type const struct
 x86cpu_device_id"
Message-ID: <20140322162808.GF13385@kroah.com>
References: <1395470418-16015-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395470418-16015-1-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 11:40:18PM -0700, behanw@converseincode.com wrote:
> From: Behan Webster <behanw@converseincode.com>
> 
> Similar to the fix in 40413dcb7b273bda681dca38e6ff0bbb3728ef11
> 
> MODULE_DEVICE_TABLE(x86cpu, ...) expects the struct to be called struct
> x86cpu_device_id, and not struct x86_cpu_id which is what is used in the rest
> of the kernel code.  Although gcc seems to ignore this error, clang fails
> without this define to fix the name.
> 
> Code from drivers/thermal/x86_pkg_temp_thermal.c
> static const struct x86_cpu_id __initconst pkg_temp_thermal_ids[] = { ... };
> MODULE_DEVICE_TABLE(x86cpu, pkg_temp_thermal_ids);
> 
> Error from clang:
> drivers/thermal/x86_pkg_temp_thermal.c:577:1: error: variable has
>       incomplete type 'const struct x86cpu_device_id'
> MODULE_DEVICE_TABLE(x86cpu, pkg_temp_thermal_ids);
> ^
> include/linux/module.h:145:3: note: expanded from macro
>       'MODULE_DEVICE_TABLE'
>   MODULE_GENERIC_TABLE(type##_device, name)
>   ^
> include/linux/module.h:87:32: note: expanded from macro
>       'MODULE_GENERIC_TABLE'
> extern const struct gtype##_id __mod_##gtype##_table            \
>                                ^
> <scratch space>:143:1: note: expanded from here
> __mod_x86cpu_device_table
> ^
> drivers/thermal/x86_pkg_temp_thermal.c:577:1: note: forward declaration of
>       'struct x86cpu_device_id'
> include/linux/module.h:145:3: note: expanded from macro
>       'MODULE_DEVICE_TABLE'
>   MODULE_GENERIC_TABLE(type##_device, name)
>   ^
> include/linux/module.h:87:21: note: expanded from macro
>       'MODULE_GENERIC_TABLE'
> extern const struct gtype##_id __mod_##gtype##_table            \
>                     ^
> <scratch space>:141:1: note: expanded from here
> x86cpu_device_id
> ^
> 1 error generated.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
