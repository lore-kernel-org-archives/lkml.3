Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab3FDOGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:06:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab3FDOG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:06:29 -0400
Message-ID: <51ADF44E.40100@redhat.com>
Date: Tue, 04 Jun 2013 16:06:06 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH 1/2] KVM: x86: handle hardware breakpoints during emulation
References: <1369929631-2101-1-git-send-email-pbonzini@redhat.com> <1369929631-2101-2-git-send-email-pbonzini@redhat.com> <20130604112820.GM4725@redhat.com> <51ADD080.3040308@redhat.com> <20130604114731.GN4725@redhat.com> <51ADDB41.5040402@redhat.com> <20130604125310.GO4725@redhat.com>
In-Reply-To: <20130604125310.GO4725@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/06/2013 14:53, Gleb Natapov ha scritto:
>> > 
> Yeah. What about:
>  if ((dr6 = guest_debug()))
>    return handle_gues_debug();
>  else if ((dr6 = check_bp()))
>    return handle_bp(dr6);

I'll try either this...

>>>> > >> If you do not want EMULATE_PROCEED, I can just use -1 instead in
>>>> > >> kvm_vcpu_check_breakpoint, and return if r < 0.
>>>> > >>
>>> > > But you need to know what to return EMULATE_DONE or EMULATE_USER_EXIT.
>> > 
>> > Sorry, _not_ return if r < 0.
>> > 
> Function that returns enum or -1? This is worse IMO. Return
> EMULATE_DONE/EMULATE_USER_EXIT via a pointer will be better.

... or this, and see what looks nicer.  But I like

   if (check_bp(&r))
       return r;

Thanks for the review.

Paolo

