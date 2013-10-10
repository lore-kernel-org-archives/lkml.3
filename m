Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3JJPJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:09:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43873 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab3JJPJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:09:42 -0400
Message-ID: <5256C2F9.8090707@zytor.com>
Date: Thu, 10 Oct 2013 08:08:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: rngd
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com> <20131003165130.GA11974@thunk.org> <524EEB96.6040707@mm-sol.com> <20131004181005.GA7022@thunk.org> <52556C4E.9000604@mm-sol.com> <52557137.5050200@zytor.com> <20131009160338.GD1198@thunk.org> <52558320.9090603@zytor.com> <52565B56.1070606@ladisch.de>
In-Reply-To: <52565B56.1070606@ladisch.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 12:46 AM, Clemens Ladisch wrote:
> H. Peter Anvin wrote:
>> On 10/09/2013 09:03 AM, Theodore Ts'o wrote:
>>> You can specify as a command-line argument (-H) to rngd the entropy
>>> per bit of input data.
>>
>> There is no -H option in upstream rngd.  It might be in the Debian fork,
>> but the Debian fork has serious other problems.
> 
> What problems?  I have been thinking about adding another entropy source
> to rngd, and was wondering which fork to use, or if it would make sense
> to merge them.  Are there any features of the Debian fork that should
> not be ported to upstream?
> 

Mainly the maintainer isn't merging in fixes from upstream, apparently
because he has misunderstood their function.

>> I don't understand how that would work with the FIPS tests in rngd,
>> unless of course the FIPS tests are so weak they are pointless anyway
> 
> Most of the FIPS tests assume that the bits are independently generated
> (the two other tests check for correlations in 4/32-bit groups).  None
> of these tests make sense if the bit stream is the output of an AES
> conditioner.  For RDRAND, it might be useful to check that we don't
> accidentally get a series of zeros or something like that, but otherwise
> we have to trust the built-in tests that Intel claims the hardware is
> doing before conditioning.
> 
> As it happens, the 2002-12-03 change notice of FIPS 140-2 dropped the
> RNG tests.
> 
> For the entropy source I've been thinking about (captured audio
> samples), the FIPS tests would make sense only if done independently on
> each bit in the sample (e.g., with 24-bit samples, there would be 24
> parallel bit streams, most of which wouldn't be random).  Additional
> tests to check for correlations between the bits in a sample would be
> useful, too.
> 
> What I'm trying to say with all this is that self-tests must be
> customized for each entropy source.
> 

Yes.  I don't think the FIPS tests make any sense at all (up to and
including rngd 3 they would eventually kill rngd, because it only
allowed for a fixed number of false positives.)

	-hpa


