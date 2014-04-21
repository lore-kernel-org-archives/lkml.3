Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaDUTZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 15:25:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbaDUTY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 15:24:56 -0400
Date: Sun, 20 Apr 2014 23:13:33 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] KVM: vmx: speed up emulation of invalid guest
 state
Message-ID: <20140421021333.GA18207@amt.cnet>
References: <1395919838-18466-1-git-send-email-pbonzini@redhat.com>
 <1395919838-18466-2-git-send-email-pbonzini@redhat.com>
 <20140416225258.GA19597@amt.cnet>
 <5350A7D0.8070603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5350A7D0.8070603@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 12:19:28AM -0400, Paolo Bonzini wrote:
> Il 16/04/2014 18:52, Marcelo Tosatti ha scritto:
> >How about handling VM-entry error due to invalid state with
> >
> >vmx->emulation_required = true;
> >continue to main vcpu loop;
> 
> What would reset it to false though?  None of the places that call
> emulation_required() is a hot path right now, and this patch doesn't
> add any.

The same code which resets it to false inside the
handle_invalid_guest_state loop (so you would stop emulating
at the same point as you do with this patch).

Advantage would be that failure to set vmx->emulation_required to
true would not cause VM-entry failure.

