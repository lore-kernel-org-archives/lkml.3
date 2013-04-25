Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab3DYOoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:44:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56563 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397Ab3DYOo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:44:29 -0400
Message-ID: <51794141.3070205@zytor.com>
Date: Thu, 25 Apr 2013 07:44:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Ted Ts'o" <tytso@mit.edu>, DJ Johnston <dj.johnston@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] random: Account for entropy loss due to overwrites
References: <1366777569-23192-1-git-send-email-hpa@zytor.com> <1366777569-23192-3-git-send-email-hpa@zytor.com> <CA+55aFwkEMAkvZFdeQm2PKQD1xgFBfVa+kTwJXGmWXoDqDp7xQ@mail.gmail.com>
In-Reply-To: <CA+55aFwkEMAkvZFdeQm2PKQD1xgFBfVa+kTwJXGmWXoDqDp7xQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 07:38 AM, Linus Torvalds wrote:
> This doesn't work AT ALL. You even hint at the reason why in your message.
> 
> On Tue, Apr 23, 2013 at 9:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> As such, this conservatism seems more than justified.  Note, however,
>> that attempting to add one bit of entropy will never succeed; nor will
>> two bits unless the pool is completely empty.  These roundoff
>> artifacts could be improved by using fixed-point arithmetic and adding
>> some number of fractional entropy bits.
> 
> Take a look at "add_interrupt_randomness()". Hmm..
> 

<facepalm>

Right.  Before July of last year add_interrupt_randomness() called
add_timer_randomness() which credits up to 11 bits, but not anymore.

-ESTALEBRAIN.

OK, so we need to track fractional bits.

	-hpa


