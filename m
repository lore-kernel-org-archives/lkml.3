Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaEZRFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:05:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaEZRFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:05:22 -0400
Date: Mon, 26 May 2014 13:55:18 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, jan.kiszka@siemens.com, kvm@vger.kernel.org,
        gleb@kernel.org, avi.kivity@gmail.com
Subject: Re: [PATCH v2 1/4] KVM: x86: use new CS.RPL as CPL during task switch
Message-ID: <20140526165518.GB30582@amt.cnet>
References: <1400172691-27030-1-git-send-email-pbonzini@redhat.com>
 <1400172691-27030-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400172691-27030-2-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 06:51:28PM +0200, Paolo Bonzini wrote:
> During task switch, all of CS.DPL, CS.RPL, SS.DPL must match (in addition
> to all the other requirements) and will be the new CPL.  So far this
> worked by carefully setting the CS selector and flag before doing the
> task switch; however, this will not work once we get the CPL from SS.DPL:
> setting SS itself would fail if the task switch changes the privilege
> level.
> 
> Temporarily assume that the CPL comes from CS.RPL during task switch
> to a protected-mode task.  This is the same approach used in QEMU's
> emulation code, which (until version 2.0) manually tracks the CPL.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

