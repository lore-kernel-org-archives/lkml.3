Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbaFSGx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 02:53:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:38062 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbaFSGx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 02:53:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,505,1400050800"; 
   d="scan'208";a="557790825"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
Thread-Topic: [PATCH v6 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
Thread-Index: AQHPitp5+re2FjJ0DkeRHdzRM5ptp5t2HnuAgAGAu2D//9RQAIAAiwew
Date: Thu, 19 Jun 2014 06:53:28 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE016A3F75@shsmsx102.ccr.corp.intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-8-git-send-email-qiaowei.ren@intel.com>
 <20140618100745.GB24419@pd.tnic>
 <9E0BE1322F2F2246BD820DA9FC397ADE016A3BAA@shsmsx102.ccr.corp.intel.com>
 <20140619062824.GB22025@pd.tnic>
In-Reply-To: <20140619062824.GB22025@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5J6s4Oi024239

On 2014-06-19, Borislav Petkov wrote:
> On Thu, Jun 19, 2014 at 01:13:48AM +0000, Ren, Qiaowei wrote:
>> On 2014-06-18, Borislav Petkov wrote:
>>> On Wed, Jun 18, 2014 at 05:44:13PM +0800, Qiaowei Ren wrote:
>>> 
>>> This whole insn decoding machinery above looks like adapted from
>>> arch/x86/lib/insn.c. You should merge it with the generic code in
>>> insn.c instead of homegrowing it here only for the purposes of MPX.
>>> And if it doesn't work for your needs, you should should extend
>>> the generic code to do so.
> 
>> Petkov, as we discussed on initial version of this patchset, general
>> insn framework didn't work out well and I have tried to use generic
>> struct insn, insn_field, etc. for obvious benefits.
> 
> Let me repeat myself: "And if it doesn't work for your needs, you
> should extend the generic code to do so."
> 
> We don't do homegrown almost-copies of generic code.
>
I see. If possible, I will be very happy to use or extend generic code. But due to extra overhead caused by MPX, I have to use MPX specific decoding to do performance optimization.

You can check the discussion on this: https://lkml.org/lkml/2014/1/11/190

Thanks,
Qiaowei

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
