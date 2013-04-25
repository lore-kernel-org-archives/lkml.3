Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab3DYOu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:50:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56613 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932475Ab3DYOu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:50:27 -0400
Message-ID: <517942AB.1010201@zytor.com>
Date: Thu, 25 Apr 2013 07:50:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] random: Account for entropy loss due to overwrites
References: <1366777569-23192-1-git-send-email-hpa@zytor.com> <1366777569-23192-3-git-send-email-hpa@zytor.com> <CA+55aFwkEMAkvZFdeQm2PKQD1xgFBfVa+kTwJXGmWXoDqDp7xQ@mail.gmail.com> <51794141.3070205@zytor.com>
In-Reply-To: <51794141.3070205@zytor.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 07:44 AM, H. Peter Anvin wrote:
> 
> OK, so we need to track fractional bits.
> 

Ted, Linus: there are two ways we can do this: we can either change the
credit_entropy_bits() interface to take some kind of fractional bits as
interface, or we can change the accounting internally.

The latter has the advantage of being a less invasive change, but the
former has the advantage of making it possible to credit sub-bit entropy.

Do you have a preference?  Otherwise I will probably write up the
internal change for now.

	-hpa


