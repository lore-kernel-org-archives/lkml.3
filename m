Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbaFSRdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:33:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60358 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295AbaFSRdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:33:39 -0400
Message-ID: <53A31EBD.8060708@zytor.com>
Date: Thu, 19 Jun 2014 10:32:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>, Borislav Petkov <bp@alien8.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-8-git-send-email-qiaowei.ren@intel.com> <20140618100745.GB24419@pd.tnic> <9E0BE1322F2F2246BD820DA9FC397ADE016A3BAA@shsmsx102.ccr.corp.intel.com> <20140619062824.GB22025@pd.tnic> <9E0BE1322F2F2246BD820DA9FC397ADE016A3F75@shsmsx102.ccr.corp.intel.com> <53A3181F.9070005@intel.com>
In-Reply-To: <53A3181F.9070005@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 10:04 AM, Dave Hansen wrote:
> 
> Could you please support this position with some data?  I'm a bit
> skeptical that instruction decoding is going to be a
> performance-critical path.
> 
> I also don't see the extra field that you talked about in the previous
> thread?  What's the extra field?  I see a 'limit' vs. 'length', but you
> don't use 'length' at all, so I think you can use it instead, or at
> least union it.
> 
> I've taken a quick stab at trying to consolidate things.  I think I may
> have screwed up this:
> 
> 	insn->limit = MAX_MPX_INSN_SIZE - bytes;
> 
> Qiaowei, is there anything fundamentally broken with what I've got here?
> 

So I encouraged Qiaowei to do a limited special-purpose decoder, simply
because the glue to use the generic decoder was almost as large.  I am
overall not a huge fan of using the generic decoder in constrained
situation, because the generic decoder is very heavyweight not just in
terms of performance but in terms of interface -- because it has to.

	-hpa

