Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762738Ab3DCRUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:20:49 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:40847
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762600Ab3DCRUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:20:48 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT004.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(zz98dI936eI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "jwboyer@redhat.com" <jwboyer@redhat.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] efi: Distinguish between "remaining space" and
 actually used space
Thread-Topic: [PATCH 2/2] efi: Distinguish between "remaining space" and
 actually used space
Thread-Index: AQHOLuuZcipjhSHk/kmF5JR3t+omNZjEe7AAgAAKU4CAADjhAIAAAlkA
Date: Wed, 3 Apr 2013 17:20:30 +0000
Message-ID: <1365009630.19098.16.camel@x230>
References: <515150EC.7040203@redhat.com>
	  <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
	  <1364829240-26475-2-git-send-email-matthew.garrett@nebula.com>
	  <515C2A86.6070606@console-pimps.org> <1364996911.19098.9.camel@x230>
	 <515C62E6.1070004@console-pimps.org>
In-Reply-To: <515C62E6.1070004@console-pimps.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <96B0B8E853769340B45CAFFFF359E053@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r33HKmC0030171

On Wed, 2013-04-03 at 18:12 +0100, Matt Fleming wrote:

> The solution you're proposing has the same downsides as 3) - we risk
> having to tweak things either way. The difference is that in the case of
> 3) the tweaking is adding entries to the whitelist, whereas tweaking
> your solution has more chance of introducing further unwanted
> regressions because you'd be tweaking an algorithm, an algorithm that
> relies on the internal implementation of the variable storage code.

We *risk* having to tweak things, and we fail on the side of safety. 

> > Dealing with firmware is hard. This fixes (1) without leaving us with
> > (2), which seems like a net win.
> 
> I'm not convinced that implementing 3) would inevitably lead to 2),
> provided that we apply a bit of common sense when adding entries. I'm
> not advocating some kind of flag day where we add umpteen machines to
> the whitelist.
> 
> For reference, I just pushed two patches to the 'whitelist' branch at,
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
> 
> which should hopefully illustrate the kind of thing that I'm talking about.

I don't think that works. People are complaining that we broke some
Thinkpads as well, but we also have reports that Thinkpads can be
bricked if we use too much space.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
