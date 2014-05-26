Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaEZRFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:05:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaEZRFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:05:24 -0400
Date: Mon, 26 May 2014 13:10:10 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, jan.kiszka@siemens.com, kvm@vger.kernel.org,
        gleb@kernel.org, avi.kivity@gmail.com
Subject: Re: [PATCH v2 4/4] KVM: x86: get CPL from SS.DPL
Message-ID: <20140526161009.GA30582@amt.cnet>
References: <1400172691-27030-1-git-send-email-pbonzini@redhat.com>
 <1400172691-27030-5-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400172691-27030-5-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 06:51:31PM +0200, Paolo Bonzini wrote:
> CS.RPL is not equal to the CPL in the few instructions between
> setting CR0.PE and reloading CS.  And CS.DPL is also not equal
> to the CPL for conforming code segments.
> 
> However, SS.DPL *is* always equal to the CPL except for the weird
> case of SYSRET on AMD processors, which sets SS.DPL=SS.RPL from the
> value in the STAR MSR, but force CPL=3 (Intel instead forces
> SS.DPL=SS.RPL=CPL=3).
> 
> So this patch:
> 
> - modifies SVM to update the CPL from SS.DPL rather than CS.RPL;
> the above case with SYSRET is not broken further, and the way
> to fix it would be to pass the CPL to userspace and back
> 
> - modifies VMX to always return the CPL from SS.DPL (except
> forcing it to 0 if we are emulating real mode via vm86 mode;
> in vm86 mode all DPLs have to be 3, but real mode does allow
> privileged instructions).  It also removes the CPL cache,
> which becomes a duplicate of the SS access rights cache.
> 
> This fixes doing KVM_IOCTL_SET_SREGS exactly after setting
> CR0.PE=1 but before CS has been reloaded.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>


Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

