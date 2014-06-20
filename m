Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067AbaFTDWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 23:22:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:32869 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbaFTDWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 23:22:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,511,1400050800"; 
   d="scan'208";a="447795031"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Hansen, Dave" <dave.hansen@intel.com>,
        Borislav Petkov <bp@alien8.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
Thread-Topic: [PATCH v6 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
Thread-Index: AQHPitp5+re2FjJ0DkeRHdzRM5ptp5t2HnuAgAGAu2D//9RQAIAAiwewgAAmtICAAAfjgIABJ8Lw
Date: Fri, 20 Jun 2014 03:21:58 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE016A5747@shsmsx102.ccr.corp.intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-8-git-send-email-qiaowei.ren@intel.com>
 <20140618100745.GB24419@pd.tnic>
 <9E0BE1322F2F2246BD820DA9FC397ADE016A3BAA@shsmsx102.ccr.corp.intel.com>
 <20140619062824.GB22025@pd.tnic>
 <9E0BE1322F2F2246BD820DA9FC397ADE016A3F75@shsmsx102.ccr.corp.intel.com>
 <53A3181F.9070005@intel.com> <53A31EBD.8060708@zytor.com>
In-Reply-To: <53A31EBD.8060708@zytor.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5K3MVPt030842

On 2014-06-20, H. Peter Anvin wrote:
> On 06/19/2014 10:04 AM, Dave Hansen wrote:
>> 
>> Could you please support this position with some data?  I'm a bit
>> skeptical that instruction decoding is going to be a
>> performance-critical path.
>> 
>> I also don't see the extra field that you talked about in the
>> previous thread?  What's the extra field?  I see a 'limit' vs.
>> 'length', but you don't use 'length' at all, so I think you can use
>> it instead, or at least union it.
>> 
>> I've taken a quick stab at trying to consolidate things.  I think I
>> may have screwed up this:
>> 
>> 	insn->limit = MAX_MPX_INSN_SIZE - bytes;
>> 
>> Qiaowei, is there anything fundamentally broken with what I've got here?
>> 
> 
Firstly instructions will be got from user pointer stored in 'ip', and then validate_next() will use 'limit' to make sure that next sizeof(t) bytes can be on the same instruction.

As hpa said, generic decoder, including struct insn and implementation of decoding, is very heavyweight because it has to. So MPX specific decoding should be better choice.

> So I encouraged Qiaowei to do a limited special-purpose decoder,
> simply because the glue to use the generic decoder was almost as
> large.  I am overall not a huge fan of using the generic decoder in
> constrained situation, because the generic decoder is very heavyweight
> not just in terms of performance but in terms of interface -- because it has to.
> 
Thanks,
Qiaowei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
