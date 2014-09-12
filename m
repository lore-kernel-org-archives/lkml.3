Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaILTHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:07:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56974 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaILTHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:07:41 -0400
Message-ID: <54134464.1010809@zytor.com>
Date: Fri, 12 Sep 2014 12:07:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Dave Hansen <dave.hansen@intel.com>, Qiaowei Ren <qiaowei.ren@intel.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-8-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120015030.4178@nanos> <5412230A.6090805@intel.com> <541223B1.5040705@zytor.com> <alpine.DEB.2.10.1409121949460.4178@nanos>
In-Reply-To: <alpine.DEB.2.10.1409121949460.4178@nanos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 10:52 AM, Thomas Gleixner wrote:
> 
> Well, I did not see the trainwreck which tried to use the generic
> decoder, but as I explained in the other mail, there is no reason not
> to use it and I can't see any complexity in retrieving the data beyond
> calling insn_get_length(insn);
> 

Looking at how complex the state machine ended up being, it probably was
the wrong direction.  It is safe to copy_from_user() 15 bytes, decode
what we get (which may be less than 15 bytes) and then verify with
insn_get_length() that what we decoded is actually what we copied if the
copy_from_user() length is < 15.

My intent was to explore a state machine limited to the restricted "mib"
encodings that are valid for BNDSTX and BNDLDX only, but in the end it
really doesn't make enough difference that it is worth messing with, I
don't think.

	-hpa

