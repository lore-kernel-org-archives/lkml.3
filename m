Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbaEPLcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 07:32:18 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:42446 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbaEPLcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 07:32:17 -0400
Message-ID: <5375F739.2090903@de.ibm.com>
Date: Fri, 16 May 2014 13:32:09 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michael Mueller <mimu@linux.vnet.ibm.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Cornelia Huck <cornelia.huck@de.ibm.com>, Alexander Graf <agraf@suse.de>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Andreas Faerber <afaerber@suse.de>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Subject: Re: [PATCH v1 RFC 0/6] KVM: s390: cpu model implementation
References: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
In-Reply-To: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051611-4966-0000-0000-0000000DD822
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/05/14 16:58, Michael Mueller wrote:
> The proposed patch set implements S390 cpu model support in kvm. A cpu
> model is defined by a triple comprizing the cpu type , the cpu facility
> set and instruction blocking control. A consumer requests a feasible
> combination of that that triple before vcpu creation. All subsequently
> created vcpu's will use this cpu configuration. 
> 
> Michael Mueller (6):
>   s390/sclp: add sclp_get_ibc function
>   KVM: s390: split SIE state guest prefix field
>   KVM: s390: use facilities and cpu_id per KVM
>   KVM: s390: add ibc api
>   KVM: s390: initial implementation of soft facilities
>   KVM: s390: add cpu model support
> 
>  arch/s390/include/asm/kvm_host.h |  13 +-
>  arch/s390/include/asm/sclp.h     |   1 +
>  arch/s390/include/uapi/asm/kvm.h |  23 ++++
>  arch/s390/kvm/Makefile           |   2 +-
>  arch/s390/kvm/diag.c             |   2 +-
>  arch/s390/kvm/gaccess.c          |   4 +-
>  arch/s390/kvm/gaccess.h          |   8 +-
>  arch/s390/kvm/ibc.c              |  29 +++++
>  arch/s390/kvm/kvm-s390.c         | 263 +++++++++++++++++++++++++++++++++------
>  arch/s390/kvm/kvm-s390.h         |  43 ++++++-
>  arch/s390/kvm/priv.c             |  16 ++-
>  arch/s390/kvm/softfac.c          |  38 ++++++
>  drivers/s390/char/sclp_early.c   |  12 +-
>  13 files changed, 397 insertions(+), 57 deletions(-)
>  create mode 100644 arch/s390/kvm/ibc.c
>  create mode 100644 arch/s390/kvm/softfac.c
> 

I will add patch 1 and 2 to the next KVM: s390: pull request as there 
does not seem to be potential for discussion / interface changes. 
Everything else looks ok, but I want to wait if additional feedback 
about the overall design comes in. 

Christian

