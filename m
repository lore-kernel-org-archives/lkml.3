Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3J3LVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:21:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab3J3LVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:21:30 -0400
Date: Wed, 30 Oct 2013 13:20:50 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tim.gardner@canonical.com, torvalds@linux-foundation.org
Subject: Re: [PATCH] KVM: use a more sensible error number when debugfs
 directory creation fails
Message-ID: <20131030112050.GF4651@redhat.com>
References: <1383131852-5566-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383131852-5566-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 12:17:32PM +0100, Paolo Bonzini wrote:
> I don't know if this was due to cut and paste, or somebody was really
> using a D20 to pick the error code for kvm_init_debugfs as suggested by
> Linus (EFAULT is 14, so the possibility cannot be entirely ruled out).
> 
Heh.

> In any case, this patch fixes it.
> 
Acked-by: Gleb Natapov <gleb@redhat.com>

> Reported-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a9dd682cf5e3..1cf9ccb01013 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3091,7 +3091,7 @@ static const struct file_operations *stat_fops[] = {
>  
>  static int kvm_init_debug(void)
>  {
> -	int r = -EFAULT;
> +	int r = -EEXIST;
>  	struct kvm_stats_debugfs_item *p;
>  
>  	kvm_debugfs_dir = debugfs_create_dir("kvm", NULL);
> -- 
> 1.8.3.1

--
			Gleb.
