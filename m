Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaF3PZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:25:36 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:63375 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbaF3PZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:25:32 -0400
Date: Mon, 30 Jun 2014 18:25:26 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jan Kiszka <jan.kiszka@web.de>, Paolo Bonzini <pbonzini@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: [PATCH] KVM: SVM: Fix CPL export via SS.DPL
Message-ID: <20140630152526.GA4399@minantech.com>
References: <20140629131443.GA5199@pd.tnic>
 <20140629134247.GG18167@minantech.com>
 <20140629140104.GB12528@pd.tnic>
 <20140629142722.GH18167@minantech.com>
 <53B02395.8030505@web.de>
 <53B027E0.7040003@web.de>
 <53B02CEB.7010607@web.de>
 <53B17BDD.5030301@redhat.com>
 <53B17C5D.5050407@web.de>
 <20140630151544.GF4766@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=cp1255
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140630151544.GF4766@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 05:15:44PM +0200, Borislav Petkov wrote:
> On Mon, Jun 30, 2014 at 05:03:57PM +0200, Jan Kiszka wrote:
> > 15.5.1:
> > 
> > "When examining segment attributes after a #VMEXIT:
> > [...]
> > • Retrieve the CPL from the CPL field in the VMCB, not from any segment
> > DPL."
> 
> Heey, it is even documented! :-P
> 
Yes, on SVM we should always respect this field. Unfortunately there
is no such field in VMX, so we have to do DPL gymnastics there.

--
			Gleb.
