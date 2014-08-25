Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138AbaHYRXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:23:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932836AbaHYRXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:23:33 -0400
Date: Mon, 25 Aug 2014 13:22:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Geoff Levand <geoff@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, kexec@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        maximilian attems <max@stro.at>, Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 1/5] kexec: Fix make headers_check
Message-ID: <20140825172234.GD14379@redhat.com>
References: <cover.1408731991.git.geoff@infradead.org>
 <115373b6ac68ee7a305975896e1c4971e8e51d4c.1408731991.git.geoff@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <115373b6ac68ee7a305975896e1c4971e8e51d4c.1408731991.git.geoff@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 06:39:47PM +0000, Geoff Levand wrote:
> Remove the unneded declaration for a kexec_load() routine.
> 
> Fixes errors like these when running 'make headers_check':
> 
> include/uapi/linux/kexec.h: userspace cannot reference function or variable defined in the kernel
> 
> Signed-off-by: Geoff Levand <geoff@infradead.org>

I think Paul Bolle tried to remove this in the past and maximilian
had objections.

http://lists.infradead.org/pipermail/kexec/2014-January/010902.html

I can't see that how exporting kernel prototype helps here. kexec-tools
seems to be using syscall(__NR_kexec_load) directly for non-xen case. So
I would be fine with removing this definition. Just trying to make sure
that it does not break any other library or users of this declaration.

Thanks
Vivek


> ---
>  include/uapi/linux/kexec.h | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/include/uapi/linux/kexec.h b/include/uapi/linux/kexec.h
> index 6925f5b..99048e5 100644
> --- a/include/uapi/linux/kexec.h
> +++ b/include/uapi/linux/kexec.h
> @@ -55,12 +55,6 @@ struct kexec_segment {
>  	size_t memsz;
>  };
>  
> -/* Load a new kernel image as described by the kexec_segment array
> - * consisting of passed number of segments at the entry-point address.
> - * The flags allow different useage types.
> - */
> -extern int kexec_load(void *, size_t, struct kexec_segment *,
> -		unsigned long int);
>  #endif /* __KERNEL__ */
>  
>  #endif /* _UAPILINUX_KEXEC_H */
> -- 
> 1.9.1
> 
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
