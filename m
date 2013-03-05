Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab3CERCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:02:17 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:53513 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3CERCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:02:16 -0500
X-IronPort-AV: E=Sophos;i="4.84,787,1355097600"; 
   d="scan'208";a="2198687"
Message-ID: <51362516.1000600@citrix.com>
Date: Tue, 5 Mar 2013 18:02:14 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 01/12] xen-blkback: don't store dev_bus_addr
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com> <1362047335-26402-2-git-send-email-roger.pau@citrix.com> <512F467602000078000C1E0C@nat28.tlf.novell.com> <5134D78B.4060400@citrix.com> <5135B58202000078000C2FED@nat28.tlf.novell.com>
In-Reply-To: <5135B58202000078000C2FED@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/13 09:06, Jan Beulich wrote:
>>>> On 04.03.13 at 18:19, Roger Pau Monné<roger.pau@citrix.com> wrote:
>> On 28/02/13 11:58, Jan Beulich wrote:
>>>>>> On 28.02.13 at 11:28, Roger Pau Monne <roger.pau@citrix.com> wrote:
>>> And then the biolist[] array really can be folded into a union
>>> with the remaining seg[] one, as their usage scopes are easily
>>> separable.
>>
>> Could we leave that for a further patch? I would like to avoid messing
>> any more with blkback, as I'm already touching a lot of bits with this
>> patch series.
> 
> Fine by me, but ...
> 
>>>> @@ -631,7 +629,8 @@ static int xen_blkbk_map(struct blkif_request *req,
>>>>  			if (ret)
>>>>  				continue;
>>>>  
>>>> -			seg[i].buf = persistent_gnts[i]->dev_bus_addr |
>>>> +			seg[i].buf = pfn_to_mfn(page_to_pfn(
>>>> +				persistent_gnts[i]->page)) << PAGE_SHIFT |
>>>
>>> So why do you do this? The only reader masks the field with
>>> ~PAGE_MASK anyway.
>>
>> Yes, I only need to store first_sect.
> 
> ... as you're touching this code anyway, and as it'll make the
> code as well as the patch smaller, could you at least drop this
> pointless storing of the page address (which otherwise I'd ask
> you to properly parenthesize anyway)?
> 
> And iirc once that's dropped, the storing of first_sect ends up
> being identical between the if and else bodies, so it could be
> pulled out (further reducing code size, albeit at the price of a
> marginally bigger patch).

Yes, I've already done that, thanks for the suggestion.

