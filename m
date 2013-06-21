Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965767Ab3FUMCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:02:47 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:18321 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965692Ab3FUMCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:02:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,912,1363132800"; 
   d="scan'208";a="5918610"
Message-ID: <51C440D6.2030107@citrix.com>
Date: Fri, 21 Jun 2013 14:02:30 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/4] xen-blkback: check the number of iovecs
 before allocating a bios
References: <1371812216-17093-1-git-send-email-roger.pau@citrix.com> <1371812216-17093-4-git-send-email-roger.pau@citrix.com> <51C4593702000078000DFA44@nat28.tlf.novell.com>
In-Reply-To: <51C4593702000078000DFA44@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/13 13:46, Jan Beulich wrote:
>>>> On 21.06.13 at 12:56, Roger Pau Monne <roger.pau@citrix.com> wrote:
>> @@ -1236,7 +1236,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>>  				     seg[i].nsec << 9,
>>  				     seg[i].offset) == 0)) {
>>  
>> -			bio = bio_alloc(GFP_KERNEL, nseg-i);
>> +			int nr_iovecs = (nseg-i) > BIO_MAX_PAGES ? BIO_MAX_PAGES : (nseg-i);
> 
> I'm sure this results in a compiler warning (declaration after
> statement).

No, because it's the first statement inside the while loop.

> And it surely would read much better if you used some form of
> min() - the shorter line would at once allow you to properly
> blank separate operands from operators.

Sure, I will switch it to min, thanks for the comments.

> 
> Jan
> 
>> +			bio = bio_alloc(GFP_KERNEL, nr_iovecs);
>>  			if (unlikely(bio == NULL))
>>  				goto fail_put_bio;
>>  
> 
> 

