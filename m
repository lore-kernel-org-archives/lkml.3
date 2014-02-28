Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaB1Owu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:52:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbaB1Ows (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:52:48 -0500
Date: Fri, 28 Feb 2014 11:52:34 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 0/2 v2] x86: kvm: global clock updates
Message-ID: <20140228145234.GA13771@amt.cnet>
References: <1393588375-13664-1-git-send-email-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393588375-13664-1-git-send-email-drjones@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 12:52:53PM +0100, Andrew Jones wrote:
> This patch series addresses two issues with global clock updates.
> The first fixes a bug found on hosts that have a tsc marked as
> unstable. As global clock updates get triggered on every vcpu load
> in these cases, guests with a large number of vcpus have their
> progress nearly halted. The fix for that bug should also go to
> stable. The second patch in this series ensures that NTP corrections
> on the host, as well as on guests with all vcpus pinned, will be
> propagated periodically. That patch improves things, but doesn't
> fix a bug, thus it can be merged at a later time than the first.
> I've posted them together as a series, as the second one builds
> on the first.
> 
> Andrew Jones (2):
>   x86: kvm: rate-limit global clock updates
>   x86: kvm: introduce periodic global clock updates
> 
>  arch/x86/include/asm/kvm_host.h |  2 +
>  arch/x86/kvm/x86.c              | 92 +++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 90 insertions(+), 4 deletions(-)
> 
> -- 
> 1.8.1.4

Looks good. 

