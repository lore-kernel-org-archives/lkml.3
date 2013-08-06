Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab3HFXGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 19:06:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44198 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800Ab3HFXGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 19:06:20 -0400
Message-ID: <5201813F.1070102@zytor.com>
Date: Tue, 06 Aug 2013 16:05:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Anders Larsen <al@alarsen.net>
CC: Bjorn Helgaas <bhelgaas@google.com>, Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        postmaster@vger.kernel.org, Konstantin Ryabitsev <mricon@kernel.org>
Subject: Re: kernel mailing list permalinks
References: <1375826105.22552.0@oscar>
In-Reply-To: <1375826105.22552.0@oscar>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 02:55 PM, Anders Larsen wrote:
> On 2013-08-06 23:23, H. Peter Anvin wrote:
>> On 08/06/2013 02:11 PM, Bjorn Helgaas wrote:
>> >>
>> >> The above link is also a good example of subtleness: + in a URL
>> means a
>> >> space character, it has to be escaped as %2B.  Particularly a
>> problem in
>> >> gmail message-ids.
> 
> the link in question works just fine without escaping the +; the + only
> has to be escaped in then query component of a URL, not in the path
> component where it is just another valid character - and the link in
> question did not contain any query component.
> 
> (see RFC 3986 sections 3.3 and 3.4)
> 

Well, the backend does unescape, so regardless of what is legal by URL
syntax, the current implementation and therefore existing link tags
expect it to be escaped (this is a consequence of the bouncer turning
the link into a query URL in a redirect.)  So they will need to be
escaped no matter what RFC 3986 says.  Consider a part of the
specification for lkml.kernel.org links.

That being said, we could definitely choose to interpret + as a + rather
than space.  I don't know if we can easily distinguish between "%20",
"+" and " ", though, without dramatically change the implementation.

>> A quoted Message-ID might be weird as heck, but one rarely if ever see
>> them, I don't know if they are even legal.
> 
> I don't think they are even possible, as the percent-sign is just another
> valid character in a Message-ID - but so is the '+' sign, so it seems
> you're trying to solve a non-existent problem...
> 
> (see RFC 5322 section 3.2.3)
> 

I'm referring to message-id's with a obs-id-left production.

	-hpa

