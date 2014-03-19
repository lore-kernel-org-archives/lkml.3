Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965258AbaCSNQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:16:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42351 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965229AbaCSNQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:16:05 -0400
Date: Wed, 19 Mar 2014 10:15:43 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Richard Weinberger <richard@nod.at>
Cc: dedekind1@gmail.com, dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] UBI: block: Implement kernel_param_ops->get()
Message-ID: <20140319131543.GA529@arch.cereza>
References: <1395225803-25037-1-git-send-email-richard@nod.at>
 <1395225803-25037-2-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395225803-25037-2-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Mar 19, Richard Weinberger wrote:
> The ->get() function is not optional.
> 

[..]
>  static struct kernel_param_ops ubiblock_param_ops = {
>  	.set    = ubiblock_set_param,
> +	.get	= param_get_charp,
>  };
>  module_param_cb(block, &ubiblock_param_ops, NULL, 0);

The comment for the function says they are both optional:

/**
 * module_param_cb - general callback for a module/cmdline parameter
 * @name: a valid C identifier which is the parameter name.
 * @ops: the set & get operations for this parameter.
 * @perm: visibility in sysfs.
 *
 * The ops can have NULL set or get functions.
 */

This has no visibility in sysfs, so I can't see how having a NULL
get() is a problem. What's the issue you're trying to fix here?

Maybe I'm missing something?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
