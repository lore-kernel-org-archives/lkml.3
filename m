Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab3KKIfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:35:42 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:47282 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3KKIfh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 11 Nov 2013 03:35:37 -0500
Message-Id: <5280A4E30200007800101A2C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 11 Nov 2013 08:35:31 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Kyungsik Lee" <kyungsik.lee@lge.com>
Cc: "Matthew Daley" <mattjd@gmail.com>, <chan.jeong@lge.com>,
        <hyojun.im@lge.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unlz4: always set an error return code on failures
References: <527CBC7D020000780010117C@nat28.tlf.novell.com>
 <20131111024924.GA23164@hulk>
In-Reply-To: <20131111024924.GA23164@hulk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.11.13 at 03:49, Kyungsik Lee <kyungsik.lee@lge.com> wrote:
> Hello Jan,
> 
> Thanks for the patch.
> 
> On Fri, Nov 08, 2013 at 09:27:09AM +0000, Jan Beulich wrote:
>> "ret", being set to -1 early on, gets cleared by the first invocation
>> of lz4_decompress()/lz4_decompress_unknownoutputsize(), and hence
>> subsequent failures wouldn't be noticed by the caller without setting
>> it back to -1 right after those calls.
>> 
>> Reported-by: Matthew Daley <mattjd@gmail.com>
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> Cc: Kyungsik Lee <kyungsik.lee@lge.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> 
>> --- a/lib/decompress_unlz4.c
>> +++ b/lib/decompress_unlz4.c
>> @@ -141,6 +141,7 @@ STATIC inline int INIT unlz4(u8 *input, 
>>  			goto exit_2;
>>  		}
>>  
>> +		ret = -1;
>>  		if (flush && flush(outp, dest_len) != dest_len)
>>  			goto exit_2;
>>  		if (output)
>>
> What do you think of adding "ret2" for keeping "ret" error status
> which is set by lz4_decompress*() like below.

I'd be fine with that too, but preferred to submit the smallest
possible (read: one line) patch in this case.

Jan

