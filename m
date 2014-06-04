Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaFDKev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:34:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48727 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbaFDKeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:34:50 -0400
Date: Wed, 4 Jun 2014 12:34:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 05/13] kexec: Make kexec_segment user buffer pointer a
 union
Message-ID: <20140604103423.GD4105@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-6-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401800822-27425-6-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:06:54AM -0400, Vivek Goyal wrote:
> So far kexec_segment->buf was always a user space pointer as user space
> passed the array of kexec_segment structures and kernel copied it.
> 
> But with new system call, list of kexec segments will be prepared by
> kernel and kexec_segment->buf will point to a kernel memory.
> 
> So while I was adding code where I made assumption that ->buf is pointing
> to kernel memory, sparse started giving warning.
> 
> Make ->buf a union. And where a user space pointer is expected, access
> it using ->buf and where a kernel space pointer is expected, access it
> using ->kbuf. That takes care of sparse warnings.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
