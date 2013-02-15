Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3BOShL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:37:11 -0500
Received: from chrocht.moloch.sk ([62.176.169.44]:33647 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3BOShJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:37:09 -0500
Message-ID: <511E8053.4060402@250bpm.com>
Date: Fri, 15 Feb 2013 19:37:07 +0100
From: Martin Sustrik <sustrik@250bpm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Wong <normalperson@yhbt.net>
Subject: Re: [PATCH v2 1/1] eventfd: implementation of EFD_MASK flag
References: <1360311077-14474-1-git-send-email-sustrik@250bpm.com> <20130214145430.04f8750c.akpm@linux-foundation.org> <511DAEA3.4080201@250bpm.com> <20130214212411.55788ec1.akpm@linux-foundation.org> <CALCETrWxLiesdRc6v11uaSVnQYXJQwP+gR7reG3x-iU44wV2HA@mail.gmail.com>
In-Reply-To: <CALCETrWxLiesdRc6v11uaSVnQYXJQwP+gR7reG3x-iU44wV2HA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/13 18:32, Andy Lutomirski wrote:
> On Thu, Feb 14, 2013 at 9:24 PM, Andrew Morton
> <akpm@linux-foundation.org>  wrote:
>> On Fri, 15 Feb 2013 04:42:27 +0100 Martin Sustrik<sustrik@250bpm.com>  wrote:
>>
>>>> This is a non-back-compatible userspace interface change.  A procfs
>>>> file which previously displayed
>>>>
>>>>      eventfd-count: nnnn
>>>>
>>>> can now also display
>>>>
>>>>      eventfd-mask: nnnn
>>>>
>>>> So existing userspace could misbehave.
>>>>
>>>> Please fully describe the proposed interface change in the changelog.
>>>> That description should include the full pathname of the procfs file
>>>> and example before-and-after output and a discussion of whether and why
>>>> the risk to existing userspace is acceptable.
>>>
>>> I am not sure what the policy is here. Is not printing out the state of
>>> the object acceptable way to maintain backward compatibility? If not so,
>>> does new type of object require new procfs file, which, AFAIU, is the
>>> only way to retain full backward compatibility?
>>
>> Adding a new file is the only way I can think of to preserve the API.
>> But from Andy's comment is sounds like we don't have to worry a lot
>> about back-compatibility.
>>
>
> I'm not even convinced there's an issue in the first place (other than
> the fact that use of this feature will break old criu, regardless of
> /proc changes).  The fdinfo files already vary by descriptor type.
> Anything that screws up if unexpected fields are present is already
> screwed.

Ok then. I'll leave the relevant code as is.

Martin
