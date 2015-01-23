Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbbAWPKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:10:09 -0500
Received: from plane.gmane.org ([80.91.229.3]:47560 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbbAWPKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:10:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: x86/MCE: drop bogus const modifier from AMD's bank4_names()
Date: Fri, 23 Jan 2015 16:04:46 +0100
Organization: mutluit.com
Message-ID: <m9tnue$fiu$1@ger.gmane.org>
References: <54C21511020000780005890E@mail.emea.novell.com> <20150123095838.GA22635@pd.tnic> <54C22B040200007800058A07@mail.emea.novell.com> <20150123101623.GB22635@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip4d16f302.dynamic.kabel-deutschland.de
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:27.0) Gecko/20100101 Firefox/27.0 SeaMonkey/2.24
In-Reply-To: <20150123101623.GB22635@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote, On 01/23/2015 09:32 AM:
>
> -static const char * const bank4_names(struct threshold_block *b)
> +static const char *bank4_names(const struct threshold_block *b)

There is a big difference in the return type, cf. below.
Of course, if possible, the more const the better.

Borislav Petkov wrote, On 01/23/2015 11:16 AM:
> On Fri, Jan 23, 2015 at 10:05:40AM +0000, Jan Beulich wrote:
>> It's been a long while ago that I noticed and fixed the warning, so
>> I don't recall the details. What I do know is that I didn't force any
>> extra flags, and that a similar issue elsewhere in the tree (fixed
>> in 3.19-rc5) triggered the same warning in at least one of my builds
>> (again without any extra warning options) in -rc4.
>
> Older compiler maybe. Not that it is worth wasting too much time on it
> though...

int main()
  {
    char mem1[] = "foo";
    char mem2[] = "bar";

    const char* const p1 = mem1;   // both ptr and content are const
    const char*       p2 = mem2;   // content is const, but not the ptr

// ++p1;         // not possible b/c p1 is const
    ++p2;         // possible b/c p2 is not const

// *p1 = 'X';    // not possible b/c content of p1 is const
// *p2 = 'A';    // not possible b/c content of p2 is const

    return 0;
  }


cu
Uenal

