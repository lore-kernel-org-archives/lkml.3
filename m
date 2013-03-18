Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3CRLTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:19:20 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:37557 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3CRLTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:19:18 -0400
Message-ID: <5146F830.1070602@redhat.com>
Date: Mon, 18 Mar 2013 12:19:12 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/5] KVM: MMU: store generation-number into mmio spte
References: <51433D98.4050605@linux.vnet.ibm.com> <51433E43.60900@linux.vnet.ibm.com>
In-Reply-To: <51433E43.60900@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/03/2013 16:29, Xiao Guangrong ha scritto:
> +/*
> + * spte bits of bit 3 ~ bit 11 are used as low 9 bits of
> + * generation, the bits of bits 52 ~ bit 61 are used as
> + * high 12 bits of generation.
> + */

High 10 bits.

How often does the generation number change?  Especially with Takuya's
patches, using just 10 bits for the generation might be enough and
simplifies the code.

Paolo
