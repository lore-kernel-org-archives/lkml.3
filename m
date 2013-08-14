Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab3HNQH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:07:57 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:39873 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750974Ab3HNQH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:07:56 -0400
Message-ID: <520BAB57.300@hurleysoftware.com>
Date: Wed, 14 Aug 2013 12:07:51 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk
Subject: Re: pty FIONREAD returning zero breaks emacs in 3.11rc3
References: <20130809211126.GF19750@two.firstfloor.org> <52098F4F.8070508@hurleysoftware.com> <20130813220314.GB19750@two.firstfloor.org>
In-Reply-To: <20130813220314.GB19750@two.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 06:03 PM, Andi Kleen wrote:
> On Mon, Aug 12, 2013 at 09:43:43PM -0400, Peter Hurley wrote:
>> On 08/09/2013 05:11 PM, Andi Kleen wrote:
>>>
>>> When I run emacs over ssh terminal (no X) on 3.11-rc3 it often ignores key
>>> strokes.  I first thought the system was busy or so, but when
>>> stracing the emacs it was not blocked.
>>
>> Andi,
>>
>> More information might help me narrow this down since I can't
>> reproduce this.
>>
>> Is the ssh session remote?
>
> Yes.
>
>> Can you reproduce this on a local ssh session?
>
> Yes.
>
>> What version of emacs is this? Is it the nox flavor?
>
> emacs-24.3-6.11.x86_64
>
> It's emacs-gtk
>
>
>> What distribution/version?
>
> Current Tumbleweed
>
>> What platform?
>
> x86_64 2S Westmere

Thanks. I'll need to install Tumbleweed to attempt to reproduce this.

>>> Here's a typical sequence. select/SIGIO wakes it up, but then
>>> FIONREAD returns 0.
>>>
>>> I'm not fully sure when it started.
>>
>> In the 3.11 cycle? or could have started back on 3.9 or earlier?
>
> Ok I tried and it actually happens on 3.9 too. For some reason
> I didn't notice it earlier (or blamed my bad typing)
> Haven't tried earlier

Ok. Thanks for testing 3.9 -- that eliminates a lot of possible
culprits.

>>
>> Could you try to reproduce this on linux-next?
>
> Happens on linux-next too.
>>
>> Would you please attach the full strace of emacs from this session?
>
> Attached (from a different session)

Can you send me more of the original session?

The session you sent me didn't exhibit the problem of pselect()
indicating input available but ioctl(FIONREAD) returning 0.
It may have seemed that input wasn't being read but actually
emacs was beeping you back for each input (that's what all the
write('\7') are about in the strace).

Regards,
Peter Hurley

