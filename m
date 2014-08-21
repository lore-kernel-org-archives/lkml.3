Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaHUIYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:24:51 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34548 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbaHUIYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:24:49 -0400
Message-ID: <53F5ACCB.8000201@redhat.com>
Date: Thu, 21 Aug 2014 10:24:43 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 4/6] KVM: VMX: dynamise PLE window
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com> <1408567997-21222-5-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408567997-21222-5-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/08/2014 22:53, Radim Krčmář ha scritto:
> +static void update_ple_window_actual_max(void)
> +{
> +	ple_window_actual_max =
> +			__shrink_ple_window(max(ple_window_max, ple_window),

Why the max() here?

> +			                    ple_window_grow, INT_MIN);

This should be 0 (in fact you can probably make everything unsigned now
that you've sorted out the overflows).

Paolo

> +}
> +

