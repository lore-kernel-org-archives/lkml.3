Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaDVD3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:29:49 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:57103 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaDVD3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:29:46 -0400
Message-ID: <5355E222.7010607@redhat.com>
Date: Mon, 21 Apr 2014 23:29:38 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Check for host supported fields in shadow
 vmcs
References: <jpgk3aiv6a9.fsf@nelium.bos.redhat.com>
In-Reply-To: <jpgk3aiv6a9.fsf@nelium.bos.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/04/2014 15:20, Bandan Das ha scritto:
> +	for (i = j = 0; i < max_shadow_read_write_fields; i++) {
> +

Extra empty line.  Not a big deal, but...

> +		switch (shadow_read_write_fields[i]) {
> +		case GUEST_BNDCFGS:
> +			if (!vmx_mpx_supported())
> +				continue;
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		if (j < i)
> +			shadow_read_write_fields[j] =
> +				shadow_read_write_fields[i];
> +		j++;

... you need to respin anyway because the j++ is wrong.  It should be 
inside the "if".  If you prefer, you can put it in the lhs of the 
assignment, otherwise a separate statement is fine by me too.

Paolo
