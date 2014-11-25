Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaKYNgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:36:16 -0500
Received: from smtp-out-206.synserver.de ([212.40.185.206]:1025 "EHLO
	smtp-out-206.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaKYNgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:36:14 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31441
Message-ID: <547485CF.4050600@metafoo.de>
Date: Tue, 25 Nov 2014 14:36:15 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Jean-Francois Moine <moinejf@free.fr>
CC: Liam Girdwood <lgirdwood@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ASoC: Remove 'const' from the device_node pointers
References: <20141125131351.GC7712@sirena.org.uk>
In-Reply-To: <20141125131351.GC7712@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 02:13 PM, Mark Brown wrote:
> On Tue, Nov 25, 2014 at 12:14:48PM +0100, Jean-Francois Moine wrote:
>> As Russell King's explained it, there should not be pointers to
>> struct device_node:
>>
>> "struct device_node is a ref-counted structure.  That means if you
>>   store a reference to it, you should "get" it, and you should "put"
>>   it once you've done.  The act of "put"ing the pointed-to structure
>>   involves writing to that structure, so it is totally unappropriate
>>   to store a device_node structure as a const pointer.  It forces you
>>   to have to cast it back to a non-const pointer at various points
>>   in time to use various OF function calls."
>
> So, we're not holding references here (we're just doing comparisons, the
> references need to be owned before we get into the core)

The core itself will only do the comparisons and it is the board drivers 
responsibility to get and put the references. Making the pointers non const 
allows the board driver to use them to put the reference once the card has 
been unregistered rather than having to keep a separate set of pointers 
around. This should probably be mentioned in the commit message though.

> I'm not seeing anything here removing casts?

This patch used to be part of a two part series where the second patch 
removed the casts. This patch as already been applied though.

