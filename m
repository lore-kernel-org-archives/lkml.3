Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbbAFMrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:47:06 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:43922 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054AbbAFMrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:47:04 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, dmaengine@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH, RFC] MIPS: jz4740: use dma filter function
References: <22569458.nE7JkNNnz3@wuerfel> <54ABBCE6.8060904@metafoo.de>
Date: Tue, 06 Jan 2015 12:47:00 +0000
In-Reply-To: <54ABBCE6.8060904@metafoo.de> (Lars-Peter Clausen's message of
	"Tue, 06 Jan 2015 11:45:58 +0100")
Message-ID: <yw1xtx04f54r.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen <lars@metafoo.de> writes:

> On 01/05/2015 11:39 PM, Arnd Bergmann wrote:
>> As discussed on the topic of shmobile DMA today, jz4740 is the only
>> user of the slave_id field in dma_slave_config besides shmobile. This
>> use is really incompatible with the way that other drivers use the
>> dmaengine API, so we should get rid of it.
>
> Do you have a link to that discussion?
>
>>
>> This adds a trivial filter function that uses the filter param to
>> pass the dma type, and uses that in both drivers.
>
> In my opinion that's just from bad to worse. Using filter functions
> isn't that great in the first place. And using them to pass data from
> the consumer to the DMA provider is just a horrible abuse of the API.

It seems to me the only sane way to use the dmaengine API is in
conjunction with DT.

-- 
Måns Rullgård
mans@mansr.com
