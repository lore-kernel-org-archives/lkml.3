Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaB0PL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:11:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55990 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaB0PL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:11:26 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140227082529.GA18210@pd.tnic>
References: <530E6F76.1070605@zytor.com> <1393462087.24588.50.camel@joe-AO722> <530E8C2E.7080307@zytor.com> <1393466619.24588.65.camel@joe-AO722> <20140227022857.GC23659@thin> <1393469594.24588.71.camel@joe-AO722> <20140227025845.GA25145@thin> <530EB103.5070406@zytor.com> <1393472326.24588.82.camel@joe-AO722> <60797a1a-1a83-468e-9629-abf4e8712d65@email.android.com> <20140227082529.GA18210@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 27 Feb 2014 07:10:25 -0800
To: Borislav Petkov <bp@alien8.de>
CC: Joe Perches <joe@perches.com>, Ben Pfaff <blp@nicira.com>,
        Christopher Li <sparse@chrisli.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <dbc47544-a6f6-4ab4-80b0-25d93a1666e2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep in mind, too, that for the kernel we don't care about the full C standard but a subset.  We rely on extrastandard behavior all over the place.  For all ABIs supported by the kernel, sizeof(_Book) == 1 and so everything is sane.


On February 27, 2014 12:25:29 AM PST, Borislav Petkov <bp@alien8.de> wrote:
>On Wed, Feb 26, 2014 at 07:42:37PM -0800, H. Peter Anvin wrote:
>> sizeof(_Bool), like for many other types, is ABI-dependent, but that
>> doesn't mean it is illegitimate.
>>
>> I don't think C99 says that it is invalid (which means C99 doesn't
>> permit is to be a packed bitmap.)
>
>Ok, but what can be said about the __pcpu_size_call() use case where we
>do sizeof(bool)? We have there accessors for sizes 1,2,4 and 8. Can we
>simply assume that the ABI will give us a size of bool which is one of
>those?
>
>What if sizeof(bool) is 3?
>
>Or, are we saying that sizeof(bool) will always be of some natural,
>native size like byte, short, int or long so we're good there?
>
>Thanks.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
