Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaLCO42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:56:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaLCO41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:56:27 -0500
Message-ID: <547F1D84.9040505@redhat.com>
Date: Wed, 03 Dec 2014 15:26:12 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Nadav Amit <namit@cs.technion.ac.il>, hpa@linux.intel.com,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [CFT PATCH v2 2/2] KVM: x86: support XSAVES usage in the host
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com> <1416847414-22253-3-git-send-email-pbonzini@redhat.com> <802AF3F4-2631-4979-A8CC-46B406546062@gmail.com>
In-Reply-To: <802AF3F4-2631-4979-A8CC-46B406546062@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/12/2014 15:23, Nadav Amit wrote:
> I think it is better just to replace the last line with:
> 
> *(u64 *)(dest + XSAVE_HDR_OFFSET) = xsave->xsave_hdr.xstate_bv

Right, this matches

        u64 xstate_bv = *(u64 *)(src + XSAVE_HDR_OFFSET);
	...
        xsave->xsave_hdr.xstate_bv = xstate_bv;

in load_xsave.

Paolo
