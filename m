Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934623AbaFSUeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:34:36 -0400
Received: from mx5-phx2.redhat.com ([209.132.183.37]:58786 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaFSUee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:34:34 -0400
Date: Thu, 19 Jun 2014 16:33:45 -0400 (EDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        peterz@infradead.org, gleb@kernel.org, eranian@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <378397117.29564840.1403210025829.JavaMail.zimbra@redhat.com>
In-Reply-To: <20140619173326.GS8178@tassilo.jf.intel.com>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org> <1401412327-14810-5-git-send-email-andi@firstfloor.org> <20140610180448.GA9485@amt.cnet> <20140610192207.GC8178@tassilo.jf.intel.com> <20140610210654.GA16344@amt.cnet> <53A2F6E3.6020703@redhat.com> <20140619173326.GS8178@tassilo.jf.intel.com>
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF29 (Linux)/8.0.6_GA_5922)
Thread-Topic: Implement PEBS virtualization
Thread-Index: Ewoot2mDHbTuEaaFTJqjuTr5hq6EIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Userspace then can read/write these MSRs, and add them to the migration
> > stream.  QEMU has code for that.
> 
> Thanks. The PEBS setup always redoes its state, can be arbitarily often
> redone.
> 
> So the only change needed would be to add the MSRs to some list in qemu?

Yes, and also adding them to the migration stream if the MSRs do not
have the default (all-zero? need to look at the SDM) values.

Paolo
