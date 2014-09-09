Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbaIILOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:14:36 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37781 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755335AbaIILOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:14:34 -0400
Message-ID: <540EE10F.5050802@hurleysoftware.com>
Date: Tue, 09 Sep 2014 07:14:23 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: David Laight <David.Laight@ACULAB.COM>, Jakub Jelinek <jakub@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Miroslav Franc <mfranc@redhat.com>,
        Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org
Subject: Re: bit fields && data tearing
References: <20140712181328.GA8738@redhat.com>	<54079B70.4050200@hurleysoftware.com>	<1409785893.30640.118.camel@pasglop>	<063D6719AE5E284EB5DD2968C1650D6D17487172@AcuExch.aculab.com>	<1409824374.4246.62.camel@pasglop>	<5408E458.3@zytor.com>	<54090AF4.7060406@hurleysoftware.com>	<54091B30.7080100@zytor.com>	<5409D76D.2070203@hurleysoftware.com>	<5409D9C0.7030403@zytor.com> <20140908185240.21f52ca0@alan.etchedpixels.co.uk> <540DEE6C.2060904@zytor.com> <540E3207.7090007@hurleysoftware.com>
In-Reply-To: <540E3207.7090007@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 06:47 PM, Peter Hurley wrote:
> On 09/08/2014 01:59 PM, H. Peter Anvin wrote:
>> On 09/08/2014 10:52 AM, One Thousand Gnomes wrote:
>>> On Fri, 05 Sep 2014 08:41:52 -0700
>>> "H. Peter Anvin" <hpa@zytor.com> wrote:
>>>
>>>> On 09/05/2014 08:31 AM, Peter Hurley wrote:
>>>>>
>>>>> Which is a bit ironic because I remember when Digital had a team
>>>>> working on emulating native x86 apps on Alpha/NT.
>>>>>
>>>>
>>>> Right, because the x86 architecture was obsolete and would never scale...
>>>
>>> Talking about "not scaling" can anyone explain how a "you need to use
>>> set_bit() and friends" bug report scaled into a hundred message plus
>>> discussion about ambiguous properties of processors (and nobody has
>>> audited all the embedded platforms we support yet, or the weirder ARMs)
>>> and a propsal to remove Alpha support.
>>>
>>> Wouldn't it be *much* simpler to do what I suggested in the first place
>>> and use the existing intended for purpose, deliberately put there,
>>> functions for atomic bitops, because they are fast on sane processors and
>>> they work on everything else.

And much simpler how?

By turning a 4- line patch into a 400- line patch?

And what about multi-value assignments for which set_bit() doesn't work, like
the byte-sized ->ctrl_status field? Is the expectation to submit a patch
which fixes that for a system from 1995, but already works for everything else?

The extra complexity comes with real cost; reduced reliability for every other
arch .

>>> I think the whole "removing Alpha EV5" support is basically bonkers. Just
>>> use set_bit in the tty layer. Alpha will continue to work as well as it
>>> always has done and you won't design out support for any future processor
>>> that turns out not to do byte aligned stores.

I thought the overriding design principle of this kernel was to support
what exists now, not design-in support for the future which may have
different requirements than expected anyway.


>> Is *that* what we are talking about?  I was added to this conversation
>> in the middle where it had already generalized, so I had no idea.
> 
> No, this is just what brought this craziness to my attention.
> 
> For example, byte- and short-sized circular buffers could not possibly
> be safe either, when the head nears the tail.
> 
> Who has audited global storage and ensured that _every_ byte-sized write
> doesn't happen to be adjacent to some other storage that may not happen
> to be protected by the same (or any) lock?

And add to this list all bitfields because gcc ignores the type
specifier and only allocates the minimum number of bytes to contain the
declared fields.

Regards,
Peter Hurley


