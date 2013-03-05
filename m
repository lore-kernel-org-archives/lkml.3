Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3CEIFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:05:24 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:49519 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3CEIFX (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 5 Mar 2013 03:05:23 -0500
Message-Id: <5135B58202000078000C2FED@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Tue, 05 Mar 2013 08:06:10 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "=?UTF-8?Q?Roger=20Pau=20Monn=C3=A9?=" <roger.pau@citrix.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 01/12] xen-blkback: don't store
 dev_bus_addr
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-2-git-send-email-roger.pau@citrix.com>
 <512F467602000078000C1E0C@nat28.tlf.novell.com>
 <5134D78B.4060400@citrix.com>
In-Reply-To: <5134D78B.4060400@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.03.13 at 18:19, Roger Pau Monné<roger.pau@citrix.com> wrote:
> On 28/02/13 11:58, Jan Beulich wrote:
>>>>> On 28.02.13 at 11:28, Roger Pau Monne <roger.pau@citrix.com> wrote:
>> And then the biolist[] array really can be folded into a union
>> with the remaining seg[] one, as their usage scopes are easily
>> separable.
> 
> Could we leave that for a further patch? I would like to avoid messing
> any more with blkback, as I'm already touching a lot of bits with this
> patch series.

Fine by me, but ...

>>> @@ -631,7 +629,8 @@ static int xen_blkbk_map(struct blkif_request *req,
>>>  			if (ret)
>>>  				continue;
>>>  
>>> -			seg[i].buf = persistent_gnts[i]->dev_bus_addr |
>>> +			seg[i].buf = pfn_to_mfn(page_to_pfn(
>>> +				persistent_gnts[i]->page)) << PAGE_SHIFT |
>> 
>> So why do you do this? The only reader masks the field with
>> ~PAGE_MASK anyway.
> 
> Yes, I only need to store first_sect.

... as you're touching this code anyway, and as it'll make the
code as well as the patch smaller, could you at least drop this
pointless storing of the page address (which otherwise I'd ask
you to properly parenthesize anyway)?

And iirc once that's dropped, the storing of first_sect ends up
being identical between the if and else bodies, so it could be
pulled out (further reducing code size, albeit at the price of a
marginally bigger patch).

Jan
