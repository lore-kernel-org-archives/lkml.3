Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab3FCVcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 17:32:24 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:54862 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662Ab3FCVcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 17:32:13 -0400
Date: Tue, 4 Jun 2013 06:31:30 +0900 (PWT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
cc: sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: [RFC PATCH 2/2] SELinux: cache inode checks inside struct
 inode
In-Reply-To: <1370285941-18367-2-git-send-email-eparis@redhat.com>
Message-ID: <alpine.LFD.2.03.1306040628420.25797@pixel.linux-foundation.org>
References: <1370285941-18367-1-git-send-email-eparis@redhat.com> <1370285941-18367-2-git-send-email-eparis@redhat.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Jun 2013, Eric Paris wrote:
>  
>  #ifdef CONFIG_SECURITY
> +	seqcount_t		i_security_seqcount;
> +	u32			i_last_task_sid;
> +	u32			i_last_granting;
> +	u32			i_last_perms;
> +	u32			i_audit_allow;
>  	void			*i_security;
>  #endif

This is much too big. I was really hoping for "another word that the 
security layer can use" or similar. 

Something this big would be acceptable if it would be a *generic* security 
cache, and others could use it too, and would avoid ever actually calling 
into any security layer at all (ie we could do the checks entirely at the 
VFS layer). Then it would be fine. But for just the fact that SELinux is 
too slow? No.

              Linus
