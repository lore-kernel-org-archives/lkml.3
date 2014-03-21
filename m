Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761184AbaCURkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:40:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374AbaCURjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:39:54 -0400
Date: Fri, 21 Mar 2014 14:39:44 -0300
From: Eduardo Habkost <ehabkost@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@kernel.org,
        mtosatti@redhat.com, alex.williamson@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 1/4] KVM: ioapic: merge ioapic_deliver into
 ioapic_service
Message-ID: <20140321173944.GC10819@otherpad.lan.raisama.net>
References: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
 <1395394081-16252-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395394081-16252-2-git-send-email-pbonzini@redhat.com>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 10:27:58AM +0100, Paolo Bonzini wrote:
> Commonize the handling of masking, which was absent for kvm_ioapic_set_irq.
> Setting remote_irr does not need a separate function either, and merging
> the two functions avoids confusion.
> 
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>

Just code movement, no functional changes.

(The change from entry->fields.trig_mode to irqe.trig_mode is not purely
code movement, but kvm_irq_delivery_to_apic() doesn't change
irq->trig_mode, so it's OK).

-- 
Eduardo
