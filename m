Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab3BTAnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:43:37 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:62333 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3BTAng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:43:36 -0500
Message-ID: <51241C32.3050500@gmail.com>
Date: Wed, 20 Feb 2013 08:43:30 +0800
From: Will Huck <will.huckk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Li Haifeng <omycle@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Should a swapped out page be deleted from swap cache?
References: <CAFNq8R4UYvygk8+X+NZgyGjgU5vBsEv1UM6MiUxah6iW8=0HrQ@mail.gmail.com> <alpine.LNX.2.00.1302180939200.2246@eggly.anvils> <5122C9B3.10306@gmail.com> <alpine.LNX.2.00.1302191056390.2248@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1302191056390.2248@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 03:06 AM, Hugh Dickins wrote:
> On Tue, 19 Feb 2013, Will Huck wrote:
>> Another question:
> I don't see the connection to deleting a swapped out page from swap cache.
>
>> Why kernel memory mapping use direct mapping instead of kmalloc/vmalloc which
>> will setup mapping on demand?
> I may misunderstand you, and "kernel memory mapping".
>
> kmalloc does not set up a mapping, it uses the direct mapping already set up.
>
> It would be circular if the basic page allocation primitives used kmalloc,
> since kmalloc relies on the basic page allocation primitives.
>
> vmalloc is less efficient than using the direct mapping (repeated setup
> and teardown, no use of hugepages), but necessary when you want a larger

Is there tlb flush in setup and teardown process? and they also expensive?

> virtual array than you're likely to find from the buddy allocator.
>
> Hugh

