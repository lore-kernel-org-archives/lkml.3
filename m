Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbaGNNlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:41:10 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:54747 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaGNNlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:41:05 -0400
Message-ID: <53C3DDE7.6000108@brockmann-consult.de>
Date: Mon, 14 Jul 2014 15:40:55 +0200
From: Peter Maloney <peter.maloney@brockmann-consult.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Kamal Mostafa <kamal@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: kernel BUG - handle_mm_fault - Ubuntu 14.04 kernel 3.13.0-29-generic
References: <20140619163614.GA24297@node.dhcp.inet.fi>
In-Reply-To: <20140619163614.GA24297@node.dhcp.inet.fi>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:9g2pXndD4PIDaYeyaPkqt7y5b8rfAIo2x04GRLAY9jl
 BBlpkEFCeud4J0QGcqV2s7kK8rjkNgIOzu5rTgVM5i/+vv4HKc
 +f6AEj59lc4uUsAy8kaZEl82SaaAcDzqJ7WSkj85t+TSOcCwgS
 5QkrK51i/SjNBPpuK2P+6v2PeT050nz/LRJPMy4oZkyaKdzaW6
 63gynMP5nsPcfHgeuhZkb7/jvRNZMUKk8h2tWT8jAfn6eeEiwI
 dTSiCcwF18pVGapTvTotxrS2TWPgwd0f6MkaYc4RQlWOLshFpo
 VktwmvscmYbKP9eo1YrlQzgEmg8rDpS4tmfqYEfNrWtsqotg42
 eEPN9x8P3oxnw0khv8yJ9Jkj3UVqjvsa0sFO51WI1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014-06-19 18:36, Kirill A. Shutemov wrote:
> On Thu, Jun 19, 2014 at 06:10:11PM +0200, Peter Maloney wrote:
>> Hi, can someone please take a look at this and tell me what is going on?
>>
>> The event log reports no ECC errors.
>>
>> This machine was working fine with an older Ubuntu version, and has
>> failed this way twice since an upgrade 2 weeks ago.
>>
>> Symptoms include:
>>  - load goes up high, currently 1872.72
>>  - "ps -ef" hangs
>>  - this time I tested "echo w > /proc/sysrq-trigger" which made the
>> local shell and ssh hang, and ctrl+alt+del doesn't work, but machine
>> still responds to ping
>>
>> Please CC me; I'm not on the list.
>>
>> Thanks,
>> Peter
>>
>>
>>
>> Here's the log:
>>
>> Jun 12 15:42:42 node73 kernel: [17196.908781] ------------[ cut here
>> ]------------
>> Jun 12 15:42:42 node73 kernel: [17196.909789] kernel BUG at
>> /build/buildd/linux-3.13.0/mm/memory.c:3756!
> Looks like this:
>
> http://lkml.org/lkml/2014/5/8/275
>
> It seems the commit 107437febd49 has added to 3.13.11.3 "extended stable",
> but not in other -stable.
>
> Rik, should it be there too?
>
Hello again, I just wanted to say that I have built a kernel with this
fix on Jun 26, deployed it on the problem machines, and it has been
stable ever since.

