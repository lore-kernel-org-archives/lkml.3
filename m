Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaHUSkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:40:10 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41438 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaHUSkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:40:08 -0400
Message-ID: <53F63D3A.3000700@linux.vnet.ibm.com>
Date: Fri, 22 Aug 2014 00:10:58 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 0/7] Dynamic Pause Loop Exiting window.
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082118-0009-0000-0000-000000B62EF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 09:38 PM, Radim Krčmář wrote:
> v2 -> v3:
>   * copy&paste frenzy [v3 4/7] (split modify_ple_window)
>   * commented update_ple_window_actual_max [v3 4/7]
>   * renamed shrinker to modifier [v3 4/7]
>   * removed an extraneous max(new, ple_window) [v3 4/7] (should have been in v2)
>   * changed tracepoint argument type, printing and macro abstractions [v3 5/7]
>   * renamed ple_t to ple_int [v3 6/7] (visible in modinfo)
>   * intelligent updates of ple_window [v3 7/7]
>
> ---
> v1 -> v2:
>   * squashed [v1 4/9] and [v1 5/9] (clamping)
>   * dropped [v1 7/9] (CPP abstractions)
>   * merged core of [v1 9/9] into [v1 4/9] (automatic maximum)
>   * reworked kernel_param_ops: closer to pure int [v2 6/6]
>   * introduced ple_window_actual_max & reworked clamping [v2 4/6]
>   * added seqlock for parameter modifications [v2 6/6]
>
> ---

Was able to test, both V1 and V2. and trace showed good behaviour of 
ple_window in undercommit and overcommit.
Considering V3 does not have any change w.r.t functionality except 
intelligent update with dirty field, Please feel free to add

Tested-by: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>

I do have some observations and comments though.

