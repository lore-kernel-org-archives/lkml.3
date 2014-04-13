Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaDMMsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 08:48:47 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:42033 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbaDMMsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 08:48:45 -0400
Message-ID: <534A87A0.9080809@redhat.com>
Date: Sun, 13 Apr 2014 08:48:32 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 6/6] KVM: emulate: remove memopp and rip_relative
References: <1397174612-17373-1-git-send-email-bsd@redhat.com> <1397174612-17373-7-git-send-email-bsd@redhat.com>
In-Reply-To: <1397174612-17373-7-git-send-email-bsd@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/04/2014 20:03, Bandan Das ha scritto:
>  	/* Fields above regs are cleared together. */

This comment is not accurate anymore after patch 4.  Since you're fixing 
it, please add another comment saying where the cleared fields start, too.

> +	ctxt->memop.addr.mem.ea = (u32)ctxt->memop.addr.mem.ea;

This is missing "if (ctxt->ad_bytes != 8)".

> +	if (rip_relative)
> +		ctxt->memop.addr.mem.ea += ctxt->_eip;

Paolo
