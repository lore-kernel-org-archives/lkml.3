Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab3A2Kv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:51:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3A2Kvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:51:54 -0500
Date: Tue, 29 Jan 2013 02:54:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix 32-bit compile warning from printk()
Message-Id: <20130129025428.918e295c.akpm@linux-foundation.org>
In-Reply-To: <20130128191939.7F67966B@kernel.stglabs.ibm.com>
References: <20130128191939.7F67966B@kernel.stglabs.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013 11:19:39 -0800 Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> My patch "Fix kvm's use of __pa() on percpu areas" introduced a
> compile warning:
> 
> arch/x86/kernel/kvm.c: In function 'kvm_register_steal_time':
> arch/x86/kernel/kvm.c:302:3: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'phys_addr_t' [-Wformat]
> 
> According to: Documentation/printk-formats.txt
> 
> 	If <type> is dependent on a config option for its size
> 	(e.g., phys_addr_t) ... use a format specifier of its
> 	largest possible type and explicitly cast to it.
> 
> So, we'll do just that.  We will consider it an unsigned long
> long, and cast to it explicitly.

Please note that I have
http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintf-add-%25pa-format-specifier-for-phys_addr_t-types.patch
queued for 3.8.


