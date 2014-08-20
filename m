Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaHTTFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:05:12 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:64229 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaHTTFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:05:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140820170520.GF29733@console-pimps.org>
References: <53E62EEF.9040801@gmail.com>
	<CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
	<20140809192302.GJ15082@console-pimps.org>
	<CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
	<CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
	<CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>
	<20140813140219.GP15082@console-pimps.org>
	<CAPWNY8WdA+Q+WjXirGOsrYjMGp+69sCqYa8ST7_owQeVhQkT0w@mail.gmail.com>
	<20140813184449.GV15082@console-pimps.org>
	<20140820170520.GF29733@console-pimps.org>
Date: Wed, 20 Aug 2014 22:05:08 +0300
Message-ID: <CAPWNY8V_gFutOcow5rBUSz2updGzf4hkQ98qBZ9WRGkb_sA2jA@mail.gmail.com>
Subject: Re: Loading initrd above 4G causes freeze on boot
From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 8:05 PM, Matt Fleming <matt@console-pimps.org> wrote:
> On Wed, 13 Aug, at 07:44:49PM, Matt Fleming wrote:
>>
>> At this point, I think modifying the max address is the best way to
>> debug this further, and figure out what address causes the hang.
>
> Mantas, did you manage to get to the bottom of this issue?

I experimented with some things (like setting chunk size to a few kB
to see if it hangs earlier or only at the very end; etc.), and finally
found out that it stops freezing if I pad the initrd file to a
multiple of 512 bytes :/ That is, 5684268 bytes will freeze, 5684736
bytes will not.

...In other words, seems like it cannot read chunks that aren't
multiples of 512 into a location above 4 GB. Or something like that...

-- 
Mantas Mikulėnas <grawity@gmail.com>
